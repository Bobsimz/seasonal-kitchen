package com.seasonaldining.auth.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "인증 토큰 응답")
public record AuthTokenResponse(
        @Schema(description = "JWT access token") String accessToken,
        @Schema(description = "토큰 타입", example = "Bearer") String tokenType,
        @Schema(description = "사용자 ID", example = "1") Long userId,
        @Schema(description = "닉네임", example = "제철러버") String nickname
) {}
