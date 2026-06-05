package com.seasonaldining.reel.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "creators")
public class Creator {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "user_id") private Long userId;
    @Column(name = "display_name", nullable = false, length = 100) private String displayName;
    @Column(name = "avatar_url", length = 500) private String avatarUrl;
    @Column(nullable = false, length = 50) private String status;
    protected Creator() {}
    public Creator(Long userId, String displayName, String avatarUrl, String status) {
        this.userId = userId; this.displayName = displayName; this.avatarUrl = avatarUrl; this.status = status;
    }
    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public String getDisplayName() { return displayName; }
    public String getAvatarUrl() { return avatarUrl; }
    public String getStatus() { return status; }
}
