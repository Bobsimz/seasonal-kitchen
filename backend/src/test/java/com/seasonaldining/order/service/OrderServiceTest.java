package com.seasonaldining.order.service;

import com.seasonaldining.cart.dto.request.AddCartItemRequest;
import com.seasonaldining.cart.service.CartService;
import com.seasonaldining.order.dto.response.OrderResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
class OrderServiceTest {

    private static final long USER_ID = 8201L;
    private static final long PRODUCER_ID = 8210L;
    private static final long OFFER_ID = 82100L;

    @Autowired OrderService orderService;
    @Autowired CartService cartService;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach
    void setUp() {
        jdbc.update("DELETE FROM order_items WHERE order_id IN (SELECT id FROM orders WHERE user_id = ?)", USER_ID);
        jdbc.update("DELETE FROM orders WHERE user_id = ?", USER_ID);
        jdbc.update("DELETE FROM cart_items WHERE cart_id IN (SELECT id FROM carts WHERE user_id = ?)", USER_ID);
        jdbc.update("DELETE FROM carts WHERE user_id = ?", USER_ID);
        jdbc.update("DELETE FROM producer_offers WHERE producer_id = ?", PRODUCER_ID);
        jdbc.update("DELETE FROM producers WHERE id = ?", PRODUCER_ID);

        jdbc.update("INSERT INTO producers (id, name, region, style, price_level, freshness_level, rating, review_count, honorary) " +
                "VALUES (?, '테스트농가', '강원', 'ORGANIC', 4, 5, 4.8, 10, false)", PRODUCER_ID);
        jdbc.update("INSERT INTO producer_offers (id, producer_id, ingredient_name, price, unit, freshness_label) " +
                "VALUES (?, ?, '시금치', 3800, '단', '당일수확')", OFFER_ID, PRODUCER_ID);
    }

    @Test
    void createOrderFromCart_returnsDetailWithOrderNumber() {
        cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_ID, 2));
        OrderResponse order = orderService.createOrder(USER_ID);

        assertThat(order.orderNumber()).isNotBlank();
        assertThat(order.items()).singleElement()
                .satisfies(i -> assertThat(i.ingredientName()).isEqualTo("시금치"));
        assertThat(order.itemsTotal()).isEqualByComparingTo("7600"); // 3800 * 2
    }

    @Test
    void createOrder_savesOfferSnapshot_titleFallsBackToIngredientName() {
        // OFFER_ID 시드 오퍼는 title이 없음 → offer_title은 ingredient_name fallback
        cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_ID, 2));
        orderService.createOrder(USER_ID);

        Map<String, Object> row = jdbc.queryForMap(
                "SELECT oi.offer_id, oi.offer_title, oi.offer_unit FROM order_items oi " +
                "JOIN orders o ON oi.order_id = o.id WHERE o.user_id = ?", USER_ID);
        assertThat(((Number) row.get("offer_id")).longValue()).isEqualTo(OFFER_ID);
        assertThat(row.get("offer_title")).isEqualTo("시금치");
        assertThat(row.get("offer_unit")).isEqualTo("단");
    }

    @Test
    void createOrder_savesOfferTitle_whenOfferHasTitle() {
        long titledOffer = 82101L;
        jdbc.update("INSERT INTO producer_offers (id, producer_id, ingredient_name, price, unit, freshness_label, title) " +
                "VALUES (?, ?, '봄동', 6900, '박스', '당일수확', '햇 봄동 1.5kg 산지직송')", titledOffer, PRODUCER_ID);
        cartService.addItem(USER_ID, new AddCartItemRequest(titledOffer, 1));
        orderService.createOrder(USER_ID);

        Map<String, Object> row = jdbc.queryForMap(
                "SELECT oi.offer_id, oi.offer_title FROM order_items oi " +
                "JOIN orders o ON oi.order_id = o.id WHERE o.user_id = ?", USER_ID);
        assertThat(((Number) row.get("offer_id")).longValue()).isEqualTo(titledOffer);
        assertThat(row.get("offer_title")).isEqualTo("햇 봄동 1.5kg 산지직송");
    }

    @Test
    void repeatedOrders_produceUniqueOrderNumbers() {
        Set<String> numbers = new HashSet<>();
        for (int i = 0; i < 10; i++) {
            cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_ID, 1));
            numbers.add(orderService.createOrder(USER_ID).orderNumber());
        }
        // 반복 주문에서도 주문번호가 전부 유일해야 한다 (unique 충돌 없음)
        assertThat(numbers).hasSize(10);
    }
}
