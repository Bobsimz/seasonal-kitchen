package com.seasonaldining.ingredient.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;
import java.util.List;

public record IngredientDetailResponse(
        @Schema(description = "식재료 ID", example = "1")
        Long id,

        @Schema(description = "식재료명", example = "무")
        String name,

        @Schema(description = "카테고리", example = "채소")
        String category,

        @Schema(description = "식재료 이미지 URL", example = "https://example.com/radish.png", nullable = true)
        String imageUrl,

        @Schema(description = "기준 단위", example = "1개")
        String baseUnit,

        @Schema(description = "제철 여부", example = "false")
        boolean seasonal,

        @Schema(description = "인기(핫) 여부", example = "false")
        boolean hot,

        @Schema(description = "제철 점수", example = "0", nullable = true)
        Integer seasonScore,

        // ── 프론트가 직접 읽는 flat 가격 필드 ──────────────────────────────
        @Schema(description = "현재 가격. 가격 스냅샷 없으면 null", example = "4500", nullable = true)
        BigDecimal currentPrice,

        @Schema(description = "가격 단위", example = "봉", nullable = true)
        String unit,

        @Schema(description = "주간 가격 변동률(정수 %)", example = "-12", nullable = true)
        Integer priceChangePct,

        @Schema(description = "가격 추세 방향(UP|DOWN|FLAT)", example = "DOWN", nullable = true)
        String trendDirection,

        @Schema(description = "가격 변동 라벨(표시용)", example = "-12%", nullable = true)
        String priceChangeLabel,

        @Schema(description = "가격 요약. 가격 도메인 미구현 시 null")
        IngredientCardResponse.PriceSummaryResponse price,

        @Schema(description = "구매 시그널(GOOD|HOLD|HIGH)", example = "GOOD", nullable = true)
        String buyingSignal,

        @Schema(description = "상세 설명", example = "현재 가격 메리트가 높은 제철 식재료입니다.", nullable = true)
        String description,
        @Schema(description = "제철 월 목록")
        List<Integer> seasonMonths,
        @Schema(description = "영양 정보 목록({label,value})", nullable = true)
        List<NutritionItemResponse> nutrition,
        @Schema(description = "손질 팁")
        List<String> careTips,
        @Schema(description = "보관 팁")
        List<String> storageTips,
        @Schema(description = "가격 비교 가능 매장 수", example = "3")
        long compareStoreCount
) {
    public record NutritionItemResponse(String label, String value) {}
}
