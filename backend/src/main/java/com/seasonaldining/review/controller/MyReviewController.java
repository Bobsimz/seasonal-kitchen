package com.seasonaldining.review.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.review.dto.response.MyReviewResponse;
import com.seasonaldining.review.service.MyReviewService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/users/me/reviews")
@Tag(name = "20. Reviews", description = "리뷰 API")
public class MyReviewController {

    private final MyReviewService myReviewService;
    private final CurrentUserProvider currentUserProvider;

    public MyReviewController(MyReviewService myReviewService, CurrentUserProvider currentUserProvider) {
        this.myReviewService = myReviewService;
        this.currentUserProvider = currentUserProvider;
    }

    @GetMapping
    @Operation(summary = "내 리뷰 조회", description = "status=writable(작성가능) | written(작성한). 기본값 written.")
    public ApiResponse<List<MyReviewResponse>> getMyReviews(
            @Parameter(description = "writable | written", example = "written")
            @RequestParam(required = false, defaultValue = "written") String status) {
        return ApiResponse.success(
                myReviewService.getMyReviews(currentUserProvider.getCurrentUserId(), status), null);
    }
}
