package com.seasonaldining.reel.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.OffsetDateTime;
import java.util.List;

public record ReelResponse(
        @Schema(description = "릴스 ID", example = "1") Long id,
        @Schema(description = "연결 레시피 ID", example = "1", nullable = true) Long recipeId,
        @Schema(description = "크리에이터 ID", example = "1") Long creatorId,
        @Schema(description = "크리에이터 이름", example = "쿠킹맘") String creatorName,
        @Schema(description = "크리에이터 아바타 URL", nullable = true) String creatorAvatar,
        @Schema(description = "영상 URL") String videoUrl,
        @Schema(description = "썸네일 URL") String thumbnailUrl,
        @Schema(description = "제목", example = "봄동 비빔밥 1분") String title,
        @Schema(description = "캡션/설명", nullable = true) String caption,
        @Schema(description = "재료 태그(표시용 이름)") List<String> ingredients,
        @Schema(description = "재료 바로가기(이름+카탈로그 ID). id가 있으면 식재료 상세로 링크 가능") List<IngredientRef> ingredientRefs,
        @Schema(description = "좋아요 수", example = "84000") long likes,
        @Schema(description = "댓글 수", example = "12") long comments,
        @Schema(description = "저장 수", example = "30") long saves,
        @Schema(description = "조회 수", example = "1240000") long views,
        @Schema(description = "재생 시간(초)", example = "48", nullable = true) Integer durationSeconds,
        @Schema(description = "현재 사용자의 좋아요 여부") boolean liked,
        @Schema(description = "현재 사용자의 저장 여부") boolean saved,
        @Schema(description = "발행 시각") OffsetDateTime publishedAt
) {
        /** 재료 바로가기 항목 — id가 null이 아니면 식재료 상세(/ingredients/{id})로 이동 가능. */
        public record IngredientRef(
                @Schema(description = "카탈로그 식재료 ID(매칭 안 되면 null)", nullable = true) Long id,
                @Schema(description = "재료 이름", example = "당근") String name
        ) {}
}
