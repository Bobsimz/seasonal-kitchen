package com.seasonaldining.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record UserProfileResponse(
        @Schema(description = "사용자 ID", example = "1")
        Long id,
        @Schema(description = "이메일", example = "user@example.com")
        String email,
        @Schema(description = "닉네임", example = "제철요리사")
        String nickname,
        @Schema(description = "프로필 이미지 URL", example = "https://example.com/profile.png", nullable = true)
        String profileImageUrl,
        @Schema(description = "사용자 상태", example = "ACTIVE")
        String status,
        @Schema(description = "농가(판매자) 여부 — 화면 분기용. 농가로 등록돼 있으면 true", example = "false")
        boolean isProducer,
        @Schema(description = "농가 ID — 농가면 값, 소비자면 null", example = "1", nullable = true)
        Long producerId
) {
}
