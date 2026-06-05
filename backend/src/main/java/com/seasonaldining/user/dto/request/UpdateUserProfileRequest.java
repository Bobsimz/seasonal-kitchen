package com.seasonaldining.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UpdateUserProfileRequest(
        @Schema(description = "닉네임", example = "제철요리사")
        @NotBlank
        @Size(max = 100)
        String nickname,
        @Schema(description = "프로필 이미지 URL", example = "https://example.com/profile.png", nullable = true)
        @Size(max = 500)
        String profileImageUrl
) {
}
