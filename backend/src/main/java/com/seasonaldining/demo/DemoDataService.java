package com.seasonaldining.demo;

import com.seasonaldining.favorite.entity.Favorite;
import com.seasonaldining.favorite.repository.FavoriteRepository;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.entity.IngredientCareTip;
import com.seasonaldining.ingredient.entity.IngredientNutrition;
import com.seasonaldining.ingredient.entity.IngredientStorageTip;
import com.seasonaldining.ingredient.repository.IngredientCareTipRepository;
import com.seasonaldining.ingredient.repository.IngredientNutritionRepository;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.ingredient.repository.IngredientStorageTipRepository;
import com.seasonaldining.notification.entity.Notification;
import com.seasonaldining.notification.repository.NotificationRepository;
import com.seasonaldining.price.entity.PriceAlert;
import com.seasonaldining.price.entity.PriceSnapshot;
import com.seasonaldining.price.repository.PriceAlertRepository;
import com.seasonaldining.price.repository.PriceSnapshotRepository;
import com.seasonaldining.recipe.entity.Recipe;
import com.seasonaldining.recipe.entity.RecipeIngredient;
import com.seasonaldining.recipe.entity.RecipeStep;
import com.seasonaldining.recipe.repository.RecipeIngredientRepository;
import com.seasonaldining.recipe.repository.RecipeRepository;
import com.seasonaldining.recipe.repository.RecipeStepRepository;
import com.seasonaldining.recommendation.entity.RecommendationSession;
import com.seasonaldining.recommendation.repository.RecommendationSessionRepository;
import com.seasonaldining.reel.entity.Creator;
import com.seasonaldining.reel.entity.Reel;
import com.seasonaldining.reel.repository.CreatorRepository;
import com.seasonaldining.reel.repository.ReelRepository;
import com.seasonaldining.shopping.entity.ShoppingPlan;
import com.seasonaldining.shopping.entity.ShoppingPlanItem;
import com.seasonaldining.shopping.repository.ShoppingPlanItemRepository;
import com.seasonaldining.shopping.repository.ShoppingPlanRepository;
import com.seasonaldining.store.entity.Store;
import com.seasonaldining.store.entity.StoreOffer;
import com.seasonaldining.store.repository.StoreOfferRepository;
import com.seasonaldining.store.repository.StoreRepository;
import com.seasonaldining.user.entity.PantryItem;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.entity.UserAllergy;
import com.seasonaldining.user.entity.UserPreference;
import com.seasonaldining.user.repository.PantryItemRepository;
import com.seasonaldining.user.repository.UserAllergyRepository;
import com.seasonaldining.user.repository.UserPreferenceRepository;
import com.seasonaldining.user.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Objects;

@Service
public class DemoDataService {

    public static final String DEMO_USER_EMAIL = "demo@seasonal-dining.local";

    private final IngredientRepository ingredients;
    private final PriceSnapshotRepository prices;
    private final IngredientNutritionRepository nutritions;
    private final IngredientCareTipRepository careTips;
    private final IngredientStorageTipRepository storageTips;
    private final RecipeRepository recipes;
    private final RecipeIngredientRepository recipeIngredients;
    private final RecipeStepRepository recipeSteps;
    private final CreatorRepository creators;
    private final ReelRepository reels;
    private final StoreRepository stores;
    private final StoreOfferRepository storeOffers;
    private final UserRepository users;
    private final UserPreferenceRepository preferences;
    private final UserAllergyRepository allergies;
    private final PantryItemRepository pantryItems;
    private final FavoriteRepository favorites;
    private final PriceAlertRepository priceAlerts;
    private final NotificationRepository notifications;
    private final RecommendationSessionRepository sessions;
    private final ShoppingPlanRepository shoppingPlans;
    private final ShoppingPlanItemRepository shoppingItems;

