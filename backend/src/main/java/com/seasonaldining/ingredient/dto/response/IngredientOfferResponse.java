package com.seasonaldining.ingredient.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

public record IngredientOfferResponse(
        @Schema(description = "오퍼 ID", example = "1") Long id,
        @Schema(description = "스토어 ID", example = "1") Long storeId,
        @Schema(description = "스토어명", example = "쿠팡") String storeName,
        @Schema(description = "스토어 유형", example = "ONLINE") String storeType,
        @Schema(description = "로고 URL", nullable = true) String logoUrl,
        @Schema(description = "로고 텍스트", example = "C", nullable = true) String logoText,
        @Schema(description = "브랜드 색상", example = "#FF5C39", nullable = true) String brandColor,
        @Schema(description = "현재 가격", example = "1190") BigDecimal price,
        @Schema(description = "가격 범위 최소", nullable = true) BigDecimal priceRangeMin,
        @Schema(description = "가격 범위 최대", nullable = true) BigDecimal priceRangeMax,
        @Schema(description = "정가", nullable = true) BigDecimal originalPrice,
        @Schema(description = "할인율", nullable = true) Integer discountRate,
        @Schema(description = "단위", example = "1단") String unit,
        @Schema(description = "배송 라벨", example = "로켓프레시 · 내일 도착", nullable = true) String deliveryLabel,
        @Schema(description = "뱃지", example = "최저가", nullable = true) String badge,
        @Schema(description = "상품 URL", nullable = true) String productUrl,
        @Schema(description = "관측 시각", nullable = true) OffsetDateTime observedAt
) {}
