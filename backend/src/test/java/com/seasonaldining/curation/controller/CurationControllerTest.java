package com.seasonaldining.curation.controller;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.greaterThanOrEqualTo;
import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest @AutoConfigureMockMvc @ActiveProfiles("test")
class CurationControllerTest {
    @Autowired MockMvc mvc;
    @Autowired JdbcTemplate jdbc;

    @Test void listsCurationCards() throws Exception {
        // 시드(V56) 큐레이션 3건이 카드(이미지/타이틀/서브타이틀)로 내려온다.
        mvc.perform(get("/api/v1/curations")).andExpect(status().isOk())
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data.length()", greaterThanOrEqualTo(1)))
                .andExpect(jsonPath("$.data[0].id", notNullValue()))
                .andExpect(jsonPath("$.data[0].title", notNullValue()));
    }

    @Test void returnsCurationDetailWithRelated() throws Exception {
        Long id = jdbc.queryForObject(
                "SELECT id FROM curations WHERE main_title = ?", Long.class, "무, 겨울을 견디는 단단한 단맛");
        mvc.perform(get("/api/v1/curations/{id}", id)).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.id").value(id))
                .andExpect(jsonPath("$.data.title", notNullValue()))
                .andExpect(jsonPath("$.data.seasonalStory", notNullValue()))
                // 관련 식재료/레시피는 배열로 내려온다(조인 매핑 경로 검증; 건수는 시드 식재료 유무에 의존).
                .andExpect(jsonPath("$.data.relatedIngredients").isArray())
                .andExpect(jsonPath("$.data.relatedRecipes").isArray());
    }

    @Test void unknownCuration_returns404() throws Exception {
        mvc.perform(get("/api/v1/curations/{id}", 999999)).andExpect(status().isNotFound());
    }
}
