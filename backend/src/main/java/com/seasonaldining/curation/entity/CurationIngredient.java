package com.seasonaldining.curation.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/** 큐레이션 ↔ 관련 식재료 연결(조인 테이블). FK 값을 컬럼으로 직접 들고 있는다(릴스 도메인과 동일 패턴). */
@Entity
@Table(name = "curation_ingredients")
public class CurationIngredient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "curation_id", nullable = false)
    private Long curationId;

    @Column(name = "ingredient_id", nullable = false)
    private Long ingredientId;

    @Column(name = "sort_order", nullable = false)
    private int sortOrder;

    protected CurationIngredient() {}

    public Long getId() { return id; }
    public Long getCurationId() { return curationId; }
    public Long getIngredientId() { return ingredientId; }
    public int getSortOrder() { return sortOrder; }
}
