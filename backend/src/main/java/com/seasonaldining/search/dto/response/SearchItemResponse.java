package com.seasonaldining.search.dto.response;
import io.swagger.v3.oas.annotations.media.Schema;
public record SearchItemResponse(
 @Schema(description="결과 유형",example="INGREDIENT") String type,
 @Schema(description="결과 ID",example="1") Long id,
 @Schema(description="표시 제목",example="무") String title,
 @Schema(description="설명",nullable=true) String description,
 @Schema(description="이미지 URL",nullable=true) String imageUrl){}
