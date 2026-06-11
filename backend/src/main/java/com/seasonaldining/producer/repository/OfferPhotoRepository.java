package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.OfferPhoto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OfferPhotoRepository extends JpaRepository<OfferPhoto, Long> {
    List<OfferPhoto> findByOfferIdOrderBySortOrderAsc(Long offerId);
    List<OfferPhoto> findByOfferIdInOrderBySortOrderAsc(List<Long> offerIds);
}
