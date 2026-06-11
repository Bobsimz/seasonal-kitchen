package com.seasonaldining.producer.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "offer_options")
public class OfferOption {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "offer_id", nullable = false)
    private Long offerId;
    @Column
    private BigDecimal quantity;
    @Column(length = 30)
    private String unit;
    @Column(nullable = false)
    private BigDecimal price;
    @Column(name = "sort_order", nullable = false)
    private int sortOrder;

    protected OfferOption() {}

    public static OfferOption of(Long offerId, BigDecimal quantity, String unit, BigDecimal price, int sortOrder) {
        OfferOption o = new OfferOption();
        o.offerId = offerId;
        o.quantity = quantity;
        o.unit = unit;
        o.price = price;
        o.sortOrder = sortOrder;
        return o;
    }

    public Long getId() { return id; }
    public Long getOfferId() { return offerId; }
    public BigDecimal getQuantity() { return quantity; }
    public String getUnit() { return unit; }
    public BigDecimal getPrice() { return price; }
    public int getSortOrder() { return sortOrder; }
}
