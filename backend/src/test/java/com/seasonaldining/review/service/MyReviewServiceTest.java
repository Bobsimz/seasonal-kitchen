package com.seasonaldining.review.service;

import com.seasonaldining.review.dto.response.MyReviewResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * 내 리뷰 writable(작성가능) 통합 테스트 — 배송완료(DELIVERED) 주문의 농가 중 미작성만 노출.
 */
@SpringBootTest
@ActiveProfiles("test")
class MyReviewServiceTest {

    private static final String EMAIL = "myreview@example.com";
    private static final long PRODUCER_ID = 9310L;

    @Autowired MyReviewService myReviewService;
    @Autowired JdbcTemplate jdbc;

    private Long userId;

    @BeforeEach
    void setUp() {
        jdbc.update("DELETE FROM producer_reviews WHERE user_id IN (SELECT id FROM users WHERE email = ?)", EMAIL);
        jdbc.update("DELETE FROM order_items WHERE order_id IN (SELECT id FROM orders WHERE user_id IN (SELECT id FROM users WHERE email = ?))", EMAIL);
        jdbc.update("DELETE FROM orders WHERE user_id IN (SELECT id FROM users WHERE email = ?)", EMAIL);
        jdbc.update("DELETE FROM producer_reviews WHERE producer_id = ?", PRODUCER_ID);
        jdbc.update("DELETE FROM producers WHERE id = ?", PRODUCER_ID);
        jdbc.update("DELETE FROM users WHERE email = ?", EMAIL);

        jdbc.update("INSERT INTO users (email, nickname, status) VALUES (?, '리뷰테스터', 'ACTIVE')", EMAIL);
        userId = jdbc.queryForObject("SELECT id FROM users WHERE email = ?", Long.class, EMAIL);
        jdbc.update("INSERT INTO producers (id, name, region, style, price_level, freshness_level, rating, review_count, honorary) " +
                "VALUES (?, '리뷰농가', '전남', 'ORGANIC', 3, 5, 4.5, 7, false)", PRODUCER_ID);
    }

    @Test
    void writable_returnsDeliveredProducer_notYetReviewed() {
        long orderId = insertOrder("RV-DELIV", "DELIVERED");
        insertItem(orderId, "봄동");

        List<MyReviewResponse> writable = myReviewService.getMyReviews(userId, "writable");

        assertThat(writable).singleElement().satisfies(r -> {
            assertThat(r.producerId()).isEqualTo(PRODUCER_ID);
            assertThat(r.producerName()).isEqualTo("리뷰농가");
            assertThat(r.item()).isEqualTo("봄동");
            assertThat(r.reviewId()).isNull();   // 아직 미작성
            assertThat(r.rating()).isNull();
            assertThat(r.body()).isNull();
            assertThat(r.date()).isNotNull();    // 배송완료(없으면 주문)시각
        });
    }

    @Test
    void writable_excludesAlreadyReviewedProducer() {
        long orderId = insertOrder("RV-REVIEWED", "DELIVERED");
        insertItem(orderId, "봄동");
        jdbc.update("INSERT INTO producer_reviews (producer_id, user_id, rating, item, body, created_at) " +
                "VALUES (?, ?, 5, '봄동', '맛있어요', CURRENT_TIMESTAMP)", PRODUCER_ID, userId);

        assertThat(myReviewService.getMyReviews(userId, "writable")).isEmpty();
    }

    @Test
    void writable_excludesNonDeliveredOrders() {
        long orderId = insertOrder("RV-PAID", "PAID");
        insertItem(orderId, "봄동");

        assertThat(myReviewService.getMyReviews(userId, "writable")).isEmpty();
    }

    private long insertOrder(String number, String status) {
        jdbc.update("INSERT INTO orders (user_id, order_number, total_amount, status) VALUES (?, ?, ?, ?)",
                userId, number, 0, status);
        return jdbc.queryForObject("SELECT id FROM orders WHERE order_number = ?", Long.class, number);
    }

    private void insertItem(long orderId, String ingredient) {
        jdbc.update("INSERT INTO order_items (order_id, producer_id, producer_name, ingredient_name, qty, unit_price) " +
                        "VALUES (?, ?, ?, ?, ?, ?)",
                orderId, PRODUCER_ID, "리뷰농가", ingredient, 1, 4500);
    }
}
