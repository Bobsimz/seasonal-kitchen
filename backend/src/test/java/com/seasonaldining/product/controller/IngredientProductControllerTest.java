package com.seasonaldining.product.controller;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * GET /api/v1/ingredients/{id}/products — 식재료별 판매 상품(producer_offers facade) 조회.
 * 농가 비교(/producers)와 동일 offer 집합을 가격순 ProductCardResponse로 노출.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class IngredientProductControllerTest {

    private static final long PRODUCER_ID = 94000L;
    private static final long ING_ID = 94500L;        // 대상 식재료 (ingredients 행 불필요 — ingredient_id 직접 링크)
    private static final long OTHER_ING_ID = 94999L;  // 다른 식재료

    private static final long OFFER_MID = 94001L;     // ACTIVE, 5000
    private static final long OFFER_CHEAP = 94002L;   // ACTIVE, 3000 (최저가)
    private static final long OFFER_HIDDEN = 94003L;  // HIDDEN, 1000 (제외)
    private static final long OFFER_OTHER = 94004L;   // ACTIVE, 2000 but 다른 식재료 (제외)

    @Autowired MockMvc mvc;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach
    void setUp() {
        cleanup();
        jdbc.update("INSERT INTO producers (id, name, region, style, price_level, freshness_level, rating, review_count, honorary) " +
                "VALUES (?, '감자장인농가', '강원 평창', 'ORGANIC', 3, 5, 4.7, 21, false)", PRODUCER_ID);
        insertOffer(OFFER_MID, ING_ID, "감자", "강원 햇감자", 5000, "ACTIVE");
        insertOffer(OFFER_CHEAP, ING_ID, "감자", "유기농 감자", 3000, "ACTIVE");
        insertOffer(OFFER_HIDDEN, ING_ID, "감자", "숨김 감자", 1000, "HIDDEN");
        insertOffer(OFFER_OTHER, OTHER_ING_ID, "고구마", "꿀고구마", 2000, "ACTIVE");
        // 최저가 상품 대표 이미지
        jdbc.update("INSERT INTO offer_photos (offer_id, url, sort_order, is_primary) VALUES (?, 'https://img/cheap.png', 0, true)", OFFER_CHEAP);
    }

    @AfterEach
    void tearDown() { cleanup(); }

    private void insertOffer(long id, long ingredientId, String ingredient, String title, int price, String status) {
        jdbc.update("INSERT INTO producer_offers (id, producer_id, ingredient_id, ingredient_name, price, unit, freshness_label, title, category, status, stock_quantity) " +
                "VALUES (?, ?, ?, ?, ?, 'kg', '당일수확', ?, '뿌리채소', ?, 80)",
                id, PRODUCER_ID, ingredientId, ingredient, price, title, status);
    }

    private void cleanup() {
        String mine = "SELECT id FROM producer_offers WHERE producer_id = " + PRODUCER_ID;
        jdbc.update("DELETE FROM offer_photos WHERE offer_id IN (" + mine + ")");
        jdbc.update("DELETE FROM producer_offers WHERE producer_id = ?", PRODUCER_ID);
        jdbc.update("DELETE FROM producers WHERE id = ?", PRODUCER_ID);
    }

    @Test
    void getProductsForIngredient_returnsActiveOffers_priceAsc_asCards() throws Exception {
        mvc.perform(get("/api/v1/ingredients/{id}/products", ING_ID))
                .andExpect(status().isOk())
                // HIDDEN(94003)·다른 식재료(94004) 제외 → ACTIVE 2건
                .andExpect(jsonPath("$.data.length()").value(2))
                // 가격 오름차순 → cheap(3000) 먼저
                .andExpect(jsonPath("$.data[0].id").value(OFFER_CHEAP))
                .andExpect(jsonPath("$.data[0].name").value("유기농 감자"))
                .andExpect(jsonPath("$.data[0].price").value(3000))
                .andExpect(jsonPath("$.data[0].producerName").value("감자장인농가"))
                .andExpect(jsonPath("$.data[0].region").value("강원 평창"))
                .andExpect(jsonPath("$.data[0].producerId").value(PRODUCER_ID))
                .andExpect(jsonPath("$.data[0].stockStatus").value("IN_STOCK"))
                .andExpect(jsonPath("$.data[0].imageUrl").value("https://img/cheap.png"))
                .andExpect(jsonPath("$.data[1].id").value(OFFER_MID))
                .andExpect(jsonPath("$.data[1].price").value(5000));
    }

    @Test
    void getProductsForIngredient_unknownIngredient_returnsEmptyList() throws Exception {
        // 농가 비교(/producers)와 동일 — 존재하지 않는 식재료는 404가 아니라 빈 목록
        mvc.perform(get("/api/v1/ingredients/{id}/products", 98765432L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(0));
    }
}
