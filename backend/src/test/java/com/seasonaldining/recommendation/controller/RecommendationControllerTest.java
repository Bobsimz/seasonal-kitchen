package com.seasonaldining.recommendation.controller;

import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceSnapshotRepository;
import com.seasonaldining.shopping.repository.ShoppingPlanItemRepository;
import com.seasonaldining.store.entity.Store;
import com.seasonaldining.store.entity.StoreOffer;
import com.seasonaldining.store.repository.StoreOfferRepository;
import com.seasonaldining.store.repository.StoreRepository;
import com.seasonaldining.support.UserDataCleaner;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class RecommendationControllerTest {

    @Autowired
    private MockMvc mvc;

    @Autowired
    private JwtTokenProvider jwt;

    @Autowired
    private UserRepository users;

    @Autowired
    private IngredientRepository ingredients;

    @Autowired
    private PriceSnapshotRepository prices;

    @Autowired
    private StoreRepository stores;

    @Autowired
    private StoreOfferRepository storeOffers;

    @Autowired
    private ShoppingPlanItemRepository shoppingItems;

    @Autowired
    private JdbcTemplate jdbc;

    @BeforeEach
    void setUp() {
        UserDataCleaner.clean(jdbc);
        ingredients.deleteAll();
    }

    @Test
    void createsPlanWithScreenReadyItems() throws Exception {
        User user = users.save(new User("plan@example.com", "계획", null, "ACTIVE"));
        seedShoppingCandidates();

        mvc.perform(post("/api/v1/recommendations/plans")
                        .header("Authorization", token(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"days\":3,\"people\":2,\"budget\":30000}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.days").value(3))
                .andExpect(jsonPath("$.data.summary").value("3일치 제철 식재료 중심 장보기 계획입니다."))
                .andExpect(jsonPath("$.data.expectedSavingRate").isNumber())
                .andExpect(jsonPath("$.data.meals.length()").value(3))
                .andExpect(jsonPath("$.data.items.length()").value(2))
                .andExpect(jsonPath("$.data.items[0].ingredientName").value("봄동"))
                .andExpect(jsonPath("$.data.items[0].estimatedPrice").value(4300.00))
                .andExpect(jsonPath("$.data.items[0].platform").value("마켓컬리"))
                .andExpect(jsonPath("$.data.reasons.length()").value(2));
    }

    @Test
    void validatesPlan() throws Exception {
        User user = users.save(new User("plan@example.com", "계획", null, "ACTIVE"));

        mvc.perform(post("/api/v1/recommendations/plans")
                        .header("Authorization", token(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"days\":0,\"people\":0}"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void getsOwnedPlanWithSameScreenReadyShape() throws Exception {
        User user = users.save(new User("plan@example.com", "계획", null, "ACTIVE"));
        seedShoppingCandidates();
        String token = token(user);
        Long planId = createPlan(token);

        mvc.perform(get("/api/v1/shopping-plans/{id}", planId).header("Authorization", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.planId").value(planId))
                .andExpect(jsonPath("$.data.items[0].ingredientName").value("봄동"));
    }

    @Test
    void updatesSelectedItemState() throws Exception {
        User user = users.save(new User("plan@example.com", "계획", null, "ACTIVE"));
        seedShoppingCandidates();
        String token = token(user);
        Long planId = createPlan(token);
        Long itemId = shoppingItems.findByPlanIdOrderByIdAsc(planId).get(0).getId();

        mvc.perform(patch("/api/v1/shopping-plans/{planId}/items/{itemId}", planId, itemId)
                        .header("Authorization", token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"selected\":false}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.selected").value(false))
                .andExpect(jsonPath("$.data.ingredientName").value("봄동"));
    }

    @Test
    void storeLinksGroupsSelectedItemsByStore() throws Exception {
        User user = users.save(new User("plan@example.com", "계획", null, "ACTIVE"));
        seedShoppingCandidates();
        String token = token(user);
        Long planId = createPlan(token);

        mvc.perform(get("/api/v1/shopping-plans/{planId}/store-links", planId).header("Authorization", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.savingAmount").isNumber())
                .andExpect(jsonPath("$.data.storeGroups.length()").value(1))
                .andExpect(jsonPath("$.data.storeGroups[0].storeName").value("마켓컬리"))
                .andExpect(jsonPath("$.data.storeGroups[0].deliveryLabel").value("샛별배송"))
                .andExpect(jsonPath("$.data.storeGroups[0].externalCheckoutUrl").value("https://example.com/checkout"))
                .andExpect(jsonPath("$.data.storeGroups[0].items.length()").value(2));
    }

    @Test
    void unauthorizedUserCannotAccessAnotherUsersPlan() throws Exception {
        User owner = users.save(new User("owner@example.com", "주인", null, "ACTIVE"));
        User other = users.save(new User("other@example.com", "타인", null, "ACTIVE"));
        seedShoppingCandidates();
        Long planId = createPlan(token(owner));

        mvc.perform(get("/api/v1/shopping-plans/{id}", planId).header("Authorization", token(other)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("SHOPPING_PLAN_NOT_FOUND"));
    }

    private Long createPlan(String token) throws Exception {
        mvc.perform(post("/api/v1/recommendations/plans")
                        .header("Authorization", token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"days\":3,\"people\":2,\"budget\":30000}"))
                .andExpect(status().isOk());
        return jdbc.queryForObject("SELECT id FROM shopping_plans ORDER BY id DESC LIMIT 1", Long.class);
    }

    private void seedShoppingCandidates() {
        Ingredient bomdong = ingredients.save(new Ingredient("봄동", "채소", null, "봉", true));
        Ingredient radish = ingredients.save(new Ingredient("무", "채소", null, "개", true));
        prices.save(new PriceSnapshot(bomdong.getId(), "KAMIS", "PUBLIC_AVERAGE", new BigDecimal("4500.00"), "봉", LocalDate.of(2026, 6, 1)));
        prices.save(new PriceSnapshot(radish.getId(), "KAMIS", "PUBLIC_AVERAGE", new BigDecimal("2200.00"), "개", LocalDate.of(2026, 6, 1)));
        Store marketKurly = stores.save(new Store("마켓컬리", "ONLINE", null, "컬", "#5f0080", null, null));
        storeOffers.save(new StoreOffer(marketKurly.getId(), bomdong.getId(), new BigDecimal("4300.00"), new BigDecimal("4200.00"), new BigDecimal("4500.00"), null, null, "봉", "샛별배송", "최저가", "https://example.com/checkout"));
        storeOffers.save(new StoreOffer(marketKurly.getId(), radish.getId(), new BigDecimal("2100.00"), new BigDecimal("2000.00"), new BigDecimal("2300.00"), null, null, "개", "샛별배송", "추천", "https://example.com/checkout"));
    }

    private String token(User user) {
        return "Bearer " + jwt.createAccessToken(user.getId());
    }
}
