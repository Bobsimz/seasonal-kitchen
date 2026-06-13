package com.seasonaldining.curation.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * 제철 큐레이션. 홈 히어로(메인 이미지/타이틀/서브타이틀)와 상세 페이지(+제철 이야기)의 본문.
 * 관련 식재료/레시피는 조인 테이블(curation_ingredients/curation_recipes)로 연결한다.
 */
@Entity
@Table(name = "curations")
public class Curation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "main_image_url", length = 500)
    private String mainImageUrl;

    @Column(name = "main_title", nullable = false, length = 200)
    private String mainTitle;

    @Column(length = 300)
    private String subtitle;

    @Column(name = "seasonal_story", columnDefinition = "TEXT")
    private String seasonalStory;

    @Column(name = "display_order", nullable = false)
    private int displayOrder;

    @Column(nullable = false)
    private boolean active;

    protected Curation() {}

    public Long getId() { return id; }
    public String getMainImageUrl() { return mainImageUrl; }
    public String getMainTitle() { return mainTitle; }
    public String getSubtitle() { return subtitle; }
    public String getSeasonalStory() { return seasonalStory; }
    public int getDisplayOrder() { return displayOrder; }
    public boolean isActive() { return active; }
}
