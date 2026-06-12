package com.seasonaldining.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "배송지 등록 요청")
public record CreateAddressRequest(
        @Schema(description = "받는 사람", example = "홍길동")
        @NotBlank @Size(max = 50) String recipientName,

        @Schema(description = "연락처", example = "010-1234-5678")
        @NotBlank @Size(max = 30) String phone,

        @Schema(description = "우편번호(선택)", example = "06236", nullable = true)
        @Size(max = 10) String zipCode,

        @Schema(description = "기본 주소", example = "서울 강남구 테헤란로 1")
        @NotBlank @Size(max = 200) String address1,

        @Schema(description = "상세 주소(선택)", example = "3층 301호", nullable = true)
        @Size(max = 200) String address2,

        @Schema(description = "기본 배송지로 설정(선택, 첫 배송지는 자동 기본)", example = "true", nullable = true)
        Boolean isDefault
) {}
