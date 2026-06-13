package com.seasonaldining.curation.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/** 큐레이션 ↔ 관련 레시피 연결(조인 테이블). */
@Entity
@Table(name = "curation_recipes")
public class CurationRecipe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "curation_id", nullable = false)
    private Long curationId;

    @Column(name = "recipe_id", nullable = false)
    private Long recipeId;

    @Column(name = "sort_order", nullable = false)
    private int sortOrder;

    protected CurationRecipe() {}

    public Long getId() { return id; }
    public Long getCurationId() { return curationId; }
    public Long getRecipeId() { return recipeId; }
    public int getSortOrder() { return sortOrder; }
}
