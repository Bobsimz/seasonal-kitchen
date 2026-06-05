package com.seasonaldining.price.dto.request;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*; import java.math.BigDecimal;
public record UpdatePriceAlertRequest(
 @Schema(description="알림 기준 가격",example="1800") @NotNull @Positive BigDecimal targetPrice,
 @Schema(description="활성 여부",example="true") @NotNull Boolean active){}
