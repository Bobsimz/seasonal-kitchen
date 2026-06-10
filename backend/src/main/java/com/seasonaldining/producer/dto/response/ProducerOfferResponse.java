package com.seasonaldining.producer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;

@Schema(description = "농가 상품(식재료) 가격 응답 — 농가 비교/농가 상세 공용")
public record ProducerOfferResponse(
        @Schema(description = "오퍼 ID", example = "10") Long id,
        @Schema(description = "농가 ID", example = "1") Long producerId,
        @Schema(description = "농가 이름", example = "권민성") String producerName,
        @Schema(description = "지역", example = "경북영천") String region,
        @Schema(description = "식재료명", example = "봄동") String ingredientName,
        @Schema(description = "식재료 ID(연결된 경우)", example = "12", nullable = true) Long ingredientId,
        @Schema(description = "판매가", example = "4500") BigDecimal price,
        @Schema(description = "단위", example = "봉") String unit,
        @Schema(description = "신선도 라벨", example = "당일수확") String freshnessLabel
) {}
