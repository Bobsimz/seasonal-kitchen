package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.ProducerReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface ProducerReviewRepository extends JpaRepository<ProducerReview, Long> {
    List<ProducerReview> findByProducerIdOrderByCreatedAtDesc(Long producerId);
    List<ProducerReview> findByUserIdOrderByCreatedAtDesc(Long userId);

    long countByProducerId(Long producerId);

    long countByUserId(Long userId);

    @Query("select avg(r.rating) from ProducerReview r where r.producerId = :producerId")
    Double avgRatingByProducerId(@Param("producerId") Long producerId);
}