    public DemoDataService(
            IngredientRepository ingredients,
            PriceSnapshotRepository prices,
            IngredientNutritionRepository nutritions,
            IngredientCareTipRepository careTips,
            IngredientStorageTipRepository storageTips,
            RecipeRepository recipes,
            RecipeIngredientRepository recipeIngredients,
            RecipeStepRepository recipeSteps,
            CreatorRepository creators,
            ReelRepository reels,
            StoreRepository stores,
            StoreOfferRepository storeOffers,
            UserRepository users,
            UserPreferenceRepository preferences,
            UserAllergyRepository allergies,
            PantryItemRepository pantryItems,
            FavoriteRepository favorites,
            PriceAlertRepository priceAlerts,
            NotificationRepository notifications,
            RecommendationSessionRepository sessions,
            ShoppingPlanRepository shoppingPlans,
            ShoppingPlanItemRepository shoppingItems
    ) {
        this.ingredients = ingredients;
        this.prices = prices;
        this.nutritions = nutritions;
        this.careTips = careTips;
        this.storageTips = storageTips;
        this.recipes = recipes;
        this.recipeIngredients = recipeIngredients;
        this.recipeSteps = recipeSteps;
        this.creators = creators;
        this.reels = reels;
        this.stores = stores;
        this.storeOffers = storeOffers;
        this.users = users;
        this.preferences = preferences;
        this.allergies = allergies;
        this.pantryItems = pantryItems;
        this.favorites = favorites;
        this.priceAlerts = priceAlerts;
        this.notifications = notifications;
        this.sessions = sessions;
        this.shoppingPlans = shoppingPlans;
        this.shoppingItems = shoppingItems;
    }

    @Transactional
    public void seed() {
        Ingredient bomdong = ingredient("봄동", "채소", "https://images.unsplash.com/photo-1512621776951-a57141f2eefd", "봉");
        Ingredient radish = ingredient("무", "채소", "https://images.unsplash.com/photo-1598170845058-32b9d6a5da37", "개");
        Ingredient cabbage = ingredient("배추", "채소", "https://images.unsplash.com/photo-1594282486552-05b4d80fbb9f", "포기");
        Ingredient spinach = ingredient("시금치", "채소", "https://images.unsplash.com/photo-1576045057995-568f588f82fb", "단");
        Ingredient mandarin = ingredient("감귤", "과일", "https://images.unsplash.com/photo-1603664454146-50b9bb1e7afa", "kg");

        price(bomdong, "4500.00", "봉");
        price(radish, "2200.00", "개");
        price(cabbage, "6800.00", "포기");
        price(spinach, "3200.00", "단");
        price(mandarin, "9900.00", "kg");
        ingredientDetailData(bomdong);

        Recipe bibimbap = recipe("봄동 비빔밥", "봄동과 고추장 양념을 곁들인 한 그릇 식사", "https://images.unsplash.com/photo-1498654896293-37aacf113fd9", "EASY", 20, 2);
        recipeIngredient(bibimbap, bomdong, "1.00", "봉");
        recipeIngredient(bibimbap, radish, "0.50", "개");
        recipeStep(bibimbap, 1, "봄동을 씻어 한입 크기로 자릅니다.", 5);
        recipeStep(bibimbap, 2, "밥 위에 봄동과 무채를 올리고 양념장을 곁들입니다.", 10);

        Recipe muchae = recipe("무생채", "아삭한 무로 빠르게 만드는 반찬", "https://images.unsplash.com/photo-1546069901-ba9599a7e63c", "EASY", 15, 2);
        recipeIngredient(muchae, radish, "1.00", "개");
        recipeStep(muchae, 1, "무를 채 썰고 소금에 살짝 절입니다.", 7);

        Creator creator = creator();
        reel(bibimbap, creator, "봄동 비빔밥 1분 레시피", "봄동,무", 54);
        reel(muchae, creator, "무생채 빠르게 만들기", "무", 42);

        Store kurly = store("마켓컬리", "ONLINE", "컬", "#5f0080", "https://example.com/kurly");
        Store coupang = store("쿠팡", "ONLINE", "쿠", "#346aff", "https://example.com/coupang");
        Store oasis = store("오아시스", "ONLINE", "오", "#00a86b", "https://example.com/oasis");
        Store naver = store("네이버 장보기", "ONLINE", "N", "#03c75a", "https://example.com/naver-shopping");
        Store emart = store("이마트몰", "ONLINE", "E", "#ffd040", "https://example.com/emart");
        offer(kurly, bomdong, "4300.00", "봉", "샛별배송", "최저가");
        offer(coupang, bomdong, "4600.00", "봉", "로켓배송", "추천");
        offer(kurly, radish, "2100.00", "개", "샛별배송", "특가");
        offer(coupang, cabbage, "6500.00", "포기", "로켓배송", "인기");
        offer(oasis, spinach, "3100.00", "단", "새벽배송", "유기농");
        offer(naver, mandarin, "9600.00", "kg", "택배", "인기");
        offer(emart, cabbage, "6700.00", "포기", "쓱배송", "대형마트");

        User demoUser = users.findByEmail(DEMO_USER_EMAIL)
                .orElseGet(() -> users.save(new User(DEMO_USER_EMAIL, "제철데모", "https://example.com/demo-profile.png", "ACTIVE")));
        preference(demoUser);
        userData(demoUser, bomdong, radish, bibimbap);
    }

