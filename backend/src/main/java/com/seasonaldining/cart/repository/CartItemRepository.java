package com.seasonaldining.cart.repository;

import com.seasonaldining.cart.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByCartId(Long cartId);
    Optional<CartItem> findByIdAndCartId(Long id, Long cartId);
    Optional<CartItem> findByCartIdAndOfferId(Long cartId, Long offerId);

    /** 같은 옵션 라인 병합용. */
    Optional<CartItem> findByCartIdAndOfferIdAndOfferOptionId(Long cartId, Long offerId, Long offerOptionId);
    /** 옵션 없는 라인 병합용(offer_option_id IS NULL). */
    Optional<CartItem> findByCartIdAndOfferIdAndOfferOptionIdIsNull(Long cartId, Long offerId);
}
