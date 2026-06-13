package com.seasonaldining.cart.service;

import com.seasonaldining.cart.dto.request.AddCartItemRequest;
import com.seasonaldining.cart.dto.response.CartResponse;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
class CartServiceTest {

    private static final long USER_ID = 9001L;
    private static final long PRODUCER_ID = 7101L;
    private static final long OFFER_BOMDONG = 71010L;
    private static final long OFFER_RADISH = 71011L;
    private static final long OPT_3KG = 710100L;   // 봄동 3kg / 12000
    private static final long OPT_1KG = 710101L;   // 봄동 1kg / 5000

    @Autowired CartService cartService;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach
    void setUp() {
        // 깨끗한 상태 (FK 순서대로 삭제: cart_items → offer_options → producer_offers → producers)
        jdbc.update("DELETE FROM cart_items");
        jdbc.update("DELETE FROM carts WHERE user_id = ?", USER_ID);
        jdbc.update("DELETE FROM offer_options WHERE offer_id IN (SELECT id FROM producer_offers WHERE producer_id = ?)", PRODUCER_ID);
        jdbc.update("DELETE FROM producer_offers WHERE producer_id = ?", PRODUCER_ID);
        jdbc.update("DELETE FROM producers WHERE id = ?", PRODUCER_ID);

        // 농가 1곳
        jdbc.update("INSERT INTO producers (id, name, region, style, price_level, freshness_level, rating, review_count, honorary) " +
                "VALUES (?, '권민성', '경북영천', 'PREMIUM', 5, 5, 4.9, 1280, true)", PRODUCER_ID);
        // 오퍼 2개
        jdbc.update("INSERT INTO producer_offers (id, producer_id, ingredient_id, ingredient_name, price, unit, freshness_label) " +
                "VALUES (?, ?, 12, '봄동', 4500, '봉', '당일수확')", OFFER_BOMDONG, PRODUCER_ID);
        jdbc.update("INSERT INTO producer_offers (id, producer_id, ingredient_id, ingredient_name, price, unit, freshness_label) " +
                "VALUES (?, ?, 13, '무', 2200, '개', '당일수확')", OFFER_RADISH, PRODUCER_ID);
        // 봄동 옵션 2개(규격)
        jdbc.update("INSERT INTO offer_options (id, offer_id, quantity, unit, price, sort_order) VALUES (?, ?, 3, 'kg', 12000, 0)", OPT_3KG, OFFER_BOMDONG);
        jdbc.update("INSERT INTO offer_options (id, offer_id, quantity, unit, price, sort_order) VALUES (?, ?, 1, 'kg', 5000, 1)", OPT_1KG, OFFER_BOMDONG);
    }

    @Test
    void addItemByOfferId_storesSnapshotFromOffer() {
        CartResponse cart = cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_BOMDONG, 2));

        assertThat(cart.groups()).singleElement().satisfies(group -> {
            assertThat(group.producerId()).isEqualTo(PRODUCER_ID);
            assertThat(group.producerName()).isEqualTo("권민성");
            assertThat(group.items()).singleElement().satisfies(item -> {
                assertThat(item.ingredientName()).isEqualTo("봄동");
                assertThat(item.qty()).isEqualTo(2);
                // 0원 fallback이 아니라 offer의 실제 단가가 들어가야 한다
                assertThat(item.unitPrice()).isEqualByComparingTo("4500");
                assertThat(item.unit()).isEqualTo("봉");
            });
        });
        assertThat(cart.itemsTotal()).isEqualByComparingTo("9000");
    }

    @Test
    void addItemWithUnknownOffer_throwsAndCreatesNothing() {
        assertThatThrownBy(() -> cartService.addItem(USER_ID, new AddCartItemRequest(999L, 1)))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.PRODUCER_OFFER_NOT_FOUND));

        // 0원 fallback 항목이 생성되지 않아야 한다
        Integer count = jdbc.queryForObject("SELECT COUNT(*) FROM cart_items", Integer.class);
        assertThat(count).isZero();
    }

    @Test
    void addingSameOfferTwice_increasesQtyInsteadOfDuplicating() {
        cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_BOMDONG, 2));
        CartResponse cart = cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_BOMDONG, 3));

        assertThat(cart.groups()).singleElement().satisfies(group ->
                assertThat(group.items()).singleElement().satisfies(item ->
                        assertThat(item.qty()).isEqualTo(5)));

        Integer rows = jdbc.queryForObject("SELECT COUNT(*) FROM cart_items", Integer.class);
        assertThat(rows).isEqualTo(1);
        assertThat(cart.itemsTotal()).isEqualByComparingTo(new BigDecimal("22500")); // 4500 * 5
    }

    @Test
    void differentOffers_createSeparateItems() {
        cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_BOMDONG, 1));
        CartResponse cart = cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_RADISH, 1));

        assertThat(cart.groups()).singleElement().satisfies(group ->
                assertThat(group.items()).hasSize(2));
        assertThat(cart.itemsTotal()).isEqualByComparingTo("6700"); // 4500 + 2200
    }

    @Test
    void addItemWithOption_usesOptionPriceAndLabel() {
        CartResponse cart = cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_BOMDONG, 1, OPT_3KG));

        assertThat(cart.groups()).singleElement().satisfies(group ->
                assertThat(group.items()).singleElement().satisfies(item -> {
                    assertThat(item.unitPrice()).isEqualByComparingTo("12000"); // 기본가 4500 아닌 옵션가
                    assertThat(item.unit()).isEqualTo("kg");
                    assertThat(item.offerOptionId()).isEqualTo(OPT_3KG);
                    assertThat(item.optionLabel()).isEqualTo("3kg");
                }));
        assertThat(cart.itemsTotal()).isEqualByComparingTo("12000");
    }

    @Test
    void sameOfferDifferentOptions_createSeparateLines_sameOptionMerges() {
        cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_BOMDONG, 1, OPT_3KG));
        cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_BOMDONG, 1, OPT_1KG));
        CartResponse cart = cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_BOMDONG, 2, OPT_3KG)); // 3kg 누적

        assertThat(cart.groups()).singleElement().satisfies(group ->
                assertThat(group.items()).hasSize(2)); // 3kg, 1kg 별도 라인
        // 3kg 라인은 1+2=3개, 1kg 라인은 1개
        assertThat(cart.itemsTotal()).isEqualByComparingTo("41000"); // 12000*3 + 5000*1
        Integer rows = jdbc.queryForObject("SELECT COUNT(*) FROM cart_items", Integer.class);
        assertThat(rows).isEqualTo(2);
    }

    @Test
    void optionNotBelongingToOffer_throwsOfferOptionNotFound() {
        // OPT_3KG은 봄동 옵션 — 무(OFFER_RADISH)에 적용하면 거부
        assertThatThrownBy(() -> cartService.addItem(USER_ID, new AddCartItemRequest(OFFER_RADISH, 1, OPT_3KG)))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.OFFER_OPTION_NOT_FOUND));
        assertThat(jdbc.queryForObject("SELECT COUNT(*) FROM cart_items", Integer.class)).isZero();
    }
}
