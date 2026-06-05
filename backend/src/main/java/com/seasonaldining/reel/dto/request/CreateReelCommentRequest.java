package com.seasonaldining.reel.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateReelCommentRequest(
        @NotBlank
        @Size(max = 1000)
        @Schema(description = "댓글 내용", example = "오늘 바로 해먹어볼게요")
        String content
) {}
