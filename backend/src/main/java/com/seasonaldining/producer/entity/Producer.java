package com.seasonaldining.producer.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Entity
@Table(name = "producers")
public class Producer {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false, length = 100)
    private String name;
    @Column(nullable = false, length = 100)
    private String region;
    @Column(length = 300)
    private String tagline;
    @Column(name = "photo_url", length = 500)
    private String photoUrl;
    @Column(nullable = false, length = 20)
    private String style;                 // VALUE | ORGANIC | PREMIUM
    @Column(name = "price_level", nullable = false)
    private int priceLevel;
    @Column(name = "freshness_level", nullable = false)
    private int freshnessLevel;
    @Column(nullable = false)
    private BigDecimal rating = BigDecimal.ZERO;
    @Column(name = "review_count", nullable = false)
    private int reviewCount;
    @Column(nullable = false)
    private boolean honorary;
    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt = OffsetDateTime.now();

    protected Producer() {}

    /** 리뷰 작성 시 평점/리뷰수 집계 갱신 */
    public void applyReviewStats(BigDecimal rating, int reviewCount) {
        this.rating = rating;
        this.reviewCount = reviewCount;
    }

    public Long getId() { return id; }
    public String getName() { return name; }
    public String getRegion() { return region; }
    public String getTagline() { return tagline; }
    public String getPhotoUrl() { return photoUrl; }
    public String getStyle() { return style; }
    public int getPriceLevel() { return priceLevel; }
    public int getFreshnessLevel() { return freshnessLevel; }
    public BigDecimal getRating() { return rating; }
    public int getReviewCount() { return reviewCount; }
    public boolean isHonorary() { return honorary; }
    public OffsetDateTime getCreatedAt() { return createdAt; }
}
