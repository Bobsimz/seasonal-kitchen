package com.seasonaldining.user.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.favorite.entity.Favorite;
import com.seasonaldining.favorite.repository.FavoriteRepository;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.price.entity.PriceAlert;
import com.seasonaldining.price.repository.PriceAlertRepository;
import com.seasonaldining.producer.dto.request.RegisterProducerRequest;
import com.seasonaldining.producer.service.ProducerService;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.UserRepository;
import com.seasonaldining.user.repository.UserPreferenceRepository;
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
import java.util.List;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserPreferenceRepository userPreferenceRepository;

    @Autowired
    private IngredientRepository ingredientRepository;

    @Autowired
    private FavoriteRepository favoriteRepository;

    @Autowired
    private PriceAlertRepository priceAlertRepository;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private ProducerService producerService;

    @Autowired
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        UserDataCleaner.clean(jdbcTemplate);
        ingredientRepository.deleteAll();
    }

    @Test
    void authenticatedRequestReturnsCurrentUser() throws Exception {
        User user = userRepository.save(new User("user@example.com", "제철요리사", null, "ACTIVE"));

        mockMvc.perform(get("/api/v1/users/me")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(user.getId()))
                .andExpect(jsonPath("$.data.email").value("user@example.com"))
                // 농가로 등록 안 한 일반 사용자(소비자) — 화면 분기 계약
                .andExpect(jsonPath("$.data.isProducer").value(false))
                .andExpect(jsonPath("$.data.producerId").value(nullValue()));
    }

    @Test
    void currentUserIncludesProducerFlagWhenRegistered() throws Exception {
        // /users/me JSON 계약 고정: 농가로 등록된 사용자는 isProducer=true, producerId가 내려와야 한다(새로고침 세션 복원용)
        User user = userRepository.save(new User("farmer@example.com", "농부", null, "ACTIVE"));
        Long producerId = producerService.registerMyProducer(user.getId(), new RegisterProducerRequest(
                "해남농가", "농부", "전남 해남", "010-1111-2222",
                List.of("무"), "https://cert/x.png", true)).id();

        mockMvc.perform(get("/api/v1/users/me")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.isProducer").value(true))
                .andExpect(jsonPath("$.data.producerId").value(producerId));
    }

    @Test
    void unauthenticatedRequestReturns401() throws Exception {
        mockMvc.perform(get("/api/v1/users/me"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error.code").value("COMMON_UNAUTHORIZED"));
    }

    @Test
    void invalidTokenReturns401() throws Exception {
        mockMvc.perform(get("/api/v1/users/me").header("Authorization", "Bearer invalid-token"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error.code").value("AUTH_INVALID_TOKEN"));
    }

    @Test
    void authenticatedRequestUpdatesCurrentUser() throws Exception {
        User user = userRepository.save(new User("user@example.com", "기존닉네임", null, "ACTIVE"));

        mockMvc.perform(patch("/api/v1/users/me")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId()))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(new UpdateRequest("새닉네임", "https://example.com/profile.png"))))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.nickname").value("새닉네임"))
                .andExpect(jsonPath("$.data.profileImageUrl").value("https://example.com/profile.png"));
    }

    @Test
    void profileUpdateValidationFailure() throws Exception {
        User user = userRepository.save(new User("user@example.com", "기존닉네임", null, "ACTIVE"));

        mockMvc.perform(patch("/api/v1/users/me")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId()))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(new UpdateRequest("", null))))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error.code").value("COMMON_VALIDATION_FAILED"));
    }

    @Test
    void authenticatedRequestUpsertsPreference() throws Exception {
        User user = userRepository.save(new User("user@example.com", "사용자", null, "ACTIVE"));

        mockMvc.perform(put("/api/v1/users/me/preferences")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId()))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"householdSize":2,"budget":30000,"spicyAvoid":true,"priority":"LOW_PRICE"}
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.householdSize").value(2))
                .andExpect(jsonPath("$.data.priority").value("LOW_PRICE"))
                .andExpect(jsonPath("$.data.allergyCodes.length()").value(0));
    }

    @Test
    void preferenceUpdatePersistsAllergyCodes() throws Exception {
        User user = userRepository.save(new User("user@example.com", "사용자", null, "ACTIVE"));

        mockMvc.perform(put("/api/v1/users/me/preferences")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId()))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"householdSize":2,"budget":30000,"spicyAvoid":true,"priority":"LOW_PRICE","allergyCodes":["MILK","EGG","EGG"]}
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.allergyCodes.length()").value(2))
                .andExpect(jsonPath("$.data.allergyCodes[0]").value("EGG"))
                .andExpect(jsonPath("$.data.allergyCodes[1]").value("MILK"));
    }

    @Test
    void myPageSummaryReturnsProfileStatsAndPersonalizedCards() throws Exception {
        User user = userRepository.save(new User("user@example.com", "사용자", "https://example.com/profile.png", "ACTIVE"));
        Ingredient ingredient = ingredientRepository.save(new Ingredient("봄동", "채소", "https://example.com/bomdong.png", "봉", true));
        favoriteRepository.save(new Favorite(user.getId(), "INGREDIENT", ingredient.getId()));
        priceAlertRepository.save(new PriceAlert(user.getId(), ingredient.getId(), new BigDecimal("3000.00"), true));

        mockMvc.perform(put("/api/v1/users/me/preferences")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId()))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"householdSize":2,"budget":30000,"spicyAvoid":true,"priority":"LOW_PRICE","allergyCodes":["EGG"]}
                                """))
                .andExpect(status().isOk());

        mockMvc.perform(get("/api/v1/users/me/summary")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.user.id").value(user.getId()))
                .andExpect(jsonPath("$.data.user.nickname").value("사용자"))
                .andExpect(jsonPath("$.data.user.photoUrl").value("https://example.com/profile.png"))
                .andExpect(jsonPath("$.data.counts.favorites").value(1))
                .andExpect(jsonPath("$.data.counts.priceAlerts").value(1))
                .andExpect(jsonPath("$.data.counts.orders").value(0))
                .andExpect(jsonPath("$.data.counts.reviews").value(0))
                .andExpect(jsonPath("$.data.stats.orderCount").value(0))
                .andExpect(jsonPath("$.data.stats.reviewCount").value(0))
                .andExpect(jsonPath("$.data.personalized[0].name").value("봄동"));
    }

    @Test
    void myPageSummaryReturnsEmptyDefaultsWhenOptionalDataMissing() throws Exception {
        User user = userRepository.save(new User("user@example.com", "사용자", null, "ACTIVE"));

        mockMvc.perform(get("/api/v1/users/me/summary")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.counts.favorites").value(0))
                .andExpect(jsonPath("$.data.counts.priceAlerts").value(0))
                .andExpect(jsonPath("$.data.counts.orders").value(0))
                .andExpect(jsonPath("$.data.counts.reviews").value(0))
                .andExpect(jsonPath("$.data.personalized.length()").value(0));
    }

    @Test
    void myPageSummaryRequiresAuthentication() throws Exception {
        mockMvc.perform(get("/api/v1/users/me/summary"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error.code").value("COMMON_UNAUTHORIZED"));
    }

    @Test
    void preferenceAcceptsFrontendSurveyBody() throws Exception {
        // 가입 설문(FE)이 보내는 사람-라벨 바디 — 모두 선택값. 2xx 로 받고 best-effort 저장한다.
        User user = userRepository.save(new User("survey@example.com", "설문", null, "ACTIVE"));

        mockMvc.perform(put("/api/v1/users/me/preferences")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId()))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"household":"2인","lifestyles":["신선한","저렴한"],"spicyAvoid":false,"allergens":["난류","우유"]}
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.householdSize").value(2))
                .andExpect(jsonPath("$.data.priority").value("신선한"))
                .andExpect(jsonPath("$.data.allergyCodes.length()").value(2));
    }

    @Test
    void preferenceToleratesEmptyBody() throws Exception {
        // 빈/누락 바디도 검증 400 없이 통과해야 한다(설문 건너뛰기 등).
        User user = userRepository.save(new User("empty-pref@example.com", "빈설문", null, "ACTIVE"));

        mockMvc.perform(put("/api/v1/users/me/preferences")
                        .header("Authorization", "Bearer " + jwtTokenProvider.createAccessToken(user.getId()))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isOk());
    }

    private record UpdateRequest(String nickname, String profileImageUrl) {
    }
}
