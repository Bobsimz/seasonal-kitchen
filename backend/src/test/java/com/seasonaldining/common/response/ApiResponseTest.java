package com.seasonaldining.common.response;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class ApiResponseTest {

    @Test
    void createsSuccessResponse() {
        ApiResponse<String> response = ApiResponse.success("ok", "trace-1");

        assertTrue(response.success());
        assertEquals("ok", response.data());
        assertNull(response.error());
        assertEquals("trace-1", response.traceId());
    }

    @Test
    void createsFailureResponse() {
        FieldErrorResponse fieldError = new FieldErrorResponse("name", "must not be blank", "");
        ErrorResponse error = new ErrorResponse("COMMON_VALIDATION_FAILED", "요청 값 검증에 실패했습니다.", List.of(fieldError));

        ApiResponse<Void> response = ApiResponse.failure(error, "trace-2");

        assertFalse(response.success());
        assertNull(response.data());
        assertEquals("COMMON_VALIDATION_FAILED", response.error().code());
        assertEquals("요청 값 검증에 실패했습니다.", response.error().message());
        assertEquals(1, response.error().fieldErrors().size());
        assertEquals("trace-2", response.traceId());
    }

    @Test
    void createsFieldErrorResponse() {
        FieldErrorResponse fieldError = new FieldErrorResponse("days", "must be greater than 0", 0);

        assertEquals("days", fieldError.field());
        assertEquals("must be greater than 0", fieldError.message());
        assertEquals(0, fieldError.rejectedValue());
    }

    @Test
    void copiesFieldErrorsAsImmutableList() {
        ErrorResponse error = new ErrorResponse("COMMON_INVALID_REQUEST", "잘못된 요청입니다.", null);

        assertTrue(error.fieldErrors().isEmpty());
        assertThrows(UnsupportedOperationException.class, () -> error.fieldErrors().add(
                new FieldErrorResponse("field", "message", "value")
        ));
    }
}

