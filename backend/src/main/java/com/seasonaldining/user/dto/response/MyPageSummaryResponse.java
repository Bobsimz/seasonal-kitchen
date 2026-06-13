package com.seasonaldining.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "마이페이지 화면 요약 응답")
public record MyPageSummaryResponse(
        UserBlock user,
        StatsResponse stats,
        CountsResponse counts,
        List<PersonalizedIngredientResponse> personalized
) {

    @Schema(description = "프로필 블록 — FE ProfileBlock 가 읽는다")
    public record UserBlock(
            @Schema(example = "1") Long id,
            @Schema(example = "제철요리사") String nickname,
            @Schema(example = "https://example.com/profile.png") String photoUrl
    ) {
    }

    @Schema(description = "상단 통계 3종 — 절약액/주문/리뷰")
    public record StatsResponse(
            @Schema(example = "12000") BigDecimal savedAmount,
            @Schema(example = "7") long orderCount,
            @Schema(example = "3") long reviewCount
    ) {
    }

    @Schema(description = "메뉴 리스트 배지 카운트")
    public record CountsResponse(
            @Schema(example = "7") long orders,
            @Schema(example = "12") long favorites,
            @Schema(example = "4") long priceAlerts,
            @Schema(example = "3") long reviews
    ) {
    }

    @Schema(description = "개인화 제철 추천 — FE IngredientCard 형태")
    public record PersonalizedIngredientResponse(
            @Schema(example = "1") Long id,
            @Schema(example = "봄동") String name,
            @Schema(example = "채소") String category,
            @Schema(example = "https://example.com/bomdong.png") String imageUrl,
            @Schema(example = "4500", nullable = true) BigDecimal currentPrice,
            @Schema(example = "봉", nullable = true) String unit,
            @Schema(example = "-15%", nullable = true) String priceChangeLabel,
            @Schema(example = "DOWN", nullable = true) String trendDirection
    ) {
    }
}
