package com.seasonaldining.producer.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.gms")
public record GeminiProperties(
        String key,
        String model,
        String visionModel,
        String imageModel
) {
    public GeminiProperties {
        if (model == null || model.isBlank()) model = "gemini-2.5-flash-lite";
        if (visionModel == null || visionModel.isBlank()) visionModel = "gemini-2.5-flash";
        if (imageModel == null || imageModel.isBlank()) imageModel = "gemini-2.5-flash-image";
    }
}
