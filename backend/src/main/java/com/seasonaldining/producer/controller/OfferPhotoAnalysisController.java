package com.seasonaldining.producer.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.producer.dto.request.GenerateDescriptionRequest;
import com.seasonaldining.producer.dto.request.OfferImageGenerationRequest;
import com.seasonaldining.producer.dto.response.GenerateDescriptionResponse;
import com.seasonaldining.producer.dto.response.OfferImageGenerationResponse;
import com.seasonaldining.producer.dto.response.OfferPhotoAnalysisResponse;
import com.seasonaldining.producer.service.GeminiService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/v1/producers/me/offers")
@Tag(name = "18. Producers", description = "농가(생산자) API")
public class OfferPhotoAnalysisController {

    private final GeminiService geminiService;

    public OfferPhotoAnalysisController(GeminiService geminiService) {
        this.geminiService = geminiService;
    }

    @PostMapping(value = "/analyze-photo", consumes = "multipart/form-data")
    @Operation(
            summary = "상품 사진 AI 분석",
            description = "업로드한 상품 사진을 Gemini AI로 분석하여 식재료명·카테고리·보관방법·소구포인트를 반환합니다. 인증 필요."
    )
    public ApiResponse<OfferPhotoAnalysisResponse> analyzePhoto(
            @RequestParam("image") MultipartFile image) {
        return ApiResponse.success(geminiService.analyzeOfferPhoto(image), null);
    }

    @PostMapping("/generate-image")
    @Operation(
            summary = "추가 상품 이미지 AI 생성",
            description = "분석된 상품 정보를 기반으로 Gemini AI가 추가 상품 이미지를 생성합니다. 인증 필요."
    )
    public ApiResponse<OfferImageGenerationResponse> generateImage(
            @RequestBody OfferImageGenerationRequest request) {
        return ApiResponse.success(geminiService.generateOfferImage(request), null);
    }

    @PostMapping("/generate-description")
    @Operation(
            summary = "소구문장 AI 생성",
            description = "농가명·식재료명·선택된 소구 키워드를 바탕으로 상품 소개 문구를 생성합니다. 인증 필요."
    )
    public ApiResponse<GenerateDescriptionResponse> generateDescription(
            @Valid @RequestBody GenerateDescriptionRequest request) {
        return ApiResponse.success(geminiService.generateDescription(request), null);
    }
}
