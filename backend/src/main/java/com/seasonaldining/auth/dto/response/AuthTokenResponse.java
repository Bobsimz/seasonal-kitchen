package com.seasonaldining.auth.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "인증 토큰 응답")
public record AuthTokenResponse(
        @Schema(description = "JWT access token") String accessToken,
        @Schema(description = "Refresh token(만료 시 /auth/refresh로 access 재발급)") String refreshToken,
        @Schema(description = "토큰 타입", example = "Bearer") String tokenType,
        @Schema(description = "사용자 ID", example = "1") Long userId,
        @Schema(description = "닉네임", example = "제철러버") String nickname,
        @Schema(description = "농가(판매자) 여부 — 화면 분기용. 농가로 등록돼 있으면 true", example = "false") boolean isProducer,
        @Schema(description = "농가 ID — 농가면 값, 소비자면 null", example = "1", nullable = true) Long producerId
) {}
