package com.seasonaldining.auth.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

/**
 * Refresh token — 원문은 저장하지 않고 SHA-256 해시만 보관(스키마: V5 refresh_tokens).
 * 폐기는 revoked_at(시각)으로 표시 — null이면 유효, 값이 있으면 폐기됨.
 */
@Entity
@Table(name = "refresh_tokens")
public class RefreshToken {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "user_id", nullable = false)
    private Long userId;
    @Column(name = "token_hash", nullable = false, unique = true, length = 255)
    private String tokenHash;
    @Column(name = "expires_at", nullable = false)
    private OffsetDateTime expiresAt;
    @Column(name = "revoked_at")
    private OffsetDateTime revokedAt;
    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt = OffsetDateTime.now();

    protected RefreshToken() {}

    public RefreshToken(Long userId, String tokenHash, OffsetDateTime expiresAt) {
        this.userId = userId;
        this.tokenHash = tokenHash;
        this.expiresAt = expiresAt;
        this.createdAt = OffsetDateTime.now();
    }

    public Long getId() { return id; }
    public Long getUserId() { return userId; }
    public String getTokenHash() { return tokenHash; }
    public OffsetDateTime getExpiresAt() { return expiresAt; }
    public OffsetDateTime getRevokedAt() { return revokedAt; }
    public boolean isRevoked() { return revokedAt != null; }

    public void revoke() {
        if (revokedAt == null) revokedAt = OffsetDateTime.now();
    }

    /** 사용 가능한 토큰인가(미폐기 + 미만료). */
    public boolean isUsable() {
        return revokedAt == null && expiresAt.isAfter(OffsetDateTime.now());
    }
}
