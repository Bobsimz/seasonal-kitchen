package com.seasonaldining.user.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.favorite.repository.FavoriteRepository;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.order.repository.OrderRepository;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceAlertRepository;
import com.seasonaldining.price.repository.PriceSnapshotRepository;
import com.seasonaldining.producer.entity.Producer;
import com.seasonaldining.producer.repository.ProducerRepository;
import com.seasonaldining.producer.repository.ProducerReviewRepository;
import com.seasonaldining.user.dto.request.UpdateUserProfileRequest;
import com.seasonaldining.user.dto.request.UpdateUserPreferenceRequest;
import com.seasonaldining.user.dto.response.MyPageSummaryResponse;
import com.seasonaldining.user.dto.response.UserProfileResponse;
import com.seasonaldining.user.dto.response.UserPreferenceResponse;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.entity.UserAllergy;
import com.seasonaldining.user.entity.UserPreference;
import com.seasonaldining.user.repository.UserAllergyRepository;
import com.seasonaldining.user.repository.UserRepository;
import com.seasonaldining.user.repository.UserPreferenceRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final UserPreferenceRepository userPreferenceRepository;
    private final UserAllergyRepository userAllergyRepository;
    private final FavoriteRepository favoriteRepository;
    private final PriceAlertRepository priceAlertRepository;
    private final IngredientRepository ingredientRepository;
    private final ProducerRepository producerRepository;
    private final OrderRepository orderRepository;
    private final ProducerReviewRepository producerReviewRepository;
    private final PriceSnapshotRepository priceSnapshotRepository;

    public UserService(
            UserRepository userRepository,
            UserPreferenceRepository userPreferenceRepository,
            UserAllergyRepository userAllergyRepository,
            FavoriteRepository favoriteRepository,
            PriceAlertRepository priceAlertRepository,
            IngredientRepository ingredientRepository,
            ProducerRepository producerRepository,
            OrderRepository orderRepository,
            ProducerReviewRepository producerReviewRepository,
            PriceSnapshotRepository priceSnapshotRepository
    ) {
        this.userRepository = userRepository;
        this.userPreferenceRepository = userPreferenceRepository;
        this.userAllergyRepository = userAllergyRepository;
        this.favoriteRepository = favoriteRepository;
        this.priceAlertRepository = priceAlertRepository;
        this.ingredientRepository = ingredientRepository;
        this.producerRepository = producerRepository;
        this.orderRepository = orderRepository;
        this.producerReviewRepository = producerReviewRepository;
        this.priceSnapshotRepository = priceSnapshotRepository;
    }

    @Transactional
    public UserPreferenceResponse updatePreference(Long userId, UpdateUserPreferenceRequest request) {
        getUserOrThrow(userId);
        // 모든 필드 선택값 — 보낸 만큼만 저장하고 누락분은 기존값/안전한 기본값으로 유지한다.
        // entity 의 householdSize 는 not-null primitive 이므로 null 이면 기본 1, priority 는 빈 문자열.
        Integer householdSize = request.resolvedHouseholdSize();
        String priority = request.resolvedPriority();
        UserPreference preference = userPreferenceRepository.findById(userId)
                .orElseGet(() -> new UserPreference(
                        userId,
                        householdSize != null ? householdSize : 1,
                        request.budget(),
                        request.spicyAvoid() != null && request.spicyAvoid(),
                        priority != null ? priority : ""
                ));
        preference.update(
                householdSize != null ? householdSize : preference.getHouseholdSize(),
                request.budget() != null ? request.budget() : preference.getBudget(),
                request.spicyAvoid() != null ? request.spicyAvoid() : preference.isSpicyAvoid(),
                priority != null ? priority : preference.getPriority()
        );
        UserPreference savedPreference = userPreferenceRepository.save(preference);
        List<String> allergyCodes = request.resolvedAllergyCodes();
        if (allergyCodes != null) {
            userAllergyRepository.deleteByUserId(userId);
            userAllergyRepository.saveAll(allergyCodes.stream()
                    .filter(code -> code != null && !code.isBlank())
                    .distinct()
                    .map(code -> new UserAllergy(userId, code))
                    .toList());
        }
        return toResponse(savedPreference);
    }

    @Transactional(readOnly = true)
    public UserProfileResponse getProfile(Long userId) {
        return toResponse(getUserOrThrow(userId));
    }

    @Transactional
    public UserProfileResponse updateProfile(Long userId, UpdateUserProfileRequest request) {
        User user = getUserOrThrow(userId);
        user.updateProfile(request.nickname(), request.profileImageUrl());
        return toResponse(user);
    }

    @Transactional(readOnly = true)
    public MyPageSummaryResponse getSummary(Long userId) {
        User user = getUserOrThrow(userId);
        long favoriteCount = favoriteRepository.countByUserId(userId);
        long activeAlertCount = priceAlertRepository.countByUserIdAndActiveTrue(userId);
        long orderCount = orderRepository.countByUserId(userId);
        long reviewCount = producerReviewRepository.countByUserId(userId);

        List<MyPageSummaryResponse.PersonalizedIngredientResponse> personalized =
                ingredientRepository.findByActiveTrue(PageRequest.of(0, 4)).getContent().stream()
                        .map(this::toPersonalizedIngredientResponse)
                        .toList();

        return new MyPageSummaryResponse(
                new MyPageSummaryResponse.UserBlock(user.getId(), user.getNickname(), user.getProfileImageUrl()),
                // savedAmount: best-effort — 산정 소스가 없어 0으로 둔다(FE 가 허용).
                new MyPageSummaryResponse.StatsResponse(BigDecimal.ZERO, orderCount, reviewCount),
                new MyPageSummaryResponse.CountsResponse(orderCount, favoriteCount, activeAlertCount, reviewCount),
                personalized
        );
    }

    private User getUserOrThrow(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));
    }

    private UserProfileResponse toResponse(User user) {
        // 농가 여부 = 이 사용자로 등록된 producer 행 존재 여부(한 사용자당 농가 1개). 화면 분기용.
        Long producerId = producerRepository.findByUserId(user.getId())
                .map(Producer::getId).orElse(null);
        return new UserProfileResponse(
                user.getId(),
                user.getEmail(),
                user.getNickname(),
                user.getProfileImageUrl(),
                user.getStatus(),
                producerId != null,
                producerId
        );
    }

    private UserPreferenceResponse toResponse(UserPreference preference) {
        return new UserPreferenceResponse(
                preference.getHouseholdSize(),
                preference.getBudget(),
                preference.isSpicyAvoid(),
                preference.getPriority(),
                allergyCodes(preference.getUserId())
        );
    }

    private List<String> allergyCodes(Long userId) {
        return userAllergyRepository.findByUserIdOrderByAllergyCodeAsc(userId).stream()
                .map(UserAllergy::getAllergyCode)
                .toList();
    }

    private MyPageSummaryResponse.PersonalizedIngredientResponse toPersonalizedIngredientResponse(Ingredient ingredient) {
        // 최신 시세 스냅샷에서 현재가/단위/추세를 best-effort 로 채운다. 없으면 가격 필드는 null.
        PriceSnapshot latest = priceSnapshotRepository
                .findFirstByIngredientIdOrderByObservedDateDescIdDesc(ingredient.getId())
                .orElse(null);
        BigDecimal currentPrice = latest != null ? latest.getPrice() : null;
        String unit = latest != null ? latest.getUnit() : ingredient.getBaseUnit();
        return new MyPageSummaryResponse.PersonalizedIngredientResponse(
                ingredient.getId(),
                ingredient.getName(),
                ingredient.getCategory(),
                ingredient.getImageUrl(),
                currentPrice,
                unit,
                null,
                null
        );
    }
}
