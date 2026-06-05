package com.seasonaldining.recommendation.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.recommendation.dto.response.RecommendationMessageResponse;
import com.seasonaldining.recommendation.entity.RecommendationMessage;
import com.seasonaldining.recommendation.repository.RecommendationMessageRepository;
import com.seasonaldining.shopping.entity.ShoppingPlan;
import com.seasonaldining.shopping.repository.ShoppingPlanRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RecommendationMessageService {

    private final ShoppingPlanRepository plans;
    private final RecommendationMessageRepository messages;

    public RecommendationMessageService(
            ShoppingPlanRepository plans,
            RecommendationMessageRepository messages
    ) {
        this.plans = plans;
        this.messages = messages;
    }

    @Transactional
    public RecommendationMessageResponse add(Long userId, Long planId, String content) {
        ShoppingPlan plan = plans.findByIdAndUserId(planId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.SHOPPING_PLAN_NOT_FOUND));
        messages.save(new RecommendationMessage(plan.getSessionId(), "USER", content));
        RecommendationMessage reply = messages.save(new RecommendationMessage(
                plan.getSessionId(),
                "ASSISTANT",
                "요청을 반영해 계획을 다시 검토하겠습니다."
        ));
        return new RecommendationMessageResponse(reply.getId(), reply.getRole(), reply.getContent());
    }
}
