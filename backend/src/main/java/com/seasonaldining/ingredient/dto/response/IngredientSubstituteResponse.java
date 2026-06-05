package com.seasonaldining.ingredient.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;

public record IngredientSubstituteResponse(
        @Schema(description = "대체 식재료 ID", example = "2")
        Long ingredientId,
        @Schema(description = "대체 식재료명", example = "감자")
        String name,
        @Schema(description = "대체 적합도 점수", example = "85")
        int score,
        @Schema(description = "대체 이유", example = "비슷한 식감을 제공합니다.", nullable = true)
        String reason,
        @Schema(description = "이미지 URL", nullable = true)
        String imageUrl,
        @Schema(description = "현재 가격", nullable = true)
        BigDecimal price,
        @Schema(description = "단위", nullable = true)
        String unit,
        @Schema(description = "가격 차이 라벨", nullable = true)
        String priceDeltaLabel
) {
}
