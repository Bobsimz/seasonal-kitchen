package com.seasonaldining.home.dto.response;

import com.seasonaldining.ingredient.dto.response.IngredientCardResponse;
import com.seasonaldining.recipe.dto.response.RecipeCardResponse;
import com.seasonaldining.search.dto.response.SearchKeywordResponse;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

public record HomeResponse(
        @Schema(description = "제철/절기 제목", example = "11월 둘째 주 · 입동")
        String seasonTitle,

        @Schema(description = "홈 제철 설명", example = "지금이 가장 알뜰한 제철 식재료를 모았어요")
        String seasonSubtitle,

        @Schema(description = "홈 히어로 카드")
        HeroResponse hero,

        @Schema(description = "홈 추천 식재료") List<IngredientCardResponse> ingredients,
        @Schema(description = "홈 추천 레시피") List<RecipeCardResponse> recipes,
        @Schema(description = "홈 릴스 요약 카드. 릴스 도메인 미구현 시 빈 배열") List<HomeReelResponse> reels,
        @Schema(description = "인기 검색어") List<SearchKeywordResponse> trendingKeywords,
        @Schema(description = "읽지 않은 알림 수. 비로그인 홈에서는 0") long unreadNotificationCount
) {
    public record HeroResponse(
            @Schema(description = "히어로 제목", example = "지금이 가장 알뜰한 제철 식재료")
            String title,
            @Schema(description = "히어로 부제", example = "가격이 내려간 봄동과 무를 확인해보세요")
            String subtitle,
            @Schema(description = "히어로 이미지 URL", nullable = true)
            String imageUrl,
            @Schema(description = "주요 이동 대상 유형", example = "INGREDIENT")
            String primaryTargetType,
            @Schema(description = "주요 이동 대상 ID", example = "1", nullable = true)
            Long primaryTargetId
    ) {
    }

    public record HomeReelResponse(
            @Schema(description = "릴스 ID", example = "1")
            Long id,
            @Schema(description = "레시피 ID", example = "1", nullable = true)
            Long recipeId,
            @Schema(description = "릴스 제목", example = "봄동 비빔밥 1분")
            String title,
            @Schema(description = "썸네일 URL", nullable = true)
            String thumbnailUrl,
            @Schema(description = "조회 수", example = "1240000")
            long viewCount,
            @Schema(description = "좋아요 수", example = "84000")
            long likeCount,
            @Schema(description = "크리에이터 이름", example = "쿠킹맘", nullable = true)
            String creatorName,
            @Schema(description = "재생 시간(초)", example = "48")
            Integer durationSeconds,
            @Schema(description = "태그 목록")
            List<String> tags
    ) {
    }
}
