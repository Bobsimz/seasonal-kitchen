package com.seasonaldining.auth.service;

import com.seasonaldining.auth.entity.RefreshToken;
import com.seasonaldining.auth.repository.RefreshTokenRepository;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.OffsetDateTime;
import java.util.Base64;
import java.util.HexFormat;

/**
 * Refresh token 발급/검증/폐기. 원문 토큰은 클라이언트에만 주고 서버는 SHA-256 해시만 저장한다.
 */
@Service
public class RefreshTokenService {

    private final RefreshTokenRepository repository;
    private final long expirationSeconds;
    private final SecureRandom random = new SecureRandom();

    public RefreshTokenService(RefreshTokenRepository repository,
                               @Value("${app.jwt.refresh-token-expiration-seconds:1209600}") long expirationSeconds) {
        this.repository = repository;
        this.expirationSeconds = expirationSeconds; // 기본 14일
    }

    /** 새 refresh token을 발급하고 원문을 반환한다(서버엔 해시만 저장). */
    @Transactional
    public String issue(Long userId) {
        String raw = generateRaw();
        repository.save(new RefreshToken(userId, hash(raw),
                OffsetDateTime.now().plusSeconds(expirationSeconds)));
        return raw;
    }

    /** 원문 토큰이 유효하면 userId 반환, 아니면 AUTH_INVALID_REFRESH_TOKEN. */
    @Transactional(readOnly = true)
    public Long validate(String rawToken) {
        return findUsable(rawToken).getUserId();
    }

    /** 토큰 회전 — 기존 토큰을 폐기하고 새 토큰을 발급한다. userId + 새 원문 토큰 반환. */
    @Transactional
    public Rotated rotate(String rawToken) {
        RefreshToken current = findUsable(rawToken);
        current.revoke();
        return new Rotated(current.getUserId(), issue(current.getUserId()));
    }

    /** 회전 결과(userId + 새 refresh 원문). */
    public record Rotated(Long userId, String rawToken) {}

    /** 로그아웃 — 토큰 폐기(없거나 이미 폐기여도 무해, 멱등). */
    @Transactional
    public void revoke(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) return;
        repository.findByTokenHash(hash(rawToken)).ifPresent(RefreshToken::revoke);
    }

    // ── helpers ──────────────────────────────────────────────
    private RefreshToken findUsable(String rawToken) {
        if (rawToken == null || rawToken.isBlank()) {
            throw new BusinessException(ErrorCode.AUTH_INVALID_REFRESH_TOKEN);
        }
        RefreshToken token = repository.findByTokenHash(hash(rawToken))
                .orElseThrow(() -> new BusinessException(ErrorCode.AUTH_INVALID_REFRESH_TOKEN));
        if (!token.isUsable()) {
            throw new BusinessException(ErrorCode.AUTH_INVALID_REFRESH_TOKEN);
        }
        return token;
    }

    private String generateRaw() {
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private String hash(String raw) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return HexFormat.of().formatHex(md.digest(raw.getBytes(StandardCharsets.UTF_8)));
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 unavailable", e);
        }
    }
}
