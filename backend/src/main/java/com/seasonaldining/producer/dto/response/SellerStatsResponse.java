package com.seasonaldining.producer.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Schema(description = "판매자 통계 응답 — 화면 21f 판매자 통계 / 마이 판매자 센터 카드")
public record SellerStatsResponse(
        @Schema(description = "요약 KPI") Summary summary,
        @Schema(description = "최근 7일 일별 매출(과거→오늘)") List<DailyRevenue> revenueSeries,
        @Schema(description = "최근 7일 일 평균 매출", example = "689000") BigDecimal dailyAverage,
        @Schema(description = "인기 상품(판매량순)") List<TopProduct> topProducts
) {
    @Schema(description = "요약 KPI")
    public record Summary(
            @Schema(description = "이번 달 매출", example = "4820000") BigDecimal monthlyRevenue,
            @Schema(description = "이번 달 주문 건수", example = "186") long orderCount,
            @Schema(description = "이번 달 매출 전월대비 증감률(%), 전월 0이면 null", example = "12.0", nullable = true) Double monthlyRevenueChangeRate,
            @Schema(description = "이번 달 주문 전월대비 증감률(%), 전월 0이면 null", example = "8.0", nullable = true) Double orderCountChangeRate,
            @Schema(description = "오늘 매출(마이 카드용)", example = "184000") BigDecimal todayRevenue,
            @Schema(description = "오늘 주문 건수(마이 카드용)", example = "7") long todayOrderCount,
            @Schema(description = "상품 조회수(이벤트 미수집 시 null)", nullable = true) Long viewCount,
            @Schema(description = "전환율 %(조회수 미수집 시 null)", nullable = true) Double conversionRate,
            @Schema(description = "다음 정산일", example = "2026-06-25") LocalDate nextSettlementDate
    ) {}

    @Schema(description = "일별 매출")
    public record DailyRevenue(
            @Schema(description = "날짜", example = "2026-06-12") LocalDate date,
            @Schema(description = "해당일 매출", example = "184000") BigDecimal amount
    ) {}

    @Schema(description = "인기 상품 — 상품(offer) 단위 집계. 과거(offer_id 없는) 주문은 식재료명 단위 fallback.")
    public record TopProduct(
            @Schema(description = "상품(offer) ID. 과거 데이터는 null", example = "10", nullable = true) Long offerId,
            @Schema(description = "상품명(주문 시점 스냅샷). 과거 데이터는 null → 프론트는 ingredientName으로 표시", example = "햇 봄동 1.5kg 산지직송", nullable = true) String title,
            @Schema(description = "식재료명(title 없을 때 표시용 fallback)", example = "무") String ingredientName,
            @Schema(description = "판매 수량 합계", example = "64") long soldCount,
            @Schema(description = "매출 합계", example = "537600") BigDecimal amount
    ) {}
}
