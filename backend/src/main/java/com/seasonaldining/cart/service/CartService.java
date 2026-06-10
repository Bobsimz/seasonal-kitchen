package com.seasonaldining.cart.service;

import com.seasonaldining.cart.dto.request.AddCartItemRequest;
import com.seasonaldining.cart.dto.request.UpdateCartItemRequest;
import com.seasonaldining.cart.dto.response.CartResponse;
import com.seasonaldining.cart.entity.Cart;
import com.seasonaldining.cart.entity.CartItem;
import com.seasonaldining.cart.repository.CartItemRepository;
import com.seasonaldining.cart.repository.CartRepository;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.entity.ProducerOffer;
import com.seasonaldining.producer.repository.ProducerOfferRepository;
import com.seasonaldining.producer.repository.ProducerRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 장바구니 서비스 — farm-direct-commerce 스켈레톤.
 * 농가별 그룹핑 + 배송비(3,000원, 그룹 소계 30,000원↑ 무료) 골격을 갖췄다.
 * 결제/주문 전환은 OrderService, 배송비 정책 확정은 tasks 1.6.
 */
@Service
public class CartService {

    private static final BigDecimal SHIPPING_FEE = BigDecimal.valueOf(3000);
    private static final BigDecimal FREE_SHIPPING_THRESHOLD = BigDecimal.valueOf(30000);
    private static final BigDecimal POINT_RATE = BigDecimal.valueOf(0.01);

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final ProducerRepository producerRepository;
    private final ProducerOfferRepository offerRepository;

    public CartService(CartRepository cartRepository, CartItemRepository cartItemRepository,
                       ProducerRepository producerRepository, ProducerOfferRepository offerRepository) {
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
        this.producerRepository = producerRepository;
        this.offerRepository = offerRepository;
    }

    @Transactional(readOnly = true)
    public CartResponse getCart(Long userId) {
        Cart cart = cartRepository.findByUserId(userId).orElse(null);
        if (cart == null) return emptyCart();
        return buildResponse(cartItemRepository.findByCartId(cart.getId()));
    }

    @Transactional
    public CartResponse addItem(Long userId, AddCartItemRequest req) {
        // offerId 기준으로 신뢰 가능한 상품 정보를 서버에서 조회한다. (클라이언트 입력 producer/price 미신뢰)
        ProducerOffer offer = offerRepository.findById(req.offerId())
                .orElseThrow(() -> new BusinessException(ErrorCode.PRODUCER_OFFER_NOT_FOUND));

        Cart cart = cartRepository.findByUserId(userId).orElseGet(() -> cartRepository.save(new Cart(userId)));

        // 같은 offer를 이미 담았으면 새 row 대신 수량 증가 (uq_cart_items_cart_offer 정책)
        CartItem existing = cartItemRepository.findByCartIdAndOfferId(cart.getId(), offer.getId()).orElse(null);
        if (existing != null) {
            existing.increaseQty(req.qty());
            cartItemRepository.save(existing);
        } else {
            // producer/ingredient/price/unit 은 offer에서 가져온 주문시점 스냅샷으로 저장
            cartItemRepository.save(new CartItem(
                    cart.getId(), offer.getId(), offer.getProducerId(), offer.getIngredientId(),
                    offer.getIngredientName(), req.qty(), offer.getPrice(), offer.getUnit()));
        }
        return buildResponse(cartItemRepository.findByCartId(cart.getId()));
    }

    @Transactional
    public CartResponse updateItem(Long userId, Long cartItemId, UpdateCartItemRequest req) {
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.CART_ITEM_NOT_FOUND));
        CartItem item = cartItemRepository.findByIdAndCartId(cartItemId, cart.getId())
                .orElseThrow(() -> new BusinessException(ErrorCode.CART_ITEM_NOT_FOUND));
        item.setQty(req.qty());
        cartItemRepository.save(item);
        return buildResponse(cartItemRepository.findByCartId(cart.getId()));
    }

    @Transactional
    public void deleteItem(Long userId, Long cartItemId) {
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.CART_ITEM_NOT_FOUND));
        CartItem item = cartItemRepository.findByIdAndCartId(cartItemId, cart.getId())
                .orElseThrow(() -> new BusinessException(ErrorCode.CART_ITEM_NOT_FOUND));
        cartItemRepository.delete(item);
    }

    // ── helpers ──────────────────────────────────────────────
    private CartResponse emptyCart() {
        return new CartResponse(List.of(), BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO);
    }

    private CartResponse buildResponse(List<CartItem> items) {
        Map<Long, List<CartItem>> byProducer = items.stream()
                .collect(Collectors.groupingBy(CartItem::getProducerId, LinkedHashMap::new, Collectors.toList()));
        List<CartResponse.ProducerGroup> groups = new ArrayList<>();
        BigDecimal itemsTotal = BigDecimal.ZERO;
        BigDecimal shippingTotal = BigDecimal.ZERO;
        for (var e : byProducer.entrySet()) {
            BigDecimal subtotal = e.getValue().stream()
                    .map(i -> i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQty())))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            BigDecimal shipping = subtotal.compareTo(FREE_SHIPPING_THRESHOLD) >= 0 ? BigDecimal.ZERO : SHIPPING_FEE;
            Producer p = producerRepository.findById(e.getKey()).orElse(null);
            List<CartResponse.Item> itemDtos = e.getValue().stream()
                    .map(i -> new CartResponse.Item(i.getId(), i.getIngredientName(), i.getQty(), i.getUnitPrice(), i.getUnit()))
                    .toList();
            groups.add(new CartResponse.ProducerGroup(e.getKey(), p != null ? p.getName() : null, itemDtos, subtotal, shipping));
            itemsTotal = itemsTotal.add(subtotal);
            shippingTotal = shippingTotal.add(shipping);
        }
        return new CartResponse(groups, itemsTotal, shippingTotal, itemsTotal.add(shippingTotal));
    }

    public static BigDecimal pointRate() { return POINT_RATE; }
}
