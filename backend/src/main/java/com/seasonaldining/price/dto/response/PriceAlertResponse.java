package com.seasonaldining.price.dto.response;
import io.swagger.v3.oas.annotations.media.Schema; import java.math.BigDecimal;
public record PriceAlertResponse(
 @Schema(description="가격 알림 ID",example="1") Long id,
 @Schema(description="식재료 ID",example="1") Long ingredientId,
 @Schema(description="식재료명",example="무") String ingredientName,
 @Schema(description="식재료 이미지 URL",nullable=true) String imageUrl,
 @Schema(description="현재가(최신 시세 스냅샷)",example="2200",nullable=true) BigDecimal currentPrice,
 @Schema(description="알림 기준 가격",example="2000") BigDecimal targetPrice,
 @Schema(description="단위",example="개",nullable=true) String unit,
 @Schema(description="활성 여부",example="true") boolean active){}
