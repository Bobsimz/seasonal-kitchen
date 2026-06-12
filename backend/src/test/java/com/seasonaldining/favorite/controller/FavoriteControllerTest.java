package com.seasonaldining.favorite.controller;

import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.favorite.entity.Favorite;
import com.seasonaldining.favorite.repository.FavoriteRepository;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.UserRepository;
import com.seasonaldining.support.UserDataCleaner;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.jdbc.core.JdbcTemplate;
import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest @AutoConfigureMockMvc @ActiveProfiles("test")
class FavoriteControllerTest {
    @Autowired MockMvc mockMvc;
    @Autowired JwtTokenProvider jwtTokenProvider;
    @Autowired FavoriteRepository favoriteRepository;
    @Autowired UserRepository userRepository;
    @Autowired IngredientRepository ingredientRepository;
    @Autowired RecipeRepository recipeRepository;
    @Autowired JdbcTemplate jdbcTemplate;

    @BeforeEach void setUp() {
        UserDataCleaner.clean(jdbcTemplate);
        ingredientRepository.deleteAll();
    }

    @Test void crudFavorite() throws Exception {
        User user = userRepository.save(new User("favorite@example.com", "찜사용자", null, "ACTIVE"));
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        String token = token(user);
        mockMvc.perform(post("/api/v1/favorites").header("Authorization", token).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"targetType\":\"INGREDIENT\",\"targetId\":" + ingredient.getId() + "}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.targetType").value("INGREDIENT"))
                .andExpect(jsonPath("$.data.title").value("무"));         // 대상 요약(생성 응답에도 포함)
        Favorite favorite = favoriteRepository.findAll().get(0);
        mockMvc.perform(get("/api/v1/favorites").header("Authorization", token))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.length()").value(1))
                .andExpect(jsonPath("$.data[0].title").value("무"))        // 찜 목록 표시용 요약
                .andExpect(jsonPath("$.data[0].subtitle").value("채소"))
                .andExpect(jsonPath("$.data[0].targetId").value(ingredient.getId()));
        mockMvc.perform(delete("/api/v1/favorites/{id}", favorite.getId()).header("Authorization", token))
                .andExpect(status().isOk());
    }

    @Test void cannotDeleteAnotherUsersFavorite() throws Exception {
        User owner = userRepository.save(new User("owner-f@example.com", "주인찜", null, "ACTIVE"));
        User other = userRepository.save(new User("other-f@example.com", "타인찜", null, "ACTIVE"));
        Favorite favorite = favoriteRepository.save(new Favorite(owner.getId(), "INGREDIENT", 1L));
        mockMvc.perform(delete("/api/v1/favorites/{id}", favorite.getId()).header("Authorization", token(other)))
                .andExpect(status().isNotFound()).andExpect(jsonPath("$.error.code").value("FAVORITE_NOT_FOUND"));
    }

    @Test void favoriteList_enrichesProducerSummary() throws Exception {
        User user = userRepository.save(new User("fav-prod@example.com", "찜프로", null, "ACTIVE"));
        long pid = 99100L;
        jdbcTemplate.update("DELETE FROM producers WHERE id = ?", pid);
        jdbcTemplate.update("INSERT INTO producers (id,name,region,tagline,photo_url,style,price_level,freshness_level,rating,review_count,honorary) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?,?)",
                pid, "권민성농가", "경북 영천", "고랭지 무농약", "https://img/p.png", "ORGANIC", 4, 5, new java.math.BigDecimal("4.5"), 3, false);
        favoriteRepository.save(new Favorite(user.getId(), "PRODUCER", pid));
        mockMvc.perform(get("/api/v1/favorites").header("Authorization", token(user)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].targetType").value("PRODUCER"))
                .andExpect(jsonPath("$.data[0].title").value("권민성농가"))
                .andExpect(jsonPath("$.data[0].imageUrl").value("https://img/p.png"))
                .andExpect(jsonPath("$.data[0].subtitle").value("고랭지 무농약"));   // tagline 우선
        jdbcTemplate.update("DELETE FROM producers WHERE id = ?", pid);
    }

    @Test void favoriteList_enrichesRecipeSummary() throws Exception {
        User user = userRepository.save(new User("fav-recipe@example.com", "찜레시피", null, "ACTIVE"));
        Recipe r = recipeRepository.save(new Recipe("무조림", "무로 만든 조림", "https://img/r.png", "EASY", 20, 2, "PUBLISHED"));
        favoriteRepository.save(new Favorite(user.getId(), "RECIPE", r.getId()));
        mockMvc.perform(get("/api/v1/favorites").header("Authorization", token(user)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].title").value("무조림"))
                .andExpect(jsonPath("$.data[0].imageUrl").value("https://img/r.png"))
                .andExpect(jsonPath("$.data[0].subtitle").value("무로 만든 조림"));
    }

    @Test void favoriteList_inactiveIngredient_summaryNull() throws Exception {
        User user = userRepository.save(new User("fav-inactive@example.com", "찜비활성", null, "ACTIVE"));
        Ingredient inactive = ingredientRepository.save(new Ingredient("배추", "채소", null, "1포기", false)); // active=false
        // 비활성 대상이 찜에 남아있는 상황(직접 저장으로 시뮬레이션) → 식별필드 유지, 요약 null
        favoriteRepository.save(new Favorite(user.getId(), "INGREDIENT", inactive.getId()));
        mockMvc.perform(get("/api/v1/favorites").header("Authorization", token(user)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].targetId").value(inactive.getId()))
                .andExpect(jsonPath("$.data[0].title").value(nullValue()))
                .andExpect(jsonPath("$.data[0].subtitle").value(nullValue()));
    }

    @Test void favoriteList_unpublishedRecipe_summaryNull() throws Exception {
        User user = userRepository.save(new User("fav-draft@example.com", "찜초안", null, "ACTIVE"));
        Recipe draft = recipeRepository.save(new Recipe("초안 레시피", "비공개", null, "EASY", 10, 1, "DRAFT"));
        favoriteRepository.save(new Favorite(user.getId(), "RECIPE", draft.getId()));
        mockMvc.perform(get("/api/v1/favorites").header("Authorization", token(user)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].targetId").value(draft.getId()))
                .andExpect(jsonPath("$.data[0].title").value(nullValue()));
    }

    @Test void unauthenticatedFavoriteRequestReturns401() throws Exception {
        mockMvc.perform(get("/api/v1/favorites"))
                .andExpect(status().isUnauthorized());
    }

    private String token(User user) { return "Bearer " + jwtTokenProvider.createAccessToken(user.getId()); }
}
