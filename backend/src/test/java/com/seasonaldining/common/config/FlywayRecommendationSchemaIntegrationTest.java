package com.seasonaldining.common.config;
import org.junit.jupiter.api.Test; import org.springframework.beans.factory.annotation.Autowired; import org.springframework.boot.test.context.SpringBootTest; import org.springframework.jdbc.core.JdbcTemplate; import org.springframework.test.context.DynamicPropertyRegistry; import org.springframework.test.context.DynamicPropertySource; import org.testcontainers.containers.PostgreSQLContainer; import org.testcontainers.junit.jupiter.Container; import org.testcontainers.junit.jupiter.Testcontainers; import static org.assertj.core.api.Assertions.assertThat;
@SpringBootTest @Testcontainers class FlywayRecommendationSchemaIntegrationTest{
 @Container static final PostgreSQLContainer<?> DB=new PostgreSQLContainer<>("postgres:16").withDatabaseName("test").withUsername("seasonal").withPassword("seasonal");
 @DynamicPropertySource static void ds(DynamicPropertyRegistry r){r.add("spring.datasource.url",DB::getJdbcUrl);r.add("spring.datasource.username",DB::getUsername);r.add("spring.datasource.password",DB::getPassword);}
 @Autowired JdbcTemplate jdbc; @Test void createsTables(){for(String t:new String[]{"recommendation_sessions","shopping_plans","shopping_plan_meals","shopping_plan_items"})assertThat(jdbc.queryForObject("SELECT COUNT(*) FROM information_schema.tables WHERE table_name='"+t+"'",Integer.class)).isEqualTo(1);}
}
