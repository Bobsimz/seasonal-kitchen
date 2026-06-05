package com.seasonaldining.shopping.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;

@Schema(description = "장보기 항목 응답")
public record ShoppingPlanItemResponse(
        @Schema(example = "1") Long itemId,
        @Schema(example = "1") Long ingredientId,
        @Schema(example = "봄동") String ingredientName,
        @Schema(example = "1") BigDecimal quantity,
        @Schema(example = "봉") String unit,
        @Schema(example = "4500") BigDecimal estimatedPrice,
        @Schema(example = "true") boolean selected,
        @Schema(example = "마켓컬리") String platform,
        @Schema(example = "최저가") String tag
) {
}
