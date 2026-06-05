package com.seasonaldining.demo;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile({"local", "dev"})
@EnableConfigurationProperties(DemoDataProperties.class)
public class DemoDataInitializer implements ApplicationRunner {

    private final DemoDataProperties properties;
    private final DemoDataService demoDataService;

    public DemoDataInitializer(DemoDataProperties properties, DemoDataService demoDataService) {
        this.properties = properties;
        this.demoDataService = demoDataService;
    }

    @Override
    public void run(ApplicationArguments args) {
        if (properties.enabled()) {
            demoDataService.seed();
        }
    }
}
