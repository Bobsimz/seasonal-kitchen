package com.seasonaldining.notification.repository;

import com.seasonaldining.notification.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByUserIdOrderByIdDesc(Long userId);
    Optional<Notification> findByIdAndUserId(Long id, Long userId);
    List<Notification> findByUserIdAndReadAtIsNull(Long userId);
}
