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
import com.seasonaldining.producer.entity.OfferOption;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.entity.ProducerOffer;
import com.seasonaldining.producer.repository.OfferOptionRepository;
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
    private final OfferOptionRepository offerOptionRepository;

    public CartService(CartRepository cartRepository, CartItemRepository cartItemRepository,
                       ProducerRepository producerRepository, ProducerOfferRepository offerRepository,
                       OfferOptionRepository offerOptionRepository) {
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
        this.producerRepository = producerRepository;
        this.offerRepository = offerRepository;
        this.offerOptionRepository = offerOptionRepository;
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

        // 옵션 선택 시: 해당 offer의 옵션이어야 하며 단가/단위/라벨은 옵션에서 스냅샷.
        Long offerOptionId = req.offerOptionId();
        BigDecimal unitPrice;
        String unit;
        String optionLabel;
        CartItem existing;
        if (offerOptionId != null) {
            OfferOption option = offerOptionRepository.findById(offerOptionId)
                    .filter(op -> op.getOfferId().equals(offer.getId()))
                    .orElseThrow(() -> new BusinessException(ErrorCode.OFFER_OPTION_NOT_FOUND));
            unitPrice = option.getPrice();
            unit = (option.getUnit() != null && !option.getUnit().isBlank()) ? option.getUnit() : offer.getUnit();
            optionLabel = optionLabel(option);
            // 같은 offer라도 옵션이 다르면 별도 라인 → (cart, offer, option) 기준 병합
            existing = cartItemRepository.findByCartIdAndOfferIdAndOfferOptionId(
                    cart.getId(), offer.getId(), offerOptionId).orElse(null);
        } else {
            unitPrice = offer.getPrice();
            unit = offer.getUnit();
            optionLabel = null;
            existing = cartItemRepository.findByCartIdAndOfferIdAndOfferOptionIdIsNull(
                    cart.getId(), offer.getId()).orElse(null);
        }

        if (existing != null) {
            existing.increaseQty(req.qty());
            cartItemRepository.save(existing);
        } else {
            // producer/ingredient/price/unit 은 offer(또는 옵션)에서 가져온 주문시점 스냅샷으로 저장
            cartItemRepository.save(new CartItem(
                    cart.getId(), offer.getId(), offer.getProducerId(), offer.getIngredientId(),
                    offer.getIngredientName(), req.qty(), unitPrice, unit, offerOptionId, optionLabel));
        }
        return buildResponse(cartItemRepository.findByCartId(cart.getId()));
    }

    /** 옵션 라벨: 수량+단위(예: 3kg). 둘 다 없으면 null. */
    private static String optionLabel(OfferOption op) {
        String q = op.getQuantity() != null ? op.getQuantity().stripTrailingZeros().toPlainString() : "";
        String u = op.getUnit() != null ? op.getUnit() : "";
        String label = (q + u).trim();
        return label.isEmpty() ? null : label;
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
                    .map(i -> new CartResponse.Item(i.getId(), i.getIngredientName(), i.getQty(), i.getUnitPrice(),
                            i.getUnit(), i.getOfferOptionId(), i.getOptionLabel()))
                    .toList();
            groups.add(new CartResponse.ProducerGroup(e.getKey(), p != null ? p.getName() : null, itemDtos, subtotal, shipping));
            itemsTotal = itemsTotal.add(subtotal);
            shippingTotal = shippingTotal.add(shipping);
        }
        return new CartResponse(groups, itemsTotal, shippingTotal, itemsTotal.add(shippingTotal));
    }

    public static BigDecimal pointRate() { return POINT_RATE; }
}
