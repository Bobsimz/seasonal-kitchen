package com.seasonaldining.search.entity;
import jakarta.persistence.*;
@Entity @Table(name="search_keywords")
public class SearchKeyword {
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private Long id;
 @Column(nullable=false,unique=true,length=100) private String keyword;
 @Column(name="search_count",nullable=false) private long searchCount;
 protected SearchKeyword(){} public SearchKeyword(String keyword){this.keyword=keyword;} public void increment(){searchCount++;}
 public Long getId(){return id;} public String getKeyword(){return keyword;} public long getSearchCount(){return searchCount;}
}
