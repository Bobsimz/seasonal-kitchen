package com.seasonaldining.common.exception;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
class TestExceptionController {
    @PostMapping("/test/validation")
    public String validation(@Valid @RequestBody ValidationRequest request) {
        return "ok";
    }

    @GetMapping("/test/business")
    public String business() {
        throw new BusinessException(ErrorCode.INGREDIENT_NOT_FOUND);
    }

    @GetMapping("/test/internal")
    public String internal() {
        throw new IllegalStateException("boom");
    }

    record ValidationRequest(@NotBlank String name) {
    }
}

