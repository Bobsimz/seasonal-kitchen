package com.seasonaldining.cart.repository;

import com.seasonaldining.cart.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByCartId(Long cartId);
    Optional<CartItem> findByIdAndCartId(Long id, Long cartId);
    Optional<CartItem> findByCartIdAndOfferId(Long cartId, Long offerId);
}
