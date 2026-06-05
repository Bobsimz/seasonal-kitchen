package com.seasonaldining.ingredient.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public record IngredientCardResponse(
        @Schema(description = "식재료 ID", example = "1")
        Long id,

        @Schema(description = "식재료명", example = "무")
        String name,

        @Schema(description = "식재료 이미지 URL", example = "https://example.com/radish.png", nullable = true)
        String imageUrl,

        @Schema(description = "카테고리", example = "채소")
        String category,

        @Schema(description = "가격 요약. 가격 도메인 미구현 시 null")
        PriceSummaryResponse price,

        @Schema(description = "제철 여부", example = "false")
        boolean seasonal,

        @Schema(description = "구매 시그널", example = "BUY_NOW", nullable = true)
        String buyingSignal,

        @Schema(description = "태그 목록", example = "[\"제철\", \"가격하락\"]")
        List<String> tags
) {
    public record PriceSummaryResponse(
            @Schema(description = "현재 가격", example = "1980")
            BigDecimal currentPrice,
            @Schema(description = "가격 단위", example = "1개")
            String unit,
            @Schema(description = "주간 변동률", example = "-12.5")
            BigDecimal weekChangeRate,
            @Schema(description = "연평균 대비 변동률", example = "-8.2")
            BigDecimal yearAverageChangeRate,
            @Schema(description = "가격 관측일", example = "2026-06-01")
            LocalDate observedDate,
            @Schema(description = "데이터 출처", example = "KAMIS")
            String source
    ) {
    }
}
