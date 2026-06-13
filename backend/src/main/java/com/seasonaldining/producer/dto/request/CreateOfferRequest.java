package com.seasonaldining.producer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "내 농가 상품(오퍼) 등록 요청")
public record CreateOfferRequest(
        @Schema(description = "연결 식재료 ID(선택, 있으면 비교/검색 연동이 정확해짐)", example = "12", nullable = true)
        Long ingredientId,

        @Schema(description = "식재료명", example = "봄동")
        @NotBlank @Size(max = 50) String ingredientName,

        @Schema(description = "판매가(기본가)", example = "4500")
        @NotNull @DecimalMin("0.0") BigDecimal price,

        @Schema(description = "단위", example = "봉")
        @NotBlank @Size(max = 30) String unit,

        @Schema(description = "신선도 라벨(선택)", example = "당일수확", nullable = true)
        @Size(max = 50) String freshnessLabel,

        @Schema(description = "상품명(선택, 없으면 식재료명 사용)", example = "햇 봄동 1.5kg 산지직송", nullable = true)
        @Size(max = 150) String title,

        @Schema(description = "상품 설명(선택)", example = "남도 텃밭에서 새벽 수확한 유기농 봄동", nullable = true)
        @Size(max = 1000) String description,

        @Schema(description = "카테고리(선택)", example = "잎채소", nullable = true)
        @Size(max = 30) String category,

        @Schema(description = "상품 사진 URL 목록(선택, 첫 번째가 대표 이미지)", nullable = true)
        List<@Size(max = 500) String> photoUrls,

        @Schema(description = "상품 태그 목록(선택)", example = "[\"산지직송\",\"무료배송\"]", nullable = true)
        List<@Size(max = 40) String> tags,

        @Schema(description = "상품 옵션(규격/variant) 목록(선택). 각 옵션 = 수량+단위+가격", nullable = true)
        @Valid List<OptionInput> options,

        @Schema(description = "인증마크(선택, 0개 이상)", example = "[\"무농약\",\"유기농(유기농산물)\"]", nullable = true)
        List<@Size(max = 40) String> certifications,

        @Schema(description = "재고 수량(실시간 판매 가능 수량, 선택)", example = "120", nullable = true)
        @Min(0) Integer stockQuantity,

        @Schema(description = "보관방법(선택, 냉장 보관/냉동 보관/실온 보관/서늘한 그늘 등)", example = "냉장 보관", nullable = true)
        @Size(max = 30) String storageMethod,

        @Schema(description = "보관 안내 설명(선택)", example = "신문지에 싸서 냉장 보관하면 2주까지 신선해요.", nullable = true)
        @Size(max = 500) String storageNote
) {
    @Schema(description = "상품 옵션 입력 — 라벨을 강제하지 않고 수량+단위(자유)+가격으로 받음")
    public record OptionInput(
            @Schema(description = "수량(선택)", example = "1.5", nullable = true)
            BigDecimal quantity,

            @Schema(description = "단위(선택, 추천목록+직접입력)", example = "kg", nullable = true)
            @Size(max = 30) String unit,

            @Schema(description = "옵션 가격", example = "6900")
            @NotNull @DecimalMin("0.0") BigDecimal price
    ) {}
}
