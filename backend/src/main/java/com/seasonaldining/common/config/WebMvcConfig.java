package com.seasonaldining.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

/**
 * 로컬 업로드 파일 정적 서빙: {@code GET /uploads/**} → {@code app.uploads.dir} 디렉터리.
 * (S3 사용 시에는 S3가 직접 서빙하므로 이 핸들러는 무해하게 비어있게 됨)
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    private final String uploadsDir;

    public WebMvcConfig(@Value("${app.uploads.dir:uploads}") String uploadsDir) {
        this.uploadsDir = uploadsDir;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String location = Paths.get(uploadsDir).toAbsolutePath().normalize().toUri().toString(); // file:/.../uploads/
        registry.addResourceHandler("/uploads/**").addResourceLocations(location);
    }
}
