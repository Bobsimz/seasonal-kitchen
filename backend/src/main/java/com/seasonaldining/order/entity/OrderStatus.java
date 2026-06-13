package com.seasonaldining.order.entity;

import java.util.Set;

/**
 * 주문 상태 및 허용 전이. DB에는 문자열로 저장(Order.status).
 *
 * <pre>
 *   PAID ──▶ PREPARING ──▶ SHIPPED ──▶ DELIVERED
 *    │           │
 *    └────┬──────┘
 *         ▼
 *      CANCELLED   (배송 시작 전에만 취소 가능)
 * </pre>
 *
 * DELIVERED·CANCELLED는 종료 상태(이후 전이 없음).
 */
public enum OrderStatus {
    PAID,
    PREPARING,
    SHIPPED,
    DELIVERED,
    CANCELLED;

    private static final java.util.Map<OrderStatus, Set<OrderStatus>> ALLOWED = java.util.Map.of(
            PAID, Set.of(PREPARING, CANCELLED),
            PREPARING, Set.of(SHIPPED, CANCELLED),
            SHIPPED, Set.of(DELIVERED),
            DELIVERED, Set.of(),
            CANCELLED, Set.of());

    /** 현재 상태에서 next로 전이 가능한가. */
    public boolean canTransitionTo(OrderStatus next) {
        return ALLOWED.getOrDefault(this, Set.of()).contains(next);
    }

    /** 운송장(SHIPPED) 진입 여부 — trackingNumber 필수 검증에 사용. */
    public boolean requiresTracking(OrderStatus next) {
        return next == SHIPPED;
    }

    /** 문자열을 enum으로 — 알 수 없는 값이면 null. */
    public static OrderStatus from(String raw) {
        if (raw == null) return null;
        try {
            return OrderStatus.valueOf(raw.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
