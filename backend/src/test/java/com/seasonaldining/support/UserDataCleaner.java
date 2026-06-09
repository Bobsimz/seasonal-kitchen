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
        jdbcTemplate.update("DELETE FROM users");
    }
}
