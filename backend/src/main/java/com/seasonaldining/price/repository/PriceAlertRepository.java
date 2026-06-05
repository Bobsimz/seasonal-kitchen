package com.seasonaldining.price.repository;
import com.seasonaldining.price.entity.PriceAlert;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List; import java.util.Optional;
public interface PriceAlertRepository extends JpaRepository<PriceAlert,Long>{
    List<PriceAlert> findByUserIdOrderByIdDesc(Long userId);
    Optional<PriceAlert> findByIdAndUserId(Long id,Long userId);
    List<PriceAlert> findByActiveTrueAndIngredientId(Long ingredientId);
    long countByUserIdAndActiveTrue(Long userId);
}
