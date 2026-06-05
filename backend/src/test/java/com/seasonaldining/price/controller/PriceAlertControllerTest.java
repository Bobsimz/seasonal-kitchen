package com.seasonaldining.price.controller;
import com.seasonaldining.common.security.JwtTokenProvider; import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository; import com.seasonaldining.price.entity.PriceAlert;
import com.seasonaldining.price.repository.PriceAlertRepository; import com.seasonaldining.user.entity.User; import com.seasonaldining.user.repository.UserRepository;
import com.seasonaldining.support.UserDataCleaner;
import org.junit.jupiter.api.*; import org.springframework.beans.factory.annotation.Autowired; import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest; import org.springframework.http.MediaType; import org.springframework.test.context.ActiveProfiles; import org.springframework.test.web.servlet.MockMvc;
import java.math.BigDecimal; import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*; import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import org.springframework.jdbc.core.JdbcTemplate;
@SpringBootTest @AutoConfigureMockMvc @ActiveProfiles("test")
class PriceAlertControllerTest {
 @Autowired MockMvc mvc; @Autowired JwtTokenProvider jwt; @Autowired PriceAlertRepository alerts; @Autowired UserRepository users; @Autowired IngredientRepository ingredients; @Autowired JdbcTemplate jdbc;
 @BeforeEach void setUp(){UserDataCleaner.clean(jdbc);ingredients.deleteAll();}
 @Test void crudPriceAlert() throws Exception{
  User u=users.save(new User("alert@example.com","알림",null,"ACTIVE")); Ingredient i=ingredients.save(new Ingredient("무","채소",null,"1개",true)); String t=token(u);
  mvc.perform(post("/api/v1/price-alerts").header("Authorization",t).contentType(MediaType.APPLICATION_JSON).content("{\"ingredientId\":"+i.getId()+",\"targetPrice\":2000}"))
   .andExpect(status().isOk()).andExpect(jsonPath("$.data.active").value(true));
  PriceAlert a=alerts.findAll().get(0);
  mvc.perform(patch("/api/v1/price-alerts/{id}",a.getId()).header("Authorization",t).contentType(MediaType.APPLICATION_JSON).content("{\"targetPrice\":1800,\"active\":false}"))
   .andExpect(status().isOk()).andExpect(jsonPath("$.data.active").value(false));
  mvc.perform(get("/api/v1/price-alerts").header("Authorization",t)).andExpect(status().isOk()).andExpect(jsonPath("$.data.length()").value(1));
  mvc.perform(delete("/api/v1/price-alerts/{id}",a.getId()).header("Authorization",t)).andExpect(status().isOk());
 }
 @Test void validationFailure() throws Exception{
  User u=users.save(new User("alert@example.com","알림",null,"ACTIVE"));
  mvc.perform(post("/api/v1/price-alerts").header("Authorization",token(u)).contentType(MediaType.APPLICATION_JSON).content("{\"ingredientId\":0,\"targetPrice\":-1}"))
   .andExpect(status().isBadRequest()).andExpect(jsonPath("$.error.code").value("COMMON_VALIDATION_FAILED"));
 }
 @Test void cannotDeleteAnotherUsersAlert() throws Exception{
  User owner=users.save(new User("owner-a@example.com","주인",null,"ACTIVE")); User other=users.save(new User("other-a@example.com","타인",null,"ACTIVE"));
  Ingredient ingredient=ingredients.save(new Ingredient("무","채소",null,"1개",true));
  PriceAlert a=alerts.save(new PriceAlert(owner.getId(),ingredient.getId(),new BigDecimal("1000"),true));
  mvc.perform(delete("/api/v1/price-alerts/{id}",a.getId()).header("Authorization",token(other)))
   .andExpect(status().isNotFound()).andExpect(jsonPath("$.error.code").value("PRICE_ALERT_NOT_FOUND"));
 }
 private String token(User u){return "Bearer "+jwt.createAccessToken(u.getId());}
}
