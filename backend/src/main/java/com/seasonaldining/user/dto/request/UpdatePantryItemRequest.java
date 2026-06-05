package com.seasonaldining.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.time.LocalDate;

public record UpdatePantryItemRequest(
        @Schema(description = "보유 수량", example = "3", nullable = true) @Positive BigDecimal quantity,
        @Schema(description = "수량 단위", example = "개", nullable = true) @Size(max = 30) String unit,
        @Schema(description = "소비기한", example = "2026-06-10", nullable = true) @FutureOrPresent LocalDate expiresAt
) {
}
