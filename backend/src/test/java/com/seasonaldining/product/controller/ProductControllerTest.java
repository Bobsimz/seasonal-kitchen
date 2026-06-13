package com.seasonaldining.product.controller;

import com.seasonaldining.support.UserDataCleaner;
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

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class ProductControllerTest {

    private static final long PRODUCER_ID = 93000L;
    private static final long OFFER_IN_STOCK = 93001L;   // stock 120
    private static final long OFFER_SOLD_OUT = 93002L;   // stock 0
    private static final long OFFER_UNKNOWN  = 93003L;   // stock null
    private static final String TOKEN = "ZZUNIQUE";       // q 필터용 고유 토큰

    @Autowired MockMvc mvc;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach
    void setUp() {
        cleanup();
        jdbc.update("INSERT INTO producers (id, name, region, style, price_level, freshness_level, rating, review_count, honorary) " +
                "VALUES (?, '쩐주농가', '경북 영천', 'ORGANIC', 4, 5, 4.8, 10, false)", PRODUCER_ID);
        // 재고 다양화: IN_STOCK / SOLD_OUT / UNKNOWN
        insertOffer(OFFER_IN_STOCK, "봄동" + TOKEN, "햇 봄동 " + TOKEN, "잎채소", 120);
        insertOffer(OFFER_SOLD_OUT, "무" + TOKEN, "가을무 " + TOKEN, "뿌리채소", 0);
        insertOfferNullStock(OFFER_UNKNOWN, "배추" + TOKEN, "절임배추 " + TOKEN, "잎채소");
        // 대표 이미지 + 인증마크(상세 검증용)
        jdbc.update("INSERT INTO offer_photos (offer_id, url, sort_order, is_primary) VALUES (?, 'https://img/p1.png', 0, true)", OFFER_IN_STOCK);
        jdbc.update("INSERT INTO offer_photos (offer_id, url, sort_order, is_primary) VALUES (?, 'https://img/p2.png', 1, false)", OFFER_IN_STOCK);
        jdbc.update("INSERT INTO offer_certifications (offer_id, label) VALUES (?, '무농약')", OFFER_IN_STOCK);
    }

    @AfterEach
    void tearDown() { cleanup(); }

    private void insertOffer(long id, String ingredient, String title, String category, int stock) {
        jdbc.update("INSERT INTO producer_offers (id, producer_id, ingredient_name, price, unit, freshness_label, title, category, stock_quantity, storage_method, storage_note) " +
                "VALUES (?, ?, ?, 4500, '봉', '당일수확', ?, ?, ?, '냉장 보관', '신문지에 싸서 보관')",
                id, PRODUCER_ID, ingredient, title, category, stock);
    }

    private void insertOfferNullStock(long id, String ingredient, String title, String category) {
        jdbc.update("INSERT INTO producer_offers (id, producer_id, ingredient_name, price, unit, freshness_label, title, category) " +
                "VALUES (?, ?, ?, 4500, '봉', '당일수확', ?, ?)",
                id, PRODUCER_ID, ingredient, title, category);
    }

    private void cleanup() {
        String mine = "SELECT id FROM producer_offers WHERE producer_id = " + PRODUCER_ID;
        jdbc.update("DELETE FROM offer_photos WHERE offer_id IN (" + mine + ")");
        jdbc.update("DELETE FROM offer_tags WHERE offer_id IN (" + mine + ")");
        jdbc.update("DELETE FROM offer_options WHERE offer_id IN (" + mine + ")");
        jdbc.update("DELETE FROM offer_certifications WHERE offer_id IN (" + mine + ")");
        jdbc.update("DELETE FROM offer_detail_sections WHERE offer_id IN (" + mine + ")");
        jdbc.update("DELETE FROM producer_offers WHERE producer_id = ?", PRODUCER_ID);
        jdbc.update("DELETE FROM producers WHERE id = ?", PRODUCER_ID);
        // 검색 키워드 오염 방지 — PRODUCT 검색에서 기록된 TOKEN 키워드 정리
        jdbc.update("DELETE FROM recent_searches WHERE keyword = ?", TOKEN);
        jdbc.update("DELETE FROM search_keywords WHERE keyword = ?", TOKEN);
    }

    @Test
    void getProducts_listsOffersAsProducts_withPagination() throws Exception {
        mvc.perform(get("/api/v1/products").param("q", TOKEN).param("size", "20"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items.length()").value(3))
                .andExpect(jsonPath("$.data.page").value(0))
                .andExpect(jsonPath("$.data.size").value(20))
                .andExpect(jsonPath("$.data.totalElements").value(3))
                // order by id desc → items[2] = OFFER_IN_STOCK. name은 title fallback, producerName/region 조인
                .andExpect(jsonPath("$.data.items[2].id").value(OFFER_IN_STOCK))
                .andExpect(jsonPath("$.data.items[2].name").value("햇 봄동 " + TOKEN))
                .andExpect(jsonPath("$.data.items[2].producerName").value("쩐주농가"))
                .andExpect(jsonPath("$.data.items[2].region").value("경북 영천"))
                .andExpect(jsonPath("$.data.items[2].stockStatus").value("IN_STOCK"))
                .andExpect(jsonPath("$.data.items[2].imageUrl").value("https://img/p1.png"));
    }

    @Test
    void getProducts_filtersByCategory() throws Exception {
        mvc.perform(get("/api/v1/products").param("q", TOKEN).param("category", "뿌리채소"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items.length()").value(1))
                .andExpect(jsonPath("$.data.items[0].id").value(OFFER_SOLD_OUT));
    }

    @Test
    void stockStatus_isComputedFromStockQuantity() throws Exception {
        mvc.perform(get("/api/v1/products/" + OFFER_IN_STOCK)).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.stockStatus").value("IN_STOCK"))
                .andExpect(jsonPath("$.data.stockQuantity").value(120));
        mvc.perform(get("/api/v1/products/" + OFFER_SOLD_OUT)).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.stockStatus").value("SOLD_OUT"));
        mvc.perform(get("/api/v1/products/" + OFFER_UNKNOWN)).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.stockStatus").value("UNKNOWN"))
                .andExpect(jsonPath("$.data.stockQuantity").doesNotExist());
    }

    @Test
    void getProduct_detail_includesImagesCertificationsStorage() throws Exception {
        mvc.perform(get("/api/v1/products/" + OFFER_IN_STOCK)).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.id").value(OFFER_IN_STOCK))
                .andExpect(jsonPath("$.data.name").value("햇 봄동 " + TOKEN))
                .andExpect(jsonPath("$.data.images.length()").value(2))
                .andExpect(jsonPath("$.data.imageUrl").value("https://img/p1.png"))
                .andExpect(jsonPath("$.data.certifications[0]").value("무농약"))
                .andExpect(jsonPath("$.data.storageMethod").value("냉장 보관"))
                .andExpect(jsonPath("$.data.relatedRecipeIds").isArray())
                // 상세 섹션 없으면 빈 배열(프론트는 description 폴백)
                .andExpect(jsonPath("$.data.detailSections").isArray())
                .andExpect(jsonPath("$.data.detailSections.length()").value(0));
    }

    @Test
    void getProduct_includesDetailSections_orderedBySortOrder() throws Exception {
        jdbc.update("INSERT INTO offer_detail_sections (offer_id, heading, body, sort_order) VALUES (?, '보관법', '냉장 5일', 1)", OFFER_IN_STOCK);
        jdbc.update("INSERT INTO offer_detail_sections (offer_id, image_url, heading, body, sort_order) VALUES (?, 'https://img/farm.png', '재배 환경', '해남 황토밭 무농약', 0)", OFFER_IN_STOCK);

        mvc.perform(get("/api/v1/products/" + OFFER_IN_STOCK)).andExpect(status().isOk())
                .andExpect(jsonPath("$.data.detailSections.length()").value(2))
                // sort_order asc → 재배 환경(0)이 먼저, 섹션 이미지 포함
                .andExpect(jsonPath("$.data.detailSections[0].heading").value("재배 환경"))
                .andExpect(jsonPath("$.data.detailSections[0].body").value("해남 황토밭 무농약"))
                .andExpect(jsonPath("$.data.detailSections[0].imageUrl").value("https://img/farm.png"))
                // 이미지 없는 섹션은 imageUrl=null
                .andExpect(jsonPath("$.data.detailSections[1].heading").value("보관법"))
                .andExpect(jsonPath("$.data.detailSections[1].imageUrl").value(org.hamcrest.Matchers.nullValue()));
    }

    @Test
    void getProduct_notFound_returns404() throws Exception {
        mvc.perform(get("/api/v1/products/99999999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("PRODUCT_NOT_FOUND"));
    }

    @Test
    void getProduct_hiddenOffer_returns404() throws Exception {
        // 숨김(HIDDEN) 상품은 상세에서도 비공개 — 직접 id 접근 시 404
        jdbc.update("UPDATE producer_offers SET status = 'HIDDEN' WHERE id = ?", OFFER_IN_STOCK);
        mvc.perform(get("/api/v1/products/" + OFFER_IN_STOCK))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("PRODUCT_NOT_FOUND"));
    }

    @Test
    void getProducts_styleFilter_isCaseInsensitive() throws Exception {
        // 농가 style은 'ORGANIC'이지만 소문자 'organic'으로 보내도 결과가 나와야 한다
        mvc.perform(get("/api/v1/products").param("q", TOKEN).param("style", "organic"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items.length()").value(3));
    }

    @Test
    void search_productType_returnsProducts() throws Exception {
        mvc.perform(get("/api/v1/search").param("q", TOKEN).param("type", "PRODUCT"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.productCount").value(3))
                .andExpect(jsonPath("$.data.products.length()").value(3))
                .andExpect(jsonPath("$.data.products[0].type").value("PRODUCT"))
                .andExpect(jsonPath("$.data.items.length()").value(3));
    }
}
