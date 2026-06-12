package com.seasonaldining.producer.service;

import com.seasonaldining.producer.dto.request.RegisterProducerRequest;
import com.seasonaldining.producer.dto.response.ProducerDetailResponse;
import com.seasonaldining.producer.dto.response.SellerStatsResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
class SellerStatsServiceTest {

    private static final String EMAIL = "seller-stats@example.com";

    @Autowired SellerStatsService sellerStatsService;
    @Autowired ProducerService producerService;
    @Autowired JdbcTemplate jdbc;

    private Long userId;
    private Long producerId;

    @BeforeEach
    void setUp() {
        jdbc.update("DELETE FROM order_items WHERE order_id IN (SELECT id FROM orders WHERE user_id IN (SELECT id FROM users WHERE email = ?))", EMAIL);
        jdbc.update("DELETE FROM orders WHERE user_id IN (SELECT id FROM users WHERE email = ?)", EMAIL);
        jdbc.update("DELETE FROM producer_specialties WHERE producer_id IN (SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", EMAIL);
        jdbc.update("DELETE FROM producer_badges WHERE producer_id IN (SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", EMAIL);
        jdbc.update("DELETE FROM producers WHERE user_id IN (SELECT id FROM users WHERE email = ?)", EMAIL);
        jdbc.update("DELETE FROM users WHERE email = ?", EMAIL);
        jdbc.update("INSERT INTO users (email, nickname, status) VALUES (?, '통계판매자', 'ACTIVE')", EMAIL);
        userId = jdbc.queryForObject("SELECT id FROM users WHERE email = ?", Long.class, EMAIL);
        ProducerDetailResponse me = producerService.registerMyProducer(userId, new RegisterProducerRequest(
                "통계농가", "이통계", "전남 나주", "010-1111-2222",
                List.of("무"), "https://cert/stats.png", true));
        producerId = me.id();

        // 오늘자 주문 3건(PAID 2 + CANCELLED 1)
        long oA = insertOrder("STAT-A", "PAID");
        insertItem(oA, "무", 3, 2000);   // 6000
        insertItem(oA, "봄동", 2, 4500);  // 9000
        long oB = insertOrder("STAT-B", "PAID");
        insertItem(oB, "무", 1, 2000);   // 2000
        long oC = insertOrder("STAT-C", "CANCELLED");
        insertItem(oC, "무", 10, 2000);  // 제외돼야 함
    }

    private long insertOrder(String number, String status) {
        jdbc.update("INSERT INTO orders (user_id, order_number, total_amount, status) VALUES (?, ?, ?, ?)",
                userId, number, 0, status);
        return jdbc.queryForObject("SELECT id FROM orders WHERE order_number = ?", Long.class, number);
    }

    private void insertItem(long orderId, String ingredient, int qty, int unitPrice) {
        // 과거(legacy) 행: offer_id/offer_title 없음
        jdbc.update("INSERT INTO order_items (order_id, producer_id, producer_name, ingredient_name, qty, unit_price) " +
                        "VALUES (?, ?, ?, ?, ?, ?)",
                orderId, producerId, "통계농가", ingredient, qty, unitPrice);
    }

    private void insertOfferItem(long orderId, long offerId, String offerTitle, String ingredient, int qty, int unitPrice) {
        jdbc.update("INSERT INTO order_items (order_id, producer_id, producer_name, ingredient_name, qty, unit_price, offer_id, offer_title, offer_unit) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                orderId, producerId, "통계농가", ingredient, qty, unitPrice, offerId, offerTitle, "kg");
    }

    @Test
    void getMyStats_aggregatesRevenueOrdersTopProducts_excludingCancelled() {
        SellerStatsResponse stats = sellerStatsService.getMyStats(userId);

        // 취소 제외: 6000 + 9000 + 2000 = 17000
        assertThat(stats.summary().monthlyRevenue()).isEqualByComparingTo("17000");
        assertThat(stats.summary().todayRevenue()).isEqualByComparingTo("17000");
        assertThat(stats.summary().orderCount()).isEqualTo(2);       // A, B
        assertThat(stats.summary().todayOrderCount()).isEqualTo(2);
        // 전월 0 → 증감률 null, 조회 이벤트 미수집 → null
        assertThat(stats.summary().monthlyRevenueChangeRate()).isNull();
        assertThat(stats.summary().viewCount()).isNull();
        assertThat(stats.summary().conversionRate()).isNull();
        assertThat(stats.summary().nextSettlementDate()).isNotNull();

        // 인기상품(legacy, offer_id 없음 → 식재료명 fallback): 무(3+1=4건, 8000) > 봄동(2건, 9000)
        SellerStatsResponse.TopProduct top = stats.topProducts().get(0);
        assertThat(top.ingredientName()).isEqualTo("무");
        assertThat(top.soldCount()).isEqualTo(4);
        assertThat(top.amount()).isEqualByComparingTo("8000");
        assertThat(top.offerId()).isNull();   // 과거 데이터 → offerId/title null
        assertThat(top.title()).isNull();

        // 7일 시리즈: 길이 7, 마지막(오늘) = 17000
        assertThat(stats.revenueSeries()).hasSize(7);
        SellerStatsResponse.DailyRevenue last = stats.revenueSeries().get(6);
        assertThat(last.date()).isEqualTo(LocalDate.now(ZoneId.of("Asia/Seoul")));
        assertThat(last.amount()).isEqualByComparingTo("17000");
    }

    @Test
    void getMyStats_separatesByOffer_evenWhenSameIngredientName() {
        // 같은 '무'지만 서로 다른 offer 2개 → topProducts에서 분리 집계돼야 한다
        long ox = insertOrder("STAT-X", "PAID");
        insertOfferItem(ox, 5001L, "무 프리미엄 3kg", "무", 4, 3000);  // 12000
        insertOfferItem(ox, 5002L, "무 알뜰 1kg", "무", 7, 1000);     // 7000

        SellerStatsResponse stats = sellerStatsService.getMyStats(userId);

        SellerStatsResponse.TopProduct premium = stats.topProducts().stream()
                .filter(t -> t.offerId() != null && t.offerId() == 5001L).findFirst().orElseThrow();
        SellerStatsResponse.TopProduct budget = stats.topProducts().stream()
                .filter(t -> t.offerId() != null && t.offerId() == 5002L).findFirst().orElseThrow();
        assertThat(premium.title()).isEqualTo("무 프리미엄 3kg");
        assertThat(premium.soldCount()).isEqualTo(4);
        assertThat(premium.amount()).isEqualByComparingTo("12000");
        assertThat(budget.title()).isEqualTo("무 알뜰 1kg");
        assertThat(budget.soldCount()).isEqualTo(7);
        // legacy '무'(offer_id null, setUp에서 삽입)와도 분리됨 → '무' 그룹이 최소 3개
        long muGroups = stats.topProducts().stream().filter(t -> "무".equals(t.ingredientName())).count();
        assertThat(muGroups).isGreaterThanOrEqualTo(3);
    }
}
