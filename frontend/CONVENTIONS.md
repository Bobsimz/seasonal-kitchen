# 제철식탁 프론트엔드 — 개발 컨벤션 (페이지 구현 가이드)

이 문서는 **새 페이지를 구현할 때 반드시 따르는 규칙**입니다. 모든 공통 기반(API/인증/데이터/UI/레이아웃)은 이미 만들어져 있으니, 페이지는 이 부품들을 조립만 하면 됩니다.

## 기술 스택

- Next.js 14 (App Router, **JSX** — TypeScript 아님), React 18
- Tailwind CSS (색/폰트/그림자 토큰은 `tailwind.config.js` 에 정의)
- TanStack Query v5 (데이터), framer-motion (모션), lucide-react (아이콘)
- 경로 별칭: `@/` = 프로젝트 루트 (예: `@/components/ui`, `@/lib/queries`)

## 절대 규칙

1. **인라인 스타일 금지.** 모든 스타일은 Tailwind 클래스. 동적 합성은 `cn()` (`@/lib/cn`).
2. 데이터는 **`@/lib/queries` 의 훅만** 사용. `fetch`/`endpoints` 직접 호출 금지.
3. 색은 토큰 클래스만: `brand`, `brand-dark`, `brand-bg`, `brand-soft`, `hot`, `hot-bg`, `warn`, `warn-bg`, `ink`, `ink-mid`, `ink-soft`, `surface`, `surface-soft`, `line`, `line-soft`, `info`, `danger`. (임의 hex 지양)
4. 폰트: 본문 `font-sans`(Pretendard, 기본), 디스플레이 제목 `font-display`(Gmarket Sans).
5. 데이터 훅 사용 시 **로딩/에러/빈 상태**를 반드시 처리 (`LoadingScreen`, `ErrorState`, `EmptyState`).
6. 페이지 컴포넌트 파일 맨 위 `'use client';` (대부분 훅을 쓰므로 클라이언트 컴포넌트).
7. 금액은 `won()`/`wonLabel()`, 날짜는 `date()`/`relativeTime()` (`@/lib/format`). 직접 toLocaleString 금지.
8. 화면 흐름의 모든 이동은 `next/link` 의 `<Link>` 또는 `useRouter().push`. `<a href>` 금지.
9. 모바일 전용. 폭은 프레임(`max-w-phone`=440px)이 잡아주니, 페이지는 `w-full` 기준으로 짠다. 가로 캐러셀은 `flex overflow-x-auto phone-scroll`.

## 레이아웃 / 라우트 그룹

- `app/(tabs)/...` : 하단 탭바가 **보이는** 화면 (홈/정보/상품/릴스/마이 및 목록형). 페이지는 맨 위에 `<AppHeader>` 를 직접 렌더.
- `app/(stack)/...` : 탭바 **없이** 뒤로가기로 들어오는 상세/플로우 화면. 맨 위 `<AppHeader back />`, 필요 시 하단 고정 CTA 는 `<BottomBar>`.
- `app/(auth)/...` : 온보딩/로그인/가입.
- 스크롤 영역(`ScreenScroll`)은 그룹 레이아웃이 이미 제공. 페이지는 그 안의 내용만 그린다.
- `AppHeader` 는 `sticky top-0`. 페이지 본문은 보통 `<div className="pb-6">...</div>` 로 감싸 하단 여백 확보.

## 핵심 컴포넌트 API

### 레이아웃 (`@/components/layout`)

```jsx
<AppHeader title="장바구니" back right={<HeaderIconButton icon={Bell} href="/notifications" badge={2} />} />
<AppHeader title="봄동" back transparent />   // 히어로 이미지 위 (흰 텍스트)
<HeaderIconButton icon={ShoppingBag} href="/cart" badge={3} label="장바구니" />
<BottomBar><div className="flex-1">...</div><Button block>구매하기</Button></BottomBar>
```

### UI (`@/components/ui`)

