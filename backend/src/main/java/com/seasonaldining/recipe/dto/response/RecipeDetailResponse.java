package com.seasonaldining.recipe.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

public record RecipeDetailResponse(
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
        @Schema(description = "레시피 재료 목록")
        List<RecipeIngredientResponse> ingredients,
        @Schema(description = "예상 총 재료비", example = "7800", nullable = true)
        BigDecimal estimatedCost,
        @Schema(description = "태그 목록")
        List<String> tags,
        @Schema(description = "크리에이터 이름", example = "쿠킹맘", nullable = true)
        String creatorName,
        @Schema(description = "좋아요 수", example = "84000")
        long likes,
        @Schema(description = "관련 릴스 ID 목록")
        List<Long> relatedReelIds,
        @Schema(description = "관련 릴스 목록")
        List<RelatedReelResponse> relatedReels
) {
    public record RelatedReelResponse(
            @Schema(description = "릴스 ID", example = "1") Long id,
            @Schema(description = "제목", example = "봄동 비빔밥 1분") String title,
            @Schema(description = "썸네일 URL") String thumbnailUrl,
            @Schema(description = "크리에이터 이름", nullable = true) String creatorName,
            @Schema(description = "좋아요 수", example = "84000") long likeCount,
            @Schema(description = "재생 시간(초)", example = "48", nullable = true) Integer durationSeconds,
            @Schema(description = "발행 시각", nullable = true) OffsetDateTime publishedAt
    ) {
    }
}
