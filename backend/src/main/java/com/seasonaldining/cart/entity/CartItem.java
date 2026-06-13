package com.seasonaldining.cart.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "cart_items")
public class CartItem {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "cart_id", nullable = false)
    private Long cartId;
    @Column(name = "offer_id", nullable = false)
    private Long offerId;
    @Column(name = "producer_id", nullable = false)
    private Long producerId;
    @Column(name = "ingredient_id")
    private Long ingredientId;
    @Column(name = "ingredient_name", nullable = false, length = 50)
    private String ingredientName;
    @Column(nullable = false)
    private int qty;
    @Column(name = "unit_price", nullable = false)
    private BigDecimal unitPrice;
    @Column(nullable = false, length = 30)
    private String unit;
    // 선택 옵션(규격) 스냅샷(V32). 옵션 없는 라인은 둘 다 null.
    @Column(name = "offer_option_id")
    private Long offerOptionId;
    @Column(name = "option_label", length = 60)
    private String optionLabel;

    protected CartItem() {}

    /** 옵션 없는 라인(기존 호출 호환). */
    public CartItem(Long cartId, Long offerId, Long producerId, Long ingredientId, String ingredientName, int qty, BigDecimal unitPrice, String unit) {
        this(cartId, offerId, producerId, ingredientId, ingredientName, qty, unitPrice, unit, null, null);
    }

    /** 옵션 스냅샷 포함 라인. */
    public CartItem(Long cartId, Long offerId, Long producerId, Long ingredientId, String ingredientName, int qty,
                    BigDecimal unitPrice, String unit, Long offerOptionId, String optionLabel) {
        this.cartId = cartId; this.offerId = offerId; this.producerId = producerId; this.ingredientId = ingredientId;
        this.ingredientName = ingredientName; this.qty = qty; this.unitPrice = unitPrice; this.unit = unit;
        this.offerOptionId = offerOptionId; this.optionLabel = optionLabel;
    }
    public Long getId() { return id; }
    public Long getCartId() { return cartId; }
    public Long getOfferId() { return offerId; }
    public Long getProducerId() { return producerId; }
    public Long getIngredientId() { return ingredientId; }
    public String getIngredientName() { return ingredientName; }
    public int getQty() { return qty; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public String getUnit() { return unit; }
    public Long getOfferOptionId() { return offerOptionId; }
    public String getOptionLabel() { return optionLabel; }
    public void setQty(int qty) { this.qty = qty; }
    public void increaseQty(int delta) { this.qty += delta; }
}
