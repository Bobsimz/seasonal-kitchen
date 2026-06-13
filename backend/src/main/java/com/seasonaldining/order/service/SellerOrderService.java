package com.seasonaldining.order.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.order.dto.request.UpdateOrderStatusRequest;
import com.seasonaldining.order.dto.response.SellerOrderResponse;
import com.seasonaldining.order.entity.Order;
import com.seasonaldining.order.entity.OrderItem;
import com.seasonaldining.order.entity.OrderStatus;
import com.seasonaldining.order.repository.OrderItemRepository;
import com.seasonaldining.order.repository.OrderRepository;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.repository.ProducerRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 판매자(농가) 주문 처리 — 받은 주문 조회 및 상태 전이.
 *
 * 상태 흐름: PAID → PREPARING → SHIPPED → DELIVERED (+ 배송 전 CANCELLED).
 * 주문은 여러 농가의 항목을 포함할 수 있고 status는 주문 단위이므로(MVP),
 * 해당 주문에 자기 농가 항목이 있는 농가면 상태를 변경할 수 있다.
 */
@Service
public class SellerOrderService {

    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final ProducerRepository producerRepository;

    public SellerOrderService(OrderRepository orderRepository,
                              OrderItemRepository orderItemRepository,
                              ProducerRepository producerRepository) {
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
        this.producerRepository = producerRepository;
    }

    /** 내 농가가 받은 주문 목록(최신순). 항목은 내 농가 것만 노출. */
    @Transactional(readOnly = true)
    public List<SellerOrderResponse> getMyOrders(Long userId) {
        Producer producer = requireMyProducer(userId);
        List<Order> orders = orderRepository.findOrdersForProducer(producer.getId());
        if (orders.isEmpty()) return List.of();

        List<Long> orderIds = orders.stream().map(Order::getId).toList();
        Map<Long, List<OrderItem>> itemsByOrder = orderItemRepository
                .findByOrderIdInAndProducerId(orderIds, producer.getId()).stream()
                .collect(Collectors.groupingBy(OrderItem::getOrderId));

        return orders.stream()
                .map(o -> toSellerResponse(o, itemsByOrder.getOrDefault(o.getId(), List.of())))
                .toList();
    }

    /** 주문 상태 전이. 권한·전이가능·운송장 필수를 검증한다. */
    @Transactional
    public SellerOrderResponse updateStatus(Long userId, Long orderId, UpdateOrderStatusRequest request) {
        Producer producer = requireMyProducer(userId);
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new BusinessException(ErrorCode.ORDER_NOT_FOUND));
        // 권한: 이 주문에 내 농가 항목이 있어야 한다.
        if (!orderItemRepository.existsByOrderIdAndProducerId(orderId, producer.getId())) {
            throw new BusinessException(ErrorCode.ORDER_ACCESS_DENIED);
        }

        OrderStatus current = order.statusEnum();
        OrderStatus next = OrderStatus.from(request.status());
        if (next == null) throw new BusinessException(ErrorCode.ORDER_INVALID_STATUS);
        if (current == null || !current.canTransitionTo(next)) {
            throw new BusinessException(ErrorCode.ORDER_INVALID_STATUS_TRANSITION);
        }
        // SHIPPED 진입 시 운송장 필수.
        if (next == OrderStatus.SHIPPED
                && (request.trackingNumber() == null || request.trackingNumber().isBlank())) {
            throw new BusinessException(ErrorCode.ORDER_TRACKING_REQUIRED);
        }

        order.applyTransition(next, request.carrier(), request.trackingNumber());
        // 영속 상태이므로 트랜잭션 커밋 시 flush. 명시적 save는 무해하므로 생략.

        List<OrderItem> myItems = orderItemRepository.findByOrderIdInAndProducerId(List.of(orderId), producer.getId());
        return toSellerResponse(order, myItems);
    }

    // ── helpers ──────────────────────────────────────────────
    private Producer requireMyProducer(Long userId) {
        return producerRepository.findByUserId(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.PRODUCER_NOT_FOUND));
    }

    private SellerOrderResponse toSellerResponse(Order o, List<OrderItem> items) {
        BigDecimal subtotal = items.stream()
                .map(i -> i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQty())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        List<SellerOrderResponse.Item> itemDtos = items.stream()
                .map(i -> new SellerOrderResponse.Item(
                        i.getOfferTitle(), i.getIngredientName(), i.getQty(), i.getOfferUnit(), i.getUnitPrice()))
                .toList();
        return new SellerOrderResponse(
                o.getId(), o.getOrderNumber(), o.getStatus(), subtotal,
                o.getCarrier(), o.getTrackingNumber(), o.getShippedAt(), o.getDeliveredAt(),
                o.getOrderedAt(), itemDtos);
    }
}
