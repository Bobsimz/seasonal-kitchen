package com.seasonaldining.producer.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "gemini.api")
public record GeminiProperties(
        String key,
        String model,
        String imageModel
) {
    public GeminiProperties {
        if (model == null || model.isBlank()) model = "gemini-2.5-flash-lite";
        if (imageModel == null || imageModel.isBlank()) imageModel = "gemini-3.1-flash-image";
    }
}
