package com.seasonaldining.order.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "order_items")
public class OrderItem {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "order_id", nullable = false)
    private Long orderId;
    @Column(name = "producer_id", nullable = false)
    private Long producerId;
    @Column(name = "producer_name", length = 100)
    private String producerName;
    @Column(name = "ingredient_name", nullable = false, length = 50)
    private String ingredientName;
    @Column(nullable = false)
    private int qty;
    @Column(name = "unit_price", nullable = false)
    private BigDecimal unitPrice;
    // 상품(offer) 스냅샷 (V27) — nullable. 과거 행은 모두 null.
    @Column(name = "offer_id")
    private Long offerId;
    @Column(name = "offer_title", length = 150)
    private String offerTitle;
    @Column(name = "offer_unit", length = 30)
    private String offerUnit;

    protected OrderItem() {}

    /** 기존 생성자 — offer 스냅샷 없이(과거 호출 호환). */
    public OrderItem(Long orderId, Long producerId, String producerName, String ingredientName, int qty, BigDecimal unitPrice) {
        this(orderId, producerId, producerName, ingredientName, qty, unitPrice, null, null, null);
    }

    /** offer 스냅샷 포함 생성자. */
    public OrderItem(Long orderId, Long producerId, String producerName, String ingredientName, int qty, BigDecimal unitPrice,
                     Long offerId, String offerTitle, String offerUnit) {
        this.orderId = orderId; this.producerId = producerId; this.producerName = producerName;
        this.ingredientName = ingredientName; this.qty = qty; this.unitPrice = unitPrice;
        this.offerId = offerId; this.offerTitle = offerTitle; this.offerUnit = offerUnit;
    }
    public Long getId() { return id; }
    public Long getOrderId() { return orderId; }
    public Long getProducerId() { return producerId; }
    public String getProducerName() { return producerName; }
    public String getIngredientName() { return ingredientName; }
    public int getQty() { return qty; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public Long getOfferId() { return offerId; }
    public String getOfferTitle() { return offerTitle; }
    public String getOfferUnit() { return offerUnit; }
}
