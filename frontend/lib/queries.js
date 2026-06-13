// 화면에서 쓰는 react-query 훅 모음. 데이터 호출은 전부 endpoints.js 를 통합니다.
//   const { data, isLoading, error } = useHome();
'use client';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { endpoints } from './endpoints';

export const qk = {
  home: ['home'],
  search: (q, type) => ['search', q, type],
  trending: ['trending'],
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

// ── Home / Search ──────────────────────────────────────────
export const useHome = () => useQuery({ queryKey: qk.home, queryFn: endpoints.getHome });
export const useSearch = (q, type = 'ALL', enabled = true) =>
  useQuery({ queryKey: qk.search(q, type), queryFn: () => endpoints.search(q, type), enabled });
export const useTrending = () => useQuery({ queryKey: qk.trending, queryFn: endpoints.getTrending });

// ── Ingredients ────────────────────────────────────────────
export const useIngredients = (params) =>
  useQuery({ queryKey: qk.ingredients(params), queryFn: () => endpoints.listIngredients(params), select: unwrapList });
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
export const useRecipe = (id) =>
  useQuery({ queryKey: qk.recipe(id), queryFn: () => endpoints.getRecipe(id), enabled: !!id });
export const useRecipeSteps = (id) =>
  useQuery({ queryKey: qk.recipeSteps(id), queryFn: () => endpoints.getRecipeSteps(id), enabled: !!id });

// ── Reels ──────────────────────────────────────────────────
export const useReels = () => useQuery({ queryKey: qk.reels, queryFn: endpoints.listReels, select: unwrapList });
export const useReel = (id) => useQuery({ queryKey: qk.reel(id), queryFn: () => endpoints.getReel(id), enabled: !!id });
export const useReelComments = (id) =>
  useQuery({ queryKey: qk.reelComments(id), queryFn: () => endpoints.getReelComments(id), enabled: !!id });

// ── Products ───────────────────────────────────────────────
export const useProducts = (params) =>
  useQuery({ queryKey: qk.products(params), queryFn: () => endpoints.listProducts(params), select: unwrapList });
export const useProduct = (id) =>
  useQuery({ queryKey: qk.product(id), queryFn: () => endpoints.getProduct(id), enabled: !!id });

// ── Producers ──────────────────────────────────────────────
export const useProducers = (params) =>
  useQuery({ queryKey: qk.producers(params), queryFn: () => endpoints.listProducers(params), select: unwrapList });
export const useProducer = (id) =>
  useQuery({ queryKey: qk.producer(id), queryFn: () => endpoints.getProducer(id), enabled: !!id });
export const useProducerOffers = (id) =>
  useQuery({ queryKey: qk.producerOffers(id), queryFn: () => endpoints.getProducerOffers(id), enabled: !!id });
export const useProducerReviews = (id) =>
  useQuery({ queryKey: qk.producerReviews(id), queryFn: () => endpoints.getProducerReviews(id), enabled: !!id });
export const useProducerNews = (id) =>
  useQuery({ queryKey: qk.producerNews(id), queryFn: () => endpoints.getProducerNews(id), enabled: !!id });
export const useMyProducer = () => useQuery({ queryKey: qk.myProducer, queryFn: endpoints.getMyProducer });

// ── MyPage / User ──────────────────────────────────────────
export const useMySummary = () => useQuery({ queryKey: qk.mySummary, queryFn: endpoints.getMySummary });
export const useSavePreferences = () => useMutation({ mutationFn: (body) => endpoints.savePreferences(body) });
export function useUpdateMe() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (body) => endpoints.updateMe(body),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.mySummary }),
  });
}

// ── Cart / Orders ──────────────────────────────────────────
export const useCart = () => useQuery({ queryKey: qk.cart, queryFn: endpoints.getCart });
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
export const useFavorites = () => useQuery({ queryKey: qk.favorites, queryFn: endpoints.listFavorites });
export function useToggleFavorite() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ action, targetType, targetId, favoriteId }) =>
      action === 'add' ? endpoints.addFavorite({ targetType, targetId }) : endpoints.removeFavorite(favoriteId),
    onSuccess: () => qc.invalidateQueries({ queryKey: qk.favorites }),
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
