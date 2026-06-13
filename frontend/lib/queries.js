// 화면에서 쓰는 react-query 훅 모음. 데이터 호출은 전부 endpoints.js 를 통합니다.
//   const { data, isLoading, error } = useHome();
'use client';

import { useMutation, useQuery, useInfiniteQuery, useQueryClient } from '@tanstack/react-query';
import { endpoints } from './endpoints';
import { useAuth } from './auth';

export const qk = {
  home: ['home'],
  search: (q, type) => ['search', q, type],
  trending: ['trending'],
  recentSearches: ['recent-searches'],
  ingredients: (params) => ['ingredients', params || {}],
  ingredient: (id) => ['ingredient', String(id)],
  ingredientPrices: (id) => ['ingredient', String(id), 'prices'],
  ingredientSubstitutes: (id) => ['ingredient', String(id), 'substitutes'],
  ingredientStoreOffers: (id) => ['ingredient', String(id), 'offers'],
  ingredientRecipes: (id) => ['ingredient', String(id), 'recipes'],
  ingredientProducers: (id) => ['ingredient', String(id), 'producers'],
  ingredientProducts: (id) => ['ingredient', String(id), 'products'],
  products: (params) => ['products', params || {}],
  product: (id) => ['product', String(id)],
  recipes: (params) => ['recipes', params || {}],
  recipe: (id) => ['recipe', String(id)],
  recipeSteps: (id) => ['recipe', String(id), 'steps'],
  reels: ['reels'],
  reel: (id) => ['reel', String(id)],
  reelComments: (id) => ['reel', String(id), 'comments'],
  producers: (params) => ['producers', params || {}],
  producer: (id) => ['producer', String(id)],
  producerOffers: (id) => ['producer', String(id), 'offers'],
  producerReviews: (id) => ['producer', String(id), 'reviews'],
  producerNews: (id) => ['producer', String(id), 'news'],
  myProducer: ['producer', 'me'],
  cart: ['cart'],
  orders: ['orders'],
  order: (id) => ['order', String(id)],
  favorites: ['favorites'],
  notifications: ['notifications'],
  priceAlerts: ['price-alerts'],
  mySummary: ['users', 'me', 'summary'],
};

const unwrapList = (d) => (Array.isArray(d) ? d : d?.items || []);

// 무한 스크롤 공통 헬퍼 — ListResponse({ items, page, hasNext })를 페이지 단위로 이어 받는다.
// 다음 페이지 파라미터는 응답의 hasNext/page 로 계산(없으면 종료 → 단일 페이지).
const PAGE_SIZE = 20;
function useInfiniteList(key, fetchPage, params) {
  const query = useInfiniteQuery({
    queryKey: [...key, 'infinite', params || {}],
    queryFn: ({ pageParam = 0 }) => fetchPage({ ...params, page: pageParam, size: PAGE_SIZE }),
    initialPageParam: 0,
    getNextPageParam: (last) => (last?.hasNext ? (last.page ?? 0) + 1 : undefined),
  });
  // 모든 페이지의 items 를 평탄화해 단일 배열로 노출.
  const items = (query.data?.pages ?? []).flatMap((p) => unwrapList(p));
  return { ...query, items };
}

// ── Home / Search ──────────────────────────────────────────
export const useHome = () => useQuery({ queryKey: qk.home, queryFn: endpoints.getHome });
export const useSearch = (q, type = 'ALL', enabled = true) =>
  useQuery({ queryKey: qk.search(q, type), queryFn: () => endpoints.search(q, type), enabled });
export const useTrending = () => useQuery({ queryKey: qk.trending, queryFn: endpoints.getTrending });
// 최근 검색 — 로그인 사용자 전용(/users/me/recent-searches). 비로그인 시 비활성 → 빈 배열.
// 백엔드는 [{keyword,searchCount}], 데모 mock 은 ['봄동',...] 를 주므로 키워드 문자열 배열로 통일한다.
export const useRecentSearches = () => {
  const { isAuthenticated } = useAuth();
  return useQuery({
    queryKey: qk.recentSearches,
    queryFn: endpoints.getRecentSearches,
    enabled: isAuthenticated,
    select: (d) => (Array.isArray(d) ? d : []).map((x) => (typeof x === 'string' ? x : x?.keyword)).filter(Boolean),
  });
};

// ── Ingredients ────────────────────────────────────────────
export const useIngredients = (params) =>
  useQuery({ queryKey: qk.ingredients(params), queryFn: () => endpoints.listIngredients(params), select: unwrapList });
export const useInfiniteIngredients = (params) =>
  useInfiniteList(['ingredients'], endpoints.listIngredients, params);
