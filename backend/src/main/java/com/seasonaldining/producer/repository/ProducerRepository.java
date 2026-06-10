package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.Producer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.Optional;

public interface ProducerRepository extends JpaRepository<Producer, Long>, JpaSpecificationExecutor<Producer> {
    boolean existsByUserId(Long userId);
    Optional<Producer> findByUserId(Long userId);
}
