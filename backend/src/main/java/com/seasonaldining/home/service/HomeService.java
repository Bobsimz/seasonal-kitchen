package com.seasonaldining.home.service;

import com.seasonaldining.curation.dto.response.CurationCardResponse;
import com.seasonaldining.curation.service.CurationService;
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
    private final CurationService curationService;
    private final IngredientService ingredientService;
    private final RecipeService recipeService;
    private final SearchService searchService;
    private final ReelService reelService;

    public HomeService(CurationService curationService, IngredientService ingredientService, RecipeService recipeService, SearchService searchService, ReelService reelService) {
        this.curationService = curationService;
        this.ingredientService = ingredientService;
        this.recipeService = recipeService;
        this.searchService = searchService;
        this.reelService = reelService;
    }

    public HomeResponse getHome() {
        PageRequest latest = PageRequest.of(0, 6, Sort.by(Sort.Direction.DESC, "id"));
        var ingredients = ingredientService.getIngredients(null, null, latest).items();
        // 홈 히어로 = 큐레이션 카드(메인 이미지/타이틀/서브타이틀). hero(단일)는 하위 호환을 위해 heroes[0].
        List<CurationCardResponse> heroes = curationService.getCurationCards();
        CurationCardResponse hero = heroes.isEmpty() ? null : heroes.get(0);
        return new HomeResponse(
                "이번 주 제철 식탁",
                "가격과 제철 흐름을 기준으로 추천했어요",
                hero,
                heroes,
                ingredients,
                recipeService.getRecipes(null, null, latest).items(),
                reelService.getReels(null).stream()
                        .limit(6)
                        .map(reel -> new HomeResponse.HomeReelResponse(
                                reel.id(),
                                reel.recipeId(),
                                reel.title(),
                                reel.thumbnailUrl(),
                                reel.views(),
                                reel.likes(),
                                reel.creatorName(),
                                reel.durationSeconds(),
                                reel.ingredients()
                        ))
                        .toList(),
                searchService.trending(),
                0
        );
    }
}
