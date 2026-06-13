package com.seasonaldining.recipe.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;

public record RecipeIngredientResponse(
        @Schema(description = "식재료 ID", example = "1")
        Long ingredientId,
        @Schema(description = "식재료명(프론트 키)", example = "무")
        String name,
        @Schema(description = "필요 수량 라벨(표시용)", example = "1 개", nullable = true)
        String amount,
        @Schema(description = "식재료 이미지 URL(프론트 키)", nullable = true)
        String imageUrl,
        @Schema(description = "예상 가격(프론트 키)", example = "1980", nullable = true)
        BigDecimal price,
        @Schema(description = "식재료명", example = "무")
        String ingredientName,
        @Schema(description = "필요 수량", example = "1", nullable = true)
        BigDecimal quantity,
        @Schema(description = "수량 단위", example = "개", nullable = true)
        String unit,
        @Schema(description = "선택 재료 여부", example = "false")
        boolean optional,
        @Schema(description = "식재료 이미지 URL", nullable = true)
        String ingredientImageUrl,
        @Schema(description = "예상 가격", example = "1980", nullable = true)
        BigDecimal estimatedPrice
) {
}
