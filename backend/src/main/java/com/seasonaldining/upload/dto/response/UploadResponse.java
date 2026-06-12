package com.seasonaldining.upload.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "이미지 업로드 응답")
public record UploadResponse(
        @Schema(description = "업로드된 이미지 접근 URL", example = "/uploads/images/ab12cd.png") String url
) {}
