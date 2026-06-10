package com.seasonaldining.producer.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.response.ListResponse;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.producer.dto.request.CreateOfferRequest;
import com.seasonaldining.producer.dto.request.CreateProducerReviewRequest;
import com.seasonaldining.producer.dto.request.RegisterProducerRequest;
import com.seasonaldining.producer.dto.response.*;
import com.seasonaldining.producer.entity.*;
import com.seasonaldining.producer.repository.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * 농가(생산자) 도메인 서비스 — farm-direct-commerce 스켈레톤.
 * DB-backed 조회 골격은 갖췄으나, 시드 데이터/집계 갱신 등 일부 로직은 TODO로 남겨둔다.
 * 참고: frontend/components/producers-data.js, docs/frontend-gap-analysis-2026-06-10.md
 */
@Service
public class ProducerService {

    private final ProducerRepository producerRepository;
    private final ProducerSpecialtyRepository specialtyRepository;
    private final ProducerBadgeRepository badgeRepository;
    private final ProducerOfferRepository offerRepository;
    private final ProducerNewsRepository newsRepository;
    private final ProducerReviewRepository reviewRepository;
    private final IngredientRepository ingredientRepository;

    public ProducerService(ProducerRepository producerRepository,
                           ProducerSpecialtyRepository specialtyRepository,
                           ProducerBadgeRepository badgeRepository,
                           ProducerOfferRepository offerRepository,
                           ProducerNewsRepository newsRepository,
                           ProducerReviewRepository reviewRepository,
                           IngredientRepository ingredientRepository) {
        this.producerRepository = producerRepository;
        this.specialtyRepository = specialtyRepository;
        this.badgeRepository = badgeRepository;
        this.offerRepository = offerRepository;
        this.newsRepository = newsRepository;
        this.reviewRepository = reviewRepository;
        this.ingredientRepository = ingredientRepository;
    }

    @Transactional(readOnly = true)
    public ListResponse<ProducerCardResponse> getProducers(String q, String style, Boolean honorary, Pageable pageable) {
        // q(특산품명) + style + honorary 를 함께 적용 + 페이지네이션 (통합 쿼리)
        String qn = (q == null || q.isBlank()) ? null : q.trim();
        String st = (style == null || style.isBlank()) ? null : style.trim().toUpperCase();
        Page<Producer> page = producerRepository.findAll(producerSearchSpec(qn, st, honorary), pageable);
        return new ListResponse<>(
                page.map(this::toCard).getContent(),
                page.getNumber(), page.getSize(), page.getTotalElements(), page.hasNext());
    }

    @Transactional(readOnly = true)
    public ProducerDetailResponse getProducerDetail(Long producerId) {
        Producer p = producerRepository.findById(producerId)
                .orElseThrow(() -> new BusinessException(ErrorCode.PRODUCER_NOT_FOUND));
        return toDetail(p);
    }

    // ── 농가 자가등록 (마이페이지 → 농가로 등록) ──────────────
    @Transactional
    public ProducerDetailResponse registerMyProducer(Long userId, RegisterProducerRequest req) {
        if (producerRepository.existsByUserId(userId)) {
            throw new BusinessException(ErrorCode.PRODUCER_ALREADY_REGISTERED);
        }
        int priceLevel = req.priceLevel() != null ? req.priceLevel() : 3;
        int freshnessLevel = req.freshnessLevel() != null ? req.freshnessLevel() : 4;
        Producer saved = producerRepository.save(Producer.register(
                userId, req.name(), req.region(), req.tagline(), req.photoUrl(),
                req.style().toUpperCase(), priceLevel, freshnessLevel));
        if (req.specialties() != null) {
            req.specialties().stream().filter(s -> s != null && !s.isBlank()).distinct()
                    .forEach(s -> specialtyRepository.save(
                            ProducerSpecialty.of(saved.getId(), s.trim(), resolveIngredientId(s.trim()))));
        }
        if (req.badges() != null) {
            req.badges().stream().filter(b -> b != null && !b.isBlank()).distinct()
                    .forEach(b -> badgeRepository.save(ProducerBadge.of(saved.getId(), b.trim())));
        }
        return toDetail(saved);
    }

