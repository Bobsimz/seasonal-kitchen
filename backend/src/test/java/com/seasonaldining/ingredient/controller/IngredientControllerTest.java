package com.seasonaldining.ingredient.controller;

import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.entity.IngredientCareTip;
import com.seasonaldining.ingredient.entity.IngredientNutrition;
import com.seasonaldining.ingredient.entity.IngredientStorageTip;
import com.seasonaldining.ingredient.repository.IngredientCareTipRepository;
import com.seasonaldining.ingredient.repository.IngredientNutritionRepository;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.ingredient.repository.IngredientStorageTipRepository;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceSnapshotRepository;
import com.seasonaldining.recipe.entity.IngredientSubstitute;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.entity.RecipeIngredient;
import com.seasonaldining.recipe.repository.IngredientSubstituteRepository;
import com.seasonaldining.recipe.repository.RecipeIngredientRepository;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.store.entity.Store;
import com.seasonaldining.store.entity.StoreOffer;
import com.seasonaldining.store.repository.StoreOfferRepository;
import com.seasonaldining.store.repository.StoreRepository;
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

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class IngredientControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private IngredientRepository ingredientRepository;

    @Autowired
    private PriceSnapshotRepository priceSnapshotRepository;

    @Autowired
    private IngredientSubstituteRepository ingredientSubstituteRepository;

    @Autowired
    private IngredientNutritionRepository ingredientNutritionRepository;

    @Autowired
    private IngredientCareTipRepository ingredientCareTipRepository;

    @Autowired
    private IngredientStorageTipRepository ingredientStorageTipRepository;

    @Autowired
    private StoreRepository storeRepository;

    @Autowired
    private StoreOfferRepository storeOfferRepository;

    @Autowired
    private RecipeRepository recipeRepository;

    @Autowired
    private RecipeIngredientRepository recipeIngredientRepository;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @BeforeEach
    void setUp() {
        UserDataCleaner.clean(jdbcTemplate);
        recipeIngredientRepository.deleteAll();
        recipeRepository.deleteAll();
        storeOfferRepository.deleteAll();
        storeRepository.deleteAll();
        ingredientStorageTipRepository.deleteAll();
        ingredientCareTipRepository.deleteAll();
        ingredientNutritionRepository.deleteAll();
        ingredientSubstituteRepository.deleteAll();
        priceSnapshotRepository.deleteAll();
        ingredientRepository.deleteAll();
    }

    @Test
    void listActiveIngredients() throws Exception {
        ingredientRepository.save(new Ingredient("무", "채소", "https://example.com/radish.png", "1개", true));

        mockMvc.perform(get("/api/v1/ingredients"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.items.length()").value(1))
                .andExpect(jsonPath("$.data.items[0].name").value("무"))
                .andExpect(jsonPath("$.data.items[0].price").isEmpty());
    }

    @Test
    void paginationResponseShape() throws Exception {
        ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        ingredientRepository.save(new Ingredient("배추", "채소", null, "1포기", true));

        mockMvc.perform(get("/api/v1/ingredients").param("page", "0").param("size", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.page").value(0))
                .andExpect(jsonPath("$.data.size").value(1))
                .andExpect(jsonPath("$.data.totalElements").value(2))
                .andExpect(jsonPath("$.data.hasNext").value(true));
    }

    @Test
    void excludesInactiveIngredients() throws Exception {
        ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        ingredientRepository.save(new Ingredient("비활성", "채소", null, "1개", false));

        mockMvc.perform(get("/api/v1/ingredients"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items.length()").value(1))
                .andExpect(jsonPath("$.data.items[0].name").value("무"));
    }

    @Test
    void ingredientDetailSuccess() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", "https://example.com/radish.png", "1개", true));

        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}", ingredient.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(ingredient.getId()))
                .andExpect(jsonPath("$.data.name").value("무"))
                .andExpect(jsonPath("$.data.baseUnit").value("1개"));
    }

    @Test
    void ingredientDetailIncludesScreenRequiredFields() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", "https://example.com/radish.png", "1개", true));
        Store store = storeRepository.save(new Store("시장", "LOCAL", null, "시", "#135E36", "https://example.com/store", "SEOUL"));
        ingredientNutritionRepository.save(new IngredientNutrition(
                ingredient.getId(),
                18,
                new BigDecimal("4.10"),
                new BigDecimal("2.50"),
                new BigDecimal("1.60"),
                new BigDecimal("0.70"),
                new BigDecimal("0.10"),
                "15mg",
                "230mg",
                "28ug"
        ));
        ingredientCareTipRepository.save(new IngredientCareTip(ingredient.getId(), 1, "표면이 단단한 것을 고릅니다."));
        ingredientStorageTipRepository.save(new IngredientStorageTip(ingredient.getId(), "냉장", "신문지에 싸서 보관합니다.", "fridge"));
        storeOfferRepository.save(new StoreOffer(
                store.getId(),
                ingredient.getId(),
                new BigDecimal("1900.00"),
                new BigDecimal("1800.00"),
                new BigDecimal("2100.00"),
                new BigDecimal("2300.00"),
                17,
                "1개",
                "오늘배송",
                "특가",
                "https://example.com/radish"
        ));

        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}", ingredient.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.seasonMonths").isArray())
                .andExpect(jsonPath("$.data.nutrition").isArray())
                .andExpect(jsonPath("$.data.nutrition[0].label").value("칼로리"))
                .andExpect(jsonPath("$.data.nutrition[0].value").value("18kcal"))
                .andExpect(jsonPath("$.data.nutrition[1].label").value("비타민C"))
                .andExpect(jsonPath("$.data.nutrition[1].value").value("15mg"))
                .andExpect(jsonPath("$.data.careTips[0]").value("표면이 단단한 것을 고릅니다."))
                .andExpect(jsonPath("$.data.storageTips[0]").value("신문지에 싸서 보관합니다."))
                .andExpect(jsonPath("$.data.compareStoreCount").value(1));
    }

    @Test
    void ingredientDetailNotFound() throws Exception {
        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}", 99999L))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.error.code").value("INGREDIENT_NOT_FOUND"));
    }

    @Test
    void inactiveIngredientTreatedAsNotFound() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("비활성", "채소", null, "1개", false));

        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}", ingredient.getId()))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.error.code").value("INGREDIENT_NOT_FOUND"));
    }

    @Test
    void priceHistorySuccess() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));

        priceSnapshotRepository.save(new PriceSnapshot(
                ingredient.getId(),
                "KAMIS",
                "PUBLIC_AVERAGE",
                new BigDecimal("2100.00"),
                "1개",
                LocalDate.of(2026, 5, 30)
        ));
        priceSnapshotRepository.save(new PriceSnapshot(
                ingredient.getId(),
                "KAMIS",
                "PUBLIC_AVERAGE",
                new BigDecimal("1980.00"),
                "1개",
                LocalDate.of(2026, 6, 1)
        ));

        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/prices", ingredient.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.ingredientId").value(ingredient.getId()))
                .andExpect(jsonPath("$.data.unit").value("1개"))
                .andExpect(jsonPath("$.data.source").value("KAMIS"))
                .andExpect(jsonPath("$.data.items.length()").value(2))
                .andExpect(jsonPath("$.data.items[0].observedDate").value("2026-05-30"))
                .andExpect(jsonPath("$.data.items[1].observedDate").value("2026-06-01"));
    }

    @Test
    void priceHistoryIngredientNotFound() throws Exception {
        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/prices", 99999L))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.error.code").value("INGREDIENT_NOT_FOUND"));
    }

    @Test
    void emptyPriceHistoryReturnsEmptyItems() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));

        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/prices", ingredient.getId())
                        .param("from", "2026-05-01")
                        .param("to", "2026-06-01"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.items.length()").value(0));
    }

    @Test
    void substitutesOrderedByScoreDescending() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        Ingredient potato = ingredientRepository.save(new Ingredient("감자", "채소", null, "1개", true));
        Ingredient turnip = ingredientRepository.save(new Ingredient("순무", "채소", null, "1개", true));
        ingredientSubstituteRepository.save(new IngredientSubstitute(ingredient.getId(), potato.getId(), 70, "식감이 비슷합니다."));
        ingredientSubstituteRepository.save(new IngredientSubstitute(ingredient.getId(), turnip.getId(), 90, "같은 뿌리채소입니다."));

        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/substitutes", ingredient.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(2))
                .andExpect(jsonPath("$.data[0].name").value("순무"))
                .andExpect(jsonPath("$.data[1].name").value("감자"));
    }

    @Test
    void offersSortedByPriceAscending() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        Store expensiveStore = storeRepository.save(new Store("비싼몰", "ONLINE", null, "비", "#111111", null, null));
        Store cheapStore = storeRepository.save(new Store("저렴몰", "ONLINE", null, "저", "#222222", null, null));
        storeOfferRepository.save(new StoreOffer(
                expensiveStore.getId(),
                ingredient.getId(),
                new BigDecimal("2500.00"),
                new BigDecimal("2400.00"),
                new BigDecimal("2600.00"),
                null,
                null,
                "1개",
                "택배",
                null,
                "https://example.com/expensive"
        ));
        storeOfferRepository.save(new StoreOffer(
                cheapStore.getId(),
                ingredient.getId(),
                new BigDecimal("1800.00"),
                new BigDecimal("1700.00"),
                new BigDecimal("1900.00"),
                new BigDecimal("2200.00"),
                18,
                "1개",
                "새벽배송",
                "최저가",
                "https://example.com/cheap"
        ));

        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/offers", ingredient.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(2))
                .andExpect(jsonPath("$.data[0].storeName").value("저렴몰"))
                .andExpect(jsonPath("$.data[0].deliveryLabel").value("새벽배송"))
                .andExpect(jsonPath("$.data[0].priceRangeMin").value(1700.00))
                .andExpect(jsonPath("$.data[0].priceRangeMax").value(1900.00))
                .andExpect(jsonPath("$.data[0].discountRate").value(18))
                .andExpect(jsonPath("$.data[0].productUrl").value("https://example.com/cheap"));
    }

    @Test
    void offersIngredientNotFound() throws Exception {
        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/offers", 99999L))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("INGREDIENT_NOT_FOUND"));
    }

    @Test
    void relatedRecipesForIngredient() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        Recipe recipe = recipeRepository.save(new Recipe("무조림", "달큰한 무조림", "https://example.com/recipe.png", "EASY", 20, 2, "PUBLISHED"));
        recipeIngredientRepository.save(new RecipeIngredient(recipe.getId(), ingredient.getId(), new BigDecimal("1.00"), "개", false));

        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/recipes", ingredient.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(1))
                .andExpect(jsonPath("$.data[0].title").value("무조림"))
                .andExpect(jsonPath("$.data[0].tags[0]").value("EASY"));
    }

    @Test
    void relatedRecipesIngredientNotFound() throws Exception {
        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/recipes", 99999L))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("INGREDIENT_NOT_FOUND"));
    }

    @Test
    void substitutesIngredientNotFound() throws Exception {
        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/substitutes", 99999L))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("INGREDIENT_NOT_FOUND"));
    }

    @Test
    void substitutesEmptyForValidIngredient() throws Exception {
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));

        mockMvc.perform(get("/api/v1/ingredients/{ingredientId}/substitutes", ingredient.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(0));
    }
}
