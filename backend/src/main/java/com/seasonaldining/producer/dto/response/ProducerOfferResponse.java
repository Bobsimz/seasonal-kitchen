package com.seasonaldining.producer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.util.List;

@Schema(description = "농가 상품(식재료) 응답 — 농가 비교/농가 상세/상품 화면 공용")
public record ProducerOfferResponse(
        @Schema(description = "오퍼 ID", example = "10") Long id,
        @Schema(description = "농가 ID", example = "1") Long producerId,
        @Schema(description = "농가 이름", example = "권민성") String producerName,
        @Schema(description = "지역", example = "경북영천") String region,
        @Schema(description = "식재료명", example = "봄동") String ingredientName,
        @Schema(description = "식재료 ID(연결된 경우)", example = "12", nullable = true) Long ingredientId,
        @Schema(description = "판매가(기본가)", example = "4500") BigDecimal price,
        @Schema(description = "단위", example = "봉") String unit,
        @Schema(description = "신선도 라벨", example = "당일수확") String freshnessLabel,
        @Schema(description = "상품명(없으면 식재료명)", example = "햇 봄동 1.5kg 산지직송", nullable = true) String title,
        @Schema(description = "상품 설명", nullable = true) String description,
        @Schema(description = "카테고리", example = "잎채소", nullable = true) String category,
        @Schema(description = "상품 사진 URL 목록(첫 번째가 대표)") List<String> photoUrls,
        @Schema(description = "상품 태그 목록", example = "[\"산지직송\",\"무료배송\"]") List<String> tags,
        @Schema(description = "상품 옵션 목록(규격/variant)") List<OptionResponse> options
) {
    @Schema(description = "상품 옵션")
    public record OptionResponse(
            @Schema(description = "옵션 ID", example = "100") Long id,
            @Schema(description = "수량", example = "1.5", nullable = true) BigDecimal quantity,
            @Schema(description = "단위", example = "kg", nullable = true) String unit,
            @Schema(description = "옵션 가격", example = "6900") BigDecimal price
    ) {}
}
