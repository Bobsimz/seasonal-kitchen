package com.seasonaldining.recommendation.entity;
import jakarta.persistence.*;
@Entity @Table(name="recommendation_sessions") public class RecommendationSession{
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private Long id; @Column(name="user_id",nullable=false) private Long userId; @Column(nullable=false) private String status; @Column(name="request_json",nullable=false,columnDefinition="TEXT") private String requestJson;
 protected RecommendationSession(){} public RecommendationSession(Long userId,String requestJson){this.userId=userId;this.requestJson=requestJson;this.status="CREATED";} public Long getId(){return id;} public Long getUserId(){return userId;}
}
