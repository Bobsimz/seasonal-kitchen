package com.seasonaldining.user.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.user.dto.request.CreateAddressRequest;
import com.seasonaldining.user.dto.request.UpdateAddressRequest;
import com.seasonaldining.user.dto.response.AddressResponse;
import com.seasonaldining.user.entity.UserAddress;
import com.seasonaldining.user.repository.UserAddressRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/** 배송지(주소록) — 사용자당 기본 배송지는 하나만 true 보장. */
@Service
public class AddressService {

    private final UserAddressRepository addressRepository;

    public AddressService(UserAddressRepository addressRepository) {
        this.addressRepository = addressRepository;
    }

    @Transactional(readOnly = true)
    public List<AddressResponse> getMyAddresses(Long userId) {
        return addressRepository.findByUserIdOrderByIsDefaultDescIdDesc(userId).stream()
                .map(this::toResponse).toList();
    }

    @Transactional
    public AddressResponse create(Long userId, CreateAddressRequest req) {
        // 첫 배송지는 자동 기본. isDefault=true면 기존 기본 해제.
        boolean first = !addressRepository.existsByUserId(userId);
        boolean makeDefault = first || Boolean.TRUE.equals(req.isDefault());
        if (makeDefault) addressRepository.clearDefault(userId);
        UserAddress saved = addressRepository.save(new UserAddress(
                userId, req.recipientName(), req.phone(), req.zipCode(),
                req.address1(), req.address2(), makeDefault));
        return toResponse(saved);
    }

    @Transactional
    public AddressResponse update(Long userId, Long addressId, UpdateAddressRequest req) {
        UserAddress a = addressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ADDRESS_NOT_FOUND));
        a.changeRecipientName(req.recipientName());
        a.changePhone(req.phone());
        a.changeZipCode(req.zipCode());
        a.changeAddress1(req.address1());
        a.changeAddress2(req.address2());
        // 정책: 기본 배송지는 "항상 1개". isDefault=true만 의미 있음(기존 기본 해제 후 이 주소를 기본으로).
        // 기본 해제(false)는 단독으로 허용하지 않는다 — 다른 주소를 기본 지정하거나 삭제로 처리.
        if (Boolean.TRUE.equals(req.isDefault()) && !a.isDefault()) {
            addressRepository.clearDefault(userId);
            a.markDefault(true);
        }
        return toResponse(addressRepository.save(a));
    }

    @Transactional
    public void delete(Long userId, Long addressId) {
        UserAddress a = addressRepository.findByIdAndUserId(addressId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ADDRESS_NOT_FOUND));
        boolean wasDefault = a.isDefault();
        addressRepository.delete(a);
        // 기본 배송지를 삭제했고 다른 주소가 남아 있으면 가장 최근 주소를 기본으로 승격(항상 1개 보장)
        if (wasDefault) {
            addressRepository.flush();
            addressRepository.findByUserIdOrderByIsDefaultDescIdDesc(userId).stream().findFirst()
                    .ifPresent(next -> next.markDefault(true));
        }
    }

    private AddressResponse toResponse(UserAddress a) {
        return new AddressResponse(a.getId(), a.getRecipientName(), a.getPhone(), a.getZipCode(),
                a.getAddress1(), a.getAddress2(), a.isDefault());
    }
}
