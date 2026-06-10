package com.seasonaldining.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "마이페이지 화면 요약 응답")
public record MyPageSummaryResponse(
        ProfileResponse profile,
        StatsResponse stats,
        PreferenceSummaryResponse preferences,
        List<String> allergyCodes,
        List<PersonalizedIngredientResponse> personalizedIngredients,
        List<MenuRowResponse> menuRows
) {

    public record ProfileResponse(
            @Schema(example = "1") Long id,
            @Schema(example = "제철요리사") String nickname,
            @Schema(example = "https://example.com/profile.png") String profileImageUrl
    ) {
    }

    public record StatsResponse(
            @Schema(example = "12000") BigDecimal monthlySaving,
            @Schema(example = "3") long favoriteCount,
            @Schema(example = "2") long activeAlertCount,
            @Schema(example = "0") long recentOrderCount
    ) {
    }

    public record PreferenceSummaryResponse(
            @Schema(example = "2") Integer householdSize,
            @Schema(example = "true") Boolean spicyAvoid,
            @Schema(example = "LOW_PRICE") String priority
    ) {
    }

    public record PersonalizedIngredientResponse(
            @Schema(example = "1") Long id,
            @Schema(example = "봄동") String name,
            @Schema(example = "채소") String category,
            @Schema(example = "https://example.com/bomdong.png") String imageUrl,
            List<String> tags
    ) {
    }

    public record MenuRowResponse(
            @Schema(example = "favorites") String key,
            @Schema(example = "찜한 콘텐츠") String label,
            @Schema(example = "3") long count
    ) {
    }
}