```jsx
<Button variant="primary|secondary|soft|ghost|outline|danger" size="sm|md|lg" block loading>담기</Button>
<Card className="p-4">...</Card>
<Section title="관련 레시피" action={<MoreLink/>}>...</Section>   // 좌측 제목 + 우측 액션, 본문은 children
<Chip tone="neutral|brand|hot|warn|dark|outline">제철</Chip>
<SegmentedToggle options={[{value,label}]} value={v} onChange={setV} />   // 식재료/레시피/농가 토글
<ChipTabs options={['전체','잎채소',...]} value={v} onChange={setV} />     // 가로 스크롤 카테고리 칩
<SearchBar value readOnly onClick={()=>router.push('/search')} />          // 또는 value/onChange/onSubmit
<Sheet open={open} onClose={...} title="옵션 선택">...</Sheet>             // 바텀시트
<RatingStars value={4.5} /> · <RatingStars editable value={r} onChange={setR} />
<QtyStepper value={qty} onChange={setQty} />
<TrendBadge direction="UP|DOWN|FLAT" label="-15%" />
<LoadingScreen /> · <ErrorState onRetry={refetch} /> · <EmptyState title="..." description="..." action={...} />
const toast = useToast(); toast.show('담았어요', { type:'success|error|default' });
```

### 도메인 카드 (`@/components/domain`)

```jsx
<IngredientRow ingredient={i} /> · <IngredientCard ingredient={i} />     // i: {id,name,imageUrl,currentPrice,unit,priceChangeLabel,trendDirection,hot,seasonal,category}
<RecipeRow recipe={r} /> · <RecipeCard recipe={r} width={168} />          // r: {id,title,imageUrl,cookMinutes,difficulty,likes,tags,seasonal}
<ReelThumb reel={r} />                                                    // r: {id,title,thumbnailUrl,likes}
<ProducerRow producer={p} trailing={...} footer={...} /> · <ProducerCircle producer={p} />  // p: {id,name,region,tagline,photoUrl,style,rating,reviewCount,honorary,badges[]}
<ProducerAvatar producer={p} size={52} />
<StyleBadge style="ORGANIC" />   // VALUE/ORGANIC/PREMIUM → 라벨+톤
<OfferRow offer={o} rank={1} showProducer />   // o: {id(=offerId),ingredientName,price,unit,freshnessLabel,producerName,region}
<AddToCartButton offerId={o.id} variant="icon|full" />   // 로그인 가드+토스트 내장
<PriceBars data={[{label,price}]} unit="개" />   // 가격 이력 막대차트
<VegImage name="봄동" src={url} size={56} />
```

## 데이터 훅 (`@/lib/queries`)

전부 `{ data, isLoading, error, refetch }` (쿼리) 또는 `{ mutate, mutateAsync, isPending }` (뮤테이션) 반환.
목록 쿼리는 `select` 로 배열을 바로 반환 (`data` 가 배열).

