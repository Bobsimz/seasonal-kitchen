package com.seasonaldining.common.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
public class SecurityConfig {

    private final ObjectProvider<JwtAuthenticationFilter> jwtAuthenticationFilterProvider;
    private final ObjectProvider<RestAuthenticationEntryPoint> authenticationEntryPointProvider;

    public SecurityConfig(
            ObjectProvider<JwtAuthenticationFilter> jwtAuthenticationFilterProvider,
            ObjectProvider<RestAuthenticationEntryPoint> authenticationEntryPointProvider
    ) {
        this.jwtAuthenticationFilterProvider = jwtAuthenticationFilterProvider;
        this.authenticationEntryPointProvider = authenticationEntryPointProvider;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        RestAuthenticationEntryPoint authenticationEntryPoint = authenticationEntryPointProvider.getIfAvailable();
        JwtAuthenticationFilter jwtAuthenticationFilter = jwtAuthenticationFilterProvider.getIfAvailable();

        http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/swagger-ui.html",
                                "/swagger-ui/**",
                                "/v3/api-docs",
                                "/v3/api-docs/**",
                                "/api/v1/health",
                                "/api/v1/dev/auth/token"
                        ).permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/v1/ingredients/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/v1/recipes/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/v1/reels/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/v1/home").permitAll()
                        .requestMatchers(HttpMethod.GET, "/api/v1/search/**").permitAll()
                        .requestMatchers(HttpMethod.GET, "/error").permitAll()
                        .anyRequest().authenticated()
                );

        if (authenticationEntryPoint != null) {
            http.exceptionHandling(exceptions -> exceptions.authenticationEntryPoint(authenticationEntryPoint));
        }
        if (jwtAuthenticationFilter != null) {
            http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        }

        return http.build();
    }
}
