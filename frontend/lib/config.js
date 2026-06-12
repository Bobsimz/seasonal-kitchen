// 앱 전역 설정 — 환경변수로 덮어쓸 수 있습니다.

// 백엔드 베이스 URL. .env.local 에 NEXT_PUBLIC_API_BASE_URL 을 넣으면 바뀝니다.
export const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL?.replace(/\/$/, '') || 'http://localhost:8080';

export const API_PREFIX = '/api/v1';

// 데모 모드: 백엔드가 안 떠 있거나 호출이 실패하면 mock 데이터로 화면을 채웁니다.
// 'off' 로 두면 실제 API 만 사용합니다. 기본값은 'auto'(실패 시 자동 폴백).
//   auto | off
export const DEMO_FALLBACK = process.env.NEXT_PUBLIC_DEMO_FALLBACK || 'auto';

// localStorage 키
export const STORAGE_KEYS = {
  token: 'sk.accessToken',
  user: 'sk.user',
};
