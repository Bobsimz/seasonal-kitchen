package com.seasonaldining.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.time.LocalDate;

public record PantryItemResponse(
        @Schema(description = "보유 재료 항목 ID", example = "1") Long id,
        @Schema(description = "식재료 ID", example = "1") Long ingredientId,
        @Schema(description = "식재료명", example = "무") String ingredientName,
        @Schema(description = "보유 수량", example = "2", nullable = true) BigDecimal quantity,
        @Schema(description = "수량 단위", example = "개", nullable = true) String unit,
        @Schema(description = "소비기한", example = "2026-06-10", nullable = true) LocalDate expiresAt
) {
}
