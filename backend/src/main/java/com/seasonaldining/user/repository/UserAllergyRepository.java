package com.seasonaldining.user.repository;

import com.seasonaldining.user.entity.UserAllergy;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserAllergyRepository extends JpaRepository<UserAllergy, Long> {

    List<UserAllergy> findByUserIdOrderByAllergyCodeAsc(Long userId);

    void deleteByUserId(Long userId);
}
