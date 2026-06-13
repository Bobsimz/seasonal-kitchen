package com.seasonaldining.infrastructure.storage;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;

/**
 * S3 클라이언트 빈 — {@code app.uploads.storage=s3} 일 때만 생성된다(로컬/테스트에선 미생성).
 * 리전은 {@code app.uploads.s3.region}(=AWS_REGION), 자격증명은 SDK 기본 자격증명 체인이
 * 컨테이너 환경변수({@code AWS_ACCESS_KEY_ID}/{@code AWS_SECRET_ACCESS_KEY})에서 읽는다.
 */
@Configuration
@ConditionalOnProperty(name = "app.uploads.storage", havingValue = "s3")
public class S3ClientConfig {

    @Bean
    S3Client s3Client(@Value("${app.uploads.s3.region}") String region) {
        return S3Client.builder()
                .region(Region.of(region))
                .build();
    }
}
