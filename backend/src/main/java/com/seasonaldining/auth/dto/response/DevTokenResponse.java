package com.seasonaldining.auth.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record DevTokenResponse(
        @Schema(description = "JWT access token")
        String accessToken,
        @Schema(description = "토큰 타입", example = "Bearer")
        String tokenType
) {
}
