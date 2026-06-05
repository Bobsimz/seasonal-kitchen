package com.seasonaldining.analytics.service;

import com.seasonaldining.analytics.dto.request.CreateUserEventRequest;
import com.seasonaldining.analytics.dto.response.UserEventResponse;
import com.seasonaldining.analytics.entity.UserEvent;
import com.seasonaldining.analytics.repository.UserEventRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserEventService {
    private final UserEventRepository repository;

    public UserEventService(UserEventRepository repository) {
        this.repository = repository;
    }

    @Transactional
    public UserEventResponse create(Long userId, CreateUserEventRequest request) {
        UserEvent event = repository.save(new UserEvent(
                userId,
                request.eventType(),
                request.targetType(),
                request.targetId(),
                request.metadataJson()
        ));
        return new UserEventResponse(event.getId(), event.getEventType(), event.getTargetType(), event.getTargetId(), event.getCreatedAt());
    }
}
