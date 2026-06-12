package com.seasonaldining.user.repository;

import com.seasonaldining.user.entity.UserAddress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserAddressRepository extends JpaRepository<UserAddress, Long> {
    // 기본 배송지 먼저, 그다음 최신순
    List<UserAddress> findByUserIdOrderByIsDefaultDescIdDesc(Long userId);
    Optional<UserAddress> findByIdAndUserId(Long id, Long userId);
    boolean existsByUserId(Long userId);

    /** 해당 사용자의 모든 기본배송지 해제(새 기본 지정 전 호출). */
    @Modifying
    @Query("update UserAddress a set a.isDefault = false where a.userId = :userId and a.isDefault = true")
    void clearDefault(@Param("userId") Long userId);
}
