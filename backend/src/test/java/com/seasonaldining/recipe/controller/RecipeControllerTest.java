package com.seasonaldining.recipe.controller;

import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceSnapshotRepository;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.entity.RecipeIngredient;
import com.seasonaldining.recipe.entity.RecipeStep;
import com.seasonaldining.recipe.repository.RecipeIngredientRepository;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.recipe.repository.RecipeStepRepository;
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
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class RecipeControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private RecipeIngredientRepository recipeIngredientRepository;

    @Autowired
    private IngredientRepository ingredientRepository;

    @Autowired
    private RecipeStepRepository recipeStepRepository;
    @Autowired
    private PriceSnapshotRepository priceSnapshotRepository;
    @Autowired
    private CreatorRepository creatorRepository;
    @Autowired
    private ReelRepository reelRepository;
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @BeforeEach
    void setUp() {
        UserDataCleaner.clean(jdbcTemplate);
        recipeStepRepository.deleteAll();
        recipeIngredientRepository.deleteAll();
        recipeRepository.deleteAll();
        priceSnapshotRepository.deleteAll();
        ingredientRepository.deleteAll();
    }

    @Test
    void listPublishedRecipes() throws Exception {
        recipeRepository.save(new Recipe("무조림", "간단한 반찬", null, "EASY", 30, 2, "PUBLISHED"));

        mockMvc.perform(get("/api/v1/recipes"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.items.length()").value(1))
                .andExpect(jsonPath("$.data.items[0].title").value("무조림"))
                .andExpect(jsonPath("$.data.items[0].likes").value(0))
                .andExpect(jsonPath("$.data.items[0].tags[0]").value("EASY"));
    }

    @Test
    void paginationResponseShape() throws Exception {
        recipeRepository.save(new Recipe("무조림", null, null, "EASY", 30, 2, "PUBLISHED"));
        recipeRepository.save(new Recipe("배추전", null, null, "EASY", 20, 2, "PUBLISHED"));

        mockMvc.perform(get("/api/v1/recipes").param("page", "0").param("size", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.page").value(0))
                .andExpect(jsonPath("$.data.size").value(1))
                .andExpect(jsonPath("$.data.totalElements").value(2))
                .andExpect(jsonPath("$.data.hasNext").value(true));
    }

    @Test
    void excludesDraftRecipes() throws Exception {
        recipeRepository.save(new Recipe("무조림", null, null, "EASY", 30, 2, "PUBLISHED"));
        recipeRepository.save(new Recipe("작성중", null, null, "EASY", 10, 1, "DRAFT"));

        mockMvc.perform(get("/api/v1/recipes"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items.length()").value(1))
                .andExpect(jsonPath("$.data.items[0].title").value("무조림"));
    }

    @Test
    void recipeDetailSuccess() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        Recipe recipe = recipeRepository.save(new Recipe("무조림", "간단한 반찬", null, "EASY", 30, 2, "PUBLISHED"));
        recipeIngredientRepository.save(new RecipeIngredient(recipe.getId(), ingredient.getId(), new BigDecimal("1.00"), "개", false));
        priceSnapshotRepository.save(new PriceSnapshot(ingredient.getId(), "KAMIS", "AVERAGE", new BigDecimal("1980"), "1개", LocalDate.now()));
        Creator creator = creatorRepository.save(new Creator(null, "쿠킹맘", null, "ACTIVE"));
        reelRepository.save(new Reel(recipe.getId(), creator.getId(), "무조림 1분", "간단", "https://example.com/video.mp4", "https://example.com/thumb.png", "무", 48, "PUBLISHED", OffsetDateTime.now()));

        mockMvc.perform(get("/api/v1/recipes/{recipeId}", recipe.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.title").value("무조림"))
                .andExpect(jsonPath("$.data.ingredients.length()").value(1))
                .andExpect(jsonPath("$.data.ingredients[0].ingredientName").value("무"))
                .andExpect(jsonPath("$.data.ingredients[0].estimatedPrice").value(1980))
                .andExpect(jsonPath("$.data.estimatedCost").value(1980))
                .andExpect(jsonPath("$.data.tags[0]").value("EASY"))
                .andExpect(jsonPath("$.data.relatedReels.length()").value(1))
                .andExpect(jsonPath("$.data.relatedReels[0].creatorName").value("쿠킹맘"));
    }

    @Test
    void recipeDetailShowsNonAgriculturalIngredientsAsTextWithoutLink() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        Recipe recipe = recipeRepository.save(new Recipe("무조림", "간단한 반찬", null, "EASY", 30, 2, "PUBLISHED"));
        // 농산물 — ingredient_id 연결 (상세 링크 대상)
        recipeIngredientRepository.save(new RecipeIngredient(recipe.getId(), ingredient.getId(), new BigDecimal("1.00"), "개", false));
        // 비농산물(양념) — ingredient_id 없이 자유 텍스트 이름만
        recipeIngredientRepository.save(new RecipeIngredient(recipe.getId(), null, "간장", new BigDecimal("3.00"), "스푼", false));

        mockMvc.perform(get("/api/v1/recipes/{recipeId}", recipe.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.ingredients.length()").value(2))
                .andExpect(jsonPath("$.data.ingredients[0].ingredientId").value(ingredient.getId()))
                .andExpect(jsonPath("$.data.ingredients[0].ingredientName").value("무"))
                .andExpect(jsonPath("$.data.ingredients[1].ingredientId").doesNotExist())
                .andExpect(jsonPath("$.data.ingredients[1].ingredientName").value("간장"));
    }

    @Test
    void recipeDetailNotFound() throws Exception {
        mockMvc.perform(get("/api/v1/recipes/{recipeId}", 99999L))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("RECIPE_NOT_FOUND"));
    }

    @Test
    void draftRecipeDetailTreatedAsNotFound() throws Exception {
        Recipe recipe = recipeRepository.save(new Recipe("작성중", null, null, "EASY", 10, 1, "DRAFT"));

        mockMvc.perform(get("/api/v1/recipes/{recipeId}", recipe.getId()))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("RECIPE_NOT_FOUND"));
    }

    @Test
    void recipeStepsOrderedByStepNumber() throws Exception {
        Recipe recipe = recipeRepository.save(new Recipe("무조림", null, null, "EASY", 30, 2, "PUBLISHED"));
        recipeStepRepository.save(new RecipeStep(recipe.getId(), 2, "양념을 넣습니다.", 10, null));
        recipeStepRepository.save(new RecipeStep(recipe.getId(), 1, "무를 썹니다.", 5, null));

        mockMvc.perform(get("/api/v1/recipes/{recipeId}/steps", recipe.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(2))
                .andExpect(jsonPath("$.data[0].stepNumber").value(1))
                .andExpect(jsonPath("$.data[0].timerMinutes").value(5))
                .andExpect(jsonPath("$.data[1].stepNumber").value(2));
    }

    @Test
    void recipeStepsRecipeNotFound() throws Exception {
        mockMvc.perform(get("/api/v1/recipes/{recipeId}/steps", 99999L))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("RECIPE_NOT_FOUND"));
    }

    @Test
    void recipeStepsEmptyForValidRecipe() throws Exception {
        Recipe recipe = recipeRepository.save(new Recipe("무조림", null, null, "EASY", 30, 2, "PUBLISHED"));

        mockMvc.perform(get("/api/v1/recipes/{recipeId}/steps", recipe.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(0));
    }
}
