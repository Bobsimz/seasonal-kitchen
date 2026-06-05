package com.seasonaldining.common.response;

import java.util.List;

public record ErrorResponse(
        String code,
        String message,
        List<FieldErrorResponse> fieldErrors
) {
    public ErrorResponse {
        fieldErrors = fieldErrors == null ? List.of() : List.copyOf(fieldErrors);
    }
}

