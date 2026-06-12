package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.OfferOption;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OfferOptionRepository extends JpaRepository<OfferOption, Long> {
    List<OfferOption> findByOfferIdOrderBySortOrderAsc(Long offerId);
    List<OfferOption> findByOfferIdInOrderBySortOrderAsc(List<Long> offerIds);
    void deleteByOfferId(Long offerId);
}
