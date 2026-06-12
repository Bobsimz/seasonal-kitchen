package com.seasonaldining.user.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.user.dto.request.CreateAddressRequest;
import com.seasonaldining.user.dto.request.UpdateAddressRequest;
import com.seasonaldining.user.dto.response.AddressResponse;
import com.seasonaldining.user.service.AddressService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/** 배송지(주소록) API. 모두 인증 필요. */
@RestController
@RequestMapping("/api/v1/users/me/addresses")
@Tag(name = "02. Users", description = "사용자 API")
@Validated
public class AddressController {

    private final AddressService addressService;
    private final CurrentUserProvider currentUserProvider;

    public AddressController(AddressService addressService, CurrentUserProvider currentUserProvider) {
        this.addressService = addressService;
        this.currentUserProvider = currentUserProvider;
    }

    @GetMapping
    @Operation(summary = "내 배송지 목록", description = "기본 배송지 우선, 최신순.")
    public ApiResponse<List<AddressResponse>> getMyAddresses() {
        return ApiResponse.success(addressService.getMyAddresses(currentUserProvider.getCurrentUserId()), null);
    }

    @PostMapping
    @Operation(summary = "배송지 등록", description = "첫 배송지는 자동 기본. isDefault=true면 기존 기본 배송지를 해제하고 지정.")
    public ApiResponse<AddressResponse> create(@Valid @RequestBody CreateAddressRequest request) {
        return ApiResponse.success(addressService.create(currentUserProvider.getCurrentUserId(), request), null);
    }

    @PatchMapping("/{id}")
    @Operation(summary = "배송지 수정", description = "부분 수정(null=미수정). 본인 배송지만. 없으면 ADDRESS_NOT_FOUND.")
    public ApiResponse<AddressResponse> update(@PathVariable @Positive Long id,
                                               @Valid @RequestBody UpdateAddressRequest request) {
        return ApiResponse.success(addressService.update(currentUserProvider.getCurrentUserId(), id, request), null);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "배송지 삭제", description = "본인 배송지만. 없으면 ADDRESS_NOT_FOUND.")
    public ApiResponse<Void> delete(@PathVariable @Positive Long id) {
        addressService.delete(currentUserProvider.getCurrentUserId(), id);
        return ApiResponse.success(null, null);
    }
}
