package com.seasonaldining.order.service;

import com.seasonaldining.cart.entity.Cart;
import com.seasonaldining.cart.entity.CartItem;
import com.seasonaldining.cart.repository.CartItemRepository;
import com.seasonaldining.cart.repository.CartRepository;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.order.dto.response.OrderResponse;
import com.seasonaldining.order.dto.response.OrderSummaryResponse;
import com.seasonaldining.order.entity.Order;
import com.seasonaldining.order.entity.OrderItem;
import com.seasonaldining.order.repository.OrderItemRepository;
import com.seasonaldining.order.repository.OrderRepository;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.repository.ProducerRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

/**
 * 주문 서비스 — farm-direct-commerce 스켈레톤.
 * 장바구니 → 주문 전환(모의 결제, PG 없음). 배송비/적립은 cart 정책 재사용.
 * 결제 연동 범위는 tasks 1.4.
 */
@Service
public class OrderService {

    private static final BigDecimal SHIPPING_FEE = BigDecimal.valueOf(3000);
    private static final BigDecimal FREE_SHIPPING_THRESHOLD = BigDecimal.valueOf(30000);
    private static final BigDecimal POINT_RATE = BigDecimal.valueOf(0.01);

    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final ProducerRepository producerRepository;

    public OrderService(OrderRepository orderRepository, OrderItemRepository orderItemRepository,
                        CartRepository cartRepository, CartItemRepository cartItemRepository,
                        ProducerRepository producerRepository) {
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
        this.producerRepository = producerRepository;
    }

    @Transactional
    public OrderResponse createOrder(Long userId) {
        Cart cart = cartRepository.findByUserId(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.CART_ITEM_NOT_FOUND));
        List<CartItem> items = cartItemRepository.findByCartId(cart.getId());
        if (items.isEmpty()) throw new BusinessException(ErrorCode.CART_ITEM_NOT_FOUND);

        BigDecimal itemsTotal = items.stream()
                .map(i -> i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQty())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal shipping = computeShipping(items);
        BigDecimal total = itemsTotal.add(shipping);
        BigDecimal points = itemsTotal.multiply(POINT_RATE).setScale(0, java.math.RoundingMode.FLOOR);

        Order order = orderRepository.save(new Order(userId, generateOrderNumber(), total, shipping, points));
        Map<Long, String> producerNames = new HashMap<>();
        for (CartItem ci : items) {
            String pname = producerNames.computeIfAbsent(ci.getProducerId(),
                    pid -> producerRepository.findById(pid).map(Producer::getName).orElse(null));
            orderItemRepository.save(new OrderItem(order.getId(), ci.getProducerId(), pname,
                    ci.getIngredientName(), ci.getQty(), ci.getUnitPrice()));
        }
        // 주문 후 장바구니 비우기
        cartItemRepository.deleteAll(items);
        return toDetail(order, orderItemRepository.findByOrderId(order.getId()));
    }

    @Transactional(readOnly = true)
    public List<OrderSummaryResponse> getOrders(Long userId) {
        return orderRepository.findByUserIdOrderByOrderedAtDesc(userId).stream()
                .map(o -> new OrderSummaryResponse(
                        o.getId(), o.getOrderNumber(), o.getStatus(), o.getTotalAmount(),
                        summarize(orderItemRepository.findByOrderId(o.getId())), o.getOrderedAt()))
                .toList();
    }

    @Transactional(readOnly = true)
    public OrderResponse getOrder(Long userId, Long orderId) {
        Order order = orderRepository.findByIdAndUserId(orderId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ORDER_NOT_FOUND));
        return toDetail(order, orderItemRepository.findByOrderId(orderId));
    }

    // ── helpers ──────────────────────────────────────────────
    private BigDecimal computeShipping(List<CartItem> items) {
        Map<Long, BigDecimal> subtotalByProducer = items.stream().collect(Collectors.groupingBy(
                CartItem::getProducerId,
                Collectors.reducing(BigDecimal.ZERO,
                        i -> i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQty())), BigDecimal::add)));
        return subtotalByProducer.values().stream()
                .map(sub -> sub.compareTo(FREE_SHIPPING_THRESHOLD) >= 0 ? BigDecimal.ZERO : SHIPPING_FEE)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private static final DateTimeFormatter ORDER_NO_FMT = DateTimeFormatter.ofPattern("yyyyMMdd-HHmmssSSS");

    /**
     * 주문번호: 밀리초 정밀 타임스탬프 + 16비트 랜덤. 충돌 시 사전 존재확인으로 재생성.
     * (트랜잭션 내 예외-retry는 rollback-only 문제가 있어 사전체크 방식 채택. DB sequence 전환은 후속.)
     */
    private String generateOrderNumber() {
        for (int i = 0; i < 5; i++) {
            String candidate = OffsetDateTime.now().format(ORDER_NO_FMT)
                    + "-" + String.format("%04x", ThreadLocalRandom.current().nextInt(0x10000));
            if (!orderRepository.existsByOrderNumber(candidate)) {
                return candidate;
            }
        }
        // 극히 드문 연속 충돌 폴백: UUID 조각으로 유일성 보장
        return OffsetDateTime.now().format(ORDER_NO_FMT) + "-" + UUID.randomUUID().toString().substring(0, 8);
    }

    private String summarize(List<OrderItem> items) {
        if (items.isEmpty()) return "";
        String first = items.get(0).getIngredientName();
        return items.size() == 1 ? first : first + " 외 " + (items.size() - 1) + "건";
    }

    private OrderResponse toDetail(Order o, List<OrderItem> items) {
        BigDecimal itemsTotal = o.getTotalAmount().subtract(o.getShippingFee());
        List<OrderResponse.Item> itemDtos = items.stream()
                .map(i -> new OrderResponse.Item(i.getProducerName(), i.getIngredientName(), i.getQty(), i.getUnitPrice()))
                .toList();
        return new OrderResponse(o.getId(), o.getOrderNumber(), o.getStatus(), itemsTotal,
                o.getShippingFee(), o.getTotalAmount(), o.getPointsEarned(), o.getOrderedAt(), itemDtos);
    }
}
