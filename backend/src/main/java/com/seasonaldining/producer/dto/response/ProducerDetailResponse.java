package com.seasonaldining.producer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.util.List;

@Schema(description = "농가 상세 응답")
public record ProducerDetailResponse(
        @Schema(description = "농가 ID", example = "1") Long id,
        @Schema(description = "농가 이름", example = "권민성") String name,
        @Schema(description = "지역", example = "경북영천") String region,
        @Schema(description = "한 줄 소개") String tagline,
        @Schema(description = "대표 사진 URL") String photoUrl,
        @Schema(description = "스타일", example = "PREMIUM") String style,
        @Schema(description = "가격대(1~5)", example = "5") int priceLevel,
        @Schema(description = "신선도(1~5)", example = "5") int freshnessLevel,
        @Schema(description = "평점", example = "4.9") BigDecimal rating,
        @Schema(description = "리뷰 수", example = "1280") int reviewCount,
        @Schema(description = "명예 농가 여부", example = "true") boolean honorary,
        @Schema(description = "취급 식재료") List<String> specialties,
        @Schema(description = "배지") List<String> badges
) {}
