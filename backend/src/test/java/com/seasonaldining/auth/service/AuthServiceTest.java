package com.seasonaldining.auth.service;

import com.seasonaldining.auth.dto.request.LoginRequest;
import com.seasonaldining.auth.dto.request.SignUpRequest;
import com.seasonaldining.auth.dto.response.AuthTokenResponse;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
class AuthServiceTest {

    private static final String EMAIL = "authtest@example.com";
    private static final String NICK = "인증테스트유저";
    private static final String PW = "password123";
    private static final String OTHER_EMAIL = "other@example.com";
    private static final String NOPW_EMAIL = "nopw@example.com";

    @Autowired AuthService authService;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach
    void setUp() {
        jdbc.update("DELETE FROM users WHERE email IN (?, ?, ?) OR nickname = ?",
                EMAIL, OTHER_EMAIL, NOPW_EMAIL, NICK);
    }

    @Test
    void signUp_success_returnsToken() {
        AuthTokenResponse res = authService.signUp(new SignUpRequest(EMAIL, PW, NICK));
        assertThat(res.accessToken()).isNotBlank();
        assertThat(res.tokenType()).isEqualTo("Bearer");
        assertThat(res.userId()).isNotNull();
        assertThat(res.nickname()).isEqualTo(NICK);
    }

    @Test
    void signUp_duplicateEmail_throws() {
        authService.signUp(new SignUpRequest(EMAIL, PW, NICK));
        assertThatThrownBy(() -> authService.signUp(new SignUpRequest(EMAIL, PW, "다른닉네임")))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.AUTH_EMAIL_DUPLICATE));
    }

    @Test
    void signUp_duplicateNickname_throws() {
        authService.signUp(new SignUpRequest(EMAIL, PW, NICK));
        assertThatThrownBy(() -> authService.signUp(new SignUpRequest(OTHER_EMAIL, PW, NICK)))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.AUTH_NICKNAME_DUPLICATE));
    }

    @Test
    void login_success_returnsToken() {
        authService.signUp(new SignUpRequest(EMAIL, PW, NICK));
        AuthTokenResponse res = authService.login(new LoginRequest(EMAIL, PW));
        assertThat(res.accessToken()).isNotBlank();
        assertThat(res.nickname()).isEqualTo(NICK);
    }

    @Test
    void login_wrongPassword_throws() {
        authService.signUp(new SignUpRequest(EMAIL, PW, NICK));
        assertThatThrownBy(() -> authService.login(new LoginRequest(EMAIL, "wrongpassword")))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.AUTH_INVALID_CREDENTIALS));
    }

    @Test
    void login_nonexistentEmail_throws() {
        assertThatThrownBy(() -> authService.login(new LoginRequest("ghost@example.com", PW)))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.AUTH_INVALID_CREDENTIALS));
    }

    @Test
    void login_userWithoutPasswordHash_throws() {
        // OAuth/데모 등 password_hash가 없는 기존 사용자는 이메일 로그인이 불가해야 한다
        jdbc.update("INSERT INTO users (email, nickname, status) VALUES (?, ?, 'ACTIVE')", NOPW_EMAIL, NICK);
        assertThatThrownBy(() -> authService.login(new LoginRequest(NOPW_EMAIL, PW)))
                .isInstanceOf(BusinessException.class)
                .satisfies(e -> assertThat(((BusinessException) e).getErrorCode())
                        .isEqualTo(ErrorCode.AUTH_INVALID_CREDENTIALS));
    }

    @Test
    void mapDuplicateViolation_distinguishesEmailAndNickname() {
        // H2/Postgres 모두 위반 메시지에 컬럼명이 포함됨을 가정한 매핑
        assertThat(AuthService.mapDuplicateViolation(
                new DataIntegrityViolationException("Unique index violation ON PUBLIC.USERS(NICKNAME)"))
                .getErrorCode()).isEqualTo(ErrorCode.AUTH_NICKNAME_DUPLICATE);

        assertThat(AuthService.mapDuplicateViolation(
                new DataIntegrityViolationException("duplicate key value violates unique constraint \"users_email_key\""))
                .getErrorCode()).isEqualTo(ErrorCode.AUTH_EMAIL_DUPLICATE);
    }
}
