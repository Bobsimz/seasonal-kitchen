package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.OfferDetailSection;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OfferDetailSectionRepository extends JpaRepository<OfferDetailSection, Long> {
    List<OfferDetailSection> findByOfferIdOrderBySortOrderAsc(Long offerId);
    List<OfferDetailSection> findByOfferIdInOrderBySortOrderAsc(List<Long> offerIds);
    void deleteByOfferId(Long offerId);
}
