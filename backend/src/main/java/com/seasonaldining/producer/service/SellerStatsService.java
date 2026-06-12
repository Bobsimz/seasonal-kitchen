package com.seasonaldining.producer.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.order.repository.OrderItemRepository;
import com.seasonaldining.order.repository.OrderItemRepository.SellerOrderRow;
import com.seasonaldining.producer.dto.response.SellerStatsResponse;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.repository.ProducerRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 판매자 통계 (화면 21f / 마이 판매자 센터 카드).
 * 매출·주문·인기상품·정산일은 orders/order_items 집계로 제공한다.
 * 조회수·전환율은 상품 조회 이벤트 미수집이라 1차에서는 null(후속).
 */
@Service
public class SellerStatsService {

    private static final int TOP_PRODUCT_LIMIT = 5;
    private static final int SETTLEMENT_DAY = 25; // 매월 25일 정산(MVP 가정)
    private static final ZoneId BUSINESS_ZONE = ZoneId.of("Asia/Seoul"); // 통계 날짜 기준 timezone

    private final ProducerRepository producerRepository;
    private final OrderItemRepository orderItemRepository;

    public SellerStatsService(ProducerRepository producerRepository,
                              OrderItemRepository orderItemRepository) {
        this.producerRepository = producerRepository;
        this.orderItemRepository = orderItemRepository;
    }

    @Transactional(readOnly = true)
    public SellerStatsResponse getMyStats(Long userId) {
        Producer producer = producerRepository.findByUserId(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.PRODUCER_NOT_FOUND));

        List<SellerOrderRow> rows = orderItemRepository.findSellerRows(producer.getId());

        LocalDate today = LocalDate.now(BUSINESS_ZONE);
        LocalDate monthStart = today.withDayOfMonth(1);
        LocalDate prevMonthStart = monthStart.minusMonths(1);
        LocalDate weekStart = today.minusDays(6); // 최근 7일(오늘 포함)

        BigDecimal monthlyRevenue = BigDecimal.ZERO;
        BigDecimal prevMonthlyRevenue = BigDecimal.ZERO;
        BigDecimal todayRevenue = BigDecimal.ZERO;
        Set<Long> monthOrders = new HashSet<>();
        Set<Long> prevMonthOrders = new HashSet<>();
        Set<Long> todayOrders = new HashSet<>();

        // 7일 매출 버킷 (과거→오늘 순서 유지)
        Map<LocalDate, BigDecimal> weekBuckets = new LinkedHashMap<>();
        for (int i = 0; i < 7; i++) weekBuckets.put(weekStart.plusDays(i), BigDecimal.ZERO);

        // 인기 상품 집계 — 상품(offer) 단위. offer_id가 있으면 offer별, 없으면(과거 데이터) 식재료명별 fallback.
        Map<String, ProductAgg> productAggs = new LinkedHashMap<>();

        for (SellerOrderRow r : rows) {
            // 주문 시각(OffsetDateTime)을 한국(BUSINESS_ZONE) 기준 달력 날짜로 환산 — 서버 timezone 무관
            LocalDate date = r.getOrderedAt().atZoneSameInstant(BUSINESS_ZONE).toLocalDate();
            BigDecimal lineAmount = r.getUnitPrice().multiply(BigDecimal.valueOf(r.getQty()));

            if (!date.isBefore(monthStart)) { // 이번 달
                monthlyRevenue = monthlyRevenue.add(lineAmount);
                monthOrders.add(r.getOrderId());
            } else if (!date.isBefore(prevMonthStart)) { // 전월
                prevMonthlyRevenue = prevMonthlyRevenue.add(lineAmount);
                prevMonthOrders.add(r.getOrderId());
            }
            if (date.isEqual(today)) {
                todayRevenue = todayRevenue.add(lineAmount);
                todayOrders.add(r.getOrderId());
            }
            if (weekBuckets.containsKey(date)) {
                weekBuckets.put(date, weekBuckets.get(date).add(lineAmount));
            }

            // 그룹 키: offer_id가 있으면 "offer:{id}", 없으면 "ing:{ingredientName}"(과거 데이터 fallback)
            String key = r.getOfferId() != null ? "offer:" + r.getOfferId() : "ing:" + r.getIngredientName();
            ProductAgg agg = productAggs.computeIfAbsent(key,
                    k -> new ProductAgg(r.getOfferId(), r.getOfferTitle(), r.getIngredientName()));
            agg.soldCount += r.getQty();
            agg.amount = agg.amount.add(lineAmount);
        }

        List<SellerStatsResponse.DailyRevenue> series = new ArrayList<>();
        BigDecimal weekTotal = BigDecimal.ZERO;
        for (Map.Entry<LocalDate, BigDecimal> e : weekBuckets.entrySet()) {
            series.add(new SellerStatsResponse.DailyRevenue(e.getKey(), e.getValue()));
            weekTotal = weekTotal.add(e.getValue());
        }
        BigDecimal dailyAverage = weekTotal.divide(BigDecimal.valueOf(7), 0, RoundingMode.HALF_UP);

        List<SellerStatsResponse.TopProduct> topProducts = productAggs.values().stream()
                .map(a -> new SellerStatsResponse.TopProduct(
                        a.offerId, a.title, a.ingredientName, a.soldCount, a.amount))
                .sorted(Comparator.comparingLong(SellerStatsResponse.TopProduct::soldCount).reversed())
                .limit(TOP_PRODUCT_LIMIT)
                .toList();

        SellerStatsResponse.Summary summary = new SellerStatsResponse.Summary(
                monthlyRevenue,
                monthOrders.size(),
                changeRate(monthlyRevenue, prevMonthlyRevenue),
                changeRate(BigDecimal.valueOf(monthOrders.size()), BigDecimal.valueOf(prevMonthOrders.size())),
                todayRevenue,
                todayOrders.size(),
                null,   // viewCount — 조회 이벤트 미수집(후속)
                null,   // conversionRate — 동일
                nextSettlementDate(today));

        return new SellerStatsResponse(summary, series, dailyAverage, topProducts);
    }

    /** 전월대비 증감률(%). 전월 0이면 비교 불가 → null. 소수 1자리 반올림. */
    private Double changeRate(BigDecimal current, BigDecimal previous) {
        if (previous == null || previous.signum() == 0) return null;
        return current.subtract(previous)
                .divide(previous, 4, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(100))
                .setScale(1, RoundingMode.HALF_UP)
                .doubleValue();
    }

    /** 다음 정산일 — 이번 달 25일이 아직 안 지났으면 이번 달, 지났으면 다음 달 25일. */
    private LocalDate nextSettlementDate(LocalDate today) {
        LocalDate thisMonth = today.withDayOfMonth(SETTLEMENT_DAY);
        return today.isAfter(thisMonth) ? thisMonth.plusMonths(1) : thisMonth;
    }

    /** 인기 상품 누적 — offerId/title은 그룹 첫 행 기준, ingredientName은 표시 fallback. */
    private static final class ProductAgg {
        final Long offerId;
        final String title;
        final String ingredientName;
        long soldCount;
        BigDecimal amount = BigDecimal.ZERO;

        ProductAgg(Long offerId, String title, String ingredientName) {
            this.offerId = offerId;
            this.title = title;
            this.ingredientName = ingredientName;
        }
    }
}
