package com.seasonaldining.common.health;

import com.seasonaldining.common.response.ApiResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.OffsetDateTime;

@RestController
@Tag(name = "00. Common")
public class HealthCheckController {

    @GetMapping("/api/v1/health")
    @Operation(summary = "Health check")
    public ApiResponse<HealthCheckResponse> health() {
        HealthCheckResponse response = new HealthCheckResponse("UP", OffsetDateTime.now());
        return ApiResponse.success(response, null);
    }
}

