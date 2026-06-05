package com.seasonaldining.user.controller;

import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.user.entity.PantryItem;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.PantryItemRepository;
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

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class PantryControllerTest {
    @Autowired MockMvc mockMvc;
    @Autowired JwtTokenProvider jwtTokenProvider;
    @Autowired PantryItemRepository pantryItemRepository;
    @Autowired UserRepository userRepository;
    @Autowired IngredientRepository ingredientRepository;
    @Autowired JdbcTemplate jdbcTemplate;

    @BeforeEach
    void setUp() {
        UserDataCleaner.clean(jdbcTemplate);
        ingredientRepository.deleteAll();
    }

    @Test
    void crudPantryItem() throws Exception {
        User user = userRepository.save(new User("pantry@example.com", "팬트리", null, "ACTIVE"));
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        String token = token(user);

        mockMvc.perform(post("/api/v1/users/me/pantry").header("Authorization", token).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"ingredientId\":" + ingredient.getId() + ",\"quantity\":2,\"unit\":\"개\"}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.ingredientName").value("무"));

        PantryItem item = pantryItemRepository.findAll().get(0);
        mockMvc.perform(patch("/api/v1/users/me/pantry/{itemId}", item.getId()).header("Authorization", token).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"quantity\":3,\"unit\":\"개\"}"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.quantity").value(3));

        mockMvc.perform(get("/api/v1/users/me/pantry").header("Authorization", token))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.length()").value(1));

        mockMvc.perform(delete("/api/v1/users/me/pantry/{itemId}", item.getId()).header("Authorization", token))
                .andExpect(status().isOk());
    }

    @Test
    void rejectsInvalidPantryRequest() throws Exception {
        User user = userRepository.save(new User("pantry@example.com", "팬트리", null, "ACTIVE"));
        mockMvc.perform(post("/api/v1/users/me/pantry").header("Authorization", token(user)).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"ingredientId\":0,\"quantity\":-1,\"expiresAt\":\"2020-01-01\"}"))
                .andExpect(status().isBadRequest()).andExpect(jsonPath("$.error.code").value("COMMON_VALIDATION_FAILED"));
    }

    @Test
    void cannotUpdateAnotherUsersPantryItem() throws Exception {
        User owner = userRepository.save(new User("owner@example.com", "주인", null, "ACTIVE"));
        User other = userRepository.save(new User("other@example.com", "다른사용자", null, "ACTIVE"));
        Ingredient ingredient = ingredientRepository.save(new Ingredient("무", "채소", null, "1개", true));
        PantryItem item = pantryItemRepository.save(new PantryItem(owner.getId(), ingredient.getId(), BigDecimal.ONE, "개", LocalDate.now()));

        mockMvc.perform(patch("/api/v1/users/me/pantry/{itemId}", item.getId()).header("Authorization", token(other)).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"quantity\":2,\"unit\":\"개\"}"))
                .andExpect(status().isNotFound()).andExpect(jsonPath("$.error.code").value("PANTRY_ITEM_NOT_FOUND"));
    }

    private String token(User user) {
        return "Bearer " + jwtTokenProvider.createAccessToken(user.getId());
    }
}
