package com.seasonaldining.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;

/** refresh/logout 공용 요청 — refresh token 원문. */
@Schema(description = "Refresh token 요청(갱신/로그아웃)")
public record RefreshTokenRequest(
        @Schema(description = "발급받은 refresh token", requiredMode = Schema.RequiredMode.REQUIRED)
        @NotBlank String refreshToken
) {}
