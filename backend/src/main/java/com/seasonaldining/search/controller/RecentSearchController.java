package com.seasonaldining.search.controller;
import com.seasonaldining.common.response.ApiResponse; import com.seasonaldining.common.security.CurrentUserProvider;
import com.seasonaldining.search.dto.response.SearchKeywordResponse; import com.seasonaldining.search.service.SearchService;
import io.swagger.v3.oas.annotations.Operation; import io.swagger.v3.oas.annotations.tags.Tag; import org.springframework.web.bind.annotation.*; import java.util.List;
@RestController @RequestMapping("/api/v1/users/me/recent-searches") @Tag(name="04. Search",description="검색 API")
public class RecentSearchController {
 private final SearchService service; private final CurrentUserProvider currentUser;
 public RecentSearchController(SearchService service,CurrentUserProvider currentUser){this.service=service;this.currentUser=currentUser;}
 @GetMapping @Operation(summary="내 최근 검색어 조회")
 public ApiResponse<List<SearchKeywordResponse>> recent(){return ApiResponse.success(service.recent(currentUser.getCurrentUserId()),null);}
}
