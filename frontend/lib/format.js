// 표시용 포맷 헬퍼 — 금액/날짜/숫자. (백엔드는 숫자만 주고, 콤마/원 표시는 프론트 담당)

const toNumber = (v) => (typeof v === 'string' ? Number(v.replace(/,/g, '')) : v);

// 2400 → "2,400"
export function won(value) {
  const n = toNumber(value);
  if (n == null || Number.isNaN(n)) return '-';
  return n.toLocaleString('ko-KR');
}

// 2400 → "2,400원"
export function wonLabel(value) {
  return `${won(value)}원`;
}

// 가격 ±pct 범위 "2,160~2,640" (리테일 시세 추정 표시용)
export function priceRange(value, pct = 0.1) {
  const n = toNumber(value);
  if (n == null || Number.isNaN(n)) return '-';
  const lo = Math.round(n * (1 - pct));
  const hi = Math.round(n * (1 + pct));
  return `${lo.toLocaleString('ko-KR')}~${hi.toLocaleString('ko-KR')}`;
}

// 큰 숫자 축약: 1280 → "1.3천", 15000 → "1.5만"
export function compact(value) {
  const n = toNumber(value) || 0;
  if (n >= 10000) return `${(n / 10000).toFixed(n % 10000 === 0 ? 0 : 1)}만`;
  if (n >= 1000) return `${(n / 1000).toFixed(n % 1000 === 0 ? 0 : 1)}천`;
  return String(n);
}

// ISO 문자열 → "2026.06.10"
export function date(iso) {
  if (!iso) return '';
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return '';
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}.${m}.${day}`;
}

// ISO 문자열 → "방금 전 / N분 전 / N시간 전 / N일 전 / 날짜"
export function relativeTime(iso) {
  if (!iso) return '';
  const d = new Date(iso);
  const now = Date.now();
  const diff = Math.round((now - d.getTime()) / 1000);
  if (Number.isNaN(diff)) return '';
  if (diff < 60) return '방금 전';
  if (diff < 3600) return `${Math.floor(diff / 60)}분 전`;
  if (diff < 86400) return `${Math.floor(diff / 3600)}시간 전`;
  if (diff < 604800) return `${Math.floor(diff / 86400)}일 전`;
  return date(iso);
}
