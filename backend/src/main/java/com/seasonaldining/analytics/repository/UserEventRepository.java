package com.seasonaldining.analytics.repository;

import com.seasonaldining.analytics.entity.UserEvent;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserEventRepository extends JpaRepository<UserEvent, Long> {
}
