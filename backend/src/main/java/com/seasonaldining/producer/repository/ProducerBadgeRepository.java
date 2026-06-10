package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.ProducerBadge;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProducerBadgeRepository extends JpaRepository<ProducerBadge, Long> {
    List<ProducerBadge> findByProducerId(Long producerId);
}
