package com.seasonaldining.order.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.order.dto.request.UpdateOrderStatusRequest;
import com.seasonaldining.order.dto.response.SellerOrderResponse;
import com.seasonaldining.producer.dto.request.RegisterProducerRequest;
import com.seasonaldining.producer.service.ProducerService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * 판매자 주문 상태 흐름(SellerOrderService) 통합 테스트.
 * PAID → PREPARING → SHIPPED → DELIVERED 전이, 권한, 운송장 필수, 타임스탬프 기록을 검증한다.
 */
@SpringBootTest
@ActiveProfiles("test")
class SellerOrderServiceTest {

    private static final String SELLER_EMAIL = "seller-orders@example.com";
    private static final String OTHER_EMAIL = "seller-orders-other@example.com";

    @Autowired SellerOrderService sellerOrderService;
    @Autowired ProducerService producerService;
    @Autowired JdbcTemplate jdbc;

    private Long sellerUserId;
    private Long producerId;
    private Long otherUserId;
    private Long otherProducerId;

    @BeforeEach
    void setUp() {
        cleanup(SELLER_EMAIL);
        cleanup(OTHER_EMAIL);

        sellerUserId = createUser(SELLER_EMAIL, "주문판매자");
        producerId = producerService.registerMyProducer(sellerUserId, new RegisterProducerRequest(
                "주문농가", "이주문", "전남 해남", "010-3333-4444",
                List.of("무"), "https://cert/order.png", true)).id();

        otherUserId = createUser(OTHER_EMAIL, "타농가");
        otherProducerId = producerService.registerMyProducer(otherUserId, new RegisterProducerRequest(
                "타농가", "김타인", "경북 영천", "010-5555-6666",
                List.of("사과"), "https://cert/other.png", true)).id();
    }

    // ── 조회 ────────────────────────────────────────────────
    @Test
    void getMyOrders_returnsOnlyMyProducerItems() {
        long orderId = insertOrder("ORD-MINE", "PAID");
        insertItem(orderId, producerId, "주문농가", "무", 2, 2000);       // 내 항목
        insertItem(orderId, otherProducerId, "타농가", "사과", 1, 5000);   // 타 농가 항목(제외돼야 함)

        List<SellerOrderResponse> orders = sellerOrderService.getMyOrders(sellerUserId);

        assertThat(orders).singleElement().satisfies(o -> {
            assertThat(o.orderId()).isEqualTo(orderId);
            assertThat(o.status()).isEqualTo("PAID");
            assertThat(o.producerSubtotal()).isEqualByComparingTo("4000"); // 2000 * 2, 타 농가 제외
            assertThat(o.items()).singleElement()
                    .satisfies(i -> assertThat(i.ingredientName()).isEqualTo("무"));
        });
    }

    @Test
    void getMyOrders_unregisteredSeller_throwsProducerNotFound() {
        cleanup("stranger-orders@example.com");
        long strangerUserId = createUser("stranger-orders@example.com", "비농가");
        try {
            assertThatThrownBy(() -> sellerOrderService.getMyOrders(strangerUserId))
                    .isInstanceOf(BusinessException.class)
                    .extracting(e -> ((BusinessException) e).getErrorCode())
                    .isEqualTo(ErrorCode.PRODUCER_NOT_FOUND);
        } finally {
            cleanup("stranger-orders@example.com");
        }
    }

    // ── 전이(정상) ──────────────────────────────────────────
    @Test
    void updateStatus_paidToPreparing_succeeds() {
        long orderId = insertOrder("ORD-PREP", "PAID");
        insertItem(orderId, producerId, "주문농가", "무", 1, 2000);

        SellerOrderResponse res = sellerOrderService.updateStatus(
                sellerUserId, orderId, new UpdateOrderStatusRequest("PREPARING", null, null));

        assertThat(res.status()).isEqualTo("PREPARING");
    }

    @Test
    void updateStatus_shipped_recordsCarrierTrackingAndTimestamp() {
        long orderId = insertOrder("ORD-SHIP", "PREPARING");
        insertItem(orderId, producerId, "주문농가", "무", 1, 2000);

        SellerOrderResponse res = sellerOrderService.updateStatus(
                sellerUserId, orderId, new UpdateOrderStatusRequest("SHIPPED", "CJ대한통운", "1234567890"));

        assertThat(res.status()).isEqualTo("SHIPPED");
        assertThat(res.carrier()).isEqualTo("CJ대한통운");
        assertThat(res.trackingNumber()).isEqualTo("1234567890");
        assertThat(res.shippedAt()).isNotNull();

        Map<String, Object> row = jdbc.queryForMap(
                "SELECT status, carrier, tracking_number, shipped_at FROM orders WHERE id = ?", orderId);
        assertThat(row.get("status")).isEqualTo("SHIPPED");
        assertThat(row.get("shipped_at")).isNotNull();
    }

