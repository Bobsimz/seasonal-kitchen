package com.seasonaldining.producer.repository;

import com.seasonaldining.producer.entity.ProducerOffer;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProducerOfferRepository extends JpaRepository<ProducerOffer, Long> {
    List<ProducerOffer> findByProducerIdOrderByPriceAsc(Long producerId);
    List<ProducerOffer> findByIngredientNameOrderByPriceAsc(String ingredientName);
    List<ProducerOffer> findByIngredientIdOrderByPriceAsc(Long ingredientId);
}
