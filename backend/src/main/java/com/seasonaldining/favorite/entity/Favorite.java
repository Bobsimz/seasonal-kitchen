package com.seasonaldining.favorite.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "favorites")
public class Favorite {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id", nullable = false)
    private Long userId;
    @Column(name = "target_type", nullable = false, length = 50)
    private String targetType;
    @Column(name = "target_id", nullable = false)
    private Long targetId;

    protected Favorite() {}
    public Favorite(Long userId, String targetType, Long targetId) {
        this.userId = userId; this.targetType = targetType; this.targetId = targetId;
    }
    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public String getTargetType() { return targetType; }
    public Long getTargetId() { return targetId; }
}
