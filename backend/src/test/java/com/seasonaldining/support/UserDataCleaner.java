package com.seasonaldining.support;

import org.springframework.jdbc.core.JdbcTemplate;

public final class UserDataCleaner {

    private UserDataCleaner() {
    }

    public static void clean(JdbcTemplate jdbcTemplate) {
        jdbcTemplate.update("DELETE FROM reel_comments");
        jdbcTemplate.update("DELETE FROM reel_reactions");
        jdbcTemplate.update("DELETE FROM reels");
        jdbcTemplate.update("DELETE FROM creators");
        jdbcTemplate.update("DELETE FROM store_offers");
        jdbcTemplate.update("DELETE FROM stores");
        jdbcTemplate.update("DELETE FROM ingredient_storage_tips");
        jdbcTemplate.update("DELETE FROM ingredient_care_tips");
        jdbcTemplate.update("DELETE FROM ingredient_nutritions");
        jdbcTemplate.update("DELETE FROM ingredient_substitutes");
        jdbcTemplate.update("DELETE FROM recipe_steps");
        jdbcTemplate.update("DELETE FROM recipe_ingredients");
        jdbcTemplate.update("DELETE FROM recipes");
        jdbcTemplate.update("DELETE FROM price_forecasts");
        jdbcTemplate.update("DELETE FROM price_snapshots");
        jdbcTemplate.update("DELETE FROM ingredient_aliases");
        jdbcTemplate.update("DELETE FROM notifications");
        jdbcTemplate.update("DELETE FROM user_events");
        jdbcTemplate.update("DELETE FROM outbox_events");
        jdbcTemplate.update("DELETE FROM recent_searches");
        jdbcTemplate.update("DELETE FROM price_alerts");
        jdbcTemplate.update("DELETE FROM favorites");
        jdbcTemplate.update("DELETE FROM pantry_items");
        jdbcTemplate.update("DELETE FROM user_preferences");
        jdbcTemplate.update("DELETE FROM user_allergies");
        jdbcTemplate.update("DELETE FROM refresh_tokens");
        jdbcTemplate.update("DELETE FROM oauth_accounts");
        // 자가등록 농가(user_id 보유)와 하위 데이터 정리. 시드 농가(user_id IS NULL)는 유지.
        String selfProducers = "SELECT id FROM producers WHERE user_id IS NOT NULL";
        jdbcTemplate.update("DELETE FROM cart_items WHERE offer_id IN "
                + "(SELECT id FROM producer_offers WHERE producer_id IN (" + selfProducers + "))");
        jdbcTemplate.update("DELETE FROM producer_offers WHERE producer_id IN (" + selfProducers + ")");
        jdbcTemplate.update("DELETE FROM producer_specialties WHERE producer_id IN (" + selfProducers + ")");
        jdbcTemplate.update("DELETE FROM producer_badges WHERE producer_id IN (" + selfProducers + ")");
        jdbcTemplate.update("DELETE FROM producer_news WHERE producer_id IN (" + selfProducers + ")");
        jdbcTemplate.update("DELETE FROM producer_reviews WHERE producer_id IN (" + selfProducers + ")");
        jdbcTemplate.update("DELETE FROM producers WHERE user_id IS NOT NULL");
        jdbcTemplate.update("DELETE FROM users");
    }
}
