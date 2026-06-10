package com.seasonaldining.producer.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.util.List;

@Schema(description = "농가 자가등록 요청 (마이페이지 → 농가로 등록)")
public record RegisterProducerRequest(
        @Schema(description = "농가/생산자명", example = "권민성")
        @NotBlank @Size(max = 100) String name,

        @Schema(description = "지역(시·군)", example = "경북 영천")
        @NotBlank @Size(max = 100) String region,

        @Schema(description = "한 줄 소개", example = "고랭지 무농약 채소")
        @Size(max = 300) String tagline,

        @Schema(description = "대표 사진 URL(선택)", nullable = true)
        @Size(max = 500) String photoUrl,

        @Schema(description = "판매 스타일", example = "ORGANIC", allowableValues = {"VALUE", "ORGANIC", "PREMIUM"})
        @NotBlank @Pattern(regexp = "VALUE|ORGANIC|PREMIUM") String style,

        @Schema(description = "가격대 자가표시(1~5, 선택, 기본 3)", example = "3")
        @Min(1) @Max(5) Integer priceLevel,

        @Schema(description = "신선도 자가표시(1~5, 선택, 기본 4)", example = "4")
        @Min(1) @Max(5) Integer freshnessLevel,

        @Schema(description = "취급 식재료명 목록", example = "[\"봄동\",\"무\",\"시금치\"]")
        List<String> specialties,

        @Schema(description = "배지(자기신고)", example = "[\"산지직송\",\"당일수확\"]")
        List<String> badges
) {}
