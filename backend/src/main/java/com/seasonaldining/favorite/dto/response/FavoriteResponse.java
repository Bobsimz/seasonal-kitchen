package com.seasonaldining.favorite.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record FavoriteResponse(
        @Schema(description = "찜 ID", example = "1") Long id,
        @Schema(description = "찜 대상 유형", example = "INGREDIENT") String targetType,
        @Schema(description = "찜 대상 ID", example = "1") Long targetId
) {}
