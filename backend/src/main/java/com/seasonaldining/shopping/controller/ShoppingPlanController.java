package com.seasonaldining.shopping.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.recommendation.service.RecommendationPlanService;
import com.seasonaldining.shopping.dto.request.UpdateShoppingPlanItemRequest;
import com.seasonaldining.shopping.dto.response.ShoppingPlanItemResponse;
import com.seasonaldining.shopping.dto.response.ShoppingPlanResponse;
import com.seasonaldining.shopping.dto.response.ShoppingPlanStoreLinksResponse;
import com.seasonaldining.shopping.service.ShoppingPlanItemService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/shopping-plans")
@Tag(name = "11. Shopping Plans", description = "장보기 API")
public class ShoppingPlanController {

    private final RecommendationPlanService service;
    private final ShoppingPlanItemService items;
    private final CurrentUserProvider current;

    public ShoppingPlanController(
            RecommendationPlanService service,
            ShoppingPlanItemService items,
            CurrentUserProvider current
    ) {
        this.service = service;
        this.items = items;
        this.current = current;
    }

    @GetMapping("/{planId}")
    @Operation(summary = "장보기 계획 조회")
    public ApiResponse<ShoppingPlanResponse> get(@PathVariable Long planId) {
        return ApiResponse.success(service.get(current.getCurrentUserId(), planId), null);
    }

    @GetMapping("/{planId}/store-links")
    @Operation(summary = "장보기 스토어 링크 조회", description = "선택된 장보기 항목을 스토어/플랫폼별로 묶어 checkout 화면용 링크 데이터를 반환합니다.")
    public ApiResponse<ShoppingPlanStoreLinksResponse> getStoreLinks(@PathVariable Long planId) {
        return ApiResponse.success(service.getStoreLinks(current.getCurrentUserId(), planId), null);
    }

    @PatchMapping("/{planId}/items/{itemId}")
    @Operation(summary = "장보기 항목 선택 수정")
    public ApiResponse<ShoppingPlanItemResponse> update(
            @PathVariable Long planId,
            @PathVariable Long itemId,
            @Valid @RequestBody UpdateShoppingPlanItemRequest request
    ) {
        return ApiResponse.success(items.update(current.getCurrentUserId(), planId, itemId, request.selected()), null);
    }
}
