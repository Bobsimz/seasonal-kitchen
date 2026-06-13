package com.seasonaldining.producer.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.producer.dto.request.GenerateDescriptionRequest;
import com.seasonaldining.producer.dto.response.GenerateDescriptionResponse;
import com.seasonaldining.producer.dto.response.OfferImageGenerationResponse;
import com.seasonaldining.producer.dto.response.OfferPhotoAnalysisResponse;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.repository.ProducerRepository;
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
    private final CurrentUserProvider currentUserProvider;
    private final ProducerRepository producerRepository;

    public OfferPhotoAnalysisController(GeminiService geminiService,
                                        CurrentUserProvider currentUserProvider,
                                        ProducerRepository producerRepository) {
        this.geminiService = geminiService;
        this.currentUserProvider = currentUserProvider;
        this.producerRepository = producerRepository;
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

    @PostMapping(value = "/generate-image", consumes = "multipart/form-data")
    @Operation(
            summary = "추가 상품 이미지 AI 생성",
            description = "참고 사진을 기반으로 Gemini AI가 추가 상품 이미지를 생성합니다. " +
                    "농가 프로필 사진이 등록되어 있으면 상품과 농가가 함께 담긴 사진을 생성합니다. " +
                    "입력 사진과 동일한 비율로 생성되며, 텍스트·워터마크가 없는 깔끔한 상품 사진을 반환합니다. 인증 필요."
    )
    public ApiResponse<OfferImageGenerationResponse> generateImage(
            @RequestParam("image") MultipartFile image) {
        String farmPhotoUrl = producerRepository.findByUserId(currentUserProvider.getCurrentUserId())
                .map(Producer::getPhotoUrl)
                .orElse(null);
        return ApiResponse.success(geminiService.generateOfferImageFromPhoto(image, farmPhotoUrl), null);
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
