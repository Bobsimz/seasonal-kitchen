package com.seasonaldining.recipe.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;

public record RecipeCardResponse(
        @Schema(description = "레시피 ID", example = "1")
        Long id,
        @Schema(description = "레시피 제목", example = "무조림")
        String title,
        @Schema(description = "레시피 설명", example = "달콤 짭짤한 무조림", nullable = true)
        String description,
        @Schema(description = "대표 이미지 URL", example = "https://example.com/radish-recipe.png", nullable = true)
        String imageUrl,
        @Schema(description = "난이도", example = "EASY")
        String difficulty,
        @Schema(description = "조리 시간(분)", example = "30")
        int cookMinutes,
        @Schema(description = "인분", example = "2")
        int servings,
        @Schema(description = "좋아요 수", example = "84000")
        long likes,
        @Schema(description = "조회 수", example = "1240000")
        long viewCount,
        @Schema(description = "크리에이터 이름", example = "쿠킹맘", nullable = true)
        String creatorName,
        @Schema(description = "태그 목록")
        List<String> tags,
        @Schema(description = "제철 레시피 여부", example = "false")
        boolean seasonal,
        @Schema(description = "주요 재료명 목록")
        List<String> mainIngredients
) {
}
