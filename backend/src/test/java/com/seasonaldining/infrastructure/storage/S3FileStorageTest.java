package com.seasonaldining.infrastructure.storage;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.mock.web.MockMultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectResponse;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class S3FileStorageTest {

    @Test
    void store_uploadsObjectToBucketAndReturnsCdnUrl() {
        S3Client s3 = mock(S3Client.class);
        when(s3.putObject(any(PutObjectRequest.class), any(RequestBody.class)))
                .thenReturn(PutObjectResponse.builder().build());
        S3FileStorage storage = new S3FileStorage(s3, "my-bucket", "https://cdn.example.com");
        MockMultipartFile file = new MockMultipartFile(
                "file", "clip.MP4", "video/mp4", "bytes".getBytes());

        String url = storage.store(file, "reels");

        ArgumentCaptor<PutObjectRequest> captor = ArgumentCaptor.forClass(PutObjectRequest.class);
        verify(s3).putObject(captor.capture(), any(RequestBody.class));
        PutObjectRequest req = captor.getValue();

        // 버킷/키/콘텐츠타입이 올바르게 전달되어야 한다 (키: <prefix>/<uuid32>.<소문자ext>)
        assertThat(req.bucket()).isEqualTo("my-bucket");
        assertThat(req.key()).matches("reels/[0-9a-f]{32}\\.mp4");
        assertThat(req.contentType()).isEqualTo("video/mp4");
        // 반환 URL = CDN base + "/" + key (영상은 브라우저가 이 URL로 직접 받음)
        assertThat(url).isEqualTo("https://cdn.example.com/" + req.key());
    }

    @Test
    void store_trimsTrailingSlashOnBaseUrlAndLeadingSlashOnPrefix() {
        S3Client s3 = mock(S3Client.class);
        when(s3.putObject(any(PutObjectRequest.class), any(RequestBody.class)))
                .thenReturn(PutObjectResponse.builder().build());
        S3FileStorage storage = new S3FileStorage(s3, "my-bucket", "https://cdn.example.com/");
        MockMultipartFile file = new MockMultipartFile(
                "file", "thumb.png", "image/png", "bytes".getBytes());

        String url = storage.store(file, "/images/");

        ArgumentCaptor<PutObjectRequest> captor = ArgumentCaptor.forClass(PutObjectRequest.class);
        verify(s3).putObject(captor.capture(), any(RequestBody.class));
        PutObjectRequest req = captor.getValue();

        assertThat(req.key()).matches("images/[0-9a-f]{32}\\.png");
        // base URL 끝 슬래시는 중복되지 않아야 한다
        assertThat(url).isEqualTo("https://cdn.example.com/" + req.key());
    }
}
