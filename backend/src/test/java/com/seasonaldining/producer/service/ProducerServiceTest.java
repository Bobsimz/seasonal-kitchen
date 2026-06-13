package com.seasonaldining.producer.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.producer.dto.request.CreateProducerReviewRequest;
import com.seasonaldining.producer.dto.response.ProducerDetailResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.PageRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
class ProducerServiceTest {

    private static final long PID = 7001L;
    // 시드/데모 데이터와 충돌하지 않도록 유니크한 식재료명 사용
    private static final String ING = "시금치테스트";

    @Autowired ProducerService producerService;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach
    void setUp() {
        jdbc.update("DELETE FROM producer_reviews WHERE producer_id = ?", PID);
        jdbc.update("DELETE FROM producer_news WHERE producer_id = ?", PID);
        jdbc.update("DELETE FROM producer_offers WHERE producer_id = ?", PID);
        jdbc.update("DELETE FROM producer_specialties WHERE producer_id = ?", PID);
        jdbc.update("DELETE FROM producer_badges WHERE producer_id = ?", PID);
        jdbc.update("DELETE FROM producers WHERE id = ?", PID);
        jdbc.update("DELETE FROM ingredients WHERE name = ?", ING);

        jdbc.update("INSERT INTO producers (id,name,region,tagline,style,price_level,freshness_level,rating,review_count,honorary) " +
                "VALUES (?, '테스트농가', '강원평창', '고랭지 무농약', 'ORGANIC', 4, 5, 4.8, 415, true)", PID);
        jdbc.update("INSERT INTO producer_specialties (producer_id, ingredient_name) VALUES (?, '시금치')", PID);
        jdbc.update("INSERT INTO producer_badges (producer_id, label) VALUES (?, '유기농 인증')", PID);
        jdbc.update("INSERT INTO producer_offers (producer_id, ingredient_name, price, unit, freshness_label) " +
                "VALUES (?, ?, 4480, '단', '당일수확')", PID, ING);
        jdbc.update("INSERT INTO producer_news (producer_id, posted_at, title, image_ref, body) " +
                "VALUES (?, TIMESTAMP '2026-05-28 08:58', '5월 산지 소식', '시금치', '싱싱합니다')", PID);
        jdbc.update("INSERT INTO producer_reviews (producer_id, user_id, author_name, rating, item, body, created_at) " +
                "VALUES (?, 9999, '민지', 5, '시금치', '정말 싱싱해요', TIMESTAMP '2026-05-30 10:00')", PID);
        jdbc.update("INSERT INTO ingredients (name, category, base_unit, active) VALUES (?, '채소', '단', true)", ING);
    }

    private Long ingredientId() {
        return jdbc.queryForObject("SELECT id FROM ingredients WHERE name = ?", Long.class, ING);
    }

    @Test
    void detail_returnsProfileWithSpecialtiesAndBadges() {
        ProducerDetailResponse d = producerService.getProducerDetail(PID);
        assertThat(d.name()).isEqualTo("테스트농가");
        assertThat(d.specialties()).contains("시금치");
        assertThat(d.badges()).contains("유기농 인증");
    }

    @Test
    void detail_unknownProducer_throws() {
        assertThatThrownBy(() -> producerService.getProducerDetail(999999L))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.PRODUCER_NOT_FOUND));
    }

    @Test
    void offers_byProducerAndByIngredientName() {
        assertThat(producerService.getProducerOffers(PID))
                .singleElement()
                .satisfies(o -> {
                    assertThat(o.ingredientName()).isEqualTo(ING);
                    assertThat(o.price()).isEqualByComparingTo("4480");
                    assertThat(o.unit()).isEqualTo("단");
                });
        assertThat(producerService.getOffersForIngredientName(ING))
                .anySatisfy(o -> assertThat(o.producerId()).isEqualTo(PID));
    }

    @Test
    void compareByIngredientId_worksViaNameFallback() {
        // producer_offers.ingredient_id 가 비어 있어도(백필 전) 식재료명으로 매칭되어야 한다
        assertThat(producerService.getOffersForIngredient(ingredientId()))
                .anySatisfy(o -> {
                    assertThat(o.producerId()).isEqualTo(PID);
                    assertThat(o.ingredientName()).isEqualTo(ING);
                });
    }

    @Test
    void reviews_useAuthorName() {
        assertThat(producerService.getProducerReviews(PID))
                .anySatisfy(r -> {
                    assertThat(r.author()).isEqualTo("민지");
                    assertThat(r.rating()).isEqualTo(5);
                });
    }

    @Test
    void news_returnsTimeline() {
        assertThat(producerService.getProducerNews(PID))
                .anySatisfy(n -> assertThat(n.title()).isEqualTo("5월 산지 소식"));
    }

    @Test
    void createReview_refreshesRatingAggregate() {
        // setUp이 리뷰 1건(rating 5)을 넣어둠. rating 3 리뷰 추가 → count=2, avg=4.00
        producerService.createReview(8888L, PID, new CreateProducerReviewRequest(3, "시금치", "보통이에요"));

        ProducerDetailResponse d = producerService.getProducerDetail(PID);
        assertThat(d.reviewCount()).isEqualTo(2);
        assertThat(d.rating()).isEqualByComparingTo("4.00");
    }

    @Test
    void search_byIngredientName_findsProducer() {
        assertThat(producerService.getProducers("시금치", null, null, null, PageRequest.of(0, 20)).items())
                .anySatisfy(c -> assertThat(c.id()).isEqualTo(PID));
    }

    @Test
    void search_combinesQWithHonoraryAndStyleFilters() {
        // q + honorary=true → 포함 (PID는 honorary=true)
        assertThat(producerService.getProducers("시금치", null, true, null, PageRequest.of(0, 50)).items())
                .anySatisfy(c -> assertThat(c.id()).isEqualTo(PID));
        // q + honorary=false → 제외
        assertThat(producerService.getProducers("시금치", null, false, null, PageRequest.of(0, 50)).items())
                .noneSatisfy(c -> assertThat(c.id()).isEqualTo(PID));
        // q + style 불일치(VALUE) → 제외 (PID는 ORGANIC)
        assertThat(producerService.getProducers("시금치", "VALUE", null, null, PageRequest.of(0, 50)).items())
                .noneSatisfy(c -> assertThat(c.id()).isEqualTo(PID));
        // q + style 일치(ORGANIC) → 포함
        assertThat(producerService.getProducers("시금치", "ORGANIC", null, null, PageRequest.of(0, 50)).items())
                .anySatisfy(c -> assertThat(c.id()).isEqualTo(PID));
    }
}