    @Transactional(readOnly = true)
    public ProducerDetailResponse getMyProducer(Long userId) {
        Producer p = producerRepository.findByUserId(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.PRODUCER_NOT_FOUND));
        return toDetail(p);
    }

    @Transactional
    public ProducerOfferResponse addMyOffer(Long userId, CreateOfferRequest req) {
        Producer producer = producerRepository.findByUserId(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.PRODUCER_NOT_FOUND));

        // ingredientId가 오면 실제 활성 식재료인지 검증, 없으면 이름으로 해석 시도(없으면 null)
        Long ingredientId = req.ingredientId();
        if (ingredientId != null) {
            if (ingredientRepository.findByIdAndActiveTrue(ingredientId).isEmpty()) {
                throw new BusinessException(ErrorCode.INGREDIENT_NOT_FOUND);
            }
        } else {
            ingredientId = resolveIngredientId(req.ingredientName());
        }

        ProducerOffer saved = offerRepository.save(ProducerOffer.create(
                producer.getId(), ingredientId, req.ingredientName(),
                req.price(), req.unit(), req.freshnessLabel()));

        // 검색/목록(specialty 기준)에서 새 상품이 누락되지 않도록 specialty도 upsert
        if (!specialtyRepository.existsByProducerIdAndIngredientName(producer.getId(), req.ingredientName())) {
            specialtyRepository.save(ProducerSpecialty.of(producer.getId(), req.ingredientName(), ingredientId));
        }
        return toOffer(saved, producer.getId());
    }

    /** 식재료명으로 ingredient_id 해석 (정확히 일치하는 활성 식재료가 있으면 연결, 없으면 null) */
    private Long resolveIngredientId(String name) {
        return ingredientRepository.findTop20ByActiveTrueAndNameContainingIgnoreCaseOrderByIdDesc(name)
                .stream().filter(i -> i.getName().equals(name)).map(i -> i.getId()).findFirst().orElse(null);
    }

    @Transactional(readOnly = true)
    public List<ProducerOfferResponse> getProducerOffers(Long producerId) {
        requireProducer(producerId);
        return offerRepository.findByProducerIdOrderByPriceAsc(producerId)
                .stream().map(o -> toOffer(o, producerId)).toList();
    }

    @Transactional(readOnly = true)
    public List<ProducerOfferResponse> getOffersForIngredient(Long ingredientId) {
        // 식재료 ID로 농가 비교 (화면 15).
        // 1) offer가 ingredient_id로 링크된 경우 그대로 사용
        List<ProducerOffer> byId = offerRepository.findByIngredientIdOrderByPriceAsc(ingredientId);
        if (!byId.isEmpty()) {
            return byId.stream().map(o -> toOffer(o, o.getProducerId())).toList();
        }
        // 2) 폴백: 아직 ingredient_id 백필 전이면 식재료명으로 매칭 (시드만 있어도 동작)
        return ingredientRepository.findById(ingredientId)
                .map(ing -> offerRepository.findByIngredientNameOrderByPriceAsc(ing.getName()))
                .orElseGet(List::of)
                .stream().map(o -> toOffer(o, o.getProducerId())).toList();
    }

    @Transactional(readOnly = true)
    public List<ProducerOfferResponse> getOffersForIngredientName(String ingredientName) {
        return offerRepository.findByIngredientNameOrderByPriceAsc(ingredientName)
                .stream().map(o -> toOffer(o, o.getProducerId())).toList();
    }

    @Transactional(readOnly = true)
    public List<ProducerReviewResponse> getProducerReviews(Long producerId) {
        requireProducer(producerId);
        return reviewRepository.findByProducerIdOrderByCreatedAtDesc(producerId)
                .stream().map(this::toReview).toList();
    }

    @Transactional(readOnly = true)
    public List<ProducerNewsResponse> getProducerNews(Long producerId) {
        requireProducer(producerId);
        return newsRepository.findByProducerIdOrderByPostedAtDesc(producerId)
                .stream().map(n -> new ProducerNewsResponse(
                        n.getId(), n.getPostedAt(), n.getTitle(), n.getImageRef(), n.getBody())).toList();
    }

    @Transactional
    public ProducerReviewResponse createReview(Long userId, Long producerId, CreateProducerReviewRequest request) {
        Producer producer = producerRepository.findById(producerId)
                .orElseThrow(() -> new BusinessException(ErrorCode.PRODUCER_NOT_FOUND));
        // MVP: 로그인 사용자는 존재하는 농가에 자유롭게 리뷰 작성 가능.
        // (배송완료 주문 기반 자격 검증은 MVP 범위 밖 — 운영 고도화 시 추가)
        ProducerReview saved = reviewRepository.save(
                new ProducerReview(producerId, userId, request.rating(), request.item(), request.body()));
        refreshRatingAggregate(producer);
        return toReview(saved);
    }

    /** producer_reviews 기준으로 producer.rating(평균)·review_count 재계산 */
    private void refreshRatingAggregate(Producer producer) {
        Double avg = reviewRepository.avgRatingByProducerId(producer.getId());
        long count = reviewRepository.countByProducerId(producer.getId());
        BigDecimal rating = avg == null ? BigDecimal.ZERO : BigDecimal.valueOf(avg).setScale(2, RoundingMode.HALF_UP);
        producer.applyReviewStats(rating, (int) count);
        producerRepository.save(producer);
    }

    public boolean existsById(Long producerId) {
        return producerRepository.existsById(producerId);
    }

    // ── helpers ──────────────────────────────────────────────
    private void requireProducer(Long producerId) {
        if (!producerRepository.existsById(producerId)) {
            throw new BusinessException(ErrorCode.PRODUCER_NOT_FOUND);
        }
    }

    private Specification<Producer> producerSearchSpec(String q, String style, Boolean honorary) {
        return (root, query, cb) -> {
            var predicate = cb.conjunction();
            if (q != null) {
                var subquery = query.subquery(Long.class);
                var specialty = subquery.from(ProducerSpecialty.class);
                subquery.select(cb.literal(1L))
                        .where(
                                cb.equal(specialty.get("producerId"), root.get("id")),
                                cb.like(specialty.get("ingredientName"), "%" + q + "%")
                        );
                predicate = cb.and(predicate, cb.exists(subquery));
            }
            if (style != null) {
                predicate = cb.and(predicate, cb.equal(root.get("style"), style));
            }
            if (honorary != null) {
                predicate = cb.and(predicate, cb.equal(root.get("honorary"), honorary));
            }
            return predicate;
        };
    }

    private List<String> specialties(Long producerId) {
        return specialtyRepository.findByProducerId(producerId)
                .stream().map(ProducerSpecialty::getIngredientName).toList();
    }

    private List<String> badges(Long producerId) {
        return badgeRepository.findByProducerId(producerId)
                .stream().map(ProducerBadge::getLabel).toList();
    }

    private ProducerDetailResponse toDetail(Producer p) {
        return new ProducerDetailResponse(
                p.getId(), p.getName(), p.getRegion(), p.getTagline(), p.getPhotoUrl(),
                p.getStyle(), p.getPriceLevel(), p.getFreshnessLevel(), p.getRating(),
                p.getReviewCount(), p.isHonorary(), specialties(p.getId()), badges(p.getId()));
    }

    private ProducerCardResponse toCard(Producer p) {
        return new ProducerCardResponse(
                p.getId(), p.getName(), p.getRegion(), p.getTagline(), p.getPhotoUrl(),
                p.getStyle(), p.getRating(), p.getReviewCount(), p.isHonorary(),
                specialties(p.getId()), badges(p.getId()));
    }

    private ProducerOfferResponse toOffer(ProducerOffer o, Long producerId) {
        Producer p = producerRepository.findById(producerId).orElse(null);
        return new ProducerOfferResponse(
                o.getId(), producerId,
                p != null ? p.getName() : null,
                p != null ? p.getRegion() : null,
                o.getIngredientName(), o.getIngredientId(),
                o.getPrice(), o.getUnit(), o.getFreshnessLabel());
    }

    private ProducerReviewResponse toReview(ProducerReview r) {
        // 시드 리뷰는 author_name 사용, 사용자 작성 리뷰는 user 도메인 연동 전까지 placeholder. TODO(3.10)
        String author = r.getAuthorName() != null ? r.getAuthorName() : "user#" + r.getUserId();
        return new ProducerReviewResponse(
                r.getId(), author, r.getRating(), r.getItem(), r.getBody(), r.getCreatedAt());
    }
}
