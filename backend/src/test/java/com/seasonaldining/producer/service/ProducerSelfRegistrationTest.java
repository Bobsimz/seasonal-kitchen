package com.seasonaldining.producer.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.producer.dto.request.CreateOfferRequest;
import com.seasonaldining.producer.dto.request.RegisterProducerRequest;
import com.seasonaldining.producer.dto.response.ProducerDetailResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.PageRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
class ProducerSelfRegistrationTest {

    private static final String EMAIL = "seller@example.com";
    private static final String EMAIL2 = "seller2@example.com";

    @Autowired ProducerService producerService;
    @Autowired JdbcTemplate jdbc;

    private Long userId;
    private Long userId2;

    @BeforeEach
    void setUp() {
        // 이전 데이터 정리 (FK 순서)
        for (String email : List.of(EMAIL, EMAIL2)) {
            String selfOffers = "SELECT po.id FROM producer_offers po JOIN producers p ON po.producer_id = p.id " +
                    "JOIN users u ON p.user_id = u.id WHERE u.email = ?";
            jdbc.update("DELETE FROM offer_certifications WHERE offer_id IN (" + selfOffers + ")", email);
            jdbc.update("DELETE FROM offer_photos WHERE offer_id IN (" + selfOffers + ")", email);
            jdbc.update("DELETE FROM offer_tags WHERE offer_id IN (" + selfOffers + ")", email);
            jdbc.update("DELETE FROM offer_options WHERE offer_id IN (" + selfOffers + ")", email);
            jdbc.update("DELETE FROM producer_offers WHERE producer_id IN " +
                    "(SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", email);
            jdbc.update("DELETE FROM producer_specialties WHERE producer_id IN " +
                    "(SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", email);
            jdbc.update("DELETE FROM producer_badges WHERE producer_id IN " +
                    "(SELECT p.id FROM producers p JOIN users u ON p.user_id = u.id WHERE u.email = ?)", email);
            jdbc.update("DELETE FROM producers WHERE user_id IN (SELECT id FROM users WHERE email = ?)", email);
            jdbc.update("DELETE FROM users WHERE email = ?", email);
        }
        jdbc.update("INSERT INTO users (email, nickname, status) VALUES (?, '판매자', 'ACTIVE')", EMAIL);
        jdbc.update("INSERT INTO users (email, nickname, status) VALUES (?, '판매자2', 'ACTIVE')", EMAIL2);
        userId = jdbc.queryForObject("SELECT id FROM users WHERE email = ?", Long.class, EMAIL);
        userId2 = jdbc.queryForObject("SELECT id FROM users WHERE email = ?", Long.class, EMAIL2);
    }

    private RegisterProducerRequest sampleReq() {
        return new RegisterProducerRequest("테스트농가", "김농부", "강원 평창", "010-1234-5678",
                List.of("봄동", "시금치"), "https://cert/test.png", true);
    }

    @Test
    void register_createsProducerLinkedToUser() {
        ProducerDetailResponse d = producerService.registerMyProducer(userId, sampleReq());
        assertThat(d.name()).isEqualTo("테스트농가");
        assertThat(d.specialties()).contains("봄동", "시금치");
        assertThat(d.badges()).isEmpty(); // 등록 화면에 배지 없음 → 기본 없음
        assertThat(d.rating()).isEqualByComparingTo("0");
        assertThat(d.reviewCount()).isZero();

        // 내 농가 조회로도 같은 농가가 나와야 한다
        assertThat(producerService.getMyProducer(userId).name()).isEqualTo("테스트농가");
    }

    @Test
    void register_twice_throwsAlreadyRegistered() {
        producerService.registerMyProducer(userId, sampleReq());
        assertThatThrownBy(() -> producerService.registerMyProducer(userId, sampleReq()))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.PRODUCER_ALREADY_REGISTERED));
    }

    @Test
    void addMyOffer_createsOffer() {
        producerService.registerMyProducer(userId, sampleReq());
        var offer = producerService.addMyOffer(userId,
                new CreateOfferRequest(null, "봄동", new BigDecimal("4500"), "봉", "당일수확", null, null, null, null, null, null,
                        List.of("무농약"), null, "냉장 보관", null, null, null, null));
        assertThat(offer.ingredientName()).isEqualTo("봄동");
        assertThat(offer.price()).isEqualByComparingTo("4500");
        assertThat(offer.unit()).isEqualTo("봉");
    }

    @Test
    void addMyOffer_withoutProducerProfile_throwsNotFound() {
        // userId2는 농가 등록을 안 했음
        assertThatThrownBy(() -> producerService.addMyOffer(userId2,
                new CreateOfferRequest(null, "무", new BigDecimal("2200"), "개", null, null, null, null, null, null, null,
                        List.of("무농약"), null, "냉장 보관", null, null, null, null)))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.PRODUCER_NOT_FOUND));
    }

    @Test
    void addMyOffer_invalidIngredientId_throwsIngredientNotFound() {
        producerService.registerMyProducer(userId, sampleReq());
        assertThatThrownBy(() -> producerService.addMyOffer(userId,
                new CreateOfferRequest(999999L, "봄동", new BigDecimal("4500"), "봉", null, null, null, null, null, null, null,
                        List.of("무농약"), null, "냉장 보관", null, null, null, null)))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.INGREDIENT_NOT_FOUND));
    }

    @Test
    void addMyOffer_upsertsSpecialty_soSearchFindsIt() {
        ProducerDetailResponse d = producerService.registerMyProducer(userId, sampleReq());
        // 초기 specialties에 없던 '당근' 상품을 등록
        producerService.addMyOffer(userId,
                new CreateOfferRequest(null, "당근", new BigDecimal("3000"), "kg", null, null, null, null, null, null, null,
                        List.of("무농약"), null, "냉장 보관", null, null, null, null));
        // q='당근' 검색에서 내 농가가 나와야 한다 (specialty upsert 덕분)
        assertThat(producerService.getProducers("당근", null, null, PageRequest.of(0, 50)).items())
                .anySatisfy(c -> assertThat(c.id()).isEqualTo(d.id()));
    }

    @Test
    void getMyProducer_whenNoneRegistered_returnsNull() {
        // 미등록 사용자는 404가 아니라 200 + null 로 응답한다(프론트 셀러 페이지가 등록 CTA를 보이도록).
        assertThat(producerService.getMyProducer(userId2)).isNull();
    }
}