    private Ingredient ingredient(String name, String category, String imageUrl, String unit) {
        return ingredients.findAll().stream()
                .filter(ingredient -> ingredient.getName().equals(name))
                .findFirst()
                .orElseGet(() -> ingredients.save(new Ingredient(name, category, imageUrl, unit, true)));
    }

    private void price(Ingredient ingredient, String price, String unit) {
        boolean exists = prices.findByIngredientIdOrderByObservedDateAsc(ingredient.getId()).stream()
                .anyMatch(snapshot -> LocalDate.of(2026, 6, 1).equals(snapshot.getObservedDate()));
        if (!exists) {
            prices.save(new PriceSnapshot(ingredient.getId(), "DEMO", "PUBLIC_AVERAGE", new BigDecimal(price), unit, LocalDate.of(2026, 6, 1)));
        }
    }

    private void ingredientDetailData(Ingredient ingredient) {
        if (nutritions.findByIngredientId(ingredient.getId()).isEmpty()) {
            nutritions.save(new IngredientNutrition(ingredient.getId(), 22, new BigDecimal("4.30"), new BigDecimal("1.20"), new BigDecimal("2.00"), new BigDecimal("1.50"), new BigDecimal("0.20"), "28mg", "240mg", "64ug"));
        }
        if (careTips.findByIngredientIdOrderByTipOrderAsc(ingredient.getId()).isEmpty()) {
            careTips.save(new IngredientCareTip(ingredient.getId(), 1, "잎이 선명하고 줄기가 단단한 것을 고릅니다."));
        }
        if (storageTips.findByIngredientId(ingredient.getId()).isEmpty()) {
            storageTips.save(new IngredientStorageTip(ingredient.getId(), "냉장", "신문지에 싸서 세워 보관합니다.", "fridge"));
        }
    }

    private Recipe recipe(String title, String description, String imageUrl, String difficulty, int minutes, int servings) {
        return recipes.findAll().stream()
                .filter(recipe -> recipe.getTitle().equals(title))
                .findFirst()
                .orElseGet(() -> recipes.save(new Recipe(title, description, imageUrl, difficulty, minutes, servings, "PUBLISHED")));
    }

    private void recipeIngredient(Recipe recipe, Ingredient ingredient, String quantity, String unit) {
        boolean exists = recipeIngredients.findByRecipeIdOrderByIdAsc(recipe.getId()).stream()
                .anyMatch(item -> Objects.equals(item.getIngredientId(), ingredient.getId()));
        if (!exists) {
            recipeIngredients.save(new RecipeIngredient(recipe.getId(), ingredient.getId(), new BigDecimal(quantity), unit, false));
        }
    }

    private void recipeStep(Recipe recipe, int stepNumber, String description, int minutes) {
        boolean exists = recipeSteps.findByRecipeIdOrderByStepNumberAsc(recipe.getId()).stream()
                .anyMatch(step -> step.getStepNumber() == stepNumber);
        if (!exists) {
            recipeSteps.save(new RecipeStep(recipe.getId(), stepNumber, description, minutes, null));
        }
    }

    private Creator creator() {
        return creators.findAll().stream()
                .filter(creator -> creator.getDisplayName().equals("제철키친"))
                .findFirst()
                .orElseGet(() -> creators.save(new Creator(null, "제철키친", "https://example.com/creator.png", "ACTIVE")));
    }

