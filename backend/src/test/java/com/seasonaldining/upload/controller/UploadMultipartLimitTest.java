package com.seasonaldining.upload.controller;

import com.seasonaldining.common.exception.GlobalExceptionHandler;
import com.seasonaldining.common.response.ApiResponse;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * 멀티파트 한도(spring.servlet.multipart.*) 초과는 컨트롤러 진입 전 MaxUploadSizeExceededException으로 터진다.
 * MockMvc는 실제 서블릿 멀티파트 리졸버 한도를 타지 않으므로, 핸들러 매핑을 단위 테스트로 직접 검증한다.
 */
class UploadMultipartLimitTest {

    private final GlobalExceptionHandler handler = new GlobalExceptionHandler();

    @Test
    void maxUploadSizeExceeded_mapsToFileTooLarge_413() {
        ResponseEntity<ApiResponse<Void>> response =
                handler.handleMaxUploadSizeExceeded(new MaxUploadSizeExceededException(512L));

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.PAYLOAD_TOO_LARGE); // 413
        ApiResponse<Void> body = response.getBody();
        assertThat(body).isNotNull();
        assertThat(body.success()).isFalse();
        assertThat(body.error().code()).isEqualTo("FILE_TOO_LARGE");
    }
}
