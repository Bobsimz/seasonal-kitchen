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
    @Column(name = "user_id")
    private Long userId;
    // 판매자 등록 화면(21e) 필드
    @Column(name = "representative_name", length = 50)
    private String representativeName;
    @Column(length = 30)
    private String contact;
    @Column(name = "certification_image_url", length = 500)
    private String certificationImageUrl;
    @Column(name = "agreed_to_terms", nullable = false)
    private boolean agreedToTerms;

    protected Producer() {}

    /**
     * 마이페이지 자가등록용 팩토리. 판매자 등록 화면에서 받는 값으로 채우고,
     * 화면에서 안 받는 값(대표자/연락처/인증서류/약관동의)은 선택 입력이라 null 허용.
     * photoUrl(대표 사진)도 선택 입력 — blank면 null로 정규화한다.
     * style/priceLevel/freshnessLevel은 미입력 시 기본값(VALUE/3/4)으로 채운다.
     * rating/review_count=0, honorary=false.
     */
    public static Producer register(Long userId, String name, String region, String tagline, String photoUrl,
                                    String style, Integer priceLevel, Integer freshnessLevel,
                                    String representativeName, String contact,
                                    String certificationImageUrl, Boolean agreedToTerms) {
        Producer p = new Producer();
        p.userId = userId;
        p.name = name;
        p.region = region;
        p.tagline = (tagline != null && !tagline.isBlank()) ? tagline.trim() : null;
        p.photoUrl = (photoUrl != null && !photoUrl.isBlank()) ? photoUrl.trim() : null;
        p.style = (style != null && !style.isBlank()) ? style.trim().toUpperCase() : "VALUE";
        p.priceLevel = priceLevel != null ? priceLevel : 3;
        p.freshnessLevel = freshnessLevel != null ? freshnessLevel : 4;
        p.representativeName = representativeName;
        p.contact = contact;
        p.certificationImageUrl = certificationImageUrl;
        p.agreedToTerms = agreedToTerms != null && agreedToTerms;
        p.rating = BigDecimal.ZERO;
        p.reviewCount = 0;
        p.honorary = false;
        p.createdAt = OffsetDateTime.now();
        return p;
    }

    /** 리뷰 작성 시 평점/리뷰수 집계 갱신 */
    public void applyReviewStats(BigDecimal rating, int reviewCount) {
        this.rating = rating;
        this.reviewCount = reviewCount;
    }

    public Long getId() { return id; }
    public Long getUserId() { return userId; }
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
    public String getRepresentativeName() { return representativeName; }
    public String getContact() { return contact; }
    public String getCertificationImageUrl() { return certificationImageUrl; }
    public boolean isAgreedToTerms() { return agreedToTerms; }
}
