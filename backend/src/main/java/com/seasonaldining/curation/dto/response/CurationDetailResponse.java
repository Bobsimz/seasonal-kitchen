package com.seasonaldining.curation.dto.response;

import com.seasonaldining.ingredient.dto.response.IngredientCardResponse;
import com.seasonaldining.recipe.dto.response.RecipeCardResponse;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

/** 큐레이션 상세 — 메인 이미지/타이틀/서브타이틀 + 제철 이야기 + 관련 식재료/레시피(탭). */
public record CurationDetailResponse(
        @Schema(description = "큐레이션 ID", example = "1")
        Long id,

        @Schema(description = "메인 이미지 URL", nullable = true)
        String imageUrl,

        @Schema(description = "메인 타이틀", example = "봄동, 봄을 가장 먼저 알리는 채소")
        String title,

        @Schema(description = "서브타이틀", example = "겨우내 단맛을 머금은 봄의 첫 잎채소", nullable = true)
        String subtitle,

        @Schema(description = "제철 이야기 내용", nullable = true)
        String seasonalStory,

        @Schema(description = "관련 식재료")
        List<IngredientCardResponse> relatedIngredients,

        @Schema(description = "관련 레시피")
        List<RecipeCardResponse> relatedRecipes
) {
}
