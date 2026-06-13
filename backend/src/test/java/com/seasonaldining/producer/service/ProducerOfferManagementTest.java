package com.seasonaldining.producer.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.producer.dto.request.CreateOfferRequest;
import com.seasonaldining.producer.dto.request.RegisterProducerRequest;
import com.seasonaldining.producer.dto.request.UpdateOfferRequest;
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
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
class ProducerOfferManagementTest {

    private static final String EMAIL_A = "seller-mgmt-a@example.com";
    private static final String EMAIL_B = "seller-mgmt-b@example.com";

    @Autowired ProducerService producerService;
    @Autowired JdbcTemplate jdbc;

    private Long userA;
    private Long userB;
    private Long producerAId;
    private Long offerAId;   // userA 소유
    private Long offerBId;   // userB 소유

    @BeforeEach
    void setUp() {
        for (String email : List.of(EMAIL_A, EMAIL_B)) {
            String selfOffers = "SELECT po.id FROM producer_offers po JOIN producers p ON po.producer_id = p.id " +
                    "JOIN users u ON p.user_id = u.id WHERE u.email = ?";
            jdbc.update("DELETE FROM offer_photos WHERE offer_id IN (" + selfOffers + ")", email);
            jdbc.update("DELETE FROM offer_tags WHERE offer_id IN (" + selfOffers + ")", email);
            jdbc.update("DELETE FROM offer_options WHERE offer_id IN (" + selfOffers + ")", email);
            jdbc.update("DELETE FROM offer_certifications WHERE offer_id IN (" + selfOffers + ")", email);
            jdbc.update("DELETE FROM producer_offers WHERE producer_id IN " +
                    "(SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", email);
            jdbc.update("DELETE FROM producer_specialties WHERE producer_id IN " +
                    "(SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", email);
            jdbc.update("DELETE FROM producers WHERE user_id IN (SELECT id FROM users WHERE email = ?)", email);
            jdbc.update("DELETE FROM users WHERE email = ?", email);
            jdbc.update("INSERT INTO users (email, nickname, status) VALUES (?, ?, 'ACTIVE')", email, email);
        }
        userA = jdbc.queryForObject("SELECT id FROM users WHERE email = ?", Long.class, EMAIL_A);
        userB = jdbc.queryForObject("SELECT id FROM users WHERE email = ?", Long.class, EMAIL_B);
        ProducerDetailResponse a = producerService.registerMyProducer(userA, new RegisterProducerRequest(
                "A농가", "김에이", "전남 해남", "010-0000-0001", List.of("봄동"), "https://cert/a.png", true));
        producerService.registerMyProducer(userB, new RegisterProducerRequest(
                "B농가", "박비", "강원 평창", "010-0000-0002", List.of("무"), "https://cert/b.png", true));
        producerAId = a.id();
        offerAId = producerService.addMyOffer(userA, offerReq("봄동", "햇 봄동 1.5kg", new BigDecimal("4500"))).id();
        offerBId = producerService.addMyOffer(userB, offerReq("무", "가을무 3kg", new BigDecimal("3000"))).id();
    }

    private CreateOfferRequest offerReq(String ingredient, String title, BigDecimal price) {
        return new CreateOfferRequest(null, ingredient, price, "봉", "당일수확",
                title, "설명", "잎채소",
                List.of("https://img/x.png"), List.of("산지직송"), null,
                List.of("무농약"), 100, "냉장 보관", "신문지 보관", null, null, null, null);
    }

    @Test
    void getMyOffers_returnsOnlyMyOffers() {
        List<ProducerOfferResponse> mine = producerService.getMyOffers(userA);
        assertThat(mine).extracting(ProducerOfferResponse::id).containsExactly(offerAId);
        assertThat(mine).noneMatch(o -> o.id().equals(offerBId));
    }

    @Test
    void getMyOffers_unregisteredSeller_throwsNotFound() {
        jdbc.update("INSERT INTO users (email, nickname, status) VALUES ('mgmt-none@example.com', 'mgmt-none-nick', 'ACTIVE')");
        Long uid = jdbc.queryForObject("SELECT id FROM users WHERE email = 'mgmt-none@example.com'", Long.class);
        assertThatThrownBy(() -> producerService.getMyOffers(uid))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode()).isEqualTo(ErrorCode.PRODUCER_NOT_FOUND));
        jdbc.update("DELETE FROM users WHERE email = 'mgmt-none@example.com'");
    }

    @Test
    void updateMyOffer_updatesScalarsAndReplacesCollections() {
        ProducerOfferResponse updated = producerService.updateMyOffer(userA, offerAId, new UpdateOfferRequest(
                new BigDecimal("5200"), null, null, "햇 봄동 2kg 특가", null, null,
                List.of("https://img/new1.png", "https://img/new2.png"),
                List.of("무료배송", "콜드체인"),
                null,
                List.of("유기농(유기농산물)"),
                55, null, null));

        assertThat(updated.price()).isEqualByComparingTo("5200");
        assertThat(updated.title()).isEqualTo("햇 봄동 2kg 특가");
        assertThat(updated.unit()).isEqualTo("봉");                 // null → 미수정
        assertThat(updated.photoUrls()).containsExactly("https://img/new1.png", "https://img/new2.png");
        assertThat(updated.tags()).containsExactly("무료배송", "콜드체인");
        assertThat(updated.certifications()).containsExactly("유기농(유기농산물)");
        assertThat(updated.stockQuantity()).isEqualTo(55);
        assertThat(updated.storageMethod()).isEqualTo("냉장 보관");   // null → 미수정
    }

    @Test
    void updateMyOffer_othersOffer_throwsNotFound() {
        // userA가 userB의 상품을 수정 시도 → 존재 노출 없이 NOT_FOUND
        assertThatThrownBy(() -> producerService.updateMyOffer(userA, offerBId, new UpdateOfferRequest(
                new BigDecimal("1"), null, null, null, null, null, null, null, null, null, null, null, null)))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode()).isEqualTo(ErrorCode.PRODUCER_OFFER_NOT_FOUND));
    }

    @Test
    void deleteMyOffer_hidesFromMyListAndPublicList() {
        producerService.deleteMyOffer(userA, offerAId);

        assertThat(producerService.getMyOffers(userA)).isEmpty();
        // 공개 농가 상세 목록에서도 제외
        assertThat(producerService.getProducerOffers(producerAId)).noneMatch(o -> o.id().equals(offerAId));
        // 이미 숨김 상품 재삭제/수정은 NOT_FOUND
        assertThatThrownBy(() -> producerService.deleteMyOffer(userA, offerAId))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode()).isEqualTo(ErrorCode.PRODUCER_OFFER_NOT_FOUND));
    }
}
