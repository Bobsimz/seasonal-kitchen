# 프론트엔드 개편 정리 — 디자인 시안 → 동작하는 웹앱

기존 프론트엔드는 **Figma식 디자인 캔버스**(25개 모바일 화면을 한 캔버스에 펼쳐 보여주는 프로토타입)였습니다.
이를 **실제 라우팅 + API 연동 + Tailwind 컴포넌트**로 구성된 **모바일 웹앱**으로 재구성했습니다.
UI 구성과 화면별 정보 구조는 최대한 유지하고, 인라인 스타일 → Tailwind, 목데이터 → API 훅으로 바꿨습니다.

## 무엇이 바뀌었나

| 이전 | 이후 |
| --- | --- |
| 단일 `app/page.jsx`가 캔버스(`App`)를 렌더 | App Router 라우트 그룹 + 30여 개 실제 페이지 |
| 화면 = `t` 토큰을 props로 받는 인라인 스타일 컴포넌트 | Tailwind 클래스 + 공통 디자인 토큰 |
| 목데이터 하드코딩 | TanStack Query 훅 + API 클라이언트 (+ 데모 폴백) |
| 네비게이션 없음(캔버스) | 하단 탭바 + 뒤로가기 + 화면 전환 |
| 인증/장바구니/주문 동작 없음 | JWT 로그인·가입, 장바구니, 주문, 찜, 리뷰 동작 |

기존 화면 코드는 **`components/legacy/`** 로 옮겨 시각적 레퍼런스로 보존했습니다(앱 빌드에는 포함되지 않음). `mock-images.js`, `producers-data.js`는 데모 데이터로 재사용합니다.

## 추가한 라이브러리

- `@tanstack/react-query` — 서버 상태/캐싱
- `framer-motion` — 화면/시트 전환, 토스트 모션
- `lucide-react` — 아이콘
- `react-hook-form` — (설치) 폼 확장용
- `clsx` + `tailwind-merge` — `cn()` className 합성

## 폴더 구조

```
frontend/
├─ app/
│  ├─ layout.jsx                 # 루트: 폰트, 메타, Providers
│  ├─ globals.css                # Tailwind + 폰트 + 베이스 유틸(.tap/.ph/skeleton)
│  ├─ (tabs)/                    # 하단 탭바가 보이는 화면들
│  │  ├─ layout.jsx              #  MobileShell + ScreenScroll + BottomTabNav
│  │  ├─ page.jsx                #  / 홈
│  │  ├─ search/ curation/ info/ products/ reels/ notifications/ producers/
│  │  └─ my/ (orders, wishlist, reviews, price-alerts)
│  ├─ (stack)/                   # 탭바 없이 뒤로가기로 진입하는 상세/플로우
│  │  ├─ layout.jsx
│  │  ├─ ingredients/[id]/ (+ producers)
│  │  ├─ recipes/[id]/ (+ steps)
│  │  ├─ producers/[id]/ · products/[id]/
│  │  ├─ cart/ · checkout/ · orders/[id]/
│  │  └─ my/ (settings, reviews/new, seller/register, seller/offers/new, seller/dashboard)
│  └─ (auth)/                    # 온보딩/로그인/가입
│     └─ onboarding/ login/ signup/ (+ survey)
├─ components/
│  ├─ ui/        # 프리미티브: Button, Card, Section, Chip, SearchBar, SegmentedToggle,
│  │            #   Sheet, RatingStars, QtyStepper, TrendBadge, States, Spinner, Toast
│  ├─ layout/    # MobileShell, AmbientBackground, BottomTabNav, AppHeader, BottomBar
│  ├─ domain/    # IngredientCard, RecipeCard, ProducerCard, ReelThumb, OfferCard,
│  │            #   AddToCartButton, PriceBars, StyleBadge, VegImage
│  └─ legacy/    # (보존) 기존 디자인 캔버스 화면들 — 시각 레퍼런스
├─ lib/
│  ├─ config.js     # API base URL, 데모 폴백 플래그, storage 키
│  ├─ api.js        # fetch 래퍼(공통 응답 언랩 + JWT + ApiError)
│  ├─ endpoints.js  # 도메인별 호출 (실제 API → 실패 시 mock 폴백)
│  ├─ queries.js    # react-query 훅 (화면은 이것만 사용)
│  ├─ auth.jsx      # AuthProvider / useAuth (JWT, localStorage 세션)
│  ├─ providers.jsx # QueryClient + Auth + Toast 묶음
│  ├─ format.js     # won/wonLabel/priceRange/date/relativeTime/compact
│  ├─ cn.js         # clsx + tailwind-merge
│  └─ mock/         # data.js(읽기 데이터) + store.js(장바구니/주문/찜 쓰기 상태)
├─ tailwind.config.js  # 디자인 토큰(색/폰트/그림자) — 색 변경은 여기서
└─ CONVENTIONS.md      # 페이지 구현 규칙(개발자 필독)
```

