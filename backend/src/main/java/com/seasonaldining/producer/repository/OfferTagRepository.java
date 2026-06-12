package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.OfferTag;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OfferTagRepository extends JpaRepository<OfferTag, Long> {
    List<OfferTag> findByOfferIdOrderByIdAsc(Long offerId);
    List<OfferTag> findByOfferIdInOrderByIdAsc(List<Long> offerIds);
    void deleteByOfferId(Long offerId);
}
