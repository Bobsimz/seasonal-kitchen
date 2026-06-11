package com.seasonaldining.producer.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Entity
@Table(name = "producer_offers")
public class ProducerOffer {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "producer_id", nullable = false)
    private Long producerId;
    @Column(name = "ingredient_id")
    private Long ingredientId;
    @Column(name = "ingredient_name", nullable = false, length = 50)
    private String ingredientName;
    @Column(nullable = false)
    private BigDecimal price;
    @Column(nullable = false, length = 30)
    private String unit;
    @Column(name = "freshness_label", length = 50)
    private String freshnessLabel;
    // 상품 속성 (offer→상품 확장, V23) — nullable
    @Column(length = 150)
    private String title;
    @Column(length = 1000)
    private String description;
    @Column(length = 30)
    private String category;
    @Column(name = "observed_at", nullable = false)
    private OffsetDateTime observedAt = OffsetDateTime.now();

    protected ProducerOffer() {}

    public static ProducerOffer create(Long producerId, Long ingredientId, String ingredientName,
                                       BigDecimal price, String unit, String freshnessLabel) {
        return create(producerId, ingredientId, ingredientName, price, unit, freshnessLabel,
                null, null, null);
    }

    public static ProducerOffer create(Long producerId, Long ingredientId, String ingredientName,
                                       BigDecimal price, String unit, String freshnessLabel,
                                       String title, String description, String category) {
        ProducerOffer o = new ProducerOffer();
        o.producerId = producerId;
        o.ingredientId = ingredientId;
        o.ingredientName = ingredientName;
        o.price = price;
        o.unit = unit;
        o.freshnessLabel = freshnessLabel;
        o.title = title;
        o.description = description;
        o.category = category;
        o.observedAt = OffsetDateTime.now();
        return o;
    }

    public Long getId() { return id; }
    public Long getProducerId() { return producerId; }
    public Long getIngredientId() { return ingredientId; }
    public String getIngredientName() { return ingredientName; }
    public BigDecimal getPrice() { return price; }
    public String getUnit() { return unit; }
    public String getFreshnessLabel() { return freshnessLabel; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getCategory() { return category; }
    public OffsetDateTime getObservedAt() { return observedAt; }
}
