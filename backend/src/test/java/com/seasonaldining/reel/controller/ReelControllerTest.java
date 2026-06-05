package com.seasonaldining.reel.controller;

import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.repository.RecipeIngredientRepository;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.recipe.repository.RecipeStepRepository;
import com.seasonaldining.reel.entity.Creator;
import com.seasonaldining.reel.entity.Reel;
import com.seasonaldining.reel.repository.*;
import com.seasonaldining.support.UserDataCleaner;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.time.OffsetDateTime;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class ReelControllerTest {
    @Autowired MockMvc mvc; @Autowired JwtTokenProvider jwt; @Autowired JdbcTemplate jdbc;
    @Autowired UserRepository users; @Autowired RecipeRepository recipes; @Autowired RecipeStepRepository steps; @Autowired RecipeIngredientRepository recipeIngredients; @Autowired CreatorRepository creators; @Autowired ReelRepository reels;

    @BeforeEach void setUp() { UserDataCleaner.clean(jdbc); steps.deleteAll(); recipeIngredients.deleteAll(); recipes.deleteAll(); }

    @Test void returnsPublishedReelFeedAndDetail() throws Exception {
        Reel reel = fixtureReel();
        mvc.perform(get("/api/v1/reels"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(1))
                .andExpect(jsonPath("$.data[0].creatorName").value("쿠킹맘"))
                .andExpect(jsonPath("$.data[0].ingredientTags[0]").value("봄동"));
        mvc.perform(get("/api/v1/reels/{id}", reel.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.title").value("봄동 비빔밥 1분"));
    }

    @Test void likeUnlikeCommentAndViewRequireAuthenticatedUser() throws Exception {
        Reel reel = fixtureReel();
        User user = users.save(new User("reel@example.com", "릴스", null, "ACTIVE"));
        String token = "Bearer " + jwt.createAccessToken(user.getId());
        mvc.perform(post("/api/v1/reels/{id}/likes", reel.getId()).header("Authorization", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.liked").value(true))
                .andExpect(jsonPath("$.data.likeCount").value(1));
        mvc.perform(post("/api/v1/reels/{id}/comments", reel.getId()).header("Authorization", token).contentType(MediaType.APPLICATION_JSON).content("{\"content\":\"맛있어 보여요\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.content").value("맛있어 보여요"));
        mvc.perform(get("/api/v1/reels/{id}/comments", reel.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.length()").value(1));
        mvc.perform(post("/api/v1/reels/{id}/view-events", reel.getId()).header("Authorization", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.viewCount").value(1));
        mvc.perform(delete("/api/v1/reels/{id}/likes", reel.getId()).header("Authorization", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.liked").value(false));
    }

    @Test void unauthenticatedWriteReturns401AndMissingReelReturns404() throws Exception {
        Reel reel = fixtureReel();
        mvc.perform(post("/api/v1/reels/{id}/likes", reel.getId())).andExpect(status().isUnauthorized());
        mvc.perform(get("/api/v1/reels/{id}", 999999)).andExpect(status().isNotFound()).andExpect(jsonPath("$.error.code").value("REEL_NOT_FOUND"));
    }

    private Reel fixtureReel() {
        Recipe recipe = recipes.save(new Recipe("봄동 비빔밥", "봄동 활용", null, "EASY", 15, 2, "PUBLISHED"));
        Creator creator = creators.save(new Creator(null, "쿠킹맘", "https://example.com/avatar.png", "ACTIVE"));
        return reels.save(new Reel(recipe.getId(), creator.getId(), "봄동 비빔밥 1분", "빠른 제철 레시피", "https://example.com/video.mp4", "https://example.com/thumb.png", "봄동,고추장,쪽파", 48, "PUBLISHED", OffsetDateTime.now()));
    }
}
