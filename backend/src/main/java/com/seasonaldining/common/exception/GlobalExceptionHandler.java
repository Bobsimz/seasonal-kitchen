package com.seasonaldining.common.exception;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.response.ErrorResponse;
import com.seasonaldining.common.response.FieldErrorResponse;
import jakarta.validation.ConstraintViolationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.List;

@RestControllerAdvice
public class GlobalExceptionHandler {
    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(BusinessException ex) {
        ErrorCode errorCode = ex.getErrorCode();
        return ResponseEntity.status(errorCode.status())
                .body(ApiResponse.failure(new ErrorResponse(errorCode.code(), errorCode.message(), List.of()), traceId()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleMethodArgumentNotValidException(MethodArgumentNotValidException ex) {
        List<FieldErrorResponse> fieldErrors = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(this::toFieldErrorResponse)
                .toList();

        return ResponseEntity.status(ErrorCode.COMMON_VALIDATION_FAILED.status())
                .body(ApiResponse.failure(
                        new ErrorResponse(
                                ErrorCode.COMMON_VALIDATION_FAILED.code(),
                                ErrorCode.COMMON_VALIDATION_FAILED.message(),
                                fieldErrors
                        ),
                        traceId()
                ));
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ApiResponse<Void>> handleMissingServletRequestParameterException(
            MissingServletRequestParameterException ex
    ) {
        FieldErrorResponse fieldError = new FieldErrorResponse(ex.getParameterName(), ex.getMessage(), null);

        return ResponseEntity.status(ErrorCode.COMMON_INVALID_REQUEST.status())
                .body(ApiResponse.failure(
                        new ErrorResponse(
                                ErrorCode.COMMON_INVALID_REQUEST.code(),
                                ErrorCode.COMMON_INVALID_REQUEST.message(),
                                List.of(fieldError)
                        ),
                        traceId()
                ));
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiResponse<Void>> handleHttpMessageNotReadableException(HttpMessageNotReadableException ex) {
        return ResponseEntity.status(ErrorCode.COMMON_INVALID_REQUEST.status())
                .body(ApiResponse.failure(
                        new ErrorResponse(
                                ErrorCode.COMMON_INVALID_REQUEST.code(),
                                ErrorCode.COMMON_INVALID_REQUEST.message(),
                                List.of()
                        ),
                        traceId()
                ));
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleConstraintViolationException(ConstraintViolationException ex) {
        List<FieldErrorResponse> fieldErrors = ex.getConstraintViolations().stream()
                .map(v -> new FieldErrorResponse(v.getPropertyPath().toString(), v.getMessage(), v.getInvalidValue()))
                .toList();

        return ResponseEntity.status(ErrorCode.COMMON_VALIDATION_FAILED.status())
                .body(ApiResponse.failure(
                        new ErrorResponse(
                                ErrorCode.COMMON_VALIDATION_FAILED.code(),
                                ErrorCode.COMMON_VALIDATION_FAILED.message(),
                                fieldErrors
                        ),
                        traceId()
                ));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleException(Exception ex) {
        log.error("Unhandled exception", ex);
        return ResponseEntity.status(ErrorCode.COMMON_INTERNAL_ERROR.status())
                .body(ApiResponse.failure(
                        new ErrorResponse(
                                ErrorCode.COMMON_INTERNAL_ERROR.code(),
                                ErrorCode.COMMON_INTERNAL_ERROR.message(),
                                List.of()
                        ),
                        traceId()
                ));
    }

    private FieldErrorResponse toFieldErrorResponse(FieldError fieldError) {
        return new FieldErrorResponse(fieldError.getField(), fieldError.getDefaultMessage(), fieldError.getRejectedValue());
    }

    private String traceId() {
        return MDC.get("traceId");
    }
}
