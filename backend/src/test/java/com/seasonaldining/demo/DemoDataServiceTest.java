package com.seasonaldining.demo;

import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.reel.repository.ReelRepository;
import com.seasonaldining.store.repository.StoreOfferRepository;
import com.seasonaldining.support.UserDataCleaner;
import com.seasonaldining.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
class DemoDataServiceTest {

    @Autowired
    private DemoDataService demoDataService;

    @Autowired
    private UserRepository users;

    @Autowired
    private IngredientRepository ingredients;

    @Autowired
    private RecipeRepository recipes;

    @Autowired
    private ReelRepository reels;

    @Autowired
    private StoreOfferRepository storeOffers;

    @Autowired
    private JdbcTemplate jdbc;

    @BeforeEach
    void setUp() {
        UserDataCleaner.clean(jdbc);
        ingredients.deleteAll();
    }

    @Test
    void testProfileDoesNotAutoLoadDemoData() {
        assertThat(users.findByEmail(DemoDataService.DEMO_USER_EMAIL)).isEmpty();
        assertThat(ingredients.findAll()).isEmpty();
    }

    @Test
    void seedIsIdempotentAndCreatesKeyScreenData() {
        demoDataService.seed();
        long userCount = users.count();
        long ingredientCount = ingredients.count();
        long recipeCount = recipes.count();
        long reelCount = reels.count();
        long offerCount = storeOffers.count();

        demoDataService.seed();

        assertThat(users.count()).isEqualTo(userCount);
        assertThat(ingredients.count()).isEqualTo(ingredientCount);
        assertThat(recipes.count()).isEqualTo(recipeCount);
        assertThat(reels.count()).isEqualTo(reelCount);
        assertThat(storeOffers.count()).isEqualTo(offerCount);
        assertThat(users.findByEmail(DemoDataService.DEMO_USER_EMAIL)).isPresent();
        assertThat(ingredientCount).isGreaterThanOrEqualTo(5);
        assertThat(recipeCount).isGreaterThanOrEqualTo(2);
        assertThat(reelCount).isGreaterThanOrEqualTo(2);
        assertThat(offerCount).isGreaterThanOrEqualTo(7);
    }
}
