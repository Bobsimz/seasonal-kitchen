package com.seasonaldining.infrastructure.storage;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.storage.FileStorage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

/**
 * S3 저장 — {@code app.uploads.storage=s3} 일 때 활성화(기본은 {@code LocalFileStorage}).
 * 파일을 버킷에 PutObject 하고 <b>공개 접근 URL</b>({@code <public-base-url>/<key>})을 반환한다.
 * {@code public-base-url} 은 CloudFront 도메인을 가리킨다(영상/이미지는 브라우저가 이 URL로 직접 받는다).
 * 리전/자격증명은 {@code S3Client} 빈이 담당한다(SDK 기본 자격증명 체인).
 */
@Component
@ConditionalOnProperty(name = "app.uploads.storage", havingValue = "s3")
public class S3FileStorage implements FileStorage {

    private final S3Client s3Client;
    private final String bucket;
    private final String publicBaseUrl;   // 예: "https://d123.cloudfront.net" (끝 슬래시 제거)

    public S3FileStorage(S3Client s3Client,
                         @Value("${app.uploads.s3.bucket}") String bucket,
                         @Value("${app.uploads.public-base-url:}") String publicBaseUrl) {
        this.s3Client = s3Client;
        this.bucket = bucket;
        this.publicBaseUrl = publicBaseUrl == null ? "" : publicBaseUrl.replaceAll("/+$", "");
    }

    @Override
    public String store(MultipartFile file, String keyPrefix) {
        String ext = extensionOf(file.getOriginalFilename());
        String key = (keyPrefix == null || keyPrefix.isBlank() ? "" : keyPrefix.replaceAll("^/+|/+$", "") + "/")
                + UUID.randomUUID().toString().replace("-", "") + ext;
        try (InputStream in = file.getInputStream()) {
            s3Client.putObject(
                    PutObjectRequest.builder()
                            .bucket(bucket)
                            .key(key)
                            .contentType(file.getContentType())
                            .build(),
                    RequestBody.fromInputStream(in, file.getSize()));
        } catch (IOException e) {
            throw new BusinessException(ErrorCode.FILE_STORAGE_FAILED);
        }
        return publicBaseUrl + "/" + key;
    }

    private String extensionOf(String originalName) {
        String ext = StringUtils.getFilenameExtension(originalName);
        return (ext == null || ext.isBlank()) ? "" : "." + ext.toLowerCase();
    }
}
