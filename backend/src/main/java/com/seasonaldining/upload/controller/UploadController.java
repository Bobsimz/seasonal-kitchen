package com.seasonaldining.upload.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.upload.dto.response.UploadResponse;
import com.seasonaldining.upload.service.UploadService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 이미지 업로드 API. 인증 필요. 응답으로 접근 URL을 돌려준다.
 * 사용처: 농가 인증서류(certificationImageUrl), 상품 사진(photoUrls), (향후) 리뷰 사진.
 */
@RestController
@RequestMapping("/api/v1/uploads")
@Tag(name = "20. Uploads", description = "이미지 업로드 API")
public class UploadController {

    private final UploadService uploadService;

    public UploadController(UploadService uploadService) {
        this.uploadService = uploadService;
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "이미지 업로드", description = "multipart 'file' 파트로 이미지를 업로드하고 접근 URL을 반환합니다. image/png, image/jpeg, image/webp, image/gif만 허용하며 SVG는 제외합니다.")
    public ApiResponse<UploadResponse> upload(@RequestParam("file") MultipartFile file) {
        return ApiResponse.success(uploadService.upload(file), null);
    }

    @PostMapping(value = "/batch", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "이미지 일괄 업로드", description = "multipart 'files' 파트로 이미지를 최대 10장 업로드하고 URL 목록을 반환합니다.")
    public ApiResponse<List<UploadResponse>> uploadBatch(@RequestParam("files") List<MultipartFile> files) {
        return ApiResponse.success(uploadService.uploadAll(files), null);
    }
}
