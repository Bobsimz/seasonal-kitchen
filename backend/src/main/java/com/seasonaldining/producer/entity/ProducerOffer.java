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
    // 판매등록 필드 (V26) — nullable
    @Column(name = "stock_quantity")
    private Integer stockQuantity;
    @Column(name = "storage_method", length = 30)
    private String storageMethod;
    @Column(name = "storage_note", length = 500)
    private String storageNote;
    // 판매 상태 (V28) — ACTIVE | HIDDEN(소프트 삭제). 기본 ACTIVE.
    @Column(nullable = false, length = 20)
    private String status = "ACTIVE";
    @Column(name = "observed_at", nullable = false)
    private OffsetDateTime observedAt = OffsetDateTime.now();

    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_HIDDEN = "HIDDEN";

    protected ProducerOffer() {}

    public static ProducerOffer create(Long producerId, Long ingredientId, String ingredientName,
                                       BigDecimal price, String unit, String freshnessLabel) {
        return create(producerId, ingredientId, ingredientName, price, unit, freshnessLabel,
                null, null, null);
    }

    public static ProducerOffer create(Long producerId, Long ingredientId, String ingredientName,
                                       BigDecimal price, String unit, String freshnessLabel,
                                       String title, String description, String category) {
        return create(producerId, ingredientId, ingredientName, price, unit, freshnessLabel,
                title, description, category, null, null, null);
    }

    public static ProducerOffer create(Long producerId, Long ingredientId, String ingredientName,
                                       BigDecimal price, String unit, String freshnessLabel,
                                       String title, String description, String category,
                                       Integer stockQuantity, String storageMethod, String storageNote) {
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
        o.stockQuantity = stockQuantity;
        o.storageMethod = storageMethod;
        o.storageNote = storageNote;
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
    public Integer getStockQuantity() { return stockQuantity; }
    public String getStorageMethod() { return storageMethod; }
    public String getStorageNote() { return storageNote; }
    public String getStatus() { return status; }
    public OffsetDateTime getObservedAt() { return observedAt; }

    // ── 판매자 상품 수정/숨김 (V28) ──────────────────────────
    /** 소프트 삭제 — 공개 목록/검색에서 제외된다. */
    public void hide() { this.status = STATUS_HIDDEN; }

    public void changePrice(BigDecimal price) { if (price != null) this.price = price; }
    public void changeUnit(String unit) { if (unit != null) this.unit = unit; }
    public void changeFreshnessLabel(String freshnessLabel) { if (freshnessLabel != null) this.freshnessLabel = freshnessLabel; }
    public void changeTitle(String title) { if (title != null) this.title = title; }
    public void changeDescription(String description) { if (description != null) this.description = description; }
    public void changeCategory(String category) { if (category != null) this.category = category; }
    public void changeStockQuantity(Integer stockQuantity) { if (stockQuantity != null) this.stockQuantity = stockQuantity; }
    public void changeStorageMethod(String storageMethod) { if (storageMethod != null) this.storageMethod = storageMethod; }
    public void changeStorageNote(String storageNote) { if (storageNote != null) this.storageNote = storageNote; }
}
