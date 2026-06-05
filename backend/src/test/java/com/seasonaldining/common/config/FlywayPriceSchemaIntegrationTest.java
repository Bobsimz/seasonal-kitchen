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
class FlywayPriceSchemaIntegrationTest {

    @Container
    static final PostgreSQLContainer<?> POSTGRES = new PostgreSQLContainer<>("postgres:16")
            .withDatabaseName("seasonal_dining_test")
            .withUsername("seasonal")
            .withPassword("seasonal");

    @DynamicPropertySource
    static void configureDatasource(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", POSTGRES::getJdbcUrl);
        registry.add("spring.datasource.username", POSTGRES::getUsername);
        registry.add("spring.datasource.password", POSTGRES::getPassword);
        registry.add("spring.datasource.driver-class-name", POSTGRES::getDriverClassName);
        registry.add("spring.flyway.enabled", () -> true);
        registry.add("spring.jpa.hibernate.ddl-auto", () -> "none");
    }

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void flywayCreatesPriceSchema() {
        Integer migrationCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM flyway_schema_history WHERE version = '3'",
                Integer.class
        );
        Integer snapshotsTableExists = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'price_snapshots'",
                Integer.class
        );
        Integer forecastsTableExists = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'price_forecasts'",
                Integer.class
        );
        Integer ingredientObservedDateIndexExists = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM pg_indexes WHERE tablename = 'price_snapshots' AND indexname = 'idx_price_snapshots_ingredient_observed_date'",
                Integer.class
        );
        Integer sourceObservedDateIndexExists = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM pg_indexes WHERE tablename = 'price_snapshots' AND indexname = 'idx_price_snapshots_source_observed_date'",
                Integer.class
        );

        assertThat(migrationCount).isEqualTo(1);
        assertThat(snapshotsTableExists).isEqualTo(1);
        assertThat(forecastsTableExists).isEqualTo(1);
        assertThat(ingredientObservedDateIndexExists).isEqualTo(1);
        assertThat(sourceObservedDateIndexExists).isEqualTo(1);
    }
}
