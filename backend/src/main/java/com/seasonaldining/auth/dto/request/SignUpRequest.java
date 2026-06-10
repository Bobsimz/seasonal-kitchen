package com.seasonaldining.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "이메일 회원가입 요청")
public record SignUpRequest(
        @Schema(description = "이메일", example = "user@example.com")
        @Email @NotBlank @Size(max = 255) String email,

        @Schema(description = "비밀번호(8자 이상)", example = "password123")
        @NotBlank @Size(min = 8, max = 72) String password,

        @Schema(description = "닉네임", example = "제철러버")
        @NotBlank @Size(max = 100) String nickname
) {}
