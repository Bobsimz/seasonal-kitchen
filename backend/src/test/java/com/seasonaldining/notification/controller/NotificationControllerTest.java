package com.seasonaldining.notification.controller;

import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.notification.entity.Notification;
import com.seasonaldining.notification.repository.NotificationRepository;
import com.seasonaldining.support.UserDataCleaner;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class NotificationControllerTest {
    @Autowired MockMvc mvc;
    @Autowired JwtTokenProvider jwt;
    @Autowired NotificationRepository notifications;
    @Autowired UserRepository users;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach void setUp() { UserDataCleaner.clean(jdbc); }

    @Test void readsOwnNotifications() throws Exception {
        User user = users.save(new User("notice@example.com", "알림", null, "ACTIVE"));
        notifications.save(new Notification(user.getId(), "PRICE_DROP", "가격 하락", "무 가격이 내려갔습니다."));
        mvc.perform(get("/api/v1/notifications").header("Authorization", token(user)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items.length()").value(1))
                .andExpect(jsonPath("$.data.items[0].type").value("PRICE_DROP"))
                .andExpect(jsonPath("$.data.items[0].category").value("INGREDIENT"))
                .andExpect(jsonPath("$.data.items[0].subtitle").value("무 가격이 내려갔습니다."))
                .andExpect(jsonPath("$.data.items[0].icon").value("price-down"))
                .andExpect(jsonPath("$.data.items[0].severity").value("SUCCESS"))
                .andExpect(jsonPath("$.data.items[0].relativeTime").isNotEmpty())
                .andExpect(jsonPath("$.data.items[0].actionTargetType").value("INGREDIENT"))
                .andExpect(jsonPath("$.data.tabCounts.total").value(1))
                .andExpect(jsonPath("$.data.tabCounts.ingredient").value(1));
    }

    @Test void tabCountsMatchNotificationCategories() throws Exception {
        User user = users.save(new User("tabs@example.com", "탭", null, "ACTIVE"));
        notifications.save(new Notification(user.getId(), "PRICE_DROP", "가격 하락", "내용"));
        notifications.save(new Notification(user.getId(), "SEASON_START", "제철 시작", "내용"));
        notifications.save(new Notification(user.getId(), "RECIPE_RECOMMENDATION", "레시피 추천", "내용"));
        mvc.perform(get("/api/v1/notifications").header("Authorization", token(user)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.tabCounts.total").value(3))
                .andExpect(jsonPath("$.data.tabCounts.ingredient").value(2))
                .andExpect(jsonPath("$.data.tabCounts.recipe").value(1));
    }

    @Test void marksOneAndAllNotificationsAsRead() throws Exception {
        User user = users.save(new User("read@example.com", "읽음", null, "ACTIVE"));
        Notification first = notifications.save(new Notification(user.getId(), "PRICE_DROP", "첫 알림", "내용"));
        notifications.save(new Notification(user.getId(), "SEASON_START", "두번째 알림", "내용"));
        mvc.perform(patch("/api/v1/notifications/{id}/read", first.getId()).header("Authorization", token(user)))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.readAt").isNotEmpty());
        mvc.perform(patch("/api/v1/notifications/read-all").header("Authorization", token(user)))
                .andExpect(status().isOk());
        mvc.perform(get("/api/v1/notifications").header("Authorization", token(user)))
                .andExpect(jsonPath("$.data.items[0].readAt").isNotEmpty())
                .andExpect(jsonPath("$.data.items[1].readAt").isNotEmpty());
    }

    @Test void readAllOnlyAffectsCurrentUser() throws Exception {
        User user = users.save(new User("read-all@example.com", "읽음전체", null, "ACTIVE"));
        User other = users.save(new User("other-read-all@example.com", "다른읽음", null, "ACTIVE"));
        notifications.save(new Notification(user.getId(), "PRICE_DROP", "내 알림", "내용"));
        notifications.save(new Notification(other.getId(), "PRICE_DROP", "타인 알림", "내용"));

        mvc.perform(patch("/api/v1/notifications/read-all").header("Authorization", token(user)))
                .andExpect(status().isOk());

        mvc.perform(get("/api/v1/notifications").header("Authorization", token(other)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.items[0].readAt").isEmpty());
    }

    @Test void cannotReadAnotherUsersNotification() throws Exception {
        User owner = users.save(new User("owner-notice@example.com", "주인", null, "ACTIVE"));
        User other = users.save(new User("other-notice@example.com", "타인", null, "ACTIVE"));
        Notification notification = notifications.save(new Notification(owner.getId(), "PRICE_DROP", "알림", "내용"));
        mvc.perform(patch("/api/v1/notifications/{id}/read", notification.getId()).header("Authorization", token(other)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error.code").value("NOTIFICATION_NOT_FOUND"));
    }

    private String token(User user) { return "Bearer " + jwt.createAccessToken(user.getId()); }
}
