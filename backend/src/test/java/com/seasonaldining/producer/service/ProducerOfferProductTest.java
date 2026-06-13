package com.seasonaldining.producer.service;

import com.seasonaldining.producer.dto.request.CreateOfferRequest;
import com.seasonaldining.producer.dto.request.CreateOfferRequest.OptionInput;
import com.seasonaldining.producer.dto.request.RegisterProducerRequest;
import com.seasonaldining.producer.dto.response.ProducerDetailResponse;
import com.seasonaldining.producer.dto.response.ProducerOfferResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
class ProducerOfferProductTest {

    private static final String EMAIL = "seller-product@example.com";

    @Autowired ProducerService producerService;
    @Autowired JdbcTemplate jdbc;

    private Long userId;

    @BeforeEach
    void setUp() {
        String selfOffers = "SELECT po.id FROM producer_offers po JOIN producers p ON po.producer_id = p.id " +
                "JOIN users u ON p.user_id = u.id WHERE u.email = ?";
        jdbc.update("DELETE FROM offer_photos WHERE offer_id IN (" + selfOffers + ")", EMAIL);
        jdbc.update("DELETE FROM offer_tags WHERE offer_id IN (" + selfOffers + ")", EMAIL);
        jdbc.update("DELETE FROM offer_options WHERE offer_id IN (" + selfOffers + ")", EMAIL);
        jdbc.update("DELETE FROM offer_certifications WHERE offer_id IN (" + selfOffers + ")", EMAIL);
        jdbc.update("DELETE FROM producer_offers WHERE producer_id IN " +
                "(SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", EMAIL);
        jdbc.update("DELETE FROM producer_specialties WHERE producer_id IN " +
                "(SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", EMAIL);
        jdbc.update("DELETE FROM producer_badges WHERE producer_id IN " +
                "(SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", EMAIL);
        jdbc.update("DELETE FROM producers WHERE user_id IN (SELECT id FROM users WHERE email = ?)", EMAIL);
        jdbc.update("DELETE FROM users WHERE email = ?", EMAIL);
        jdbc.update("INSERT INTO users (email, nickname, status) VALUES (?, '상품판매자', 'ACTIVE')", EMAIL);
        userId = jdbc.queryForObject("SELECT id FROM users WHERE email = ?", Long.class, EMAIL);
        producerService.registerMyProducer(userId, new RegisterProducerRequest(
                "상품농가", "김상도", "전남 해남", "010-0000-0000",
                List.of("봄동"), "https://cert/test.png", true));
    }

    @Test
    void addMyOffer_withProductFields_savesTitleDescriptionCategoryPhotosTags() {
        ProducerOfferResponse o = producerService.addMyOffer(userId, new CreateOfferRequest(
                null, "봄동", new BigDecimal("6900"), "박스", "당일수확",
                "햇 봄동 1.5kg 산지직송", "남도 텃밭에서 새벽 수확", "잎채소",
                List.of("https://img/1.png", "https://img/2.png"),
                List.of("산지직송", "무료배송"), null,
                List.of("무농약", "유기농(유기농산물)"), 120, "냉장 보관",
                "신문지에 싸서 냉장 보관하면 2주까지 신선해요.", null, null, null, null));

        assertThat(o.title()).isEqualTo("햇 봄동 1.5kg 산지직송");
        assertThat(o.description()).contains("새벽 수확");
        assertThat(o.category()).isEqualTo("잎채소");
        assertThat(o.photoUrls()).containsExactly("https://img/1.png", "https://img/2.png");
        assertThat(o.tags()).containsExactly("산지직송", "무료배송");
        assertThat(o.options()).isEmpty();
        assertThat(o.certifications()).containsExactly("무농약", "유기농(유기농산물)");
        assertThat(o.stockQuantity()).isEqualTo(120);
        assertThat(o.storageMethod()).isEqualTo("냉장 보관");
        assertThat(o.storageNote()).contains("신문지");
    }

    @Test
    void addMyOffer_withoutProductFields_returnsEmptyLists() {
        ProducerOfferResponse o = producerService.addMyOffer(userId, new CreateOfferRequest(
                null, "봄동", new BigDecimal("4500"), "봉", null,
                null, null, null, null, null, null,
                List.of("무농약"), null, "실온 보관", null, null, null, null, null));

        assertThat(o.title()).isNull();
        assertThat(o.photoUrls()).isEmpty();
        assertThat(o.tags()).isEmpty();
        assertThat(o.options()).isEmpty();
        assertThat(o.certifications()).containsExactly("무농약");
        assertThat(o.stockQuantity()).isNull();
        assertThat(o.storageMethod()).isEqualTo("실온 보관");
    }

    @Test
    void addMyOffer_withOptions_savesQuantityUnitPriceInOrder() {
        ProducerOfferResponse o = producerService.addMyOffer(userId, new CreateOfferRequest(
                null, "무", new BigDecimal("2200"), "개", null,
                "해남 무", null, "뿌리채소", null, null,
                List.of(new OptionInput(new BigDecimal("1.5"), "kg", new BigDecimal("6900")),
                        new OptionInput(null, "단", new BigDecimal("4500"))),
                List.of("GAP(우수관리)"), 50, "서늘한 그늘", null, null, null, null, null));

        assertThat(o.options()).hasSize(2);
        assertThat(o.options().get(0).unit()).isEqualTo("kg");
        assertThat(o.options().get(0).quantity()).isEqualByComparingTo("1.5");
        assertThat(o.options().get(0).price()).isEqualByComparingTo("6900");
        assertThat(o.options().get(1).unit()).isEqualTo("단");
        assertThat(o.options().get(1).quantity()).isNull();
    }

    @Test
    void getProducerOffers_includesProductFieldsAndOptions() {
        ProducerDetailResponse me = producerService.getMyProducer(userId);
        producerService.addMyOffer(userId, new CreateOfferRequest(
                null, "봄동", new BigDecimal("6900"), "박스", "당일수확",
                "햇 봄동 1.5kg", "설명", "잎채소",
                List.of("https://img/a.png"), List.of("콜드체인"),
                List.of(new OptionInput(new BigDecimal("3"), "kg", new BigDecimal("12000"))),
                List.of("친환경"), 30, "냉장 보관", "흙은 털지 말고 보관하세요.", null, null, null, null));

        List<ProducerOfferResponse> offers = producerService.getProducerOffers(me.id());
        assertThat(offers).anySatisfy(o -> {
            assertThat(o.title()).isEqualTo("햇 봄동 1.5kg");
            assertThat(o.photoUrls()).containsExactly("https://img/a.png");
            assertThat(o.tags()).containsExactly("콜드체인");
            assertThat(o.options()).hasSize(1);
            assertThat(o.options().get(0).price()).isEqualByComparingTo("12000");
            assertThat(o.certifications()).containsExactly("친환경");
            assertThat(o.stockQuantity()).isEqualTo(30);
            assertThat(o.storageMethod()).isEqualTo("냉장 보관");
            // #9 농가 필드 보강 — 자가등록 농가 기본값(style=VALUE, rating 0, 리뷰 0, 명예 false)
            assertThat(o.style()).isEqualTo("VALUE");
            assertThat(o.honorary()).isFalse();
            assertThat(o.reviewCount()).isEqualTo(0);
            assertThat(o.rating()).isEqualByComparingTo("0");
        });
    }
}
