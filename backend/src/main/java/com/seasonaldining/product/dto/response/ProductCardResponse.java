package com.seasonaldining.product.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;

/**
 * 상품 카드(목록) 응답 — producer_offers facade.
 * id는 producer_offers.id. name은 offer.title이 있으면 title, 없으면 ingredientName.
 */
@Schema(description = "상품 카드 — producer_offers facade")
public record ProductCardResponse(
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
        @Schema(description = "카테고리", example = "잎채소", nullable = true) String category
) {}
