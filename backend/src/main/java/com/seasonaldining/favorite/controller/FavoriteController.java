package com.seasonaldining.favorite.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.favorite.dto.request.CreateFavoriteRequest;
import com.seasonaldining.favorite.dto.response.FavoriteResponse;
import com.seasonaldining.favorite.service.FavoriteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/v1/favorites")
@Tag(name = "10. Favorites", description = "찜 API")
public class FavoriteController {
    private final FavoriteService favoriteService;
    private final CurrentUserProvider currentUserProvider;
    public FavoriteController(FavoriteService favoriteService, CurrentUserProvider currentUserProvider) {
        this.favoriteService = favoriteService; this.currentUserProvider = currentUserProvider;
    }
    @GetMapping @Operation(summary = "내 찜 목록 조회")
    public ApiResponse<List<FavoriteResponse>> getFavorites() {
        return ApiResponse.success(favoriteService.getFavorites(currentUserProvider.getCurrentUserId()), null);
    }
    @PostMapping @Operation(summary = "찜 추가")
    public ApiResponse<FavoriteResponse> create(@Valid @RequestBody CreateFavoriteRequest request) {
        return ApiResponse.success(favoriteService.create(currentUserProvider.getCurrentUserId(), request), null);
    }
    @DeleteMapping("/{favoriteId}") @Operation(summary = "찜 삭제")
    public ApiResponse<Void> delete(@PathVariable Long favoriteId) {
        favoriteService.delete(currentUserProvider.getCurrentUserId(), favoriteId);
        return ApiResponse.success(null, null);
    }
}
