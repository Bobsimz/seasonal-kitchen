package com.seasonaldining.search.controller;
import com.seasonaldining.common.response.ApiResponse; import com.seasonaldining.search.dto.response.*; import com.seasonaldining.search.service.SearchService; import org.springframework.security.core.context.SecurityContextHolder; import com.seasonaldining.common.security.AuthenticatedUser; import java.util.List;
import io.swagger.v3.oas.annotations.*; import io.swagger.v3.oas.annotations.tags.Tag; import jakarta.validation.constraints.*; import org.springframework.validation.annotation.Validated; import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/v1/search") @Validated @Tag(name="04. Search",description="검색 API")
public class SearchController {
 private final SearchService service; public SearchController(SearchService service){this.service=service;}
 @GetMapping @Operation(summary="통합 검색")
 public ApiResponse<SearchResponse> search(@RequestParam @NotBlank String q,@RequestParam(defaultValue="ALL") @Pattern(regexp="ALL|INGREDIENT|RECIPE|PRODUCT") String type){return ApiResponse.success(service.search(q,type,currentUserId()),null);}
 @GetMapping("/trending") @Operation(summary="인기 검색어 조회") public ApiResponse<List<SearchKeywordResponse>> trending(){return ApiResponse.success(service.trending(),null);}
 private Long currentUserId(){var a=SecurityContextHolder.getContext().getAuthentication();return a!=null&&a.getPrincipal() instanceof AuthenticatedUser u?u.userId():null;}
}
