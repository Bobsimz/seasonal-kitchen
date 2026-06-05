package com.seasonaldining.store.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Entity
@Table(name = "store_offers")
public class StoreOffer {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "store_id", nullable = false) private Long storeId;
    @Column(name = "ingredient_id", nullable = false) private Long ingredientId;
    @Column(nullable = false, precision = 12, scale = 2) private BigDecimal price;
    @Column(name = "price_range_min", precision = 12, scale = 2) private BigDecimal priceRangeMin;
    @Column(name = "price_range_max", precision = 12, scale = 2) private BigDecimal priceRangeMax;
    @Column(name = "original_price", precision = 12, scale = 2) private BigDecimal originalPrice;
    @Column(name = "discount_rate") private Integer discountRate;
    @Column(nullable = false, length = 30) private String unit;
    @Column(name = "delivery_label", length = 100) private String deliveryLabel;
    @Column(length = 50) private String badge;
    @Column(name = "product_url", length = 500) private String productUrl;
    @Column(name = "observed_at", nullable = false, insertable = false, updatable = false) private OffsetDateTime observedAt;
    protected StoreOffer() {}
    public StoreOffer(Long storeId, Long ingredientId, BigDecimal price, BigDecimal priceRangeMin, BigDecimal priceRangeMax, BigDecimal originalPrice, Integer discountRate, String unit, String deliveryLabel, String badge, String productUrl) {
        this.storeId = storeId; this.ingredientId = ingredientId; this.price = price; this.priceRangeMin = priceRangeMin; this.priceRangeMax = priceRangeMax; this.originalPrice = originalPrice; this.discountRate = discountRate; this.unit = unit; this.deliveryLabel = deliveryLabel; this.badge = badge; this.productUrl = productUrl;
    }
    public Long getId() { return id; }
    public Long getStoreId() { return storeId; }
    public Long getIngredientId() { return ingredientId; }
    public BigDecimal getPrice() { return price; }
    public BigDecimal getPriceRangeMin() { return priceRangeMin; }
    public BigDecimal getPriceRangeMax() { return priceRangeMax; }
    public BigDecimal getOriginalPrice() { return originalPrice; }
    public Integer getDiscountRate() { return discountRate; }
    public String getUnit() { return unit; }
    public String getDeliveryLabel() { return deliveryLabel; }
    public String getBadge() { return badge; }
    public String getProductUrl() { return productUrl; }
    public OffsetDateTime getObservedAt() { return observedAt; }
}
