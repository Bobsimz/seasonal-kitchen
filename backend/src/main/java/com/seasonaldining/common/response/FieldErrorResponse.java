package com.seasonaldining.common.response;

public record FieldErrorResponse(
        String field,
        String message,
        Object rejectedValue
) {
}

