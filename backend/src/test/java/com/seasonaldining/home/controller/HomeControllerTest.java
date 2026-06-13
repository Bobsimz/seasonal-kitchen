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

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest @AutoConfigureMockMvc @ActiveProfiles("test")
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
                // 캐러셀용 heroes는 배열이어야 하고(프론트 .map 대상), hero == heroes[0]
                .andExpect(jsonPath("$.data.heroes").isArray())
                .andExpect(jsonPath("$.data.heroes.length()").value(1))
                .andExpect(jsonPath("$.data.heroes[0].title").value("무"))
                .andExpect(jsonPath("$.data.heroes[0].ingredientId").value(org.hamcrest.Matchers.notNullValue()))
                // hero(단일)는 heroes[0]과 동일해야 한다
                .andExpect(jsonPath("$.data.hero.title").value("무"))
                .andExpect(jsonPath("$.data.hero.ingredientId").value(org.hamcrest.Matchers.notNullValue()))
                .andExpect(jsonPath("$.data.ingredients.length()").value(1))
                .andExpect(jsonPath("$.data.recipes.length()").value(1))
                .andExpect(jsonPath("$.data.reels.length()").value(1))
                .andExpect(jsonPath("$.data.trendingKeywords").isArray())
                .andExpect(jsonPath("$.data.unreadNotificationCount").value(0));
    }

    @Test void emptyIngredients_heroesIsEmptyArrayAndHeroNull() throws Exception {
        // 식재료가 하나도 없으면 heroes=[](빈 배열), hero=null — 프론트가 heroes.map 해도 안전해야 한다
        mvc.perform(get("/api/v1/home")).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.heroes").isArray())
                .andExpect(jsonPath("$.data.heroes.length()").value(0))
                .andExpect(jsonPath("$.data.hero").value(org.hamcrest.Matchers.nullValue()));
    }
}
