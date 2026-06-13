// 도메인별 API 호출 함수. 실 백엔드를 직접 호출합니다.
// 화면(컴포넌트)은 이 파일의 함수만 쓰면 됩니다. 실패 시 ApiError 를 던집니다.

import { api } from './api';

export const endpoints = {
  // ── Auth ───────────────────────────────────────────────
  signup: (body) => api.post('/auth/signup', body),
  login: (body) => api.post('/auth/login', body),

  // ── User / MyPage ──────────────────────────────────────
  getMe: () => api.get('/users/me', { auth: true }),
  updateMe: (body) => api.patch('/users/me', body, { auth: true }),
  getMySummary: () => api.get('/users/me/summary', { auth: true }),
  savePreferences: (body) => api.put('/users/me/preferences', body, { auth: true }),
  getRecentSearches: () => api.get('/users/me/recent-searches', { auth: true }),

  // ── Home / Search ──────────────────────────────────────
  getHome: () => api.get('/home'),
  search: (q, type = 'ALL') => api.get('/search', { params: { q, type } }),
  getTrending: () => api.get('/search/trending'),

  // ── Curations ──────────────────────────────────────────
  getCuration: (id) => api.get(`/curations/${id}`),

  // ── Ingredients ────────────────────────────────────────
  listIngredients: (params) => api.get('/ingredients', { params }),
  listIngredientCategories: () => api.get('/ingredients/categories'),
  getIngredient: (id) => api.get(`/ingredients/${id}`),
  getIngredientPrices: (id) => api.get(`/ingredients/${id}/prices`),
  getIngredientSubstitutes: (id) => api.get(`/ingredients/${id}/substitutes`),
  getIngredientStoreOffers: (id) => api.get(`/ingredients/${id}/offers`),
  getIngredientRecipes: (id) => api.get(`/ingredients/${id}/recipes`),
  getIngredientProducers: (id) => api.get(`/ingredients/${id}/producers`),
  getIngredientProducts: (id) => api.get(`/ingredients/${id}/products`),

  // ── Recipes ────────────────────────────────────────────
  listRecipes: (params) => api.get('/recipes', { params }),
  listRecipeTags: () => api.get('/recipes/tags'),
  getRecipe: (id) => api.get(`/recipes/${id}`),
  getRecipeSteps: (id) => api.get(`/recipes/${id}/steps`),

  // ── Reels ──────────────────────────────────────────────
  listReels: () => api.get('/reels'),
  getReel: (id) => api.get(`/reels/${id}`),
  getReelComments: (id) => api.get(`/reels/${id}/comments`),
  likeReel: (id) => api.post(`/reels/${id}/likes`, {}, { auth: true }),
  unlikeReel: (id) => api.del(`/reels/${id}/likes`, { auth: true }),
  saveReel: (id) => api.post(`/reels/${id}/saves`, {}, { auth: true }),
  unsaveReel: (id) => api.del(`/reels/${id}/saves`, { auth: true }),
  commentReel: (id, body) => api.post(`/reels/${id}/comments`, body, { auth: true }),

  // ── Products ───────────────────────────────────────────
  listProducts: (params) => api.get('/products', { params }),
  getProduct: (id) => api.get(`/products/${id}`),

  // ── Producers ──────────────────────────────────────────
  listProducers: (params) => api.get('/producers', { params }),
  listProducerRegions: () => api.get('/producers/regions'),
  getProducer: (id) => api.get(`/producers/${id}`),
  getProducerOffers: (id) => api.get(`/producers/${id}/offers`),
  getProducerReviews: (id) => api.get(`/producers/${id}/reviews`),
  getProducerNews: (id) => api.get(`/producers/${id}/news`),
  createReview: (producerId, body) =>
    api.post(`/producers/${producerId}/reviews`, body, { auth: true }),

  // 내 농가 (자가등록)
  getMyProducer: () => api.get('/producers/me', { auth: true }),
  registerProducer: (body) => api.post('/producers/me', body, { auth: true }),
  addMyOffer: (body) => api.post('/producers/me/offers', body, { auth: true }),
  getMyOffers: () => api.get('/producers/me/offers', { auth: true }),
  getMyStats: () => api.get('/producers/me/stats', { auth: true }),
  listMyOffers: () => api.get('/producers/me/offers', { auth: true }),

  // AI 상품 생성
  analyzeOfferPhoto: (formData) =>
    api.post('/producers/me/offers/analyze-photo', formData, { auth: true }),
  generateDescription: (body) =>
    api.post('/producers/me/offers/generate-description', body, { auth: true }),
  generateImage: (body) => api.post('/producers/me/offers/generate-image', body, { auth: true }),

  // ── Uploads ────────────────────────────────────────────
  uploadImage: (formData) => api.post('/uploads', formData, { auth: true }),
  uploadImages: (formData) => api.post('/uploads/batch', formData, { auth: true }),

  // ── Cart / Orders ──────────────────────────────────────
  getCart: () => api.get('/cart', { auth: true }),
  // 백엔드 계약: { offerId, qty, offerOptionId? }. 선택 옵션의 id 만 보낸다(없으면 null).
  addCartItem: ({ offerId, qty, option }) =>
    api.post('/cart/items', { offerId, qty, offerOptionId: option?.id ?? null }, { auth: true }),
  updateCartItem: (id, body) => api.patch(`/cart/items/${id}`, body, { auth: true }),
  removeCartItem: (id) => api.del(`/cart/items/${id}`, { auth: true }),
  createOrder: () => api.post('/orders', {}, { auth: true }),
  listOrders: () => api.get('/orders', { auth: true }),
  getOrder: (id) => api.get(`/orders/${id}`, { auth: true }),

  // ── Favorites ──────────────────────────────────────────
  listFavorites: () => api.get('/favorites', { auth: true }),
  addFavorite: (body) => api.post('/favorites', body, { auth: true }),
  removeFavorite: (id) => api.del(`/favorites/${id}`, { auth: true }),

  // ── Notifications ──────────────────────────────────────
  listNotifications: () => api.get('/notifications', { auth: true }),
  readNotification: (id) => api.patch(`/notifications/${id}/read`, {}, { auth: true }),
  readAllNotifications: () => api.patch('/notifications/read-all', {}, { auth: true }),

  // ── Price alerts ───────────────────────────────────────
  listPriceAlerts: () => api.get('/price-alerts', { auth: true }),
  createPriceAlert: (body) => api.post('/price-alerts', body, { auth: true }),
  updatePriceAlert: (id, body) => api.patch(`/price-alerts/${id}`, body, { auth: true }),
  deletePriceAlert: (id) => api.del(`/price-alerts/${id}`, { auth: true }),

  // ── Analytics (fire-and-forget) ────────────────────────
  // background: 401 이어도 로그인 모달을 띄우지 않는다(공개 화면에서 백그라운드 전송).
  track: (body) => api.post('/events', body, { auth: true, background: true }).catch(() => {}),
};
