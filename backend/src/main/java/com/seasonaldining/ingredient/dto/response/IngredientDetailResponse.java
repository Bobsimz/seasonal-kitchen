package com.seasonaldining.ingredient.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.util.List;

public record IngredientDetailResponse(
        @Schema(description = "식재료 ID", example = "1")
        Long id,

        @Schema(description = "식재료명", example = "무")
        String name,

        @Schema(description = "카테고리", example = "채소")
        String category,

        @Schema(description = "식재료 이미지 URL", example = "https://example.com/radish.png", nullable = true)
        String imageUrl,

        @Schema(description = "기준 단위", example = "1개")
        String baseUnit,

        @Schema(description = "제철 여부", example = "false")
        boolean seasonal,

        @Schema(description = "제철 점수", example = "0", nullable = true)
        Integer seasonScore,

        @Schema(description = "가격 요약. 가격 도메인 미구현 시 null")
        IngredientCardResponse.PriceSummaryResponse price,

        @Schema(description = "구매 시그널", example = "BUY_NOW", nullable = true)
        String buyingSignal,

        @Schema(description = "상세 설명", example = "현재 가격 메리트가 높은 제철 식재료입니다.", nullable = true)
        String description,
        @Schema(description = "제철 월 목록")
        List<Integer> seasonMonths,
        @Schema(description = "영양 정보", nullable = true)
        NutritionResponse nutrition,
        @Schema(description = "손질 팁")
        List<String> careTips,
        @Schema(description = "보관 팁")
        List<StorageTipResponse> storageTips,
        @Schema(description = "가격 비교 가능 매장 수", example = "3")
        long compareStoreCount
) {
    public record NutritionResponse(Integer calories, BigDecimal carbohydrate, BigDecimal sugar, BigDecimal fiber, BigDecimal protein, BigDecimal fat, List<NutritionItemResponse> vitamins) {}
    public record NutritionItemResponse(String name, String value) {}
    public record StorageTipResponse(String storageType, String description, String icon) {}
}
