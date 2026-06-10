package com.seasonaldining.common.config;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
@ActiveProfiles("test")
class OpenApiEndpointsIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void openApiDocsEndpointReturns200() throws Exception {
        mockMvc.perform(get("/v3/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith("application/json"))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"openapi\"")));
    }

    @Test
    void swaggerUiEndpointIsAccessible() throws Exception {
        mockMvc.perform(get("/swagger-ui.html"))
                .andExpect(status().is3xxRedirection());
    }

    @Test
    void openApiDocsContainPhaseTwoEndpoints() throws Exception {
        mockMvc.perform(get("/v3/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/recipes\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/recipes/{recipeId}\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/recipes/{recipeId}/steps\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/ingredients/{ingredientId}/substitutes\"")));
    }

    @Test
    void openApiDocsContainJwtAndUserProfileEndpoints() throws Exception {
        mockMvc.perform(get("/v3/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/dev/auth/token\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/users/me\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/users/me/summary\"")));
    }

    @Test
    void openApiDocsContainPhaseThreeEndpoints() throws Exception {
        mockMvc.perform(get("/v3/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/users/me/preferences\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/favorites\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/price-alerts\"")));
    }

    @Test
    void openApiDocsContainPhaseFourEndpoints() throws Exception {
        mockMvc.perform(get("/v3/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/home\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/search\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/search/trending\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/users/me/recent-searches\"")));
    }

    @Test
    void openApiDocsContainPhaseSixEndpoints() throws Exception {
        mockMvc.perform(get("/v3/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/notifications\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/notifications/{notificationId}/read\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/notifications/read-all\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/events\"")));
    }

    @Test
    void openApiDocsContainFrontendDemoExamples() throws Exception {
        mockMvc.perform(get("/v3/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("FrontendHomeResponse")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("seasonTitle")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("FrontendIngredientOffersResponse")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("deliveryLabel")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("FrontendMyPageSummaryResponse")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("allergyCodes")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("FrontendNotificationsResponse")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("tabCounts")));
    }

    @Test
    void openApiDocsContainFrontendIntegrationReelEndpoints() throws Exception {
        mockMvc.perform(get("/v3/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/reels\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/reels/{reelId}\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/reels/{reelId}/likes\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/reels/{reelId}/comments\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/reels/{reelId}/view-events\"")));
    }

    @Test
    void openApiDocsContainFrontendIntegrationIngredientEndpoints() throws Exception {
        mockMvc.perform(get("/v3/api-docs"))
                .andExpect(status().isOk())
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/ingredients/{ingredientId}/offers\"")))
                .andExpect(content().string(org.hamcrest.Matchers.containsString("\"/api/v1/ingredients/{ingredientId}/recipes\"")));
    }

    @Test
    void unknownEndpointRequiresAuthentication() throws Exception {
        mockMvc.perform(get("/api/v1/protected-check"))
                .andExpect(status().isUnauthorized());
    }
}
