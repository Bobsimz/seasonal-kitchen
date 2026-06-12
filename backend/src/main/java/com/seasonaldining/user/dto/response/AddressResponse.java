package com.seasonaldining.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "배송지")
public record AddressResponse(
        @Schema(description = "배송지 ID", example = "1") Long id,
        @Schema(description = "받는 사람", example = "홍길동") String recipientName,
        @Schema(description = "연락처", example = "010-1234-5678") String phone,
        @Schema(description = "우편번호", example = "06236", nullable = true) String zipCode,
        @Schema(description = "기본 주소", example = "서울 강남구 테헤란로 1") String address1,
        @Schema(description = "상세 주소", example = "3층 301호", nullable = true) String address2,
        @Schema(description = "기본 배송지 여부", example = "true") boolean isDefault
) {}
