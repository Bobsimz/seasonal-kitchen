package com.seasonaldining.demo;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.demo-seed")
public record DemoDataProperties(
        boolean enabled
) {
}
