package com.seasonaldining.reel.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.AuthenticatedUser;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.reel.dto.request.CreateReelCommentRequest;
import com.seasonaldining.reel.dto.response.*;
import com.seasonaldining.reel.service.ReelService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/reels")
@Tag(name = "09. Reels", description = "릴스 API")
public class ReelController {
    private final ReelService service;
    private final CurrentUserProvider currentUserProvider;

    public ReelController(ReelService service, CurrentUserProvider currentUserProvider) {
        this.service = service;
        this.currentUserProvider = currentUserProvider;
    }

    @GetMapping
    @Operation(summary = "릴스 피드 조회")
    public ApiResponse<List<ReelResponse>> getReels() {
        return ApiResponse.success(service.getReels(optionalUserId()), null);
    }

    @GetMapping("/{reelId}")
    @Operation(summary = "릴스 상세 조회")
    public ApiResponse<ReelResponse> getReel(@PathVariable Long reelId) {
        return ApiResponse.success(service.getReel(reelId, optionalUserId()), null);
    }

    @PostMapping("/{reelId}/likes")
    @Operation(summary = "릴스 좋아요")
    public ApiResponse<ReelActionResponse> like(@PathVariable Long reelId) {
        return ApiResponse.success(service.like(reelId, currentUserProvider.getCurrentUserId()), null);
    }

    @DeleteMapping("/{reelId}/likes")
    @Operation(summary = "릴스 좋아요 취소")
    public ApiResponse<ReelActionResponse> unlike(@PathVariable Long reelId) {
        return ApiResponse.success(service.unlike(reelId, currentUserProvider.getCurrentUserId()), null);
    }

    @PostMapping("/{reelId}/saves")
    @Operation(summary = "릴스 저장(찜)")
    public ApiResponse<ReelSaveActionResponse> save(@PathVariable Long reelId) {
        return ApiResponse.success(service.save(reelId, currentUserProvider.getCurrentUserId()), null);
    }

    @DeleteMapping("/{reelId}/saves")
    @Operation(summary = "릴스 저장(찜) 취소")
    public ApiResponse<ReelSaveActionResponse> unsave(@PathVariable Long reelId) {
        return ApiResponse.success(service.unsave(reelId, currentUserProvider.getCurrentUserId()), null);
    }

    @GetMapping("/{reelId}/comments")
    @Operation(summary = "릴스 댓글 조회")
    public ApiResponse<List<ReelCommentResponse>> getComments(@PathVariable Long reelId) {
        return ApiResponse.success(service.getComments(reelId), null);
    }

    @PostMapping("/{reelId}/comments")
    @Operation(summary = "릴스 댓글 작성")
    public ApiResponse<ReelCommentResponse> addComment(@PathVariable Long reelId, @Valid @RequestBody CreateReelCommentRequest request) {
        return ApiResponse.success(service.addComment(reelId, currentUserProvider.getCurrentUserId(), request.content()), null);
    }

    @PostMapping("/{reelId}/view-events")
    @Operation(summary = "릴스 조회 이벤트 기록")
    public ApiResponse<ReelResponse> recordView(@PathVariable Long reelId) {
        return ApiResponse.success(service.recordView(reelId, currentUserProvider.getCurrentUserId()), null);
    }

    private Long optionalUserId() {
        var authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.getPrincipal() instanceof AuthenticatedUser user ? user.userId() : null;
    }
}
