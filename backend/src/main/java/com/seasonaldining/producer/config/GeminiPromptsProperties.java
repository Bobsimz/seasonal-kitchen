package com.seasonaldining.producer.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "gemini.prompts")
public record GeminiPromptsProperties(
        OfferPhotoAnalysisPrompt offerPhotoAnalysis,
        OfferImageGenerationPrompt offerImageGeneration,
        GenerateDescriptionPrompt generateDescription
) {
    public record OfferPhotoAnalysisPrompt(String userTemplate) {}
    public record OfferImageGenerationPrompt(String userTemplate) {}
    public record GenerateDescriptionPrompt(String userTemplate) {}
}
