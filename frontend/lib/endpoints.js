// 도메인별 API 호출 함수. 각 함수는 실제 백엔드를 먼저 호출하고,
// 데모 폴백이 켜져 있고(기본) 연결/서버 오류면 mock 데이터를 반환합니다.
// 화면(컴포넌트)은 이 파일의 함수만 쓰면 되고, 백엔드 유무를 몰라도 됩니다.

import { api, ApiError } from './api';
import { DEMO_FALLBACK } from './config';
import * as mock from './mock/data';
import { demoStore } from './mock/store';

async function withFallback(real, mockFn) {
  if (DEMO_FALLBACK === 'off') return real();
  try {
    return await real();
  } catch (e) {
    // 백엔드가 의도적으로 돌려준 4xx(검증/인증 실패 등)는 그대로 노출
    if (e instanceof ApiError && !e.isConnectivity) throw e;
    return mockFn();
  }
}

export const endpoints = {
  // ── Auth ───────────────────────────────────────────────
  signup: (body) =>
    withFallback(
      () => api.post('/auth/signup', body),
      () => ({ accessToken: 'demo-token', tokenType: 'Bearer', userId: 1, nickname: body.nickname || '제철러버' }),
    ),
  login: (body) =>
    withFallback(
      () => api.post('/auth/login', body),
      () => ({ accessToken: 'demo-token', tokenType: 'Bearer', userId: 1, nickname: '제철러버' }),
    ),

  // ── User / MyPage ──────────────────────────────────────
  getMe: () => withFallback(() => api.get('/users/me', { auth: true }), () => mock.demoUser),
  updateMe: (body) => withFallback(() => api.patch('/users/me', body, { auth: true }), () => ({ ...mock.demoUser, ...body })),
  getMySummary: () => withFallback(() => api.get('/users/me/summary', { auth: true }), () => mock.userSummary()),
  savePreferences: (body) => withFallback(() => api.put('/users/me/preferences', body, { auth: true }), () => body),
  getRecentSearches: () => withFallback(() => api.get('/users/me/recent-searches', { auth: true }), () => mock.recentSearches()),

  // ── Home / Search ──────────────────────────────────────
  getHome: () => withFallback(() => api.get('/home'), () => mock.home()),
  search: (q, type = 'ALL') => withFallback(() => api.get('/search', { params: { q, type } }), () => mock.search(q, type)),
  getTrending: () => withFallback(() => api.get('/search/trending'), () => mock.trending()),

  // ── Curations ──────────────────────────────────────────
  getCuration: (id) => withFallback(() => api.get(`/curations/${id}`), () => mock.curation(id)),

  // ── Ingredients ────────────────────────────────────────
  listIngredients: (params) => withFallback(() => api.get('/ingredients', { params }), () => ({ items: mock.listIngredients() })),
  listIngredientCategories: () => withFallback(() => api.get('/ingredients/categories'), () => []),
  getIngredient: (id) => withFallback(() => api.get(`/ingredients/${id}`), () => mock.getIngredient(id)),
  getIngredientPrices: (id) => withFallback(() => api.get(`/ingredients/${id}/prices`), () => mock.ingredientPrices(id)),
  getIngredientSubstitutes: (id) => withFallback(() => api.get(`/ingredients/${id}/substitutes`), () => mock.ingredientSubstitutes(id)),
  getIngredientStoreOffers: (id) => withFallback(() => api.get(`/ingredients/${id}/offers`), () => mock.ingredientStoreOffers(id)),
  getIngredientRecipes: (id) => withFallback(() => api.get(`/ingredients/${id}/recipes`), () => mock.recipesForIngredient(id)),
  getIngredientProducers: (id) => withFallback(() => api.get(`/ingredients/${id}/producers`), () => mock.ingredientProducers(id)),
  getIngredientProducts: (id) => withFallback(() => api.get(`/ingredients/${id}/products`), () => mock.ingredientProducts(id)),

  // ── Recipes ────────────────────────────────────────────
  listRecipes: (params) => withFallback(() => api.get('/recipes', { params }), () => ({ items: mock.listRecipes() })),
  listRecipeTags: () => withFallback(() => api.get('/recipes/tags'), () => []),
  getRecipe: (id) => withFallback(() => api.get(`/recipes/${id}`), () => mock.getRecipe(id)),
  getRecipeSteps: (id) => withFallback(() => api.get(`/recipes/${id}/steps`), () => mock.recipeSteps(id)),

  // ── Reels ──────────────────────────────────────────────
  listReels: () => withFallback(() => api.get('/reels'), () => ({ items: mock.reels })),
  getReel: (id) => withFallback(() => api.get(`/reels/${id}`), () => mock.getReel(id)),
  getReelComments: (id) => withFallback(() => api.get(`/reels/${id}/comments`), () => mock.reelComments(id)),
  likeReel: (id) => withFallback(() => api.post(`/reels/${id}/likes`, {}, { auth: true }), () => ({ liked: true })),
  unlikeReel: (id) => withFallback(() => api.del(`/reels/${id}/likes`, { auth: true }), () => ({ liked: false })),
  saveReel: (id) => withFallback(() => api.post(`/reels/${id}/saves`, {}, { auth: true }), () => ({ saved: true })),
  unsaveReel: (id) => withFallback(() => api.del(`/reels/${id}/saves`, { auth: true }), () => ({ saved: false })),
  commentReel: (id, body) => withFallback(
    () => api.post(`/reels/${id}/comments`, body, { auth: true }),
    () => ({
      id: Date.now(),
      reelId: Number(id),
      userId: mock.demoUser.id,
      nickname: mock.demoUser.nickname,
      profileImageUrl: mock.demoUser.photoUrl,
      content: body.content,
      createdAt: new Date().toISOString(),
    }),
  ),

  // ── Products ───────────────────────────────────────────
  listProducts: (params) => withFallback(() => api.get('/products', { params }), () => mock.products(params)),
  getProduct: (id) => withFallback(() => api.get(`/products/${id}`), () => mock.productDetail(id)),

  // ── Producers ──────────────────────────────────────────
  listProducers: (params) => withFallback(() => api.get('/producers', { params }), () => ({ items: mock.producers, page: 0, size: 20, totalElements: mock.producers.length, hasNext: false })),
  listProducerRegions: () => withFallback(() => api.get('/producers/regions'), () => []),
  getProducer: (id) => withFallback(() => api.get(`/producers/${id}`), () => mock.getProducer(id)),
  getProducerOffers: (id) => withFallback(() => api.get(`/producers/${id}/offers`), () => mock.producerOffers(id)),
  getProducerReviews: (id) => withFallback(() => api.get(`/producers/${id}/reviews`), () => mock.producerReviews(id)),
  getProducerNews: (id) => withFallback(() => api.get(`/producers/${id}/news`), () => mock.producerNews(id)),
  createReview: (producerId, body) => withFallback(() => api.post(`/producers/${producerId}/reviews`, body, { auth: true }), () => ({ id: Date.now(), author: '나', ...body, createdAt: new Date().toISOString() })),

  // 내 농가 (자가등록)
  getMyProducer: () => withFallback(() => api.get('/producers/me', { auth: true }), () => demoStore.getMyProducer()),
  registerProducer: (body) => withFallback(() => api.post('/producers/me', body, { auth: true }), () => demoStore.registerProducer(body)),
  addMyOffer: (body) => withFallback(() => api.post('/producers/me/offers', body, { auth: true }), () => demoStore.addMyOffer(body)),
  listMyOffers: () => withFallback(() => Promise.reject(new ApiError({ code: 'NETWORK_ERROR', status: 0 })), () => demoStore.listMyOffers()),

  // ── Cart / Orders ──────────────────────────────────────
  getCart: () => withFallback(() => api.get('/cart', { auth: true }), () => demoStore.getCart()),
  // 실 백엔드 계약은 { offerId, qty, offerOptionId? }. 선택 옵션의 id 만 보낸다(없으면 null).
  // 데모 폴백에는 옵션 단가/라벨 스냅샷용으로 option 객체 전체를 넘긴다.
  addCartItem: ({ offerId, qty, option }) => withFallback(
    () => api.post('/cart/items', { offerId, qty, offerOptionId: option?.id ?? null }, { auth: true }),
    () => demoStore.addCartItem(offerId, qty, option),
  ),
  updateCartItem: (id, body) => withFallback(() => api.patch(`/cart/items/${id}`, body, { auth: true }), () => demoStore.updateCartItem(id, body.qty)),
  removeCartItem: (id) => withFallback(() => api.del(`/cart/items/${id}`, { auth: true }), () => demoStore.removeCartItem(id)),
  createOrder: () => withFallback(() => api.post('/orders', {}, { auth: true }), () => demoStore.createOrder()),
  listOrders: () => withFallback(() => api.get('/orders', { auth: true }), () => demoStore.listOrders()),
  getOrder: (id) => withFallback(() => api.get(`/orders/${id}`, { auth: true }), () => demoStore.getOrder(id)),

  // ── Favorites ──────────────────────────────────────────
  listFavorites: () => withFallback(() => api.get('/favorites', { auth: true }), () => demoStore.listFavorites()),
  addFavorite: (body) => withFallback(() => api.post('/favorites', body, { auth: true }), () => demoStore.addFavorite(body.targetType, body.targetId)),
  removeFavorite: (id) => withFallback(() => api.del(`/favorites/${id}`, { auth: true }), () => demoStore.removeFavorite(id)),

  // ── Notifications ──────────────────────────────────────
  listNotifications: () => withFallback(() => api.get('/notifications', { auth: true }), () => mock.notifications()),
  readNotification: (id) => withFallback(() => api.patch(`/notifications/${id}/read`, {}, { auth: true }), () => ({ id })),
  readAllNotifications: () => withFallback(() => api.patch('/notifications/read-all', {}, { auth: true }), () => ({ ok: true })),

  // ── Price alerts ───────────────────────────────────────
  listPriceAlerts: () => withFallback(() => api.get('/price-alerts', { auth: true }), () => mock.priceAlerts()),
  createPriceAlert: (body) => withFallback(() => api.post('/price-alerts', body, { auth: true }), () => ({ id: Date.now(), ...body, active: true })),
  updatePriceAlert: (id, body) => withFallback(() => api.patch(`/price-alerts/${id}`, body, { auth: true }), () => ({ id, ...body })),
  deletePriceAlert: (id) => withFallback(() => api.del(`/price-alerts/${id}`, { auth: true }), () => ({ ok: true })),

  // ── Analytics (fire-and-forget) ────────────────────────
  // background: 401 이어도 로그인 모달을 띄우지 않는다(공개 화면에서 백그라운드 전송).
  track: (body) => api.post('/events', body, { auth: true, background: true }).catch(() => {}),
};
