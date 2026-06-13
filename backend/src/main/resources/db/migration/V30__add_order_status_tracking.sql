-- 주문 상태 흐름 + 배송 추적. BACKEND-REQUIREMENTS #4 (주문 상태).
-- 상태: PAID → PREPARING → SHIPPED → DELIVERED (+ CANCELLED). 전이는 애플리케이션에서 검증.
-- 기존 status 컬럼(orders.status)은 V1 이후 존재. 여기서는 운송장/타임스탬프만 추가.
ALTER TABLE orders ADD COLUMN carrier         VARCHAR(50);                     -- 택배사명(SHIPPED 시 기록)
ALTER TABLE orders ADD COLUMN tracking_number VARCHAR(60);                     -- 운송장 번호(SHIPPED 시 필수)
ALTER TABLE orders ADD COLUMN shipped_at      TIMESTAMP WITH TIME ZONE;        -- SHIPPED 전이 시각
ALTER TABLE orders ADD COLUMN delivered_at    TIMESTAMP WITH TIME ZONE;        -- DELIVERED 전이 시각

-- 판매자 대시보드: 농가가 받은 주문을 상태별로 조회. order_items.producer_id 기준.
CREATE INDEX idx_orders_status ON orders(status);
