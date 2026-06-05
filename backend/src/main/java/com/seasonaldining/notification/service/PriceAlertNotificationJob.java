package com.seasonaldining.notification.service;

import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.notification.entity.Notification;
import com.seasonaldining.notification.repository.NotificationRepository;
import com.seasonaldining.price.entity.PriceAlert;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceAlertRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class PriceAlertNotificationJob {
    private final PriceAlertRepository alertRepository;
    private final IngredientRepository ingredientRepository;
    private final NotificationRepository notificationRepository;

    public PriceAlertNotificationJob(
            PriceAlertRepository alertRepository,
            IngredientRepository ingredientRepository,
            NotificationRepository notificationRepository
    ) {
        this.alertRepository = alertRepository;
        this.ingredientRepository = ingredientRepository;
        this.notificationRepository = notificationRepository;
    }

    @Transactional
    public int createNotificationsFor(PriceSnapshot snapshot) {
        Ingredient ingredient = ingredientRepository.findById(snapshot.getIngredientId()).orElse(null);
        String ingredientName = ingredient == null ? "식재료" : ingredient.getName();
        List<PriceAlert> matchedAlerts = alertRepository.findByActiveTrueAndIngredientId(snapshot.getIngredientId()).stream()
                .filter(alert -> snapshot.getPrice().compareTo(alert.getTargetPrice()) <= 0)
                .toList();

        matchedAlerts.forEach(alert -> notificationRepository.save(new Notification(
                alert.getUserId(),
                "PRICE_DROP",
                ingredientName + " 가격 알림",
                ingredientName + " 가격이 설정한 목표가 이하로 내려갔습니다."
        )));
        return matchedAlerts.size();
    }
}
