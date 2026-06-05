package com.seasonaldining.recommendation.dto.request;
import jakarta.validation.constraints.*; import java.math.BigDecimal; import io.swagger.v3.oas.annotations.media.Schema;
public record CreateShoppingPlanRequest(@Schema(example="3") @NotNull @Min(1) @Max(14) Integer days,@Schema(example="2") @NotNull @Min(1) @Max(10) Integer people,@Schema(example="30000",nullable=true) @DecimalMin("0") BigDecimal budget){}
