package com.seasonaldining.favorite.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record CreateFavoriteRequest(
        @Schema(description = "찜 대상 유형: INGREDIENT 또는 RECIPE", example = "INGREDIENT") @NotBlank String targetType,
        @Schema(description = "찜 대상 ID", example = "1") @NotNull @Positive Long targetId
) {}
