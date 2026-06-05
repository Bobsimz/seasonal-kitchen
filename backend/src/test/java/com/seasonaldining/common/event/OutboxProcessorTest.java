package com.seasonaldining.common.event;

import com.seasonaldining.support.UserDataCleaner;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
class OutboxProcessorTest {
    @Autowired OutboxEventRepository repository;
    @Autowired OutboxProcessor processor;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach void setUp() { UserDataCleaner.clean(jdbc); }

    @Test void processesPendingEvents() {
        repository.save(new OutboxEvent("PRICE_UPDATED", "{\"ingredientId\":1}"));
        repository.save(new OutboxEvent("NOTIFICATION_CREATED", "{\"notificationId\":1}"));

        int processed = processor.processPending();

        assertThat(processed).isEqualTo(2);
        assertThat(repository.findTop100ByStatusOrderByIdAsc(OutboxEvent.STATUS_PENDING)).isEmpty();
        assertThat(repository.findAll())
                .allSatisfy(event -> {
                    assertThat(event.getStatus()).isEqualTo(OutboxEvent.STATUS_PROCESSED);
                    assertThat(event.getProcessedAt()).isNotNull();
                });
    }

    @Test void returnsZeroWhenNoPendingEvents() {
        assertThat(processor.processPending()).isZero();
    }
}
