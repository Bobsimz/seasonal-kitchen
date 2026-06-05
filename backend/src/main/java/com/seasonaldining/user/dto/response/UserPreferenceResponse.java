package com.seasonaldining.user.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.util.List;

public record UserPreferenceResponse(
        @Schema(description = "가구원 수", example = "2")
        int householdSize,
        @Schema(description = "예산", example = "30000", nullable = true)
        BigDecimal budget,
        @Schema(description = "매운 음식 제외 여부", example = "true")
        boolean spicyAvoid,
        @Schema(description = "추천 우선순위", example = "LOW_PRICE")
        String priority,
        @Schema(description = "알러지 코드 목록", example = "[\"EGG\",\"MILK\"]")
        List<String> allergyCodes
) {
}
