package com.seasonaldining.producer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.util.List;

/**
 * 내 농가 상품 수정 요청 (PATCH, 부분 수정).
 * <p><b>null 정책</b>: 모든 필드는 선택. <b>null이면 미수정</b>(해당 필드 보존).
 * 컬렉션(photoUrls/tags/options/certifications)은 <b>비어있지 않은 list를 보내면 전체 교체</b>,
 * <b>빈 배열을 보내면 전체 삭제(비우기)</b>, <b>null이면 미수정</b>이다.
 * (scalar 필드는 null=미수정이라 "값 비우기"는 지원하지 않는다.)
 */
@Schema(description = "내 농가 상품 수정 요청(PATCH, 부분 수정). null=미수정, 컬렉션은 list 제공 시 전체 교체")
public record UpdateOfferRequest(
        @Schema(description = "판매가", example = "4900", nullable = true)
        @DecimalMin("0.0") BigDecimal price,

        @Schema(description = "단위", example = "봉", nullable = true)
        @Size(max = 30) String unit,

        @Schema(description = "신선도 라벨", example = "당일수확", nullable = true)
        @Size(max = 50) String freshnessLabel,

        @Schema(description = "상품명", example = "햇 봄동 1.5kg 산지직송", nullable = true)
        @Size(max = 150) String title,

        @Schema(description = "상품 설명", nullable = true)
        @Size(max = 1000) String description,

        @Schema(description = "카테고리", example = "잎채소", nullable = true)
        @Size(max = 30) String category,

        @Schema(description = "상품 사진 URL 목록(제공 시 전체 교체)", nullable = true)
        List<@Size(max = 500) String> photoUrls,

        @Schema(description = "상품 태그 목록(제공 시 전체 교체)", nullable = true)
        List<@Size(max = 40) String> tags,

        @Schema(description = "상품 옵션 목록(제공 시 전체 교체)", nullable = true)
        @Valid List<CreateOfferRequest.OptionInput> options,

        @Schema(description = "인증마크 목록(제공 시 전체 교체)", nullable = true)
        List<@Size(max = 40) String> certifications,

        @Schema(description = "재고 수량", example = "80", nullable = true)
        @Min(0) Integer stockQuantity,

        @Schema(description = "보관방법", example = "냉장 보관", nullable = true)
        @Size(max = 30) String storageMethod,

        @Schema(description = "보관 안내 설명", nullable = true)
        @Size(max = 500) String storageNote
) {}
