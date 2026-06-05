package com.seasonaldining.search.entity;
import jakarta.persistence.*;
@Entity @Table(name="recent_searches")
public class RecentSearch {
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private Long id;
 @Column(name="user_id",nullable=false) private Long userId;
 @Column(nullable=false,length=100) private String keyword;
 protected RecentSearch(){} public RecentSearch(Long userId,String keyword){this.userId=userId;this.keyword=keyword;}
 public Long getId(){return id;} public Long getUserId(){return userId;} public String getKeyword(){return keyword;}
}
