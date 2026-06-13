package com.seasonaldining.product.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.response.ListResponse;
import com.seasonaldining.producer.entity.OfferCertification;
import com.seasonaldining.producer.entity.OfferDetailSection;
import com.seasonaldining.producer.entity.OfferOption;
import com.seasonaldining.producer.entity.OfferPhoto;
import com.seasonaldining.producer.entity.OfferTag;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.entity.ProducerOffer;
import com.seasonaldining.producer.repository.OfferCertificationRepository;
import com.seasonaldining.producer.repository.OfferDetailSectionRepository;
import com.seasonaldining.producer.repository.OfferOptionRepository;
import com.seasonaldining.producer.repository.OfferPhotoRepository;
import com.seasonaldining.producer.repository.OfferTagRepository;
import com.seasonaldining.producer.repository.ProducerOfferRepository;
import com.seasonaldining.producer.repository.ProducerRepository;
import com.seasonaldining.product.dto.response.ProductCardResponse;
import com.seasonaldining.product.dto.response.ProductDetailResponse;
import com.seasonaldining.product.dto.response.StockStatus;
import com.seasonaldining.recipe.entity.RecipeIngredient;
import com.seasonaldining.recipe.repository.RecipeIngredientRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 상품(Product) 도메인 — 전용 테이블 없이 <b>producer_offers를 상품으로 보는 facade</b>.
 * id는 producer_offers.id. 농가(region/style)·사진/태그/옵션/인증 정규화 테이블을 묶어 상품으로 표현한다.
 */
@Service
@Transactional(readOnly = true)
public class ProductService {

    private final ProducerOfferRepository offerRepository;
    private final ProducerRepository producerRepository;
    private final OfferPhotoRepository offerPhotoRepository;
    private final OfferTagRepository offerTagRepository;
    private final OfferOptionRepository offerOptionRepository;
    private final OfferCertificationRepository offerCertificationRepository;
    private final OfferDetailSectionRepository offerDetailSectionRepository;
    private final RecipeIngredientRepository recipeIngredientRepository;

    public ProductService(ProducerOfferRepository offerRepository,
                          ProducerRepository producerRepository,
                          OfferPhotoRepository offerPhotoRepository,
                          OfferTagRepository offerTagRepository,
                          OfferOptionRepository offerOptionRepository,
                          OfferCertificationRepository offerCertificationRepository,
                          OfferDetailSectionRepository offerDetailSectionRepository,
                          RecipeIngredientRepository recipeIngredientRepository) {
        this.offerRepository = offerRepository;
        this.producerRepository = producerRepository;
        this.offerPhotoRepository = offerPhotoRepository;
        this.offerTagRepository = offerTagRepository;
        this.offerOptionRepository = offerOptionRepository;
        this.offerCertificationRepository = offerCertificationRepository;
        this.offerDetailSectionRepository = offerDetailSectionRepository;
        this.recipeIngredientRepository = recipeIngredientRepository;
    }

    /** 상품 목록/검색 (페이지네이션 + q/category/region/style 필터). */
    public ListResponse<ProductCardResponse> getProducts(String q, String category, String region, String style,
                                                         int page, int size) {
        Page<ProducerOffer> pageResult = offerRepository.searchProducts(
                blankToNull(q), blankToNull(category), blankToNull(region), normalizeStyle(style),
                PageRequest.of(page, size));
        List<ProductCardResponse> cards = toCards(pageResult.getContent());
        return new ListResponse<>(cards, pageResult.getNumber(), pageResult.getSize(),
                pageResult.getTotalElements(), pageResult.hasNext());
    }

    /** 검색(type=PRODUCT)용 — 상위 limit개 카드. */
    public List<ProductCardResponse> searchCards(String q, int limit) {
        Page<ProducerOffer> pageResult = offerRepository.searchProducts(
                blankToNull(q), null, null, null, PageRequest.of(0, limit));
        return toCards(pageResult.getContent());
    }

