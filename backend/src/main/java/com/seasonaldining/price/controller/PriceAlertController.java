package com.seasonaldining.price.controller;
import com.seasonaldining.common.response.ApiResponse; import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.price.dto.request.*; import com.seasonaldining.price.dto.response.PriceAlertResponse; import com.seasonaldining.price.service.PriceAlertService;
import io.swagger.v3.oas.annotations.*; import io.swagger.v3.oas.annotations.tags.Tag; import jakarta.validation.Valid; import org.springframework.web.bind.annotation.*; import java.util.List;
@RestController @RequestMapping("/api/v1/price-alerts") @Tag(name="06. Prices",description="가격 API")
public class PriceAlertController {
 private final PriceAlertService service; private final CurrentUserProvider currentUser;
 public PriceAlertController(PriceAlertService service,CurrentUserProvider currentUser){this.service=service;this.currentUser=currentUser;}
 @GetMapping @Operation(summary="내 가격 알림 조회") public ApiResponse<List<PriceAlertResponse>> get(){return ApiResponse.success(service.getAlerts(currentUser.getCurrentUserId()),null);}
 @PostMapping @Operation(summary="가격 알림 추가") public ApiResponse<PriceAlertResponse> create(@Valid @RequestBody CreatePriceAlertRequest r){return ApiResponse.success(service.create(currentUser.getCurrentUserId(),r),null);}
 @PatchMapping("/{alertId}") @Operation(summary="가격 알림 수정") public ApiResponse<PriceAlertResponse> update(@PathVariable Long alertId,@Valid @RequestBody UpdatePriceAlertRequest r){return ApiResponse.success(service.update(currentUser.getCurrentUserId(),alertId,r),null);}
 @DeleteMapping("/{alertId}") @Operation(summary="가격 알림 삭제") public ApiResponse<Void> delete(@PathVariable Long alertId){service.delete(currentUser.getCurrentUserId(),alertId);return ApiResponse.success(null,null);}
}