    private void reel(Recipe recipe, Creator creator, String title, String tags, int seconds) {
        boolean exists = reels.findTop3ByRecipeIdAndStatusOrderByPublishedAtDesc(recipe.getId(), "PUBLISHED").stream()
                .anyMatch(reel -> reel.getTitle().equals(title));
        if (!exists) {
            reels.save(new Reel(recipe.getId(), creator.getId(), title, "데모 릴스", "https://example.com/demo.mp4", recipe.getImageUrl(), tags, seconds, "PUBLISHED", OffsetDateTime.now()));
        }
    }

    private Store store(String name, String type, String logoText, String color, String url) {
        return stores.findAll().stream()
                .filter(store -> store.getName().equals(name))
                .findFirst()
                .orElseGet(() -> stores.save(new Store(name, type, null, logoText, color, url, "SEOUL")));
    }

    private void offer(Store store, Ingredient ingredient, String price, String unit, String delivery, String badge) {
        boolean exists = storeOffers.findByIngredientIdOrderByPriceAsc(ingredient.getId()).stream()
                .anyMatch(offer -> Objects.equals(offer.getStoreId(), store.getId()));
        if (!exists) {
            BigDecimal amount = new BigDecimal(price);
            storeOffers.save(new StoreOffer(store.getId(), ingredient.getId(), amount, amount.subtract(BigDecimal.valueOf(100)), amount.add(BigDecimal.valueOf(300)), amount.add(BigDecimal.valueOf(500)), 10, unit, delivery, badge, store.getExternalUrl()));
        }
    }

    private void preference(User user) {
        UserPreference preference = preferences.findById(user.getId())
                .orElseGet(() -> new UserPreference(user.getId(), 2, BigDecimal.valueOf(30000), true, "LOW_PRICE"));
        preference.update(2, BigDecimal.valueOf(30000), true, "LOW_PRICE");
        preferences.save(preference);
        if (allergies.findByUserIdOrderByAllergyCodeAsc(user.getId()).isEmpty()) {
            allergies.saveAll(List.of(new UserAllergy(user.getId(), "EGG"), new UserAllergy(user.getId(), "MILK")));
        }
    }

    private void userData(User user, Ingredient bomdong, Ingredient radish, Recipe recipe) {
        if (pantryItems.findByUserIdOrderByIdDesc(user.getId()).isEmpty()) {
            pantryItems.save(new PantryItem(user.getId(), bomdong.getId(), BigDecimal.ONE, "봉", LocalDate.of(2026, 6, 10)));
        }
        if (favorites.findByUserIdOrderByIdDesc(user.getId()).isEmpty()) {
            favorites.save(new Favorite(user.getId(), "RECIPE", recipe.getId()));
        }
        if (priceAlerts.findByUserIdOrderByIdDesc(user.getId()).isEmpty()) {
            priceAlerts.save(new PriceAlert(user.getId(), radish.getId(), BigDecimal.valueOf(2000), true));
        }
        if (notifications.findByUserIdOrderByIdDesc(user.getId()).isEmpty()) {
            notifications.save(new Notification(user.getId(), "PRICE_DROP", "무 가격 하락", "무 가격이 설정 가격에 가까워졌습니다."));
            notifications.save(new Notification(user.getId(), "RECIPE_RECOMMENDATION", "봄동 비빔밥 추천", "오늘 저녁 메뉴로 봄동 비빔밥을 추천합니다."));
        }
        if (shoppingPlans.findAll().stream().noneMatch(plan -> Objects.equals(plan.getUserId(), user.getId()))) {
            RecommendationSession session = sessions.save(new RecommendationSession(user.getId(), "{\"days\":3,\"people\":2,\"budget\":30000}"));
            ShoppingPlan plan = shoppingPlans.save(new ShoppingPlan(user.getId(), session.getId(), 3, 2, BigDecimal.valueOf(30000)));
            shoppingItems.save(new ShoppingPlanItem(plan.getId(), bomdong.getId(), BigDecimal.ONE, "봉", BigDecimal.valueOf(4300)));
            shoppingItems.save(new ShoppingPlanItem(plan.getId(), radish.getId(), BigDecimal.ONE, "개", BigDecimal.valueOf(2100)));
            plan.setEstimatedTotal(BigDecimal.valueOf(6400));
        }
    }
}
