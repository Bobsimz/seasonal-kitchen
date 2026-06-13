package com.seasonaldining.recipe.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

public record RecipeStepResponse(
        @Schema(description = "단계 순서(프론트 키). stepNumber와 동일", example = "1")
        int order,
        @Schema(description = "단계 번호", example = "1")
        int stepNumber,
        @Schema(description = "조리 설명", example = "무를 먹기 좋은 크기로 썹니다.")
        String text,
        @Schema(description = "예상 소요 시간(분)", example = "5", nullable = true)
        Integer minutes,
        @Schema(description = "단계 이미지 URL", example = "https://example.com/step-1.png", nullable = true)
        String imageUrl,
        @Schema(description = "조리 팁", nullable = true)
        String tip,
        @Schema(description = "타이머 시간(분)", example = "5", nullable = true)
        Integer timerMinutes
) {
}
