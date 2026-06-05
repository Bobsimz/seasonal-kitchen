package com.seasonaldining.user.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.user.dto.request.UpdateUserProfileRequest;
import com.seasonaldining.user.dto.request.UpdateUserPreferenceRequest;
import com.seasonaldining.user.dto.response.MyPageSummaryResponse;
import com.seasonaldining.user.dto.response.UserProfileResponse;
import com.seasonaldining.user.dto.response.UserPreferenceResponse;
import com.seasonaldining.user.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/users/me")
@Tag(name = "02. Users", description = "사용자 API")
public class UserController {

    private final UserService userService;
    private final CurrentUserProvider currentUserProvider;

    public UserController(UserService userService, CurrentUserProvider currentUserProvider) {
        this.userService = userService;
        this.currentUserProvider = currentUserProvider;
    }

    @GetMapping
    @Operation(summary = "내 프로필 조회")
    public ApiResponse<UserProfileResponse> getMyProfile() {
        return ApiResponse.success(userService.getProfile(currentUserProvider.getCurrentUserId()), null);
    }

    @GetMapping("/summary")
    @Operation(summary = "마이페이지 요약 조회", description = "프로필, 통계, 추천 설정, 알러지, 개인화 식재료, 메뉴 카운트를 한 번에 조회합니다.")
    public ApiResponse<MyPageSummaryResponse> getMySummary() {
        return ApiResponse.success(userService.getSummary(currentUserProvider.getCurrentUserId()), null);
    }

    @PatchMapping
    @Operation(summary = "내 프로필 수정")
    public ApiResponse<UserProfileResponse> updateMyProfile(@Valid @RequestBody UpdateUserProfileRequest request) {
        return ApiResponse.success(userService.updateProfile(currentUserProvider.getCurrentUserId(), request), null);
    }

    @PutMapping("/preferences")
    @Operation(summary = "내 추천 설정 저장")
    public ApiResponse<UserPreferenceResponse> updateMyPreference(
            @Valid @RequestBody UpdateUserPreferenceRequest request
    ) {
        return ApiResponse.success(userService.updatePreference(currentUserProvider.getCurrentUserId(), request), null);
    }
}
