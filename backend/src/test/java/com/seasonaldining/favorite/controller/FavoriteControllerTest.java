package com.seasonaldining.favorite.controller;

import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.favorite.entity.Favorite;
import com.seasonaldining.favorite.repository.FavoriteRepository;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest @AutoConfigureMockMvc @ActiveProfiles("test")
class FavoriteControllerTest {
    @Autowired MockMvc mockMvc;
    @Autowired JwtTokenProvider jwtTokenProvider;
    @Autowired FavoriteRepository favoriteRepository;
    @Autowired UserRepository userRepository;
    @Autowired IngredientRepository ingredientRepository;
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
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.targetType").value("INGREDIENT"));
        Favorite favorite = favoriteRepository.findAll().get(0);
        mockMvc.perform(get("/api/v1/favorites").header("Authorization", token))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.length()").value(1));
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

    @Test void unauthenticatedFavoriteRequestReturns401() throws Exception {
        mockMvc.perform(get("/api/v1/favorites"))
                .andExpect(status().isUnauthorized());
    }

    private String token(User user) { return "Bearer " + jwtTokenProvider.createAccessToken(user.getId()); }
}
