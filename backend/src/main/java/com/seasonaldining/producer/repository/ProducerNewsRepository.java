package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.ProducerNews;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProducerNewsRepository extends JpaRepository<ProducerNews, Long> {
    List<ProducerNews> findByProducerIdOrderByPostedAtDesc(Long producerId);
}
