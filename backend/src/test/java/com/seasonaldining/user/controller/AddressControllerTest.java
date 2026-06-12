package com.seasonaldining.user.controller;

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

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class AddressControllerTest {

    @Autowired MockMvc mvc;
    @Autowired JwtTokenProvider jwt;
    @Autowired UserRepository userRepository;
    @Autowired JdbcTemplate jdbc;

    private String token;

    @BeforeEach
    void setUp() {
        UserDataCleaner.clean(jdbc);
        User user = userRepository.save(new User("addr@example.com", "주소사용자", null, "ACTIVE"));
        token = "Bearer " + jwt.createAccessToken(user.getId());
    }

    private String create(String name, boolean isDefault) throws Exception {
        return mvc.perform(post("/api/v1/users/me/addresses").header("Authorization", token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"recipientName\":\"" + name + "\",\"phone\":\"010-1234-5678\"," +
                                "\"address1\":\"서울 강남구 테헤란로 1\",\"isDefault\":" + isDefault + "}"))
                .andExpect(status().isOk()).andReturn().getResponse().getContentAsString();
    }

    @Test
    void firstAddress_isAutoDefault() throws Exception {
        mvc.perform(post("/api/v1/users/me/addresses").header("Authorization", token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"recipientName\":\"홍길동\",\"phone\":\"010-0000-0000\",\"address1\":\"서울\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.isDefault").value(true))     // 첫 배송지는 자동 기본
                .andExpect(jsonPath("$.data.recipientName").value("홍길동"));
    }

    @Test
    void onlyOneDefault_isKept() throws Exception {
        create("첫째", true);
        create("둘째", true);   // 새 기본 지정 → 첫째는 기본 해제돼야 함

        // 목록: 기본 우선 정렬 → [0]이 기본(둘째), 기본은 정확히 1개
        mvc.perform(get("/api/v1/users/me/addresses").header("Authorization", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(2))
                .andExpect(jsonPath("$.data[0].recipientName").value("둘째"))
                .andExpect(jsonPath("$.data[0].isDefault").value(true))
                .andExpect(jsonPath("$.data[1].recipientName").value("첫째"))
                .andExpect(jsonPath("$.data[1].isDefault").value(false));
    }

    @Test
    void update_partial_andSetDefault() throws Exception {
        create("첫째", true);
        Long secondId = idOf(create("둘째", false));

        // 둘째를 기본으로 승격 + 상세주소 수정
        mvc.perform(patch("/api/v1/users/me/addresses/{id}", secondId).header("Authorization", token)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"address2\":\"3층 301호\",\"isDefault\":true}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.address2").value("3층 301호"))
                .andExpect(jsonPath("$.data.recipientName").value("둘째"))   // null=미수정
                .andExpect(jsonPath("$.data.isDefault").value(true));

        mvc.perform(get("/api/v1/users/me/addresses").header("Authorization", token))
                .andExpect(jsonPath("$.data[0].recipientName").value("둘째"))
                .andExpect(jsonPath("$.data[0].isDefault").value(true))
                .andExpect(jsonPath("$.data[1].recipientName").value("첫째"))   // 첫째는 기본 해제됨
                .andExpect(jsonPath("$.data[1].isDefault").value(false));
    }

    @Test
    void cannotUpdateOrDeleteOthersAddress() throws Exception {
        Long myId = idOf(create("내주소", true));
        User other = userRepository.save(new User("addr-other@example.com", "타인", null, "ACTIVE"));
        String otherToken = "Bearer " + jwt.createAccessToken(other.getId());

        mvc.perform(patch("/api/v1/users/me/addresses/{id}", myId).header("Authorization", otherToken)
                        .contentType(MediaType.APPLICATION_JSON).content("{\"phone\":\"010-9999-9999\"}"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("ADDRESS_NOT_FOUND"));

        mvc.perform(delete("/api/v1/users/me/addresses/{id}", myId).header("Authorization", otherToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("ADDRESS_NOT_FOUND"));
    }

    @Test
    void delete_removesAddress() throws Exception {
        Long id = idOf(create("삭제대상", true));
        mvc.perform(delete("/api/v1/users/me/addresses/{id}", id).header("Authorization", token))
                .andExpect(status().isOk());
        mvc.perform(get("/api/v1/users/me/addresses").header("Authorization", token))
                .andExpect(jsonPath("$.data.length()").value(0));
    }

    @Test
    void deletingDefault_promotesRemainingAsDefault() throws Exception {
        Long firstId = idOf(create("첫째", true));   // 기본
        create("둘째", false);                        // 비기본
        // 기본(첫째) 삭제 → 남은 둘째가 기본으로 승격 (항상 1개)
        mvc.perform(delete("/api/v1/users/me/addresses/{id}", firstId).header("Authorization", token))
                .andExpect(status().isOk());
        mvc.perform(get("/api/v1/users/me/addresses").header("Authorization", token))
                .andExpect(jsonPath("$.data.length()").value(1))
                .andExpect(jsonPath("$.data[0].recipientName").value("둘째"))
                .andExpect(jsonPath("$.data[0].isDefault").value(true));
    }

    // 응답 JSON에서 data.id 추출
    private Long idOf(String responseBody) {
        int i = responseBody.indexOf("\"id\":");
        int start = i + 5;
        int end = start;
        while (end < responseBody.length() && Character.isDigit(responseBody.charAt(end))) end++;
        return Long.parseLong(responseBody.substring(start, end));
    }
}
