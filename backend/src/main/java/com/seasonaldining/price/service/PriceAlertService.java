package com.seasonaldining.price.service;
import com.seasonaldining.common.exception.*; import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository; import com.seasonaldining.price.dto.request.*;
import com.seasonaldining.price.dto.response.PriceAlertResponse; import com.seasonaldining.price.entity.PriceAlert;
import com.seasonaldining.price.repository.PriceAlertRepository; import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; import java.util.List;
@Service public class PriceAlertService {
 private final PriceAlertRepository repository; private final IngredientRepository ingredientRepository;
 public PriceAlertService(PriceAlertRepository repository,IngredientRepository ingredientRepository){this.repository=repository;this.ingredientRepository=ingredientRepository;}
 @Transactional(readOnly=true) public List<PriceAlertResponse> getAlerts(Long userId){return repository.findByUserIdOrderByIdDesc(userId).stream().map(this::toResponse).toList();}
 @Transactional public PriceAlertResponse create(Long userId,CreatePriceAlertRequest r){ingredient(r.ingredientId());return toResponse(repository.save(new PriceAlert(userId,r.ingredientId(),r.targetPrice(),true)));}
 @Transactional public PriceAlertResponse update(Long userId,Long id,UpdatePriceAlertRequest r){PriceAlert a=alert(id,userId);a.update(r.targetPrice(),r.active());return toResponse(a);}
 @Transactional public void delete(Long userId,Long id){repository.delete(alert(id,userId));}
 private PriceAlert alert(Long id,Long userId){return repository.findByIdAndUserId(id,userId).orElseThrow(()->new BusinessException(ErrorCode.PRICE_ALERT_NOT_FOUND));}
 private Ingredient ingredient(Long id){return ingredientRepository.findByIdAndActiveTrue(id).orElseThrow(()->new BusinessException(ErrorCode.INGREDIENT_NOT_FOUND));}
 private PriceAlertResponse toResponse(PriceAlert a){return new PriceAlertResponse(a.getId(),a.getIngredientId(),ingredient(a.getIngredientId()).getName(),a.getTargetPrice(),a.isActive());}
}
