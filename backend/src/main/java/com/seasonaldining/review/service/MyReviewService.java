package com.seasonaldining.review.service;

import com.seasonaldining.order.repository.OrderItemRepository;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.repository.ProducerRepository;
import com.seasonaldining.producer.repository.ProducerReviewRepository;
import com.seasonaldining.review.dto.response.MyReviewResponse;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 내 리뷰 조회 — farm-direct-commerce.
 * written(내가 작성한 농가 리뷰) / writable(작성가능 = 배송완료 주문의 농가 중 아직 미작성).
 */
@Service
public class MyReviewService {

    private final ProducerReviewRepository reviewRepository;
    private final ProducerRepository producerRepository;
    private final OrderItemRepository orderItemRepository;

    public MyReviewService(ProducerReviewRepository reviewRepository, ProducerRepository producerRepository,
                           OrderItemRepository orderItemRepository) {
        this.reviewRepository = reviewRepository;
        this.producerRepository = producerRepository;
        this.orderItemRepository = orderItemRepository;
    }

    @Transactional(readOnly = true)
    public List<MyReviewResponse> getMyReviews(Long userId, String status) {
        if ("writable".equalsIgnoreCase(status)) {
            return getWritable(userId);
        }
        // 기본: 작성한 리뷰
        return reviewRepository.findByUserIdOrderByCreatedAtDesc(userId).stream()
                .map(r -> {
                    Producer p = producerRepository.findById(r.getProducerId()).orElse(null);
                    return new MyReviewResponse(
                            r.getId(), r.getProducerId(), p != null ? p.getName() : null,
                            r.getItem(), r.getRating(), r.getBody(), r.getCreatedAt());
                }).toList();
    }

    /** 배송완료(DELIVERED) 주문의 농가 중, 아직 리뷰를 작성하지 않은 농가만 작성가능으로 반환. */
    private List<MyReviewResponse> getWritable(Long userId) {
        Set<Long> reviewedProducerIds = reviewRepository.findByUserIdOrderByCreatedAtDesc(userId).stream()
                .map(r -> r.getProducerId())
                .collect(Collectors.toSet());
        return orderItemRepository.findWritableReviewTargets(userId).stream()
                .filter(row -> !reviewedProducerIds.contains(row.getProducerId()))
                .map(row -> new MyReviewResponse(
                        null, row.getProducerId(), row.getProducerName(),
                        row.getIngredientName(), null, null, row.getDeliveredAt()))
                .toList();
    }
}
