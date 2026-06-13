package com.seasonaldining.producer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.util.List;

@Schema(description = "농가 자가등록 요청 (마이페이지 → 판매자 등록 화면)")
public record RegisterProducerRequest(
        @Schema(description = "농가/농장 이름", example = "해남 송지농원")
        @NotBlank @Size(max = 100) String name,

        @Schema(description = "대표 지역", example = "전남 해남")
        @NotBlank @Size(max = 100) String region,

        @Schema(description = "한줄 소개(선택)", example = "30년 무 농사, 햇무만 보냅니다", nullable = true)
        @Size(max = 300) String tagline,

        @Schema(description = "농가 대표 사진 이미지 URL(선택)", example = "https://cdn/farm.png", nullable = true)
        @Size(max = 500) String photoUrl,

        @Schema(description = "판매 스타일 VALUE(실속)|ORGANIC(유기농)|PREMIUM(프리미엄), 미지정 시 VALUE", example = "ORGANIC", nullable = true)
        @Size(max = 20) String style,

        @Schema(description = "가격대(1 저렴 ~ 5 프리미엄), 미지정 시 3", example = "3", nullable = true)
        @Min(1) @Max(5) Integer priceLevel,

        @Schema(description = "신선도(1 보통 ~ 5 최상), 미지정 시 4", example = "4", nullable = true)
        @Min(1) @Max(5) Integer freshnessLevel,

        @Schema(description = "주요 판매 품목(식재료명 목록, 선택)", example = "[\"무\",\"배추\",\"봄동\"]", nullable = true)
        List<String> specialties,

        @Schema(description = "농가 배지 목록(선택)", example = "[\"산지직송\",\"당일수확\"]", nullable = true)
        List<String> badges,

        @Schema(description = "대표자 이름(선택, 심사용)", example = "김상도", nullable = true)
        @Size(max = 50) String representativeName,

        @Schema(description = "연락처(선택, 심사용)", example = "010-1234-5678", nullable = true)
        @Size(max = 30) String contact,

        @Schema(description = "농가 인증 서류 이미지 URL(선택, 심사는 추후)", example = "https://cdn/cert.png", nullable = true)
        @Size(max = 500) String certificationImageUrl,

        @Schema(description = "판매자 이용약관·정산정책 동의(선택)", example = "true", nullable = true)
        Boolean agreedToTerms
) {
    /**
     * 하위호환 편의 생성자 — 구버전 호출부(대표자/연락처/인증서류 중심의 7-arg) 보존용.
     * 신규 필드(tagline/style/priceLevel/freshnessLevel/badges)는 기본값(null)으로 위임한다.
     */
    public RegisterProducerRequest(String name, String representativeName, String region, String contact,
                                   List<String> specialties, String certificationImageUrl, Boolean agreedToTerms) {
        this(name, region, null, null, null, null, null, specialties, null,
                representativeName, contact, certificationImageUrl, agreedToTerms);
    }
}
