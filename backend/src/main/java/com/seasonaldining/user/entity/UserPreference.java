package com.seasonaldining.user.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;

@Entity
@Table(name = "user_preferences")
public class UserPreference {

    @Id
    @Column(name = "user_id")
    private Long userId;

    @Column(name = "household_size", nullable = false)
    private int householdSize;

    @Column(precision = 12, scale = 2)
    private BigDecimal budget;

    @Column(name = "spicy_avoid", nullable = false)
    private boolean spicyAvoid;

    @Column(nullable = false, length = 50)
    private String priority;

    protected UserPreference() {
    }

    public UserPreference(Long userId, int householdSize, BigDecimal budget, boolean spicyAvoid, String priority) {
        this.userId = userId;
        update(householdSize, budget, spicyAvoid, priority);
    }

    public void update(int householdSize, BigDecimal budget, boolean spicyAvoid, String priority) {
        this.householdSize = householdSize;
        this.budget = budget;
        this.spicyAvoid = spicyAvoid;
        this.priority = priority;
    }

    public Long getUserId() {
        return userId;
    }

    public int getHouseholdSize() {
        return householdSize;
    }

    public BigDecimal getBudget() {
        return budget;
    }

    public boolean isSpicyAvoid() {
        return spicyAvoid;
    }

    public String getPriority() {
        return priority;
    }
}
