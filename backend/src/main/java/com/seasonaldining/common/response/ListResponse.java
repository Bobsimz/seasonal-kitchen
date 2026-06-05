package com.seasonaldining.common.response;

import java.util.List;

public record ListResponse<T>(
        List<T> items,
        int page,
        int size,
        long totalElements,
        boolean hasNext
) {
    public ListResponse {
        items = items == null ? List.of() : List.copyOf(items);
    }
}
