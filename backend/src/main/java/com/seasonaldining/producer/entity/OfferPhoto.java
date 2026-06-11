package com.seasonaldining.producer.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "offer_photos")
public class OfferPhoto {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "offer_id", nullable = false)
    private Long offerId;
    @Column(nullable = false, length = 500)
    private String url;
    @Column(name = "sort_order", nullable = false)
    private int sortOrder;
    @Column(name = "is_primary", nullable = false)
    private boolean primary;

    protected OfferPhoto() {}

    public static OfferPhoto of(Long offerId, String url, int sortOrder, boolean primary) {
        OfferPhoto p = new OfferPhoto();
        p.offerId = offerId;
        p.url = url;
        p.sortOrder = sortOrder;
        p.primary = primary;
        return p;
    }

    public Long getId() { return id; }
    public Long getOfferId() { return offerId; }
    public String getUrl() { return url; }
    public int getSortOrder() { return sortOrder; }
    public boolean isPrimary() { return primary; }
}
