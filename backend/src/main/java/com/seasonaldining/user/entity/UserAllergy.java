package com.seasonaldining.user.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "user_allergies")
public class UserAllergy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "allergy_code", nullable = false, length = 100)
    private String allergyCode;

    protected UserAllergy() {
    }

    public UserAllergy(Long userId, String allergyCode) {
        this.userId = userId;
        this.allergyCode = allergyCode;
    }

    public String getAllergyCode() {
        return allergyCode;
    }
}
