package com.seasonaldining.review.service;

import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.repository.ProducerRepository;
import com.seasonaldining.producer.repository.ProducerReviewRepository;
import com.seasonaldining.review.dto.response.MyReviewResponse;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 내 리뷰 조회 — farm-direct-commerce.
 * MVP: written(내가 작성한 농가 리뷰)만 제공. writable(작성가능)은 주문/배송 연동이 필요해
 * MVP 범위 밖이며, 호출 시 빈 목록을 반환한다(운영 고도화 시 구현).
 */
@Service
public class MyReviewService {

    private final ProducerReviewRepository reviewRepository;
    private final ProducerRepository producerRepository;

    public MyReviewService(ProducerReviewRepository reviewRepository, ProducerRepository producerRepository) {
        this.reviewRepository = reviewRepository;
        this.producerRepository = producerRepository;
    }

    @Transactional(readOnly = true)
    public List<MyReviewResponse> getMyReviews(Long userId, String status) {
        if ("writable".equalsIgnoreCase(status)) {
            // MVP 범위 밖: 작성가능 리뷰(배송완료 주문 기반)는 미구현 → 빈 목록
            return List.of();
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
}
