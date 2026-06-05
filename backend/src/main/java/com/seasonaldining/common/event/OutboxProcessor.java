package com.seasonaldining.common.event;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class OutboxProcessor {
    private final OutboxEventRepository repository;

    public OutboxProcessor(OutboxEventRepository repository) {
        this.repository = repository;
    }

    @Transactional
    public int processPending() {
        var events = repository.findTop100ByStatusOrderByIdAsc(OutboxEvent.STATUS_PENDING);
        events.forEach(OutboxEvent::markProcessed);
        return events.size();
    }
}
