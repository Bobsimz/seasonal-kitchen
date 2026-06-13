package com.seasonaldining.producer.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

@Configuration
@EnableConfigurationProperties({GeminiProperties.class, GeminiPromptsProperties.class})
public class GeminiConfig {

    @Bean
    public RestClient geminiRestClient(GeminiProperties properties) {
        return RestClient.builder()
                .baseUrl("https://gms.ssafy.io")
                .defaultHeader("x-goog-api-key", properties.key())
                .build();
    }
}
