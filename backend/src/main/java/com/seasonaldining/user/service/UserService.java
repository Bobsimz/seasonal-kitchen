package com.seasonaldining.user.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.favorite.repository.FavoriteRepository;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.price.repository.PriceAlertRepository;
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

    public UserService(
            UserRepository userRepository,
            UserPreferenceRepository userPreferenceRepository,
            UserAllergyRepository userAllergyRepository,
            FavoriteRepository favoriteRepository,
            PriceAlertRepository priceAlertRepository,
            IngredientRepository ingredientRepository
    ) {
        this.userRepository = userRepository;
        this.userPreferenceRepository = userPreferenceRepository;
        this.userAllergyRepository = userAllergyRepository;
        this.favoriteRepository = favoriteRepository;
        this.priceAlertRepository = priceAlertRepository;
        this.ingredientRepository = ingredientRepository;
    }

    @Transactional
    public UserPreferenceResponse updatePreference(Long userId, UpdateUserPreferenceRequest request) {
        getUserOrThrow(userId);
        UserPreference preference = userPreferenceRepository.findById(userId)
                .orElseGet(() -> new UserPreference(
                        userId,
                        request.householdSize(),
                        request.budget(),
                        request.spicyAvoid(),
                        request.priority()
                ));
        preference.update(request.householdSize(), request.budget(), request.spicyAvoid(), request.priority());
        UserPreference savedPreference = userPreferenceRepository.save(preference);
        if (request.allergyCodes() != null) {
            userAllergyRepository.deleteByUserId(userId);
            userAllergyRepository.saveAll(request.allergyCodes().stream()
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
        UserPreference preference = userPreferenceRepository.findById(userId).orElse(null);
        long favoriteCount = favoriteRepository.countByUserId(userId);
        long activeAlertCount = priceAlertRepository.countByUserIdAndActiveTrue(userId);
        List<MyPageSummaryResponse.PersonalizedIngredientResponse> personalizedIngredients =
                ingredientRepository.findByActiveTrue(PageRequest.of(0, 4)).getContent().stream()
                        .map(this::toPersonalizedIngredientResponse)
                        .toList();

        return new MyPageSummaryResponse(
                new MyPageSummaryResponse.ProfileResponse(user.getId(), user.getNickname(), user.getProfileImageUrl()),
                new MyPageSummaryResponse.StatsResponse(BigDecimal.ZERO, favoriteCount, activeAlertCount, 0),
                preference == null
                        ? new MyPageSummaryResponse.PreferenceSummaryResponse(null, null, null)
                        : new MyPageSummaryResponse.PreferenceSummaryResponse(
                        preference.getHouseholdSize(),
                        preference.isSpicyAvoid(),
                        preference.getPriority()
                ),
                allergyCodes(userId),
                personalizedIngredients,
                List.of(
                        new MyPageSummaryResponse.MenuRowResponse("favorites", "찜한 콘텐츠", favoriteCount),
                        new MyPageSummaryResponse.MenuRowResponse("priceAlerts", "가격 알림", activeAlertCount)
                )
        );
    }

    private User getUserOrThrow(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));
    }

    private UserProfileResponse toResponse(User user) {
        return new UserProfileResponse(
                user.getId(),
                user.getEmail(),
                user.getNickname(),
                user.getProfileImageUrl(),
                user.getStatus()
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
        return new MyPageSummaryResponse.PersonalizedIngredientResponse(
                ingredient.getId(),
                ingredient.getName(),
                ingredient.getCategory(),
                ingredient.getImageUrl(),
                List.of("추천", ingredient.getCategory())
        );
    }
}
