package com.seasonaldining.auth.controller;

import com.seasonaldining.auth.dto.request.DevTokenRequest;
import com.seasonaldining.auth.dto.response.DevTokenResponse;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.user.repository.UserRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.context.annotation.Profile;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/dev/auth")
@Profile({"local", "dev", "test"})
@Tag(name = "01. Auth", description = "임시 개발 인증 API")
public class DevAuthController {

    private final UserRepository userRepository;
    private final JwtTokenProvider jwtTokenProvider;

    public DevAuthController(UserRepository userRepository, JwtTokenProvider jwtTokenProvider) {
        this.userRepository = userRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @PostMapping("/token")
    @Operation(summary = "[TEMP] 개발용 access token 발급", description = "기존 사용자의 JWT를 발급합니다. OAuth 도입 전 개발용입니다.")
    public ApiResponse<DevTokenResponse> issueToken(@Valid @RequestBody DevTokenRequest request) {
        if (!userRepository.existsById(request.userId())) {
            throw new BusinessException(ErrorCode.USER_NOT_FOUND);
        }
        return ApiResponse.success(new DevTokenResponse(jwtTokenProvider.createAccessToken(request.userId()), "Bearer"), null);
    }
}
