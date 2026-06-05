package com.seasonaldining.ingredient.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record IngredientPriceHistoryResponse(
        @Schema(description = "식재료 ID", example = "1")
        Long ingredientId,
        @Schema(description = "식재료명", example = "무")
        String ingredientName,
        @Schema(description = "기준 단위", example = "1개", nullable = true)
        String unit,
        @Schema(description = "데이터 출처", example = "KAMIS", nullable = true)
        String source,
        @Schema(description = "가격 이력 목록")
        List<PriceHistoryItemResponse> items
) {
    public record PriceHistoryItemResponse(
            @Schema(description = "관측일", example = "2026-06-01")
            LocalDate observedDate,
            @Schema(description = "가격", example = "1980")
            BigDecimal price
    ) {
    }
}
