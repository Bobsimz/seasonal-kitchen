package com.seasonaldining.analytics.controller;

import com.seasonaldining.analytics.repository.UserEventRepository;
import com.seasonaldining.common.security.JwtTokenProvider;
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

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class UserEventControllerTest {
    @Autowired MockMvc mvc;
    @Autowired JwtTokenProvider jwt;
    @Autowired UserRepository users;
    @Autowired UserEventRepository events;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach void setUp() { UserDataCleaner.clean(jdbc); }

    @Test void createsUserEventForCurrentUser() throws Exception {
        User user = users.save(new User("event@example.com", "이벤트", null, "ACTIVE"));
        mvc.perform(post("/api/v1/events").header("Authorization", token(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"eventType\":\"INGREDIENT_VIEW\",\"targetType\":\"INGREDIENT\",\"targetId\":1,\"metadataJson\":\"{\\\"source\\\":\\\"home\\\"}\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.eventType").value("INGREDIENT_VIEW"));

        assertThat(events.findAll()).hasSize(1);
        assertThat(events.findAll().get(0).getUserId()).isEqualTo(user.getId());
    }

    @Test void validationFailure() throws Exception {
        User user = users.save(new User("event-validation@example.com", "검증", null, "ACTIVE"));
        mvc.perform(post("/api/v1/events").header("Authorization", token(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"eventType\":\"\",\"targetId\":0}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error.code").value("COMMON_VALIDATION_FAILED"));
    }

    @Test void unauthenticatedRequestReturns401() throws Exception {
        mvc.perform(post("/api/v1/events").contentType(MediaType.APPLICATION_JSON).content("{\"eventType\":\"INGREDIENT_VIEW\"}"))
                .andExpect(status().isUnauthorized());
    }

    private String token(User user) { return "Bearer " + jwt.createAccessToken(user.getId()); }
}