## 디자인 시스템

- 색·폰트·그림자는 **`tailwind.config.js`** 한 곳에서 관리. 메인 그린 `#16C172` 고정, 보조 그린/포인트(코랄)/중립(화이트) 톤은 기존 `design-tokens.jsx`의 spring + coral + pure 프리셋 확정값을 옮긴 것.
- 시맨틱 토큰 클래스: `brand`, `brand-dark`, `brand-bg`, `brand-soft`, `hot`, `warn`, `ink`/`ink-mid`/`ink-soft`, `surface`/`surface-soft`, `line`/`line-soft`.
- 폰트: 본문 Pretendard(`font-sans`), 디스플레이 G마켓 산스(`font-display`).
- **모바일 영역 밖 배경**: `AmbientBackground` — 짙은 농장 그린 + 유기적 그린 글로우 + 잎사귀 실루엣 + 노이즈 + (와이드 화면) 브랜드 워드마크. 모바일 폭에서는 디바이스 프레임에 가려 자연스럽게 사라지고, 데스크탑에서는 가운데 디바이스 카드가 떠 있는 형태.

## 데이터 / API 레이어 (핵심)

- 화면은 **`lib/queries.js`의 훅만** 사용 → 캐싱/로딩/에러 일관 처리.
- `endpoints.js`의 각 함수는 **실제 백엔드를 먼저 호출**하고, 데모 폴백이 켜져 있고(기본) 연결/서버 오류면 **mock 데이터로 폴백**합니다. 덕분에 백엔드가 안 떠 있어도 앱 전체가 동작/탐색 가능합니다(해커톤 데모 친화적).
- 검증/인증 실패(4xx)는 폴백하지 않고 그대로 노출 → 백엔드가 켜졌을 때 폼 에러가 정상 표시됩니다.
- 장바구니/주문/찜/내농가의 "쓰기" 상태는 데모 모드에서 `lib/mock/store.js`가 localStorage로 유지합니다.

## 인증

- `useAuth()`: `login/signup`은 access token + 사용자 정보를 localStorage에 저장, 새로고침 시 복구.
- 인증이 필요한 동작(담기/주문/찜/리뷰)은 비로그인 시 토스트 + `/login?next=...`로 유도.

## 새로 기획·추가한 화면 (기존 시안에 없던 부분)

흐름상 비어 있던 페이지를 직접 설계해 채웠습니다.

| 라우트 | 화면 | 비고 |
| --- | --- | --- |
| `/search` | 통합 검색(검색 전/결과 통합) | 기존 두 화면을 한 동작 페이지로 |
| `/checkout` | 주문/결제 | 장바구니 → 주문완료 사이 결제 단계 (모의 결제·배송지) |
| `/notifications` | 알림 센터 | 백엔드 알림 API 존재, 시안 부재분 신규 |
| `/my/price-alerts` | 가격 알림 목록 | 백엔드 price-alerts API 연동 |
| `/my/settings` | 설정/프로필 수정 | 닉네임 수정·로그아웃 등 |
| `/my/seller/offers/new` | 판매 상품 등록 | 농가 등록과 분리(AI 작성 기능은 제거) |
| `/products/[id]` | 상품 상세 | 전용 상품 API 부재로 농가+오퍼 조합으로 구현 |

> 화면 흐름 개선: 하단 탭의 가운데 **'상품'**을 띄움 버튼으로 강조(커머스 핵심 동선), 상세/결제 화면은 탭바 대신 하단 고정 CTA(`BottomBar`)로 전환.

## 실행 / 설정

```bash
cd frontend
npm install
npm run dev        # http://localhost:3000
```

기본은 데모 폴백 ON(백엔드 없어도 동작). 실제 백엔드에 붙이려면 `frontend/.env.local`:

```
NEXT_PUBLIC_API_BASE_URL=http://localhost:8080
NEXT_PUBLIC_DEMO_FALLBACK=auto   # off 로 두면 mock 폴백 없이 실제 API만 사용
```

## 프론트 개발자 가이드 (확장 방법)

- **색 바꾸기**: `tailwind.config.js`의 `colors`만 수정 → 앱 전체 반영.
- **새 페이지 추가**: 해당 라우트 그룹(`(tabs)`/`(stack)`/`(auth)`)에 `폴더/page.jsx` 생성. `CONVENTIONS.md`의 컴포넌트/훅 표를 따른다.
- **새 API 연동**: `lib/endpoints.js`에 함수 추가(+필요 시 mock 폴백) → `lib/queries.js`에 훅 추가 → 화면에서 훅 사용.
- **규칙 요약**: 인라인 스타일 금지, 데이터는 훅으로만, 색은 토큰 클래스로, 로딩/에러/빈 상태 처리, 이동은 `<Link>`/`router`. 자세한 건 `CONVENTIONS.md`.
