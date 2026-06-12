// 데모 모드에서 장바구니/주문/찜/내농가의 "쓰기" 상태를 클라이언트에 유지합니다.
// localStorage 에 저장해 새로고침해도 남습니다. 백엔드가 켜지면 이 파일은 쓰이지 않습니다.

import { getProducer, producerOffers, demoUser } from './data';

const KEY = 'sk.demoStore';

const empty = () => ({ cartItems: [], orders: [], favorites: [], myProducer: null, myOffers: [] });

function read() {
  if (typeof window === 'undefined') return empty();
  try {
    return { ...empty(), ...JSON.parse(window.localStorage.getItem(KEY) || '{}') };
  } catch {
    return empty();
  }
}
function write(s) {
  if (typeof window === 'undefined') return;
  window.localStorage.setItem(KEY, JSON.stringify(s));
}

// offerId 로 offer 정보를 역추적 (모든 농가 offer 를 훑음)
function findOffer(offerId) {
  for (const p of [1, 2, 3, 4, 5, 6, 7, 8]) {
    const off = producerOffers(p).find((o) => o.id === Number(offerId));
    if (off) return off;
  }
  return null;
}

// 장바구니를 농가별 그룹 + 합계로 직렬화 (API CartResponse 형태)
function serializeCart(s) {
  const byProducer = {};
  for (const it of s.cartItems) {
    (byProducer[it.producerId] ||= []).push(it);
  }
  const groups = Object.entries(byProducer).map(([producerId, items]) => {
    const subtotal = items.reduce((sum, it) => sum + it.unitPrice * it.qty, 0);
    const shipping = subtotal >= 30000 ? 0 : 3000;
    return {
      producerId: Number(producerId),
      producerName: items[0].producerName,
      items: items.map((it) => ({
        cartItemId: it.cartItemId,
        ingredientName: it.ingredientName,
        qty: it.qty,
        unitPrice: it.unitPrice,
        unit: it.unit,
        imageUrl: it.imageUrl,
      })),
      subtotal,
      shipping,
    };
  });
  const itemsTotal = groups.reduce((s2, g) => s2 + g.subtotal, 0);
  const shippingTotal = groups.reduce((s2, g) => s2 + g.shipping, 0);
  return { groups, itemsTotal, shippingTotal, payTotal: itemsTotal + shippingTotal };
}

let _cartSeq = 1;
let _orderSeq = 5000;
let _favSeq = 1;

export const demoStore = {
  getCart() {
    return serializeCart(read());
  },
  addCartItem(offerId, qty = 1) {
    const s = read();
    const offer = findOffer(offerId);
    if (!offer) return serializeCart(s);
    const existing = s.cartItems.find((it) => it.offerId === Number(offerId));
    if (existing) existing.qty += qty;
    else
      s.cartItems.push({
        cartItemId: _cartSeq++,
        offerId: Number(offerId),
        producerId: offer.producerId,
        producerName: offer.producerName,
        ingredientName: offer.ingredientName,
        unitPrice: offer.price,
        unit: offer.unit,
        imageUrl: offer.imageUrl || null,
        qty,
      });
    write(s);
    return serializeCart(s);
  },
  updateCartItem(cartItemId, qty) {
    const s = read();
    const it = s.cartItems.find((x) => x.cartItemId === Number(cartItemId));
    if (it) it.qty = Math.max(1, qty);
    write(s);
    return serializeCart(s);
  },
  removeCartItem(cartItemId) {
    const s = read();
    s.cartItems = s.cartItems.filter((x) => x.cartItemId !== Number(cartItemId));
    write(s);
    return serializeCart(s);
  },
  createOrder() {
    const s = read();
    const cart = serializeCart(s);
    const id = ++_orderSeq;
    const order = {
      id,
      orderNumber: `2026${id}-DEMO`,
      status: 'PAID',
      itemsTotal: cart.itemsTotal,
      shippingFee: cart.shippingTotal,
      totalAmount: cart.payTotal,
      pointsEarned: Math.round(cart.itemsTotal * 0.01),
      orderedAt: new Date().toISOString(),
      summary: cart.groups[0]
        ? `${cart.groups[0].items[0]?.ingredientName} 외 ${s.cartItems.length - 1}건`
        : '주문',
      items: s.cartItems.map((it) => ({
        producerName: it.producerName,
        ingredientName: it.ingredientName,
        qty: it.qty,
        unitPrice: it.unitPrice,
      })),
    };
    s.orders.unshift(order);
    s.cartItems = [];
    write(s);
    return order;
  },
  listOrders() {
    return read().orders;
  },
  getOrder(id) {
    return read().orders.find((o) => o.id === Number(id)) || null;
  },
  listFavorites() {
    return read().favorites;
  },
  addFavorite(targetType, targetId) {
    const s = read();
    const fav = { id: _favSeq++, targetType, targetId: Number(targetId) };
    s.favorites.push(fav);
    write(s);
    return fav;
  },
  removeFavorite(favoriteId) {
    const s = read();
    s.favorites = s.favorites.filter((f) => f.id !== Number(favoriteId));
    write(s);
  },
  getMyProducer() {
    return read().myProducer;
  },
  registerProducer(payload) {
    const s = read();
    s.myProducer = {
      id: 999,
      ...payload,
      rating: 0,
      reviewCount: 0,
      honorary: false,
    };
    write(s);
    return s.myProducer;
  },
  addMyOffer(payload) {
    const s = read();
    const offer = { id: 9000 + s.myOffers.length, producerId: 999, producerName: s.myProducer?.name || '내 농가', ...payload };
    s.myOffers.push(offer);
    if (s.myProducer && !s.myProducer.specialties?.includes(payload.ingredientName)) {
      s.myProducer.specialties = [...(s.myProducer.specialties || []), payload.ingredientName];
    }
    write(s);
    return offer;
  },
  listMyOffers() {
    return read().myOffers;
  },
};
