package com.seasonaldining.notification.service;

import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.notification.repository.NotificationRepository;
import com.seasonaldining.price.entity.PriceAlert;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceAlertRepository;
import com.seasonaldining.support.UserDataCleaner;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
class PriceAlertNotificationJobTest {
    @Autowired PriceAlertNotificationJob job;
    @Autowired PriceAlertRepository alerts;
    @Autowired NotificationRepository notifications;
    @Autowired UserRepository users;
    @Autowired IngredientRepository ingredients;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach void setUp() {
        UserDataCleaner.clean(jdbc);
        ingredients.deleteAll();
    }

    @Test void createsNotificationWhenPriceMeetsTarget() {
        User user = users.save(new User("drop@example.com", "하락", null, "ACTIVE"));
        Ingredient ingredient = ingredients.save(new Ingredient("무", "채소", null, "1개", true));
        alerts.save(new PriceAlert(user.getId(), ingredient.getId(), new BigDecimal("2000"), true));
        PriceSnapshot snapshot = new PriceSnapshot(ingredient.getId(), "KAMIS", "AVERAGE", new BigDecimal("1800"), "1개", LocalDate.now());

        int created = job.createNotificationsFor(snapshot);

        assertThat(created).isEqualTo(1);
        assertThat(notifications.findByUserIdOrderByIdDesc(user.getId()))
                .singleElement()
                .satisfies(notification -> {
                    assertThat(notification.getType()).isEqualTo("PRICE_DROP");
                    assertThat(notification.getTitle()).contains("무");
                });
    }

    @Test void skipsInactiveOrUnmatchedAlerts() {
        User user = users.save(new User("skip@example.com", "스킵", null, "ACTIVE"));
        Ingredient ingredient = ingredients.save(new Ingredient("양파", "채소", null, "1망", true));
        alerts.save(new PriceAlert(user.getId(), ingredient.getId(), new BigDecimal("1000"), true));
        alerts.save(new PriceAlert(user.getId(), ingredient.getId(), new BigDecimal("3000"), false));
        PriceSnapshot snapshot = new PriceSnapshot(ingredient.getId(), "KAMIS", "AVERAGE", new BigDecimal("1500"), "1망", LocalDate.now());

        int created = job.createNotificationsFor(snapshot);

        assertThat(created).isZero();
        assertThat(notifications.findAll()).isEmpty();
    }
}
