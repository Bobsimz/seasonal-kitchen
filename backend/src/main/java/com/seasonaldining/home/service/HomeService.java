package com.seasonaldining.home.service;

import com.seasonaldining.home.dto.response.HomeResponse;
import com.seasonaldining.ingredient.service.IngredientService;
import com.seasonaldining.recipe.service.RecipeService;
import com.seasonaldining.reel.service.ReelService;
import com.seasonaldining.search.service.SearchService;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
public class HomeService {
    private final IngredientService ingredientService;
    private final RecipeService recipeService;
    private final SearchService searchService;
    private final ReelService reelService;

    public HomeService(IngredientService ingredientService, RecipeService recipeService, SearchService searchService, ReelService reelService) {
        this.ingredientService = ingredientService;
        this.recipeService = recipeService;
        this.searchService = searchService;
        this.reelService = reelService;
    }

    public HomeResponse getHome() {
        PageRequest latest = PageRequest.of(0, 6, Sort.by(Sort.Direction.DESC, "id"));
        var ingredients = ingredientService.getIngredients(latest).items();
        Long primaryTargetId = ingredients.isEmpty() ? null : ingredients.get(0).id();
        return new HomeResponse(
                "이번 주 제철 식탁",
                "가격과 제철 흐름을 기준으로 추천했어요",
                new HomeResponse.HeroResponse(
                        "지금이 가장 알뜰한 제철 식재료",
                        "오늘의 추천 재료와 레시피를 한 번에 확인하세요",
                        ingredients.isEmpty() ? null : ingredients.get(0).imageUrl(),
                        primaryTargetId == null ? null : "INGREDIENT",
                        primaryTargetId
                ),
                ingredients,
                recipeService.getRecipes(latest).items(),
                reelService.getReels(null).stream()
                        .limit(6)
                        .map(reel -> new HomeResponse.HomeReelResponse(
                                reel.id(),
                                reel.recipeId(),
                                reel.title(),
                                reel.thumbnailUrl(),
                                reel.viewCount(),
                                reel.likeCount(),
                                reel.creatorName(),
                                reel.durationSeconds(),
                                reel.ingredientTags()
                        ))
                        .toList(),
                searchService.trending(),
                0
        );
    }
}
