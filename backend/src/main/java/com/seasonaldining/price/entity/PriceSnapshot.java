package com.seasonaldining.price.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "price_snapshots")
public class PriceSnapshot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ingredient_id", nullable = false)
    private Long ingredientId;

    @Column(nullable = false, length = 50)
    private String source;

    @Column(name = "price_type", nullable = false, length = 50)
    private String priceType;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal price;

    @Column(nullable = false, length = 30)
    private String unit;

    @Column(name = "observed_date", nullable = false)
    private LocalDate observedDate;

    protected PriceSnapshot() {
    }

    public PriceSnapshot(Long ingredientId, String source, String priceType, BigDecimal price, String unit, LocalDate observedDate) {
        this.ingredientId = ingredientId;
        this.source = source;
        this.priceType = priceType;
        this.price = price;
        this.unit = unit;
        this.observedDate = observedDate;
    }

    public Long getId() {
        return id;
    }

    public Long getIngredientId() {
        return ingredientId;
    }

    public String getSource() {
        return source;
    }

    public String getPriceType() {
        return priceType;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public String getUnit() {
        return unit;
    }

    public LocalDate getObservedDate() {
        return observedDate;
    }
}
