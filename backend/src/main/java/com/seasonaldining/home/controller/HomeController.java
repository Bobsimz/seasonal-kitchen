package com.seasonaldining.home.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.home.dto.response.HomeResponse;
import com.seasonaldining.home.service.HomeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/home")
@Tag(name = "03. Home", description = "홈 API")
public class HomeController {
    private final HomeService homeService;
    public HomeController(HomeService homeService) { this.homeService = homeService; }

    @GetMapping
    @Operation(summary = "홈 화면 집계 조회")
    public ApiResponse<HomeResponse> getHome() {
        return ApiResponse.success(homeService.getHome(), null);
    }
}
