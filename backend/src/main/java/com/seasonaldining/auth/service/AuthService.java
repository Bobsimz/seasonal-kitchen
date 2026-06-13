package com.seasonaldining.auth.service;

import com.seasonaldining.auth.dto.request.LoginRequest;
import com.seasonaldining.auth.dto.request.SignUpRequest;
import com.seasonaldining.auth.dto.response.AuthTokenResponse;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.repository.ProducerRepository;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.UserRepository;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 이메일/비밀번호 회원가입·로그인. OAuth는 추후 별도 도입(oauth_accounts).
 */
@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;
    private final ProducerRepository producerRepository;
    private final RefreshTokenService refreshTokenService;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder,
                       JwtTokenProvider jwtTokenProvider, ProducerRepository producerRepository,
                       RefreshTokenService refreshTokenService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
        this.producerRepository = producerRepository;
        this.refreshTokenService = refreshTokenService;
    }

    @Transactional
    public AuthTokenResponse signUp(SignUpRequest request) {
        // 1차: 사전 중복 검사 (일반 케이스)
        if (userRepository.existsByEmail(request.email())) {
            throw new BusinessException(ErrorCode.AUTH_EMAIL_DUPLICATE);
        }
        if (userRepository.existsByNickname(request.nickname())) {
            throw new BusinessException(ErrorCode.AUTH_NICKNAME_DUPLICATE);
        }
        // 2차: 동시 가입 레이스로 DB unique 위반 시에도 적절한 도메인 에러로 매핑
        try {
            User user = userRepository.saveAndFlush(User.forEmailSignup(
                    request.email(), request.nickname(), passwordEncoder.encode(request.password())));
            return issue(user);
        } catch (DataIntegrityViolationException e) {
            throw mapDuplicateViolation(e);
        }
    }

    /**
     * users 테이블 unique 제약(email/nickname) 위반을 도메인 에러로 매핑.
     * H2("...USERS(NICKNAME)...")·Postgres("users_nickname_key") 모두 메시지에 컬럼명이 포함되는 점을 이용한다.
     * 닉네임이 식별되지 않으면 이메일 중복으로 간주한다.
     */
    static BusinessException mapDuplicateViolation(DataIntegrityViolationException e) {
        Throwable cause = e.getMostSpecificCause();
        String message = cause != null ? cause.getMessage() : e.getMessage();
        String lower = message == null ? "" : message.toLowerCase();
        if (lower.contains("nickname")) {
            return new BusinessException(ErrorCode.AUTH_NICKNAME_DUPLICATE);
        }
        return new BusinessException(ErrorCode.AUTH_EMAIL_DUPLICATE);
    }

    @Transactional(readOnly = true)
    public AuthTokenResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new BusinessException(ErrorCode.AUTH_INVALID_CREDENTIALS));
        if (user.getPasswordHash() == null
                || !passwordEncoder.matches(request.password(), user.getPasswordHash())) {
            throw new BusinessException(ErrorCode.AUTH_INVALID_CREDENTIALS);
        }
        return issue(user);
    }

    /** 토큰 갱신 — refresh token을 회전(기존 폐기 + 신규 발급)하고 새 access/refresh를 반환. */
    @Transactional
    public AuthTokenResponse refresh(String refreshToken) {
        RefreshTokenService.Rotated rotated = refreshTokenService.rotate(refreshToken);
        User user = userRepository.findById(rotated.userId())
                .orElseThrow(() -> new BusinessException(ErrorCode.AUTH_INVALID_REFRESH_TOKEN));
        return issue(user, rotated.rawToken());
    }

    /** 로그아웃 — 전달된 refresh token을 폐기(멱등). */
    @Transactional
    public void logout(String refreshToken) {
        refreshTokenService.revoke(refreshToken);
    }

    private AuthTokenResponse issue(User user) {
        return issue(user, refreshTokenService.issue(user.getId()));
    }

    private AuthTokenResponse issue(User user, String refreshToken) {
        // 농가 여부 = 이 사용자로 등록된 producer 행 존재 여부(한 사용자당 농가 1개). 화면 분기용.
        Long producerId = producerRepository.findByUserId(user.getId())
                .map(Producer::getId).orElse(null);
        return new AuthTokenResponse(
                jwtTokenProvider.createAccessToken(user.getId()), refreshToken, "Bearer",
                user.getId(), user.getNickname(), producerId != null, producerId);
    }
}
