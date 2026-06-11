package com.seasonaldining.producer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.util.List;

@Schema(description = "농가 자가등록 요청 (마이페이지 → 판매자 등록 화면 21e)")
public record RegisterProducerRequest(
        @Schema(description = "농가/농장 이름", example = "해남 송지농원")
        @NotBlank @Size(max = 100) String name,

        @Schema(description = "대표자 이름(실명)", example = "김상도")
        @NotBlank @Size(max = 50) String representativeName,

        @Schema(description = "대표 지역", example = "전남 해남")
        @NotBlank @Size(max = 100) String region,

        @Schema(description = "연락처", example = "010-1234-5678")
        @NotBlank @Size(max = 30) String contact,

        @Schema(description = "주요 판매 품목(식재료명 목록)", example = "[\"무\",\"배추\",\"봄동\"]")
        List<String> specialties,

        @Schema(description = "농가 인증 서류 이미지 URL(필수 — 화면에서 필수, 심사는 추후)", example = "https://cdn/cert.png")
        @NotBlank @Size(max = 500) String certificationImageUrl,

        @Schema(description = "판매자 이용약관·정산정책 동의(필수)", example = "true")
        @AssertTrue(message = "약관에 동의해야 합니다") boolean agreedToTerms
) {}
