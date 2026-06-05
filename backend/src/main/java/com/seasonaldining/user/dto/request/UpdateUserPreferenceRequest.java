package com.seasonaldining.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.List;

public record UpdateUserPreferenceRequest(
        @Schema(description = "가구원 수", example = "2")
        @NotNull @Min(1) @Max(10)
        Integer householdSize,
        @Schema(description = "예산", example = "30000", nullable = true)
        @DecimalMin("0")
        BigDecimal budget,
        @Schema(description = "매운 음식 제외 여부", example = "true")
        @NotNull
        Boolean spicyAvoid,
        @Schema(description = "추천 우선순위", example = "LOW_PRICE")
        @NotBlank
        String priority,
        @Schema(description = "알러지 코드 목록", example = "[\"EGG\",\"MILK\"]")
        List<String> allergyCodes
) {
}
