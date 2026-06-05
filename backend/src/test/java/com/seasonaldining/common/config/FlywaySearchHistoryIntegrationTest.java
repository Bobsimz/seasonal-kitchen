package com.seasonaldining.common.config;
import org.junit.jupiter.api.Test; import org.springframework.beans.factory.annotation.Autowired; import org.springframework.boot.test.context.SpringBootTest; import org.springframework.jdbc.core.JdbcTemplate; import org.springframework.test.context.DynamicPropertyRegistry; import org.springframework.test.context.DynamicPropertySource; import org.testcontainers.containers.PostgreSQLContainer; import org.testcontainers.junit.jupiter.Container; import org.testcontainers.junit.jupiter.Testcontainers; import static org.assertj.core.api.Assertions.assertThat;
@SpringBootTest @Testcontainers
class FlywaySearchHistoryIntegrationTest {
 @Container static final PostgreSQLContainer<?> POSTGRES=new PostgreSQLContainer<>("postgres:16").withDatabaseName("seasonal_dining_test").withUsername("seasonal").withPassword("seasonal");
 @DynamicPropertySource static void datasource(DynamicPropertyRegistry r){r.add("spring.datasource.url",POSTGRES::getJdbcUrl);r.add("spring.datasource.username",POSTGRES::getUsername);r.add("spring.datasource.password",POSTGRES::getPassword);r.add("spring.datasource.driver-class-name",POSTGRES::getDriverClassName);}
 @Autowired JdbcTemplate jdbc;
 @Test void createsSearchTables(){assertThat(count("search_keywords")).isEqualTo(1);assertThat(count("recent_searches")).isEqualTo(1);}
 private Integer count(String table){return jdbc.queryForObject("SELECT COUNT(*) FROM information_schema.tables WHERE table_name = '"+table+"'",Integer.class);}
}
