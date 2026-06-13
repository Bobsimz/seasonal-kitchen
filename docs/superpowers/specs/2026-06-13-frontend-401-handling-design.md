# 프론트엔드 401 처리 설계

작성일: 2026-06-13 · 범위: `frontend/`

## 문제

백엔드가 `auth:true` 호출에 401(토큰 만료/무효)을 돌려줄 때 프론트가 이를 처리하지 않는다.

- `lib/api.js`의 `ApiError`는 401을 `isConnectivity=false`로 분류한다(연결 오류는 NETWORK_ERROR·5xx만).
- `lib/endpoints.js`의 `withFallback`은 connectivity 오류만 mock으로 폴백하고, 401은 그대로 **rethrow** → 컴포넌트에서 react-query 에러로 노출(무의미한 `retry:1` 후).
- 결과: 화면이 깨지고, **만료된 토큰·user가 localStorage에 남아** 앱은 여전히 "로그인됨"으로 보이지만 모든 인증 호출이 401을 반복하는 고장 상태가 된다.
- 현재 401/인증 게이트는 `MyPage`의 인라인 `LoginPromptCard`(`!isAuthenticated` 기준) 외에는 없다.

## 목표 동작 (사용자 합의)

토큰이 필요한 자원이 401을 돌려주면 **강제 리다이렉트 대신 안내 모달을 띄워 사용자가 로그인을 "선택"** 하게 한다. 로그인 성공 시 **원래 경로로 복귀**한다.

## 트리거 조건 (데모 안전)

401 처리는 `apiFetch`에서 **`auth:true` 호출일 때만** 발동한다.

- 로그인/회원가입은 `auth:true`가 아니므로 자연히 제외 → 자격증명 실패는 폼 인라인 에러 유지.
- `DEMO_FALLBACK='auto'`에서 백엔드가 꺼져 있으면 모든 호출이 connectivity로 mock 폴백되어 **401 자체가 발생하지 않는다** → 데모 둘러보기 영향 없음.
- 즉 이 처리는 "백엔드는 살아있고 토큰이 만료/무효"인 경우에만 작동한다.
- 분석 전송(`track` → `/events`)은 fire-and-forget이므로 `background:true`로 게이트에서 제외(공개 화면에서 모달이 뜨지 않게).

## 아키텍처 — 단일 길목(apiFetch) + pub/sub

선택지 비교:

- **(A) react-query 전역 onError** — `track` 등 비-react-query 호출을 놓치고, QueryClient가 AuthProvider 밖에서 생성돼 컨텍스트 접근이 번거롭다.
- **(B) `apiFetch` + 경량 pub/sub → AuthProvider 구독** ✅ 채택 — 모든 백엔드 호출이 거치는 단일 길목. 프레임워크 비의존 emit, AuthProvider가 구독해 컨텍스트/모달 처리.
- **(C) 페이지별 가드 훅** — 10여 개 페이지 보일러플레이트·누락 위험.

## 데이터 흐름

1. **`lib/api.js`**
   - 모듈 레벨 구독 레지스트리 `onUnauthorized(cb) → unsubscribe`, 내부 `emitUnauthorized(detail)`.
   - `apiFetch(path, { ..., background = false })`: 에러 분기에서 `res.status === 401 && auth && !background`이면 토큰을 비우고(`setToken(null)`) `emitUnauthorized({ hadToken })`를 호출한 뒤 기존대로 `ApiError`를 throw. `hadToken`은 요청에 실제로 토큰을 실었는지 여부.
2. **`lib/auth.jsx`**
   - `onUnauthorized` 구독: 콜백에서 `persist(null, null)`(만료 세션 정리) + `sessionExpired=true` + `expiryReason = hadToken ? 'expired' : 'required'`.
   - `login`/`signup` 성공 시 `sessionExpired=false`로 리셋.
   - 컨텍스트에 `sessionExpired`, `expiryReason`, `dismissSessionExpired()` 노출.
3. **`components/SessionGate.jsx`** (신규, 전역 1회 마운트)
   - `sessionExpired && 현재경로가 /login·/signup·/onboarding 아님` → 안내 모달 표시(루프 방지).
   - 문구: `expiryReason==='expired'` → "세션이 만료됐어요…", 아니면 "로그인이 필요한 기능이에요…".
   - **[로그인하기]** → `dismissSessionExpired()` 후 `/login?next=<현재 pathname+search>`로 이동.
   - **[나중에 할게요/닫기/배경]** → `dismissSessionExpired()`만(현재 화면 유지) ← 사용자가 요청한 "선택지".
   - Toast와 동일하게 `fixed inset-0 mx-auto max-w-phone`로 폰 프레임에 정렬(데스크탑에서 뷰포트 전체를 덮지 않음). framer-motion 페이드/스프링, ESC 닫기, `z-[210]`(Sheet 120·Toast 200 위).
4. **`lib/providers.jsx`**
   - react-query `retry`를 `(n, err) => err?.status !== 401 && n < 1`로 변경(401은 즉시 처리, 무의미한 재시도 제거).
   - `AuthProvider` 안에 `<SessionGate />` 마운트.
5. **`lib/endpoints.js`** — `track`만 `{ auth:true, background:true }`.
6. **복귀 일관성(소규모)** — `app/(auth)/login/page.jsx`는 이미 `?next=`를 읽어 `router.replace(next)` 수행. 안전을 위해 `next`가 `/`로 시작하고 `//`가 아닌 내부 경로일 때만 허용(open-redirect 방지). `MyPage`의 `LoginPromptCard` 링크에도 현재 경로를 `?next=`로 전달.

## 컴포넌트 경계

- `api.js`의 pub/sub: DOM·라우터에 의존하지 않는 순수 통지자. 입력=`auth/background/status`, 출력=구독자 호출.
- `AuthProvider`: 세션 상태의 단일 소유자. 401 신호를 세션 상태 변화로 번역.
- `SessionGate`: 표시 전용. 입력=`sessionExpired/expiryReason`, 동작=라우팅·해제. 내부를 몰라도 동작 이해 가능.

## 엣지 케이스

- **동시 다발 401**(한 페이지가 여러 인증 쿼리 발사): `sessionExpired` 플래그가 멱등 → 모달 1개만.
- **인증 라우트에서의 401**: 표시 안 함(login/signup은 애초에 `auth:false`라 emit도 안 됨).
- **모달과 페이지 자체 프롬프트 공존**(예: `/my`): 모달이 최상단(z-[210])이라 시각 충돌 없음. 닫으면 뒤의 카드가 보인다.
- **토큰 없는 보호 액션**(비로그인 좋아요/댓글/장바구니): `hadToken=false`로 "로그인이 필요해요" 안내.

## 검증

프론트에 테스트 러너가 없다(`next lint`/`next build`만 존재). 검증은:

- `npm run lint`, `npm run build` 통과.
- 수동: (a) 백엔드 up + 만료 토큰 주입 후 보호 페이지/액션 → 모달, [로그인하기] → `?next=` 복귀; (b) 백엔드 down(데모) → 모달 없이 mock 동작; (c) 잘못된 자격증명 로그인 → 폼 인라인 에러(모달 아님).

## 비목표(YAGNI)

- 토큰 자동 갱신(리프레시 토큰 엔드포인트 없음).
- 끊긴 액션의 자동 재시도(복귀는 경로까지만).
- 라우트 미들웨어/서버 가드.
