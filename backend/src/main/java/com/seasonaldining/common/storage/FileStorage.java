package com.seasonaldining.common.storage;

import org.springframework.web.multipart.MultipartFile;

/**
 * 파일 저장 추상화 — 로컬/S3 교체 지점.
 * 구현체는 파일을 저장하고 <b>공개 접근 가능한 URL</b>을 반환한다.
 * 기본 구현은 {@link LocalFileStorage}이며, S3 등으로 교체하려면 같은 인터페이스로 새 구현 빈을 제공하면 된다
 * (예: {@code @ConditionalOnProperty(name="app.uploads.storage", havingValue="s3")}).
 */
public interface FileStorage {
    /**
     * 파일을 저장하고 접근 URL을 반환한다.
     * @param file        업로드 파일(검증은 호출 측에서 끝난 상태)
     * @param keyPrefix   저장 경로/키 접두사(예: "images")
     * @return 공개 접근 URL
     */
    String store(MultipartFile file, String keyPrefix);
}
