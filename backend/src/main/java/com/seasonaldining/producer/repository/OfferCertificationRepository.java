package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.OfferCertification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OfferCertificationRepository extends JpaRepository<OfferCertification, Long> {
    List<OfferCertification> findByOfferIdOrderByIdAsc(Long offerId);
    List<OfferCertification> findByOfferIdInOrderByIdAsc(List<Long> offerIds);
    void deleteByOfferId(Long offerId);
}
