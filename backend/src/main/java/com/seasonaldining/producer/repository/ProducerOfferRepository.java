package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.ProducerOffer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProducerOfferRepository extends JpaRepository<ProducerOffer, Long> {
    List<ProducerOffer> findByProducerIdOrderByPriceAsc(Long producerId);
    List<ProducerOffer> findByIngredientNameOrderByPriceAsc(String ingredientName);
    List<ProducerOffer> findByIngredientIdOrderByPriceAsc(Long ingredientId);

    // ── 상태(ACTIVE/HIDDEN) 필터 변형 — 공개 목록/판매자 목록은 ACTIVE만 (V28) ──
    List<ProducerOffer> findByProducerIdAndStatusOrderByPriceAsc(Long producerId, String status);
    List<ProducerOffer> findByIngredientNameAndStatusOrderByPriceAsc(String ingredientName, String status);
    List<ProducerOffer> findByIngredientIdAndStatusOrderByPriceAsc(Long ingredientId, String status);

    /**
     * 상품(facade) 목록/검색 — producer_offers를 상품으로 보고 농가(region/style) 조인 필터.
     * q는 상품명(title)·식재료명·농가명 부분일치. category는 정확일치, region은 부분일치, style은 정확일치.
     * 모든 필터는 null이면 무시. status=HIDDEN(소프트 삭제)은 제외.
     */
    // 주의: :q / :region 은 cast(... as string)로 명시 타입을 준다. Postgres에서 untyped null 파라미터를
    // concat/lower 에 넣으면 bytea 로 추론돼 "function lower(bytea) does not exist" 오류가 발생한다.
    @Query(value = "select o from ProducerOffer o, com.seasonaldining.producer.entity.Producer p " +
            "where o.producerId = p.id and o.status = 'ACTIVE' " +
            "and (:q is null or lower(o.title) like lower(concat('%', cast(:q as string), '%')) " +
            "     or lower(o.ingredientName) like lower(concat('%', cast(:q as string), '%')) " +
            "     or lower(p.name) like lower(concat('%', cast(:q as string), '%'))) " +
            "and (:category is null or o.category = :category) " +
            "and (:region is null or lower(p.region) like lower(concat('%', cast(:region as string), '%'))) " +
            "and (:style is null or p.style = :style) " +
            "order by o.id desc",
            countQuery = "select count(o) from ProducerOffer o, com.seasonaldining.producer.entity.Producer p " +
            "where o.producerId = p.id and o.status = 'ACTIVE' " +
            "and (:q is null or lower(o.title) like lower(concat('%', cast(:q as string), '%')) " +
            "     or lower(o.ingredientName) like lower(concat('%', cast(:q as string), '%')) " +
            "     or lower(p.name) like lower(concat('%', cast(:q as string), '%'))) " +
            "and (:category is null or o.category = :category) " +
            "and (:region is null or lower(p.region) like lower(concat('%', cast(:region as string), '%'))) " +
            "and (:style is null or p.style = :style)")
    Page<ProducerOffer> searchProducts(@Param("q") String q, @Param("category") String category,
                                       @Param("region") String region, @Param("style") String style,
                                       Pageable pageable);
}
