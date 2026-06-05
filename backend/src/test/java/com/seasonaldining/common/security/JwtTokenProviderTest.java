package com.seasonaldining.common.security;

import io.jsonwebtoken.JwtException;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class JwtTokenProviderTest {

    private final JwtTokenProvider jwtTokenProvider =
            new JwtTokenProvider("test-secret-key-for-jwt-provider-at-least-32-bytes", 3600);

    @Test
    void createsAndValidatesAccessToken() {
        String token = jwtTokenProvider.createAccessToken(42L);

        assertThat(jwtTokenProvider.getUserId(token)).isEqualTo(42L);
    }

    @Test
    void rejectsInvalidToken() {
        assertThatThrownBy(() -> jwtTokenProvider.getUserId("invalid-token"))
                .isInstanceOf(JwtException.class);
    }
}