export const useIngredientCategories = () =>
  useQuery({ queryKey: ['ingredient-categories'], queryFn: endpoints.listIngredientCategories });
export const useIngredient = (id) =>
  useQuery({ queryKey: qk.ingredient(id), queryFn: () => endpoints.getIngredient(id), enabled: !!id });
export const useIngredientPrices = (id) =>
  useQuery({ queryKey: qk.ingredientPrices(id), queryFn: () => endpoints.getIngredientPrices(id), enabled: !!id });
export const useIngredientSubstitutes = (id) =>
  useQuery({ queryKey: qk.ingredientSubstitutes(id), queryFn: () => endpoints.getIngredientSubstitutes(id), enabled: !!id });
export const useIngredientStoreOffers = (id) =>
  useQuery({ queryKey: qk.ingredientStoreOffers(id), queryFn: () => endpoints.getIngredientStoreOffers(id), enabled: !!id });
export const useIngredientRecipes = (id) =>
  useQuery({ queryKey: qk.ingredientRecipes(id), queryFn: () => endpoints.getIngredientRecipes(id), enabled: !!id, select: unwrapList });
export const useIngredientProducers = (id) =>
  useQuery({ queryKey: qk.ingredientProducers(id), queryFn: () => endpoints.getIngredientProducers(id), enabled: !!id });
export const useIngredientProducts = (id) =>
  useQuery({ queryKey: qk.ingredientProducts(id), queryFn: () => endpoints.getIngredientProducts(id), enabled: !!id, select: unwrapList });

// ── Recipes ────────────────────────────────────────────────
export const useRecipes = (params) =>
  useQuery({ queryKey: qk.recipes(params), queryFn: () => endpoints.listRecipes(params), select: unwrapList });
export const useInfiniteRecipes = (params) =>
  useInfiniteList(['recipes'], endpoints.listRecipes, params);
export const useRecipeTags = () =>
  useQuery({ queryKey: ['recipe-tags'], queryFn: endpoints.listRecipeTags });
export const useRecipe = (id) =>
  useQuery({ queryKey: qk.recipe(id), queryFn: () => endpoints.getRecipe(id), enabled: !!id });
export const useRecipeSteps = (id) =>
  useQuery({ queryKey: qk.recipeSteps(id), queryFn: () => endpoints.getRecipeSteps(id), enabled: !!id });

// ── Reels ──────────────────────────────────────────────────
export const useReels = () => useQuery({ queryKey: qk.reels, queryFn: endpoints.listReels, select: unwrapList });
export const useReel = (id) => useQuery({ queryKey: qk.reel(id), queryFn: () => endpoints.getReel(id), enabled: !!id });
export const useReelComments = (id) =>
  useQuery({ queryKey: qk.reelComments(id), queryFn: () => endpoints.getReelComments(id), enabled: !!id });

// 좋아요/저장은 화면에서 낙관적으로 토글하고, 성공 시 피드(qk.reels)를 무효화해
// 서버 기준 카운트/내 상태(liked/saved)와 다시 맞춘다. (인자 boolean = 켜기/끄기)
export function useLikeReel(id) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (on) => (on ? endpoints.likeReel(id) : endpoints.unlikeReel(id)),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.reels }),
  });
}
export function useSaveReel(id) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (on) => (on ? endpoints.saveReel(id) : endpoints.unsaveReel(id)),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.reels }),
  });
}
export function useCommentReel(id) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (content) => endpoints.commentReel(id, { content }),
    onSuccess: (created) => {
      // 작성한 댓글을 목록에 즉시 추가(낙관적). 서버 응답이 곧 권위 있는 값이라 그대로 붙인다.
      if (created) {
        qc.setQueryData(qk.reelComments(id), (prev) => {
          const list = Array.isArray(prev) ? prev : prev?.items || [];
          return [...list, created];
        });
      }
      // 릴스 댓글 수 갱신.
      qc.invalidateQueries({ queryKey: qk.reels });
    },
  });
}

// ── Products ───────────────────────────────────────────────
export const useProducts = (params) =>
  useQuery({ queryKey: qk.products(params), queryFn: () => endpoints.listProducts(params), select: unwrapList });
export const useProduct = (id) =>
  useQuery({ queryKey: qk.product(id), queryFn: () => endpoints.getProduct(id), enabled: !!id });

// ── Producers ──────────────────────────────────────────────
export const useProducers = (params) =>
  useQuery({ queryKey: qk.producers(params), queryFn: () => endpoints.listProducers(params), select: unwrapList });
