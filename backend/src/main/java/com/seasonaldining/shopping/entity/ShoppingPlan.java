package com.seasonaldining.shopping.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.math.BigDecimal;

@Entity
@Table(name = "shopping_plans")
public class ShoppingPlan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "session_id", nullable = false)
    private Long sessionId;

    @Column(nullable = false)
    private int days;

    @Column(nullable = false)
    private int people;

    private BigDecimal budget;

    @Column(name = "estimated_total", nullable = false)
    private BigDecimal estimatedTotal;

    @Column(nullable = false)
    private String status;

    protected ShoppingPlan() {
    }

    public ShoppingPlan(Long userId, Long sessionId, int days, int people, BigDecimal budget) {
        this.userId = userId;
        this.sessionId = sessionId;
        this.days = days;
        this.people = people;
        this.budget = budget;
        this.estimatedTotal = BigDecimal.ZERO;
        this.status = "CREATED";
    }

    public void setEstimatedTotal(BigDecimal estimatedTotal) {
        this.estimatedTotal = estimatedTotal;
    }

    public Long getId() {
        return id;
    }

    public Long getUserId() {
        return userId;
    }

    public Long getSessionId() {
        return sessionId;
    }

    public int getDays() {
        return days;
    }

    public int getPeople() {
        return people;
    }

    public BigDecimal getBudget() {
        return budget;
    }

    public BigDecimal getEstimatedTotal() {
        return estimatedTotal;
    }

    public String getStatus() {
        return status;
    }
}
