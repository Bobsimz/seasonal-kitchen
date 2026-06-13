package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.Producer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface ProducerRepository extends JpaRepository<Producer, Long>, JpaSpecificationExecutor<Producer> {
    boolean existsByUserId(Long userId);
    Optional<Producer> findByUserId(Long userId);

    /** 필터 칩용 — 농가 지역 목록(가나다순). */
    @Query("select distinct p.region from Producer p order by p.region")
    List<String> findDistinctRegions();
}
