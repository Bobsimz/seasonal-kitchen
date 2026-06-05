package com.seasonaldining.common.security;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.response.ErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;

@Component
public class RestAuthenticationEntryPoint implements AuthenticationEntryPoint {

    private final ObjectMapper objectMapper;

    public RestAuthenticationEntryPoint(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public void commence(
            HttpServletRequest request,
            HttpServletResponse response,
            AuthenticationException authException
    ) throws IOException {
        write(response, ErrorCode.COMMON_UNAUTHORIZED);
    }

    public void commenceInvalidToken(HttpServletRequest request, HttpServletResponse response) throws IOException {
        write(response, ErrorCode.AUTH_INVALID_TOKEN);
    }

    private void write(HttpServletResponse response, ErrorCode errorCode) throws IOException {
        response.setStatus(errorCode.status().value());
        response.setContentType("application/json");
        objectMapper.writeValue(
                response.getOutputStream(),
                ApiResponse.failure(new ErrorResponse(errorCode.code(), errorCode.message(), List.of()), null)
        );
    }
}
