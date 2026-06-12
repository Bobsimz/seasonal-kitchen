package com.seasonaldining.producer.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "offer_certifications")
public class OfferCertification {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "offer_id", nullable = false)
    private Long offerId;
    @Column(nullable = false, length = 40)
    private String label;

    protected OfferCertification() {}

    public static OfferCertification of(Long offerId, String label) {
        OfferCertification c = new OfferCertification();
        c.offerId = offerId;
        c.label = label;
        return c;
    }

    public Long getId() { return id; }
    public Long getOfferId() { return offerId; }
    public String getLabel() { return label; }
}
