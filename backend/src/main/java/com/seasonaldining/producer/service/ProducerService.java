package com.seasonaldining.producer.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.response.ListResponse;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.producer.dto.request.CreateProducerReviewRequest;
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
        return new ProducerDetailResponse(
                p.getId(), p.getName(), p.getRegion(), p.getTagline(), p.getPhotoUrl(),
                p.getStyle(), p.getPriceLevel(), p.getFreshnessLevel(), p.getRating(),
                p.getReviewCount(), p.isHonorary(), specialties(p.getId()), badges(p.getId()));
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
