package com.seasonaldining.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/**
 * 배송지 수정 요청(부분 수정). null=미수정.
 * 필수 문자열(recipientName/phone/address1)은 보내려면 공백이 아니어야 한다(빈 문자열로 비우기 불가).
 * isDefault는 true만 허용(기본 지정). 기본 해제(false)는 다른 주소를 기본으로 지정하거나 삭제로 처리한다 — 항상 1개 정책.
 */
@Schema(description = "배송지 수정 요청(PATCH, 부분 수정). null=미수정")
public record UpdateAddressRequest(
        @Schema(description = "받는 사람(보내면 공백 불가)", nullable = true)
        @Pattern(regexp = "\\S.*", message = "must not be blank") @Size(max = 50) String recipientName,

        @Schema(description = "연락처(보내면 공백 불가)", nullable = true)
        @Pattern(regexp = "\\S.*", message = "must not be blank") @Size(max = 30) String phone,

        @Schema(description = "우편번호", nullable = true)
        @Size(max = 10) String zipCode,

        @Schema(description = "기본 주소(보내면 공백 불가)", nullable = true)
        @Pattern(regexp = "\\S.*", message = "must not be blank") @Size(max = 200) String address1,

        @Schema(description = "상세 주소", nullable = true)
        @Size(max = 200) String address2,

        @Schema(description = "기본 배송지로 지정(true만 허용). 기본 해제는 다른 주소를 기본 지정/삭제로 처리", nullable = true)
        Boolean isDefault
) {}
