package com.seasonaldining.curation.controller;

import com.seasonaldining.common.response.ApiResponse;
import com.seasonaldining.curation.dto.response.CurationCardResponse;
import com.seasonaldining.curation.dto.response.CurationDetailResponse;
import com.seasonaldining.curation.service.CurationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Positive;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/curations")
@Tag(name = "04. Curations", description = "제철 큐레이션 API")
@Validated
public class CurationController {

    private final CurationService curationService;

    public CurationController(CurationService curationService) {
        this.curationService = curationService;
    }

    @GetMapping
    @Operation(summary = "큐레이션 카드 목록", description = "노출 순서대로 큐레이션 카드(이미지/타이틀/서브타이틀)를 조회합니다.")
    public ApiResponse<List<CurationCardResponse>> getCurations() {
        return ApiResponse.success(curationService.getCurationCards(), null);
    }

    @GetMapping("/{curationId}")
    @Operation(summary = "큐레이션 상세 조회", description = "메인 이미지/타이틀/서브타이틀 + 제철 이야기 + 관련 식재료/레시피를 조회합니다.")
    public ApiResponse<CurationDetailResponse> getCurationDetail(
            @Parameter(description = "큐레이션 ID", example = "1")
            @PathVariable @Positive Long curationId
    ) {
        return ApiResponse.success(curationService.getCurationDetail(curationId), null);
    }
}
