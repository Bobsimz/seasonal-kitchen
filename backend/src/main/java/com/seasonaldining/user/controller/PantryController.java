package com.seasonaldining.user.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.user.dto.request.CreatePantryItemRequest;
import com.seasonaldining.user.dto.request.UpdatePantryItemRequest;
import com.seasonaldining.user.dto.response.PantryItemResponse;
import com.seasonaldining.user.service.PantryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/users/me/pantry")
@Tag(name = "02. Users", description = "사용자 API")
public class PantryController {
    private final PantryService pantryService;
    private final CurrentUserProvider currentUserProvider;

    public PantryController(PantryService pantryService, CurrentUserProvider currentUserProvider) {
        this.pantryService = pantryService;
        this.currentUserProvider = currentUserProvider;
    }

    @GetMapping @Operation(summary = "내 보유 재료 조회")
    public ApiResponse<List<PantryItemResponse>> getItems() {
        return ApiResponse.success(pantryService.getItems(currentUserProvider.getCurrentUserId()), null);
    }

    @PostMapping @Operation(summary = "내 보유 재료 추가")
    public ApiResponse<PantryItemResponse> create(@Valid @RequestBody CreatePantryItemRequest request) {
        return ApiResponse.success(pantryService.create(currentUserProvider.getCurrentUserId(), request), null);
    }

    @PatchMapping("/{itemId}") @Operation(summary = "내 보유 재료 수정")
    public ApiResponse<PantryItemResponse> update(@PathVariable Long itemId, @Valid @RequestBody UpdatePantryItemRequest request) {
        return ApiResponse.success(pantryService.update(currentUserProvider.getCurrentUserId(), itemId, request), null);
    }

    @DeleteMapping("/{itemId}") @Operation(summary = "내 보유 재료 삭제")
    public ApiResponse<Void> delete(@PathVariable Long itemId) {
        pantryService.delete(currentUserProvider.getCurrentUserId(), itemId);
        return ApiResponse.success(null, null);
    }
}