```
useHome()                       // {locationLabel,unreadNotificationCount,hero,seasonalIngredients[],trendingRecipes[],trendingReels[],trendingKeywords[]}
useSearch(q, type, enabled)     // {items[],ingredients[],recipes[],reels[],ingredientCount,recipeCount,reelCount}  type: 'ALL'|'INGREDIENT'|'RECIPE'
useTrending()                   // [{keyword,searchCount}]
useIngredients(params) -> []    // IngredientCard[]
useIngredient(id)               // 상세: {...card, buyingSignal, nutrition[{label,value}], careTips[], storageTips[], compareStoreCount}
useIngredientPrices(id)         // [{label,price}]
useIngredientSubstitutes(id)    // [{id,name,imageUrl,reason}]
useIngredientStoreOffers(id)    // [{id,store,delivery,price,originalPrice,discountPct,tag}]  (리테일 시세)
useIngredientRecipes(id) -> []  // RecipeCard[]
useIngredientProducers(id)      // [{id(=offerId),producerId,producerName,region,price,unit,freshnessLabel,rating,reviewCount,style,honorary,photoUrl,badges}] 가격순
useRecipes(params) -> []        // RecipeCard[]
useRecipe(id)                   // {...card, description, estimatedCost, ingredients[{ingredientId,name,amount,imageUrl,price}], relatedReelIds[]}
useRecipeSteps(id)              // [{order,text,imageUrl,timerMinutes?}]
useReels() -> []                // [{id,recipeId,title,thumbnailUrl,videoUrl,creatorName,creatorAvatar,likes,comments,saves,views,ingredients[],caption}]
useReel(id) · useReelComments(id)
useProducers(params) -> []      // Producer[]
useProducer(id) · useProducerOffers(id) · useProducerReviews(id) · useProducerNews(id)
useMyProducer()                 // 내 농가 (없으면 null)
useMySummary()                  // {user,stats:{savedAmount,orderCount,reviewCount},counts:{favorites,priceAlerts,orders,reviews,written},personalized[]}
useCart()                       // {groups:[{producerId,producerName,items:[{cartItemId,ingredientName,qty,unitPrice,unit,imageUrl}],subtotal,shipping}],itemsTotal,shippingTotal,payTotal}
useOrders() // [{id,orderNumber,status,totalAmount,summary,orderedAt}]  · useOrder(id) // {…,items[],itemsTotal,shippingFee,pointsEarned}
useFavorites() // [{id,targetType,targetId}]
useNotifications() // {tabCounts:{ALL,PRICE,ORDER,COMMUNITY}, items:[{id,type,title,body,createdAt,read,icon}]}
usePriceAlerts() // [{id,ingredientId,ingredientName,imageUrl,currentPrice,targetPrice,unit,active}]

// 뮤테이션
useAddToCart()        // mutate({offerId,qty})
useUpdateCartItem()   // mutate({id,qty})
useRemoveCartItem()   // mutate(cartItemId)
useCreateOrder()      // mutate() -> order (성공 후 /orders/[id] 로 이동)
useToggleFavorite()   // mutate({action:'add'|'remove',targetType,targetId,favoriteId})
useReadNotification() // mutate({id} | {all:true})
useCreateReview()     // mutate({producerId,rating,item,body})
useRegisterProducer() // mutate(producerPayload)
useAddMyOffer()       // mutate(offerPayload)
```

## 인증 (`@/lib/auth`)

```jsx
const { user, isAuthenticated, login, signup, logout, ready } = useAuth();
// login({email,password}) / signup({email,password,nickname}) 는 async, 성공 시 세션 저장.
// 인증 필요한 동작(담기/주문/찜/리뷰)에서 비로그인 시: toast + router.push('/login?next=...').
```

## 화면 흐름(라우트) 지도

홈 `/` · 검색 `/search` · 큐레이션 `/curation` · 정보 `/info`(식재료/레시피/농가 토글)
식재료 상세 `/ingredients/[id]` · 농가비교 `/ingredients/[id]/producers`
레시피 상세 `/recipes/[id]` · 조리순서 `/recipes/[id]/steps`
농가 목록 `/producers` · 농가 상세 `/producers/[id]`
상품 `/products` · 상품 상세 `/products/[id]` · 장바구니 `/cart` · 결제 `/checkout` · 주문완료/상세 `/orders/[id]`
릴스 `/reels`
마이 `/my` · 주문내역 `/my/orders` · 찜 `/my/wishlist` · 리뷰 `/my/reviews` · 리뷰작성 `/my/reviews/new`
가격알림 `/my/price-alerts` · 설정 `/my/settings` · 알림 `/notifications`
판매자등록 `/my/seller/register` · 판매상품등록 `/my/seller/offers/new` · 판매통계 `/my/seller/dashboard`
온보딩 `/onboarding` · 로그인 `/login` · 가입 `/signup` · 가입설문 `/signup/survey`

## 디자인 톤

- 깨끗한 화이트 배경 + 브랜드 그린(#16C172) 포인트. 둥근 모서리(rounded-2xl/3xl), 부드러운 카드 그림자(`shadow-card`).
- 가격 하락/제철/유기농 = 그린 계열, 가격 상승/인기/핫템 = `hot`(코랄), 주의 = `warn`.
- 진입 애니메이션은 컨테이너에 `animate-fade-up` 정도로 절제. 과한 모션 지양.
- legacy 원본(`@/components/legacy/screens-*.jsx`)의 **레이아웃/정보 구조/문구는 최대한 유지**하되, 인라인스타일→Tailwind, 목데이터→쿼리 훅으로 바꾼다.
```
