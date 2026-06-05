package com.seasonaldining.store.repository;

import com.seasonaldining.store.entity.StoreOffer;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface StoreOfferRepository extends JpaRepository<StoreOffer, Long> {
    List<StoreOffer> findByIngredientIdOrderByPriceAsc(Long ingredientId);
    long countByIngredientId(Long ingredientId);
}
