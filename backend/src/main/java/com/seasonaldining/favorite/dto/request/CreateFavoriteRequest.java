package com.seasonaldining.favorite.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record CreateFavoriteRequest(
        @Schema(description = "찜 대상 유형: INGREDIENT, RECIPE, PRODUCER, PRODUCT(=OFFER 상품)", example = "PRODUCT") @NotBlank String targetType,
        @Schema(description = "찜 대상 ID", example = "1") @NotNull @Positive Long targetId
) {}
