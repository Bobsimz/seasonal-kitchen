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
    @Column(name = "observed_at", nullable = false)
    private OffsetDateTime observedAt = OffsetDateTime.now();

    protected ProducerOffer() {}

    public static ProducerOffer create(Long producerId, Long ingredientId, String ingredientName,
                                       BigDecimal price, String unit, String freshnessLabel) {
        ProducerOffer o = new ProducerOffer();
        o.producerId = producerId;
        o.ingredientId = ingredientId;
        o.ingredientName = ingredientName;
        o.price = price;
        o.unit = unit;
        o.freshnessLabel = freshnessLabel;
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
    public OffsetDateTime getObservedAt() { return observedAt; }
}
