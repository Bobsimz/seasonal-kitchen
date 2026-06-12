package com.seasonaldining.common.storage;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * 로컬 파일시스템 저장 — 기본 구현(app.uploads.storage 미설정 또는 "local").
 * 저장 위치: {@code app.uploads.dir}(기본 ./uploads). 접근 URL: {@code <public-base-url>/uploads/<key>}.
 * 정적 서빙은 {@code WebMvcConfig}의 {@code /uploads/**} 핸들러가 담당한다.
 */
@Component
@ConditionalOnProperty(name = "app.uploads.storage", havingValue = "local", matchIfMissing = true)
public class LocalFileStorage implements FileStorage {

    private final Path baseDir;
    private final String publicBaseUrl;   // 예: "" → 상대경로 /uploads/...  또는 "http://localhost:8080"

    public LocalFileStorage(@Value("${app.uploads.dir:uploads}") String dir,
                            @Value("${app.uploads.public-base-url:}") String publicBaseUrl) {
        this.baseDir = Paths.get(dir).toAbsolutePath().normalize();
        this.publicBaseUrl = publicBaseUrl == null ? "" : publicBaseUrl.replaceAll("/+$", "");
    }

    @Override
    public String store(MultipartFile file, String keyPrefix) {
        String ext = extensionOf(file.getOriginalFilename());
        String key = (keyPrefix == null || keyPrefix.isBlank() ? "" : keyPrefix.replaceAll("^/+|/+$", "") + "/")
                + UUID.randomUUID().toString().replace("-", "") + ext;
        try {
            Path target = baseDir.resolve(key).normalize();
            if (!target.startsWith(baseDir)) {          // 경로 탈출 방지
                throw new BusinessException(ErrorCode.FILE_STORAGE_FAILED);
            }
            Files.createDirectories(target.getParent());
            try (InputStream in = file.getInputStream()) {
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (IOException e) {
            throw new BusinessException(ErrorCode.FILE_STORAGE_FAILED);
        }
        return publicBaseUrl + "/uploads/" + key;
    }

    private String extensionOf(String originalName) {
        String ext = StringUtils.getFilenameExtension(originalName);
        return (ext == null || ext.isBlank()) ? "" : "." + ext.toLowerCase();
    }
}
