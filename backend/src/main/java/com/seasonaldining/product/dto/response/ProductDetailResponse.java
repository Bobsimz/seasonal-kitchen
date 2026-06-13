package com.seasonaldining.product.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.util.List;

/**
 * 상품 상세 응답 — producer_offers facade.
 * 카드 필드 + 상세(이미지/설명/재고/인증/보관/옵션/태그/관련 레시피).
 */
@Schema(description = "상품 상세 — producer_offers facade")
public record ProductDetailResponse(
        @Schema(description = "상품 ID(=offer id)", example = "10") Long id,
        @Schema(description = "상품명(title 없으면 식재료명)", example = "햇 봄동 1.5kg 산지직송") String name,
        @Schema(description = "연결 식재료 ID", example = "12", nullable = true) Long ingredientId,
        @Schema(description = "식재료명", example = "봄동") String ingredientName,
        @Schema(description = "농가 ID", example = "1") Long producerId,
        @Schema(description = "농가명", example = "권민성", nullable = true) String producerName,
        @Schema(description = "지역", example = "경북영천", nullable = true) String region,
        @Schema(description = "판매가", example = "4500") BigDecimal price,
        @Schema(description = "단위", example = "봉") String unit,
        @Schema(description = "대표 이미지(첫 사진)", nullable = true) String imageUrl,
        @Schema(description = "재고 상태", example = "IN_STOCK") StockStatus stockStatus,
        @Schema(description = "카테고리", example = "잎채소", nullable = true) String category,
        @Schema(description = "상품 이미지 목록(첫 번째가 대표)") List<String> images,
        @Schema(description = "상품 설명", nullable = true) String description,
        @Schema(description = "신선도 라벨", example = "당일수확", nullable = true) String freshnessLabel,
        @Schema(description = "재고 수량(미설정 시 null)", example = "120", nullable = true) Integer stockQuantity,
        @Schema(description = "인증마크 목록") List<String> certifications,
        @Schema(description = "보관방법", example = "냉장 보관", nullable = true) String storageMethod,
        @Schema(description = "보관 안내 설명", nullable = true) String storageNote,
        @Schema(description = "상품 옵션(규격/variant) 목록") List<OptionResponse> options,
        @Schema(description = "상품 태그 목록") List<String> tags,
        @Schema(description = "관련 레시피 ID 목록(ingredientId 있을 때, 없으면 빈 배열)") List<Long> relatedRecipeIds,
        @Schema(description = "상세정보 섹션(접기/펼치기). 없으면 빈 배열 — 프론트는 description 단일 섹션으로 폴백") List<DetailSectionResponse> detailSections
) {
    @Schema(description = "상품 옵션")
    public record OptionResponse(
            @Schema(description = "옵션 ID", example = "100") Long id,
            @Schema(description = "수량", example = "1.5", nullable = true) BigDecimal quantity,
            @Schema(description = "단위", example = "kg", nullable = true) String unit,
            @Schema(description = "옵션 가격", example = "6900") BigDecimal price
    ) {}

    @Schema(description = "상품 상세정보 섹션")
    public record DetailSectionResponse(
            @Schema(description = "섹션 제목", example = "재배 환경") String heading,
            @Schema(description = "섹션 본문", example = "해남 황토밭에서 무농약으로 재배했습니다.") String body
    ) {}
}
