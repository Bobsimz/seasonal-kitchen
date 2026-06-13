# 프론트엔드 목(mock) 제거 + 레거시 정리 + 에러 페이지 설계

- 날짜: 2026-06-14
- 대상: `frontend`
- 목표: 데모용 목 데이터/폴백 인프라와 죽은 레거시 코드를 제거해 프론트엔드가 실 백엔드만 바라보게 하고, API 실패를 사용자에게 보여줄 에러 페이지를 추가한다.

## 배경

현재 모든 API 호출은 `lib/endpoints.js`의 `withFallback(real, mockFn)`을 거친다. `DEMO_FALLBACK`(기본 `auto`)이 꺼져 있지 않으면, 백엔드 연결/서버 오류 시 `lib/mock/data.js`·`lib/mock/store.js`의 목 데이터로 폴백한다. 또 `components/legacy/*`(약 16k줄)는 옛 프로토타입 화면들로, 실제 앱(`app/`)에서 import되지 않는 죽은 코드다.

백엔드 확인 결과, 장바구니·주문·찜·`producers/me/offers` 등 목 전용처럼 보였던 기능이 **모두 실제로 구현되어 있다.** 따라서 목 폴백을 제거해도 기능이 사라지지 않고 실 백엔드를 직접 사용하게 된다.

## 범위

### 1. 목 인프라 제거
- `lib/mock/` 전체 삭제(`data.js`, `store.js`).
- `lib/endpoints.js` 재작성: `withFallback`, `import * as mock`, `demoStore`, `DEMO_FALLBACK` 의존 제거. 각 엔드포인트는 `api.*`를 직접 호출한다.
  - `listMyOffers`: 지금은 일부러 실 호출을 reject시켜 항상 데모 스토어를 쓴다. 실제 `GET /producers/me/offers`로 연결한다.
  - `analyzeOfferPhoto`, `generateDescription`, `uploadImage`, `uploadImages`의 목 폴백 제거 → 직접 호출.
  - `track`은 fire-and-forget(`.catch(() => {})`) 그대로 유지.
- `lib/config.js`에서 `DEMO_FALLBACK` 제거.
- `lib/api.js`의 `ApiError.isConnectivity`는 폴백 판단 전용이므로, 다른 사용처가 없으면 제거한다(구현 중 grep 확인).

### 2. 레거시 코드 제거
- `components/legacy/*` 전체 삭제.
- 단, `vegImg` + `VEG_IMG`(채소 이름 → 이미지 URL 매핑)는 `VegImage`가 실제 화면 10여 곳에서 쓰므로 **신규 `lib/veg-images.js`로 추출**해 보존한다.
- `producers-data.js`, `mock-images.js` 등 나머지 레거시는 `lib/mock/data.js`만 참조하던 것이라 함께 삭제된다.

### 3. VegImage 이동 + 개선
- `components/domain/VegImage.jsx`의 import를 `@/lib/veg-images`로 변경.
- 이미지가 없을 때의 폴백 디자인 개선: 밋밋한 텍스트 박스 대신 부드러운 그라데이션 배경 + 채소 이모지(없으면 이름)로 표시. 기존 props(`name`, `src`, `size`, `rounded`, `className`)와 접근성(`role="img"`, `aria-label`)은 호환 유지.

### 4. 에러 처리
- `app/error.jsx`: 클라이언트 에러 경계. 친절한 메시지 + "다시 시도"(reset) 버튼 + 홈 이동 링크.
- `app/not-found.jsx`: 404 페이지. 홈으로 이동.
- `lib/providers.jsx`: QueryClient의 쿼리 기본 옵션에 `throwOnError: (err) => err?.status !== 401` 추가. 목 제거 후 API 실패가 `error.jsx` 경계로 전파되게 한다. 401은 기존 `onUnauthorized` → `SessionGate`(로그인 모달) 흐름을 그대로 두기 위해 throw 대상에서 제외한다. 뮤테이션은 기존처럼 `error`를 반환해 토스트 등으로 개별 처리한다.

## 변경 파일

- 삭제: `lib/mock/data.js`, `lib/mock/store.js`, `components/legacy/*`(17개)
- 신규: `lib/veg-images.js`, `app/error.jsx`, `app/not-found.jsx`
- 수정: `lib/endpoints.js`, `lib/config.js`, `lib/providers.jsx`, `components/domain/VegImage.jsx`, (필요 시 `lib/api.js`)

## 검증

- `npm run build` 통과.
- `grep -rn "legacy\|lib/mock\|DEMO_FALLBACK\|withFallback"`로 잔존 import 0건 확인.
- `vegImg`/`VegImage` 사용처(약 10개 페이지)에서 import 깨짐 없음.

## 위험 / 비고

- 목 제거 후에는 로컬 백엔드가 떠 있지 않으면 화면이 에러 경계로 빠진다(의도된 동작). 데모 시에는 백엔드 기동 필요.
- `app/(stack)/ingredients/[id]/page.jsx`에 기존 미커밋 작업이 있으므로 보존한다(이 작업과 무관).
