package com.seasonaldining.home.service;

import com.seasonaldining.home.dto.response.HomeResponse;
import com.seasonaldining.ingredient.dto.response.IngredientCardResponse;
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
        var ingredients = ingredientService.getIngredients(null, null, latest).items();
        // 캐러셀용 히어로 배열(상위 식재료 최대 5개). hero(단일)는 하위 호환을 위해 heroes[0]로 유지.
        List<HomeResponse.HeroResponse> heroes = ingredients.stream()
                .limit(5)
                .map(HomeService::toHero)
                .toList();
        HomeResponse.HeroResponse hero = heroes.isEmpty() ? null : heroes.get(0);
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

    /** 식재료 카드 → 홈 히어로 카드. 가격/추세 라벨은 표시용 문자열로 미리 만들어 내려준다. */
    private static HomeResponse.HeroResponse toHero(IngredientCardResponse card) {
        // 카드의 flat 가격 필드로부터 표시용 라벨을 만든다(예: "4,500원/봉").
        String priceLabel = null;
        if (card.currentPrice() != null) {
            priceLabel = String.format("%,d원", card.currentPrice().longValue());
            if (card.unit() != null && !card.unit().isBlank()) {
                priceLabel += "/" + card.unit();
            }
        }

        // 추세 라벨은 카드의 변동 라벨(예: "-15%")을 그대로 사용한다.
        String trendLabel = card.priceChangeLabel();

        return new HomeResponse.HeroResponse(
                card.name(),
                card.seasonal() ? "지금이 제철이에요" : "이번 주 추천 식재료",
                card.imageUrl(),
                "INGREDIENT",
                card.id(),
                card.id(),
                priceLabel,
                trendLabel
        );
    }
}
