package com.seasonaldining.producer.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "offer_tags")
public class OfferTag {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "offer_id", nullable = false)
    private Long offerId;
    @Column(nullable = false, length = 40)
    private String label;

    protected OfferTag() {}

    public static OfferTag of(Long offerId, String label) {
        OfferTag tg = new OfferTag();
        tg.offerId = offerId;
        tg.label = label;
        return tg;
    }

    public Long getId() { return id; }
    public Long getOfferId() { return offerId; }
    public String getLabel() { return label; }
}
