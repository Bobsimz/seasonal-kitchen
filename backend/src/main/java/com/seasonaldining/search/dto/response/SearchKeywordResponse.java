package com.seasonaldining.search.dto.response;
import io.swagger.v3.oas.annotations.media.Schema;
public record SearchKeywordResponse(@Schema(description="검색어",example="무") String keyword,@Schema(description="검색 횟수",example="10") long searchCount){}
