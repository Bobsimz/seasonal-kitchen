package com.seasonaldining.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.NotNull;

public record DevTokenRequest(
        @Schema(description = "기존 사용자 ID", example = "1")
        @NotNull
        @Positive
        Long userId
) {
}
