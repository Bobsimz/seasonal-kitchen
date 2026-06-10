-- Cart items now reference a concrete producer_offer (offer_id) instead of
-- matching by (producer_id, ingredient_name). producer_id/ingredient_*/unit_price/unit
-- remain as order-time snapshots. See openspec/changes/farm-direct-commerce cart-and-order.

ALTER TABLE cart_items ADD COLUMN offer_id BIGINT;

UPDATE cart_items ci
SET offer_id = (
    SELECT po.id
    FROM producer_offers po
    WHERE po.producer_id = ci.producer_id
      AND (
          (ci.ingredient_id IS NOT NULL AND po.ingredient_id = ci.ingredient_id)
          OR (ci.ingredient_id IS NULL AND po.ingredient_name = ci.ingredient_name)
      )
      AND po.unit = ci.unit
      AND po.price = ci.unit_price
    ORDER BY po.id
    LIMIT 1
)
WHERE ci.offer_id IS NULL;

ALTER TABLE cart_items ALTER COLUMN offer_id SET NOT NULL;

ALTER TABLE cart_items
    ADD CONSTRAINT fk_cart_items_offer FOREIGN KEY (offer_id) REFERENCES producer_offers(id);

-- 동일 장바구니 내 같은 offer 중복 담기는 qty 증가로 처리하므로 (cart_id, offer_id) 유니크
CREATE UNIQUE INDEX uq_cart_items_cart_offer ON cart_items(cart_id, offer_id);