    @Test
    void updateStatus_delivered_recordsTimestamp() {
        long orderId = insertOrder("ORD-DELIV", "SHIPPED");
        insertItem(orderId, producerId, "주문농가", "무", 1, 2000);

        SellerOrderResponse res = sellerOrderService.updateStatus(
                sellerUserId, orderId, new UpdateOrderStatusRequest("DELIVERED", null, null));

        assertThat(res.status()).isEqualTo("DELIVERED");
        assertThat(res.deliveredAt()).isNotNull();
    }

    // ── 전이(거부) ──────────────────────────────────────────
    @Test
    void updateStatus_invalidTransition_throws() {
        long orderId = insertOrder("ORD-BADTR", "PAID");
        insertItem(orderId, producerId, "주문농가", "무", 1, 2000);

        assertThatThrownBy(() -> sellerOrderService.updateStatus(
                sellerUserId, orderId, new UpdateOrderStatusRequest("DELIVERED", null, null)))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.ORDER_INVALID_STATUS_TRANSITION);
    }

    @Test
    void updateStatus_unknownStatus_throws() {
        long orderId = insertOrder("ORD-UNK", "PAID");
        insertItem(orderId, producerId, "주문농가", "무", 1, 2000);

        assertThatThrownBy(() -> sellerOrderService.updateStatus(
                sellerUserId, orderId, new UpdateOrderStatusRequest("FLYING", null, null)))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.ORDER_INVALID_STATUS);
    }

    @Test
    void updateStatus_shippedWithoutTracking_throws() {
        long orderId = insertOrder("ORD-NOTRACK", "PREPARING");
        insertItem(orderId, producerId, "주문농가", "무", 1, 2000);

        assertThatThrownBy(() -> sellerOrderService.updateStatus(
                sellerUserId, orderId, new UpdateOrderStatusRequest("SHIPPED", "CJ대한통운", "  ")))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.ORDER_TRACKING_REQUIRED);
    }

    // ── 권한 ────────────────────────────────────────────────
    @Test
    void updateStatus_foreignProducer_throwsAccessDenied() {
        long orderId = insertOrder("ORD-FOREIGN", "PAID");
        insertItem(orderId, producerId, "주문농가", "무", 1, 2000); // 내 농가만 항목 보유

        // 타 농가 판매자는 이 주문에 항목이 없으므로 상태 변경 불가
        assertThatThrownBy(() -> sellerOrderService.updateStatus(
                otherUserId, orderId, new UpdateOrderStatusRequest("PREPARING", null, null)))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.ORDER_ACCESS_DENIED);
    }

    @Test
    void updateStatus_orderNotFound_throws() {
        assertThatThrownBy(() -> sellerOrderService.updateStatus(
                sellerUserId, 99_999_999L, new UpdateOrderStatusRequest("PREPARING", null, null)))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.ORDER_NOT_FOUND);
    }

    // ── helpers ─────────────────────────────────────────────
    private void cleanup(String email) {
        jdbc.update("DELETE FROM order_items WHERE order_id IN (SELECT id FROM orders WHERE user_id IN (SELECT id FROM users WHERE email = ?))", email);
        jdbc.update("DELETE FROM orders WHERE user_id IN (SELECT id FROM users WHERE email = ?)", email);
        jdbc.update("DELETE FROM producer_specialties WHERE producer_id IN (SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", email);
        jdbc.update("DELETE FROM producer_badges WHERE producer_id IN (SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", email);
        jdbc.update("DELETE FROM producers WHERE user_id IN (SELECT id FROM users WHERE email = ?)", email);
        jdbc.update("DELETE FROM users WHERE email = ?", email);
    }

    private Long createUser(String email, String nickname) {
        jdbc.update("INSERT INTO users (email, nickname, status) VALUES (?, ?, 'ACTIVE')", email, nickname);
        return jdbc.queryForObject("SELECT id FROM users WHERE email = ?", Long.class, email);
    }

    private long insertOrder(String number, String status) {
        jdbc.update("INSERT INTO orders (user_id, order_number, total_amount, status) VALUES (?, ?, ?, ?)",
                sellerUserId, number, 0, status);
        return jdbc.queryForObject("SELECT id FROM orders WHERE order_number = ?", Long.class, number);
    }

    private void insertItem(long orderId, long producerId, String producerName, String ingredient, int qty, int unitPrice) {
        jdbc.update("INSERT INTO order_items (order_id, producer_id, producer_name, ingredient_name, qty, unit_price) " +
                        "VALUES (?, ?, ?, ?, ?, ?)",
                orderId, producerId, producerName, ingredient, qty, unitPrice);
    }
}
