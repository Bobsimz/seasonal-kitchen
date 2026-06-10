package com.seasonaldining.producer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.math.BigDecimal;

@Schema(description = "내 농가 상품(오퍼) 등록 요청")
public record CreateOfferRequest(
        @Schema(description = "연결 식재료 ID(선택, 있으면 비교/검색 연동이 정확해짐)", example = "12", nullable = true)
        Long ingredientId,

        @Schema(description = "식재료명", example = "봄동")
        @NotBlank @Size(max = 50) String ingredientName,

        @Schema(description = "판매가", example = "4500")
        @NotNull @DecimalMin("0.0") BigDecimal price,

        @Schema(description = "단위", example = "봉")
        @NotBlank @Size(max = 30) String unit,

        @Schema(description = "신선도 라벨(선택)", example = "당일수확", nullable = true)
        @Size(max = 50) String freshnessLabel
) {}
