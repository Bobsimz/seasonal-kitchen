package com.seasonaldining.ingredient.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "ingredient_nutritions")
public class IngredientNutrition {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "ingredient_id", nullable = false, unique = true) private Long ingredientId;
    private Integer calories;
    private BigDecimal carbohydrate;
    private BigDecimal sugar;
    private BigDecimal fiber;
    private BigDecimal protein;
    private BigDecimal fat;
    @Column(name = "vitamin_c", length = 50) private String vitaminC;
    @Column(length = 50) private String potassium;
    @Column(length = 50) private String folate;
    protected IngredientNutrition() {}
    public IngredientNutrition(Long ingredientId, Integer calories, BigDecimal carbohydrate, BigDecimal sugar, BigDecimal fiber, BigDecimal protein, BigDecimal fat, String vitaminC, String potassium, String folate) {
        this.ingredientId = ingredientId; this.calories = calories; this.carbohydrate = carbohydrate; this.sugar = sugar; this.fiber = fiber; this.protein = protein; this.fat = fat; this.vitaminC = vitaminC; this.potassium = potassium; this.folate = folate;
    }
    public Integer getCalories() { return calories; }
    public BigDecimal getCarbohydrate() { return carbohydrate; }
    public BigDecimal getSugar() { return sugar; }
    public BigDecimal getFiber() { return fiber; }
    public BigDecimal getProtein() { return protein; }
    public BigDecimal getFat() { return fat; }
    public String getVitaminC() { return vitaminC; }
    public String getPotassium() { return potassium; }
    public String getFolate() { return folate; }
}
