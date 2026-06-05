package com.seasonaldining.recommendation.service;
import org.junit.jupiter.api.Test; import static org.assertj.core.api.Assertions.assertThat;
class RecommendationScoringServiceTest {
 private final RecommendationScoringService service=new RecommendationScoringService();
 @Test void calculatesDeterministicWeightedScore(){assertThat(service.score(100,80,60,40,20,0)).isEqualTo(66);}
}
