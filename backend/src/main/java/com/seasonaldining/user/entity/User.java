package com.seasonaldining.user.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 255)
    private String email;

    @Column(nullable = false, unique = true, length = 100)
    private String nickname;

    @Column(name = "profile_image_url", length = 500)
    private String profileImageUrl;

    @Column(nullable = false, length = 50)
    private String status;

    @Column(name = "password_hash", length = 255)
    private String passwordHash;

    protected User() {
    }

    public User(String email, String nickname, String profileImageUrl, String status) {
        this.email = email;
        this.nickname = nickname;
        this.profileImageUrl = profileImageUrl;
        this.status = status;
    }

    /** 이메일/비밀번호 회원가입용 팩토리 (status=ACTIVE) */
    public static User forEmailSignup(String email, String nickname, String passwordHash) {
        User user = new User(email, nickname, null, "ACTIVE");
        user.passwordHash = passwordHash;
        return user;
    }

    public Long getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getNickname() {
        return nickname;
    }

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public String getStatus() {
        return status;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void updateProfile(String nickname, String profileImageUrl) {
        this.nickname = nickname;
        this.profileImageUrl = profileImageUrl;
    }
}
