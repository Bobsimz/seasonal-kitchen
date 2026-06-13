package com.seasonaldining.home.controller;

import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.reel.entity.Creator;
import com.seasonaldining.reel.entity.Reel;
import com.seasonaldining.reel.repository.CreatorRepository;
import com.seasonaldining.reel.repository.ReelRepository;
import com.seasonaldining.support.UserDataCleaner;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// @Transactional: setUp 의 deleteAll 과 빈-큐레이션 테스트의 DELETE 가 메서드 종료 시 롤백되어,
// 공유 H2 컨텍스트의 시드(큐레이션 등)가 다른 테스트로 오염되지 않게 한다.
@SpringBootTest @AutoConfigureMockMvc @ActiveProfiles("test") @Transactional
class HomeControllerTest {
    @Autowired MockMvc mvc; @Autowired IngredientRepository ingredients; @Autowired RecipeRepository recipes; @Autowired JdbcTemplate jdbc;
    @Autowired CreatorRepository creators; @Autowired ReelRepository reels;
    @BeforeEach void setUp(){UserDataCleaner.clean(jdbc);recipes.deleteAll();ingredients.deleteAll();}
    @Test void returnsHomeAggregation() throws Exception {
        ingredients.save(new Ingredient("무","채소",null,"1개",true));
        Recipe recipe=recipes.save(new Recipe("무조림",null,null,"EASY",30,2,"PUBLISHED"));
        Creator creator=creators.save(new Creator(null,"쿠킹맘",null,"ACTIVE"));
        reels.save(new Reel(recipe.getId(),creator.getId(),"무조림 1분","간단 레시피","https://example.com/reel.mp4","https://example.com/reel.png","무,간단",48,"PUBLISHED",java.time.OffsetDateTime.now()));
        mvc.perform(get("/api/v1/home")).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.seasonTitle").exists())
                // heroes는 큐레이션 카드 배열(시드 V56). 프론트 .map 대상이고 hero == heroes[0].
                .andExpect(jsonPath("$.data.heroes").isArray())
                .andExpect(jsonPath("$.data.heroes.length()", org.hamcrest.Matchers.greaterThanOrEqualTo(1)))
                .andExpect(jsonPath("$.data.heroes[0].id", org.hamcrest.Matchers.notNullValue()))
                .andExpect(jsonPath("$.data.heroes[0].title", org.hamcrest.Matchers.notNullValue()))
                // 큐레이션 카드는 이미지/타이틀/서브타이틀만 — 식재료 전용 필드는 없어야 한다
                .andExpect(jsonPath("$.data.heroes[0].ingredientId").doesNotExist())
                .andExpect(jsonPath("$.data.heroes[0].priceLabel").doesNotExist())
                // hero(단일)는 heroes[0]
                .andExpect(jsonPath("$.data.hero.id", org.hamcrest.Matchers.notNullValue()))
                .andExpect(jsonPath("$.data.hero.title", org.hamcrest.Matchers.notNullValue()))
                .andExpect(jsonPath("$.data.ingredients.length()").value(1))
                .andExpect(jsonPath("$.data.recipes.length()").value(1))
                .andExpect(jsonPath("$.data.reels.length()").value(1))
                .andExpect(jsonPath("$.data.trendingKeywords").isArray())
                .andExpect(jsonPath("$.data.unreadNotificationCount").value(0));
    }

    @Test void noCurations_heroesIsEmptyArrayAndHeroNull() throws Exception {
        // 큐레이션이 하나도 없으면 heroes=[](빈 배열), hero=null — 프론트가 heroes.map 해도 안전해야 한다
        jdbc.update("DELETE FROM curation_recipes");
        jdbc.update("DELETE FROM curation_ingredients");
        jdbc.update("DELETE FROM curations");
        mvc.perform(get("/api/v1/home")).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.heroes").isArray())
                .andExpect(jsonPath("$.data.heroes.length()").value(0))
                .andExpect(jsonPath("$.data.hero").value(org.hamcrest.Matchers.nullValue()));
    }
}
