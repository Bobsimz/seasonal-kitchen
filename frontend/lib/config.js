// 앱 전역 설정 — 환경변수로 덮어쓸 수 있습니다.

// 백엔드 베이스 URL. .env.local 에 NEXT_PUBLIC_API_BASE_URL 을 넣으면 바뀝니다.
export const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL?.replace(/\/$/, '') || 'http://localhost:8080';

export const API_PREFIX = '/api/v1';

// localStorage 키
export const STORAGE_KEYS = {
  token: 'sk.accessToken',
  user: 'sk.user',
};
