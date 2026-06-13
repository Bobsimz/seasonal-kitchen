package com.seasonaldining.producer.dto;

import com.seasonaldining.producer.dto.request.CreateOfferRequest;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

/** certifications·storageMethod 는 선택 항목 — 비어 있거나 비어 있는 문자열/널이어도 유효하다(프론트 오퍼 폼 미전송). */
class CreateOfferRequestValidationTest {

    private static ValidatorFactory factory;
    private static Validator validator;

    @BeforeAll static void init() { factory = Validation.buildDefaultValidatorFactory(); validator = factory.getValidator(); }
    @AfterAll static void close() { factory.close(); }

    private CreateOfferRequest base(List<String> certifications, String storageMethod) {
        return new CreateOfferRequest(
                null, "봄동", new BigDecimal("4500"), "봉", "당일수확",
                null, null, null, null, null, null,
                certifications, 120, storageMethod, null, null, null, null, null);
    }

    @Test
    void valid_whenCertificationsAndStorageMethodPresent() {
        Set<ConstraintViolation<CreateOfferRequest>> v =
                validator.validate(base(List.of("무농약"), "냉장 보관"));
        assertThat(v).isEmpty();
    }

    @Test
    void valid_whenCertificationsEmpty() {
        Set<ConstraintViolation<CreateOfferRequest>> v =
                validator.validate(base(List.of(), "냉장 보관"));
        assertThat(v).noneMatch(c -> c.getPropertyPath().toString().equals("certifications"));
    }

    @Test
    void valid_whenStorageMethodBlankOrNull() {
        Set<ConstraintViolation<CreateOfferRequest>> blank =
                validator.validate(base(List.of("무농약"), "  "));
        assertThat(blank).noneMatch(c -> c.getPropertyPath().toString().equals("storageMethod"));

        Set<ConstraintViolation<CreateOfferRequest>> nullValue =
                validator.validate(base(List.of("무농약"), null));
        assertThat(nullValue).noneMatch(c -> c.getPropertyPath().toString().equals("storageMethod"));
    }
}
