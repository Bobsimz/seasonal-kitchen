import { API_BASE_URL, API_PREFIX, STORAGE_KEYS } from './config';

// 백엔드 공통 에러를 감싼 예외. UI 는 code / message / fieldErrors 로 분기합니다.
export class ApiError extends Error {
  constructor({ code, message, fieldErrors, status }) {
    super(message || code || 'API_ERROR');
    this.name = 'ApiError';
    this.code = code || 'UNKNOWN';
    this.fieldErrors = fieldErrors || [];
    this.status = status;
  }

  // 백엔드가 안 떠 있거나 5xx 등 "연결/서버" 문제인지 (→ 데모 폴백 대상)
  get isConnectivity() {
    return this.code === 'NETWORK_ERROR' || (this.status != null && this.status >= 500);
  }
}

// ── 토큰 저장소 (클라이언트 전용) ───────────────────────────────
export function getToken() {
  if (typeof window === 'undefined') return null;
  return window.localStorage.getItem(STORAGE_KEYS.token);
}
export function setToken(token) {
  if (typeof window === 'undefined') return;
  if (token) window.localStorage.setItem(STORAGE_KEYS.token, token);
  else window.localStorage.removeItem(STORAGE_KEYS.token);
}

// ── 401(인증 만료/무효) 전역 통지 ──────────────────────────────
// auth 호출이 401 을 만나면 토큰을 비우고 구독자(AuthProvider)에게 알린다.
// DOM·라우터에 의존하지 않는 순수 pub/sub — UI 처리는 구독자가 한다.
const unauthorizedSubscribers = new Set();
export function onUnauthorized(cb) {
  unauthorizedSubscribers.add(cb);
  return () => unauthorizedSubscribers.delete(cb);
}
function emitUnauthorized(detail) {
  for (const cb of unauthorizedSubscribers) {
    try {
      cb(detail);
    } catch {
      /* 구독자 오류는 통지를 막지 않는다 */
    }
  }
}

// ── 핵심 fetch 래퍼 ─────────────────────────────────────────────
// path 는 '/auth/login' 처럼 prefix 이후 부분만 넘깁니다.
// 반환값은 공통 래퍼를 벗긴 data 입니다. 실패 시 ApiError 를 던집니다.
export async function apiFetch(
  path,
  { method = 'GET', body, params, auth = false, background = false, signal } = {},
) {
  const url = new URL(`${API_BASE_URL}${API_PREFIX}${path}`);
  if (params) {
    for (const [k, v] of Object.entries(params)) {
      if (v !== undefined && v !== null && v !== '') url.searchParams.set(k, String(v));
    }
  }

  const isFormData = body instanceof FormData;
  const headers = isFormData ? {} : { 'Content-Type': 'application/json' };
  let attachedToken = null;
  if (auth) {
    attachedToken = getToken();
    if (attachedToken) headers.Authorization = `Bearer ${attachedToken}`;
  }

  let res;
  try {
    res = await fetch(url.toString(), {
      method,
      headers,
      body: isFormData ? body : body != null ? JSON.stringify(body) : undefined,
      signal,
    });
  } catch (e) {
    // 네트워크 단절 / CORS / 백엔드 미기동
    throw new ApiError({ code: 'NETWORK_ERROR', message: '서버에 연결할 수 없어요.', status: 0 });
  }

  let payload = null;
  try {
    payload = await res.json();
  } catch {
    // 본문이 비었거나 JSON 이 아님
  }

  if (!res.ok || (payload && payload.success === false)) {
    // 인증 만료/무효: 잘못된 토큰을 비우고 전역 구독자에게 알린다.
    // background(fire-and-forget 분석 등) 호출은 모달을 띄우지 않는다.
    if (res.status === 401 && auth && !background) {
      setToken(null);
      emitUnauthorized({ hadToken: !!attachedToken });
    }
    const err = payload?.error || {};
    throw new ApiError({
      code: err.code,
      message: err.message || `요청에 실패했어요 (${res.status})`,
      fieldErrors: err.fieldErrors,
      status: res.status,
    });
  }

  // 공통 래퍼({success,data,error})면 data 를, 아니면 본문 전체를 반환
  return payload && 'data' in payload ? payload.data : payload;
}

export const api = {
  get: (path, opts) => apiFetch(path, { ...opts, method: 'GET' }),
  post: (path, body, opts) => apiFetch(path, { ...opts, method: 'POST', body }),
  patch: (path, body, opts) => apiFetch(path, { ...opts, method: 'PATCH', body }),
  put: (path, body, opts) => apiFetch(path, { ...opts, method: 'PUT', body }),
  del: (path, opts) => apiFetch(path, { ...opts, method: 'DELETE' }),
};
