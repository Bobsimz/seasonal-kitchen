package com.seasonaldining.upload.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.storage.FileStorage;
import com.seasonaldining.upload.dto.response.UploadResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Set;

/**
 * 이미지 업로드 — 검증(이미지 타입/크기) 후 {@link FileStorage}에 위임.
 * 저장 방식(로컬/S3)은 FileStorage 구현 교체로 결정된다.
 */
@Service
public class UploadService {

    private static final String KEY_PREFIX = "images";
    static final int MAX_FILES = 10;
    // image/* 전체 허용 대신 안전한 래스터 포맷만 whitelist. (SVG는 스크립트/외부참조 위험으로 제외)
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/png", "image/jpeg", "image/webp", "image/gif");

    private final FileStorage fileStorage;
    private final long maxBytes;

    public UploadService(FileStorage fileStorage,
                         @Value("${app.uploads.max-bytes:5242880}") long maxBytes) { // 기본 5MB
        this.fileStorage = fileStorage;
        this.maxBytes = maxBytes;
    }

    public UploadResponse upload(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BusinessException(ErrorCode.EMPTY_FILE);
        }
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
            throw new BusinessException(ErrorCode.INVALID_FILE_TYPE);   // png/jpeg/webp/gif만 허용 (SVG 등 차단)
        }
        if (file.getSize() > maxBytes) {
            throw new BusinessException(ErrorCode.FILE_TOO_LARGE);
        }
        return new UploadResponse(fileStorage.store(file, KEY_PREFIX));
    }

    public List<UploadResponse> uploadAll(List<MultipartFile> files) {
        if (files == null || files.isEmpty()) {
            throw new BusinessException(ErrorCode.EMPTY_FILE);
        }
        if (files.size() > MAX_FILES) {
            throw new BusinessException(ErrorCode.TOO_MANY_FILES);
        }
        return files.stream().map(this::upload).toList();
    }
}
