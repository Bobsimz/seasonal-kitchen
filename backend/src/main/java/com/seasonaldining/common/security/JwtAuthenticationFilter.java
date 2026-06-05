package com.seasonaldining.common.security;

import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final ObjectProvider<JwtTokenProvider> jwtTokenProviderProvider;
    private final ObjectProvider<RestAuthenticationEntryPoint> authenticationEntryPointProvider;

    public JwtAuthenticationFilter(
            ObjectProvider<JwtTokenProvider> jwtTokenProviderProvider,
            ObjectProvider<RestAuthenticationEntryPoint> authenticationEntryPointProvider
    ) {
        this.jwtTokenProviderProvider = jwtTokenProviderProvider;
        this.authenticationEntryPointProvider = authenticationEntryPointProvider;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {
        String authorization = request.getHeader("Authorization");
        JwtTokenProvider jwtTokenProvider = jwtTokenProviderProvider.getIfAvailable();
        RestAuthenticationEntryPoint authenticationEntryPoint = authenticationEntryPointProvider.getIfAvailable();
        if (jwtTokenProvider != null && authenticationEntryPoint != null
                && authorization != null && authorization.startsWith("Bearer ")) {
            try {
                Long userId = jwtTokenProvider.getUserId(authorization.substring(7));
                AuthenticatedUser principal = new AuthenticatedUser(userId);
                SecurityContextHolder.getContext().setAuthentication(
                        new UsernamePasswordAuthenticationToken(principal, null, List.of())
                );
            } catch (JwtException | IllegalArgumentException ex) {
                authenticationEntryPoint.commenceInvalidToken(request, response);
                return;
            }
        }
        filterChain.doFilter(request, response);
    }
}
