package com.seasonaldining.shopping.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "화면 표시용 장보기 계획 응답")
public record ShoppingPlanResponse(
        @Schema(example = "1") Long planId,
        @Schema(example = "1") Long sessionId,
        @Schema(example = "3") int days,
        @Schema(example = "2") int people,
        @Schema(example = "30000") BigDecimal budget,
        @Schema(example = "18400") BigDecimal estimatedTotal,
        @Schema(example = "CREATED") String status,
        @Schema(example = "3일치 제철 식재료 중심 장보기 계획입니다.") String summary,
        @Schema(example = "12") Integer expectedSavingRate,
        @Schema(example = "2500") BigDecimal expectedSavingAmount,
        List<MealResponse> meals,
        List<ShoppingPlanItemResponse> items,
        List<String> reasons,
        List<String> substitutions
) {

    @Schema(description = "추천 식단 카드")
    public record MealResponse(
            @Schema(example = "추천 식단") String title,
            @Schema(example = "제철 식재료 기반 식단") String description,
            @Schema(example = "1") Integer dayIndex,
            @Schema(example = "DINNER") String mealType
    ) {
    }

}
