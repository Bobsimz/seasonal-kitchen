package com.seasonaldining.common.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.examples.Example;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI seasonalDiningOpenApi() {
        return new OpenAPI()
                .components(frontendDemoExamples()
                        .addSecuritySchemes("bearerAuth", new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")
                                .description("로그인/회원가입으로 받은 accessToken을 입력하세요.")))
                .addSecurityItem(new SecurityRequirement().addList("bearerAuth"))
                .info(new Info()
                        .title("Seasonal Dining Backend API")
                        .description("Seasonal Dining backend API documentation. Frontend screen demo examples are available under OpenAPI components.examples.")
                        .version("v1"))
                .addServersItem(new Server()
                        .url("http://localhost:8080")
                        .description("Local development server"));
    }

    private Components frontendDemoExamples() {
        return new Components()
                .addExamples("FrontendHomeResponse", example("""
                        {
                          "success": true,
                          "data": {
                            "seasonTitle": "이번 주 제철 추천",
                            "seasonSubtitle": "봄동과 무 가격이 안정적입니다.",
                            "hero": {"title": "봄동 비빔밥", "ingredientName": "봄동", "imageUrl": "https://example.com/bomdong.png"},
                            "ingredients": [{"id": 1, "name": "봄동", "price": 4500, "tags": ["제철", "추천"]}],
                            "recipes": [{"id": 1, "title": "봄동 비빔밥", "likeCount": 12, "tags": ["EASY", "20분"]}],
                            "reels": [{"id": 1, "title": "봄동 비빔밥 1분", "creatorName": "제철키친", "viewCount": 1200}],
                            "trendingKeywords": ["봄동", "무생채"],
                            "unreadNotificationCount": 2
                          },
                          "error": null
                        }
                        """))
                .addExamples("FrontendIngredientDetailResponse", example("""
                        {
                          "success": true,
                          "data": {
                            "id": 1,
                            "name": "봄동",
                            "seasonMonths": [3, 4, 5],
                            "nutrition": {"calories": 22, "carbohydrate": 4.3, "sugar": 1.2, "fiber": 2.0, "protein": 1.5, "fat": 0.2, "vitamins": [{"name": "비타민C", "value": "28mg"}]},
                            "careTips": ["잎이 선명한 것을 고릅니다."],
                            "storageTips": [{"storageType": "냉장", "description": "신문지에 싸서 보관합니다.", "icon": "fridge"}],
                            "compareStoreCount": 2
                          },
                          "error": null
                        }
                        """))
                .addExamples("FrontendIngredientOffersResponse", example("""
                        {
                          "success": true,
                          "data": [
                            {"storeName": "마켓컬리", "deliveryLabel": "샛별배송", "price": 4300, "priceRangeMin": 4200, "priceRangeMax": 4500, "discountRate": 10, "productUrl": "https://example.com/kurly", "badge": "최저가"}
                          ],
                          "error": null
                        }
                        """))
                .addExamples("FrontendRecipeDetailResponse", example("""
                        {
                          "success": true,
                          "data": {
                            "id": 1,
                            "title": "봄동 비빔밥",
                            "estimatedTotal": 6700,
                            "creatorName": "제철키친",
                            "likeCount": 12,
                            "tags": ["EASY", "20분"],
                            "ingredients": [{"ingredientName": "봄동", "estimatedPrice": 4500}],
                            "relatedReels": [{"id": 1, "title": "봄동 비빔밥 1분"}]
                          },
                          "error": null
                        }
                        """))
                .addExamples("FrontendReelsResponse", example("""
                        {
                          "success": true,
                          "data": {
                            "items": [
                              {"id": 1, "recipeId": 1, "creatorName": "제철키친", "videoUrl": "https://example.com/demo.mp4", "thumbnailUrl": "https://example.com/thumb.png", "title": "봄동 비빔밥 1분", "ingredientTags": ["봄동"], "likeCount": 12, "commentCount": 3, "saveCount": 4, "viewCount": 1200, "durationSeconds": 54, "liked": false, "saved": false}
                            ],
                            "page": 0,
                            "size": 20,
                            "totalElements": 1,
                            "hasNext": false
                          },
                          "error": null
                        }
                        """))
                .addExamples("FrontendMyPageSummaryResponse", example("""
                        {
                          "success": true,
                          "data": {
                            "user": {"id": 1, "nickname": "제철데모", "photoUrl": "https://example.com/demo-profile.png"},
                            "stats": {"savedAmount": 0, "orderCount": 7, "reviewCount": 3},
                            "counts": {"orders": 7, "favorites": 12, "priceAlerts": 4, "reviews": 3},
                            "personalized": [{"id": 1, "name": "봄동", "category": "채소", "imageUrl": "https://example.com/bomdong.png", "currentPrice": 4500, "unit": "봉", "priceChangeLabel": null, "trendDirection": null}]
                          },
                          "error": null
                        }
                        """))
                .addExamples("FrontendNotificationsResponse", example("""
                        {
                          "success": true,
                          "data": {
                            "items": [{"id": 1, "type": "PRICE", "rawType": "PRICE_DROP", "title": "무 가격 하락", "body": "무 가격이 설정 가격에 가까워졌습니다.", "icon": "price", "read": false, "createdAt": "2026-06-12T08:30:00+09:00"}],
                            "tabCounts": {"ALL": 2, "PRICE": 1, "ORDER": 0, "COMMUNITY": 1}
                          },
                          "error": null
                        }
                        """));
    }

    private Example example(String value) {
        return new Example().value(value);
    }
}
