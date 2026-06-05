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
                .andExpect(jsonPath("$.data.hero.title").exists())
                .andExpect(jsonPath("$.data.ingredients.length()").value(1))
                .andExpect(jsonPath("$.data.recipes.length()").value(1))
                .andExpect(jsonPath("$.data.reels.length()").value(1))
                .andExpect(jsonPath("$.data.trendingKeywords").isArray())
                .andExpect(jsonPath("$.data.unreadNotificationCount").value(0));
    }
}
