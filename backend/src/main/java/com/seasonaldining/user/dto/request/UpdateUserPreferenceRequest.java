package com.seasonaldining.user.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.util.List;

/**
 * 가입 설문/취향 저장 요청.
 *
 * <p>프론트(가입 설문)는 사람이 읽는 라벨을 그대로 보낸다:
 * {@code {household:"2인", lifestyles:["신선한",...], spicyAvoid:bool, allergens:["난류",...]}}.
 * 모든 필드는 선택값이며 검증으로 400을 내지 않는다 — 보낸 만큼만 best-effort 로 저장한다.
 * 구버전 키({@code householdSize/priority/allergyCodes})도 그대로 받는다(하위호환).
 */
public record UpdateUserPreferenceRequest(
        @Schema(description = "가구 라벨(예: '2인'). 앞자리 숫자를 가구원 수로 해석", example = "2인", nullable = true)
        String household,
        @Schema(description = "선호 소비 유형 라벨 목록(첫 항목을 priority 로 사용)", example = "[\"신선한\",\"저렴한\"]", nullable = true)
        List<String> lifestyles,
        @Schema(description = "알레르기 라벨 목록", example = "[\"난류\",\"우유\"]", nullable = true)
        List<String> allergens,
        @Schema(description = "가구원 수(구버전 키)", example = "2", nullable = true)
        Integer householdSize,
        @Schema(description = "예산", example = "30000", nullable = true)
        BigDecimal budget,
        @Schema(description = "매운 음식 제외 여부", example = "true", nullable = true)
        Boolean spicyAvoid,
        @Schema(description = "추천 우선순위(구버전 키)", example = "LOW_PRICE", nullable = true)
        String priority,
        @Schema(description = "알러지 코드 목록(구버전 키)", example = "[\"EGG\",\"MILK\"]", nullable = true)
        List<String> allergyCodes
) {
    /** 가구원 수 — household('2인') 앞자리 숫자 우선, 없으면 householdSize, 둘 다 없으면 null. */
    public Integer resolvedHouseholdSize() {
        if (household != null && !household.isBlank()) {
            StringBuilder digits = new StringBuilder();
            for (char c : household.toCharArray()) {
                if (Character.isDigit(c)) {
                    digits.append(c);
                } else if (digits.length() > 0) {
                    break;
                }
            }
            if (digits.length() > 0) {
                return Integer.parseInt(digits.toString());
            }
        }
        return householdSize;
    }

    /** 우선순위 — lifestyles 의 첫 항목 우선, 없으면 구버전 priority, 둘 다 없으면 null. */
    public String resolvedPriority() {
        if (lifestyles != null && !lifestyles.isEmpty() && lifestyles.get(0) != null && !lifestyles.get(0).isBlank()) {
            return lifestyles.get(0);
        }
        return priority;
    }

    /** 알레르기 코드 — 신규 allergens 우선, 없으면 구버전 allergyCodes, 둘 다 없으면 null(=변경 안 함). */
    public List<String> resolvedAllergyCodes() {
        if (allergens != null) {
            return allergens;
        }
        return allergyCodes;
    }
}
