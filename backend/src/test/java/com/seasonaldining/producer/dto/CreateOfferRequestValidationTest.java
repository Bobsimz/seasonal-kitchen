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

/** G8 — certifications(@NotEmpty)·storageMethod(@NotBlank) 필수 검증 (V26). */
class CreateOfferRequestValidationTest {

    private static ValidatorFactory factory;
    private static Validator validator;

    @BeforeAll static void init() { factory = Validation.buildDefaultValidatorFactory(); validator = factory.getValidator(); }
    @AfterAll static void close() { factory.close(); }

    private CreateOfferRequest base(List<String> certifications, String storageMethod) {
        return new CreateOfferRequest(
                null, "봄동", new BigDecimal("4500"), "봉", "당일수확",
                null, null, null, null, null, null,
                certifications, 120, storageMethod, null);
    }

    @Test
    void valid_whenCertificationsAndStorageMethodPresent() {
        Set<ConstraintViolation<CreateOfferRequest>> v =
                validator.validate(base(List.of("무농약"), "냉장 보관"));
        assertThat(v).isEmpty();
    }

    @Test
    void invalid_whenCertificationsEmpty() {
        Set<ConstraintViolation<CreateOfferRequest>> v =
                validator.validate(base(List.of(), "냉장 보관"));
        assertThat(v).anyMatch(c -> c.getPropertyPath().toString().equals("certifications"));
    }

    @Test
    void invalid_whenStorageMethodBlank() {
        Set<ConstraintViolation<CreateOfferRequest>> v =
                validator.validate(base(List.of("무농약"), "  "));
        assertThat(v).anyMatch(c -> c.getPropertyPath().toString().equals("storageMethod"));
    }
}
