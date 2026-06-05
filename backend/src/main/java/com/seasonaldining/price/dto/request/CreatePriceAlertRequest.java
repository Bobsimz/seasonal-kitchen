package com.seasonaldining.price.dto.request;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*; import java.math.BigDecimal;
public record CreatePriceAlertRequest(
 @Schema(description="식재료 ID",example="1") @NotNull @Positive Long ingredientId,
 @Schema(description="알림 기준 가격",example="2000") @NotNull @Positive BigDecimal targetPrice){}
