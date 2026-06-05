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
class FlywayRecipeSchemaIntegrationTest {

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
    void flywayCreatesRecipeSchema() {
        assertThat(count("SELECT COUNT(*) FROM flyway_schema_history WHERE version = '4'")).isEqualTo(1);
        assertThat(count("SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'recipes'")).isEqualTo(1);
        assertThat(count("SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'recipe_ingredients'")).isEqualTo(1);
        assertThat(count("SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'recipe_steps'")).isEqualTo(1);
        assertThat(count("SELECT COUNT(*) FROM information_schema.tables WHERE table_name = 'ingredient_substitutes'")).isEqualTo(1);
        assertThat(count("SELECT COUNT(*) FROM pg_indexes WHERE indexname = 'idx_recipes_title'")).isEqualTo(1);
        assertThat(count("SELECT COUNT(*) FROM pg_indexes WHERE indexname = 'idx_recipe_ingredients_ingredient_id'")).isEqualTo(1);
        assertThat(count("SELECT COUNT(*) FROM pg_constraint WHERE conname = 'uk_recipe_steps_recipe_id_step_number'")).isEqualTo(1);
    }

    private Integer count(String sql) {
        return jdbcTemplate.queryForObject(sql, Integer.class);
    }
}
