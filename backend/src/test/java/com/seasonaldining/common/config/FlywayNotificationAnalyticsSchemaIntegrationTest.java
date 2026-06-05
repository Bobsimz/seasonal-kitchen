package com.seasonaldining.common.config;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Testcontainers
class FlywayNotificationAnalyticsSchemaIntegrationTest {

    @Container
    static final PostgreSQLContainer<?> DB = new PostgreSQLContainer<>("postgres:16")
            .withDatabaseName("test")
            .withUsername("seasonal")
            .withPassword("seasonal");

    @DynamicPropertySource
    static void dataSource(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", DB::getJdbcUrl);
        registry.add("spring.datasource.username", DB::getUsername);
        registry.add("spring.datasource.password", DB::getPassword);
    }

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void createsNotificationAnalyticsTables() {
        for (String table : new String[]{"notifications", "user_events", "outbox_events"}) {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = ?",
                    Integer.class,
                    table
            );
            assertThat(count).isEqualTo(1);
        }
    }
}
