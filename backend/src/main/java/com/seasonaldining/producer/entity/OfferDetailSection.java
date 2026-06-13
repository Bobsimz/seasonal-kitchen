package com.seasonaldining.producer.entity;

import jakarta.persistence.*;

/**
 * 상품 상세정보 섹션(제목+본문). 상품 상세 "상세보기" 접기/펼치기용. offer당 여러 개, sort_order로 정렬.
 */
@Entity
@Table(name = "offer_detail_sections")
public class OfferDetailSection {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "offer_id", nullable = false)
    private Long offerId;
    @Column(nullable = false, length = 120)
    private String heading;
    @Column(nullable = false, length = 4000)
    private String body;
    @Column(name = "sort_order", nullable = false)
    private int sortOrder;

    protected OfferDetailSection() {}

    public static OfferDetailSection of(Long offerId, String heading, String body, int sortOrder) {
        OfferDetailSection s = new OfferDetailSection();
        s.offerId = offerId;
        s.heading = heading;
        s.body = body;
        s.sortOrder = sortOrder;
        return s;
    }

    public Long getId() { return id; }
    public Long getOfferId() { return offerId; }
    public String getHeading() { return heading; }
    public String getBody() { return body; }
    public int getSortOrder() { return sortOrder; }
}