    /** 상품 상세 (id = producer_offers.id). */
    public ProductDetailResponse getProduct(Long id) {
        ProducerOffer o = offerRepository.findById(id)
                .filter(of -> ProducerOffer.STATUS_ACTIVE.equals(of.getStatus()))  // 숨김(HIDDEN) 상품은 비공개
                .orElseThrow(() -> new BusinessException(ErrorCode.PRODUCT_NOT_FOUND));
        Producer p = producerRepository.findById(o.getProducerId()).orElse(null);

        List<String> images = offerPhotoRepository.findByOfferIdOrderBySortOrderAsc(id)
                .stream().map(OfferPhoto::getUrl).toList();
        List<String> tags = offerTagRepository.findByOfferIdOrderByIdAsc(id)
                .stream().map(OfferTag::getLabel).toList();
        List<String> certifications = offerCertificationRepository.findByOfferIdOrderByIdAsc(id)
                .stream().map(OfferCertification::getLabel).toList();
        List<ProductDetailResponse.OptionResponse> options = offerOptionRepository.findByOfferIdOrderBySortOrderAsc(id)
                .stream().map(op -> new ProductDetailResponse.OptionResponse(
                        op.getId(), op.getQuantity(), op.getUnit(), op.getPrice())).toList();
        List<Long> relatedRecipeIds = o.getIngredientId() == null ? List.of()
                : recipeIngredientRepository.findByIngredientIdOrderByIdAsc(o.getIngredientId())
                        .stream().map(RecipeIngredient::getRecipeId).distinct().toList();
        List<ProductDetailResponse.DetailSectionResponse> detailSections =
                offerDetailSectionRepository.findByOfferIdOrderBySortOrderAsc(id).stream()
                        .map(s -> new ProductDetailResponse.DetailSectionResponse(s.getImageUrl(), s.getHeading(), s.getBody()))
                        .toList();

        return new ProductDetailResponse(
                o.getId(), nameOf(o), o.getIngredientId(), o.getIngredientName(),
                o.getProducerId(), p != null ? p.getName() : null, p != null ? p.getRegion() : null,
                o.getPrice(), o.getUnit(), images.isEmpty() ? null : images.get(0),
                StockStatus.from(o.getStockQuantity()), o.getCategory(),
                images, o.getDescription(), o.getFreshnessLabel(), o.getStockQuantity(),
                certifications, o.getStorageMethod(), o.getStorageNote(), options, tags, relatedRecipeIds,
                detailSections);
    }

    // ── 목록 배치 매핑 (N+1 회피) ──────────────────────────────
    private List<ProductCardResponse> toCards(List<ProducerOffer> offers) {
        if (offers.isEmpty()) return List.of();
        List<Long> offerIds = offers.stream().map(ProducerOffer::getId).toList();
        // 대표 이미지(첫 사진) — sort_order asc 첫 행
        Map<Long, String> firstPhotoByOffer = offerPhotoRepository.findByOfferIdInOrderBySortOrderAsc(offerIds)
                .stream().collect(Collectors.toMap(OfferPhoto::getOfferId, OfferPhoto::getUrl, (a, b) -> a));
        List<Long> producerIds = offers.stream().map(ProducerOffer::getProducerId).distinct().toList();
        Map<Long, Producer> producers = producerRepository.findAllById(producerIds).stream()
                .collect(Collectors.toMap(Producer::getId, pp -> pp));
        return offers.stream().map(o -> {
            Producer p = producers.get(o.getProducerId());
            return new ProductCardResponse(
                    o.getId(), nameOf(o), o.getIngredientId(), o.getIngredientName(),
                    o.getProducerId(), p != null ? p.getName() : null, p != null ? p.getRegion() : null,
                    o.getPrice(), o.getUnit(), firstPhotoByOffer.get(o.getId()),
                    StockStatus.from(o.getStockQuantity()), o.getCategory());
        }).toList();
    }

    private String nameOf(ProducerOffer o) {
        return (o.getTitle() != null && !o.getTitle().isBlank()) ? o.getTitle() : o.getIngredientName();
    }

    private String blankToNull(String s) {
        return (s == null || s.isBlank()) ? null : s.trim();
    }

    /** style은 enum(VALUE/ORGANIC/PREMIUM) 정확일치라 대소문자 정규화. 'organic' → 'ORGANIC'. */
    private String normalizeStyle(String style) {
        return (style == null || style.isBlank()) ? null : style.trim().toUpperCase();
    }
}