export const useInfiniteProducers = (params) =>
  useInfiniteList(['producers'], endpoints.listProducers, params);
export const useProducerRegions = () =>
  useQuery({ queryKey: ['producer-regions'], queryFn: endpoints.listProducerRegions });
export const useProducer = (id) =>
  useQuery({ queryKey: qk.producer(id), queryFn: () => endpoints.getProducer(id), enabled: !!id });
export const useProducerOffers = (id) =>
  useQuery({ queryKey: qk.producerOffers(id), queryFn: () => endpoints.getProducerOffers(id), enabled: !!id });
export const useProducerReviews = (id) =>
  useQuery({ queryKey: qk.producerReviews(id), queryFn: () => endpoints.getProducerReviews(id), enabled: !!id });
export const useProducerNews = (id) =>
  useQuery({ queryKey: qk.producerNews(id), queryFn: () => endpoints.getProducerNews(id), enabled: !!id });
// 인증 전용 조회 — 비로그인 시 실행하지 않는다(401 → 전역 SessionGate 모달이 공개 페이지에 뜨는 것 방지).
export const useMyProducer = () => {
  const { isAuthenticated } = useAuth();
  return useQuery({ queryKey: qk.myProducer, queryFn: endpoints.getMyProducer, enabled: isAuthenticated });
};

// ── MyPage / User ──────────────────────────────────────────
export const useMySummary = () => {
  const { isAuthenticated } = useAuth();
  return useQuery({ queryKey: qk.mySummary, queryFn: endpoints.getMySummary, enabled: isAuthenticated });
};
export const useSavePreferences = () => useMutation({ mutationFn: (body) => endpoints.savePreferences(body) });
export function useUpdateMe() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (body) => endpoints.updateMe(body),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.mySummary }),
  });
}

// ── Cart / Orders ──────────────────────────────────────────
export const useCart = () => {
  const { isAuthenticated } = useAuth();
  return useQuery({ queryKey: qk.cart, queryFn: endpoints.getCart, enabled: isAuthenticated });
};
export const useOrders = () => useQuery({ queryKey: qk.orders, queryFn: endpoints.listOrders });
export const useOrder = (id) => useQuery({ queryKey: qk.order(id), queryFn: () => endpoints.getOrder(id), enabled: !!id });

export function useAddToCart() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (body) => endpoints.addCartItem(body),
    onSuccess: (cart) => {
      qc.setQueryData?.(qk.cart, cart);
      qc.invalidateQueries({ queryKey: qk.cart });
    },
  });
}
export function useUpdateCartItem() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, qty }) => endpoints.updateCartItem(id, { qty }),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.cart }),
  });
}
export function useRemoveCartItem() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (id) => endpoints.removeCartItem(id),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.cart }),
  });
}
export function useCreateOrder() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: () => endpoints.createOrder(),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: qk.cart });
      qc.invalidateQueries({ queryKey: qk.orders });
    },
  });
}

// ── Favorites ──────────────────────────────────────────────
export const useFavorites = () => {
  const { isAuthenticated } = useAuth();
  return useQuery({ queryKey: qk.favorites, queryFn: endpoints.listFavorites, enabled: isAuthenticated });
};
export function useToggleFavorite() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ action, targetType, targetId, favoriteId }) =>
      action === 'add' ? endpoints.addFavorite({ targetType, targetId }) : endpoints.removeFavorite(favoriteId),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: qk.favorites });
      // 마이페이지 찜 카운트(users/me/summary)도 즉시 갱신.
      qc.invalidateQueries({ queryKey: qk.mySummary });
    },
  });
}

// ── Notifications ──────────────────────────────────────────
export const useNotifications = () => useQuery({ queryKey: qk.notifications, queryFn: endpoints.listNotifications });
export function useReadNotification() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ id, all }) => (all ? endpoints.readAllNotifications() : endpoints.readNotification(id)),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.notifications }),
  });
}

// ── Price alerts ───────────────────────────────────────────
export const usePriceAlerts = () => useQuery({ queryKey: qk.priceAlerts, queryFn: endpoints.listPriceAlerts });

// ── Reviews ────────────────────────────────────────────────
export function useCreateReview() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ producerId, ...body }) => endpoints.createReview(producerId, body),
    onSuccess: (_d, vars) => qc.invalidateQueries({ queryKey: qk.producerReviews(vars.producerId) }),
  });
}

// ── Seller (내 농가) ───────────────────────────────────────
export function useRegisterProducer() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (body) => endpoints.registerProducer(body),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.myProducer }),
  });
}
export function useAddMyOffer() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (body) => endpoints.addMyOffer(body),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.myProducer }),
  });
}
