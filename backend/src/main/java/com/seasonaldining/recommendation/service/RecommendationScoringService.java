package com.seasonaldining.recommendation.service;

import org.springframework.stereotype.Service;

@Service
public class RecommendationScoringService {
    public double score(double priceMerit, double seasonality, double preferenceFit, double recipeUse,
                        double pantryMatch, double storeAccess) {
        return priceMerit * 0.30 + seasonality * 0.20 + preferenceFit * 0.20
                + recipeUse * 0.15 + pantryMatch * 0.10 + storeAccess * 0.05;
    }
}
