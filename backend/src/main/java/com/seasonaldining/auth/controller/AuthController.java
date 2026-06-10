package com.seasonaldining.auth.controller;

import com.seasonaldining.auth.dto.request.LoginRequest;
import com.seasonaldining.auth.dto.request.SignUpRequest;
import com.seasonaldining.auth.dto.response.AuthTokenResponse;
import com.seasonaldining.auth.service.AuthService;
import com.seasonaldining.common.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
@Tag(name = "01. Auth", description = "인증 API (이메일 회원가입/로그인). OAuth는 추후.")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/signup")
    @Operation(summary = "이메일 회원가입", description = "이메일/비밀번호/닉네임으로 가입하고 JWT를 발급합니다.")
    public ApiResponse<AuthTokenResponse> signUp(@Valid @RequestBody SignUpRequest request) {
        return ApiResponse.success(authService.signUp(request), null);
    }

    @PostMapping("/login")
    @Operation(summary = "이메일 로그인", description = "이메일/비밀번호로 로그인하고 JWT를 발급합니다.")
    public ApiResponse<AuthTokenResponse> login(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.success(authService.login(request), null);
    }
}
