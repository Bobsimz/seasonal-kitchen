package com.seasonaldining.analytics.controller;

import com.seasonaldining.analytics.dto.request.CreateUserEventRequest;
import com.seasonaldining.analytics.dto.response.UserEventResponse;
import com.seasonaldining.analytics.service.UserEventService;
import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/events")
@Tag(name = "14. Analytics", description = "사용자 행동 로그 API")
public class UserEventController {
    private final UserEventService service;
    private final CurrentUserProvider currentUserProvider;

    public UserEventController(UserEventService service, CurrentUserProvider currentUserProvider) {
        this.service = service;
        this.currentUserProvider = currentUserProvider;
    }

    @PostMapping
    @Operation(summary = "사용자 행동 로그 적재")
    public ApiResponse<UserEventResponse> create(@Valid @RequestBody CreateUserEventRequest request) {
        return ApiResponse.success(service.create(currentUserProvider.getCurrentUserId(), request), null);
    }
}
