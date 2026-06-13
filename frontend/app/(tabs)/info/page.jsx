'use client';

import { Suspense, useState, useEffect, useRef } from 'react';
import { useSearchParams } from 'next/navigation';
import { Bell, Search, ShoppingCart, ChevronDown, Check } from 'lucide-react';
import {
  useInfiniteIngredients,
  useInfiniteRecipes,
  useInfiniteProducers,
  useIngredientCategories,
  useRecipeTags,
  useProducerRegions,
  useHome,
  useCart,
} from '@/lib/queries';
import { AppHeader, HeaderIconButton } from '@/components/layout';
import { SegmentedToggle, ChipTabs } from '@/components/ui/SegmentedToggle';
import { Sheet } from '@/components/ui/Sheet';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { IngredientRow } from '@/components/domain/IngredientCard';
import { RecipeCard } from '@/components/domain/RecipeCard';
import { ProducerRow } from '@/components/domain/ProducerCard';
import { cn } from '@/lib/cn';

const TABS = [
  { value: 'ingredient', label: '식재료' },
  { value: 'recipe', label: '레시피' },
  { value: 'producer', label: '농가' },
];
const VALID = TABS.map((t) => t.value);

export default function InfoPage() {
  return (
    <Suspense fallback={<InfoShell />}>
      <InfoInner />
    </Suspense>
  );
}

// 헤더만 그린 폴백 (서스펜스 동안 레이아웃 유지). 홈과 동일하게 알림/검색/장바구니 액션 노출.
function InfoShell({ children }) {
  const { data: home } = useHome();
  const { data: cart } = useCart();
  const cartCount = cart?.groups?.reduce((n, g) => n + g.items.length, 0) ?? 0;
  return (
    <>
      <AppHeader
        title="정보"
        right={
          <>
            <HeaderIconButton icon={Bell} href="/notifications" label="알림" badge={home?.unreadNotificationCount} />
            <HeaderIconButton icon={Search} href="/search" label="검색" />
            <HeaderIconButton icon={ShoppingCart} href="/cart" label="장바구니" badge={cartCount} />
          </>
        }
      />
      {children}
    </>
  );
}

function InfoInner() {
  const params = useSearchParams();
  const initial = VALID.includes(params.get('tab')) ? params.get('tab') : 'ingredient';
  const [tab, setTab] = useState(initial);

  return (
    <InfoShell>
      {/* 탭 토글 — 스크롤 시 헤더(56px) 바로 아래 고정. 높이를 h-14로 고정해 칩 줄의 top-28(112px) 오프셋과 맞춘다. */}
      <div className="sticky top-14 z-20 flex h-14 shrink-0 items-center bg-white/95 px-4 backdrop-blur-xl">
        <SegmentedToggle options={TABS} value={tab} onChange={setTab} className="w-full" />
      </div>
      {tab === 'ingredient' && <IngredientTab />}
      {tab === 'recipe' && <RecipeTab />}
      {tab === 'producer' && <ProducerTab />}
    </InfoShell>
  );
}

// 무한 스크롤 센티넬 — 뷰포트에 들어오면 다음 페이지를 요청한다.
function InfiniteSentinel({ hasMore, loading, onLoadMore }) {
  const ref = useRef(null);
  useEffect(() => {
    if (!hasMore) return;
    const el = ref.current;
    if (!el) return;
    const io = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && !loading) onLoadMore();
      },
      { rootMargin: '300px' },
    );
    io.observe(el);
    return () => io.disconnect();
  }, [hasMore, loading, onLoadMore]);

  if (!hasMore && !loading) return null;
  return (
    <div ref={ref} className="flex justify-center py-5 text-[12.5px] text-ink-soft">
      {loading ? '불러오는 중…' : ''}
    </div>
  );
}

// 정렬 행 — "N개의 ..." + 정렬 버튼(탭하면 onOpen). 시트는 animate-fade-up(transform) 바깥에서
// 렌더해야 fixed 가 프레임 기준으로 떠서 상품 탭과 동일하게 동작한다.
function SortRow({ count, label, options, value, onOpen }) {
  const current = options.find((o) => o.value === value) || options[0];
  return (
    <div className="flex items-center justify-between px-4 pb-2 pt-3">
      <span className="text-[12.5px] text-ink-mid">
        <b className="text-ink">{count}</b>
        {label}
      </span>
      <button
        type="button"
        onClick={onOpen}
        aria-haspopup="dialog"
        aria-label="정렬 기준 선택"
        className="tap flex items-center gap-0.5 text-[12.5px] font-bold text-ink-mid"
      >
        {current.label}
        <ChevronDown size={14} />
      </button>
    </div>
  );
}

// 정렬 바텀시트 — 상품 탭과 동일. animate-fade-up 바깥(탭 루트)에 둔다.
function SortSheet({ open, onClose, options, value, onChange }) {
  return (
    <Sheet open={open} onClose={onClose} title="정렬">
      <div className="flex flex-col">
        {options.map((o) => {
          const active = o.value === value;
          return (
            <button
              key={o.value}
              onClick={() => {
                onChange(o.value);
                onClose();
              }}
              className={cn(
                'tap flex items-center justify-between py-3 text-[14.5px]',
                active ? 'font-extrabold text-brand-dark' : 'font-semibold text-ink',
              )}
            >
              {o.label}
              {active && <Check size={18} strokeWidth={2.6} />}
            </button>
          );
        })}
      </div>
    </Sheet>
  );
}

// ── 식재료 탭 ── (필터/정렬은 서버에서 처리)
const INGREDIENT_SORTS = [
  { value: 'price_asc', label: '가격 낮은 순' },
  { value: 'price_desc', label: '가격 높은 순' },
  { value: 'name', label: '이름순' },
];

function IngredientTab() {
  const [cat, setCat] = useState('전체');
  const [sort, setSort] = useState(INGREDIENT_SORTS[0].value);
  const [sortOpen, setSortOpen] = useState(false);
  const { data: catList = [] } = useIngredientCategories();
  const cats = ['전체', ...catList];

  const { items, total, isLoading, error, refetch, fetchNextPage, hasNextPage, isFetchingNextPage } =
    useInfiniteIngredients({ sort, category: cat === '전체' ? undefined : cat });

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;

  return (
    <>
      <ChipTabs options={cats} value={cat} onChange={setCat} sticky className="sticky top-28" />
      <div className="animate-fade-up pb-6">
        <SortRow count={`${total}개`} label="의 제철 식재료" options={INGREDIENT_SORTS} value={sort} onOpen={() => setSortOpen(true)} />
        {items.length === 0 ? (
          <EmptyState title="식재료가 없어요" description="다른 카테고리를 선택해 보세요." />
        ) : (
          <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft bg-white">
            {items.map((i, idx) => (
              <IngredientRow key={i.id} ingredient={i} divider={idx < items.length - 1} />
            ))}
          </div>
        )}
        <InfiniteSentinel hasMore={hasNextPage} loading={isFetchingNextPage} onLoadMore={fetchNextPage} />
      </div>
      <SortSheet open={sortOpen} onClose={() => setSortOpen(false)} options={INGREDIENT_SORTS} value={sort} onChange={setSort} />
    </>
  );
}

// ── 레시피 탭 (2-col 그리드) ── (필터/정렬은 서버에서 처리)
const RECIPE_SORTS = [
  { value: 'likes', label: '찜 많은 순' },
  { value: 'time_asc', label: '조리 빠른 순' },
  { value: 'title', label: '이름순' },
];

function RecipeTab() {
  const [tag, setTag] = useState('전체');
  const [sort, setSort] = useState(RECIPE_SORTS[0].value);
  const [sortOpen, setSortOpen] = useState(false);
  const { data: tagList = [] } = useRecipeTags();
  const tags = ['전체', ...tagList];

  const { items, total, isLoading, error, refetch, fetchNextPage, hasNextPage, isFetchingNextPage } =
    useInfiniteRecipes({ sort, tag: tag === '전체' ? undefined : tag });

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;

  return (
    <>
      <ChipTabs options={tags} value={tag} onChange={setTag} sticky className="sticky top-28" />
      <div className="animate-fade-up pb-6">
        <SortRow count={`${total}개`} label="의 레시피" options={RECIPE_SORTS} value={sort} onOpen={() => setSortOpen(true)} />
        {items.length === 0 ? (
          <EmptyState title="레시피가 없어요" description="다른 태그를 선택해 보세요." />
        ) : (
          <div className="grid grid-cols-2 gap-x-3 gap-y-4 px-4">
            {items.map((r) => (
              <RecipeCard key={r.id} recipe={r} />
            ))}
          </div>
        )}
        <InfiniteSentinel hasMore={hasNextPage} loading={isFetchingNextPage} onLoadMore={fetchNextPage} />
      </div>
      <SortSheet open={sortOpen} onClose={() => setSortOpen(false)} options={RECIPE_SORTS} value={sort} onChange={setSort} />
    </>
  );
}

// ── 농가 탭 ── (필터/정렬은 서버에서 처리. 농가 정렬은 Spring Pageable sort 형식)
const PRODUCER_SORTS = [
  { value: 'rating,desc', label: '평점 높은 순' },
  { value: 'reviewCount,desc', label: '리뷰 많은 순' },
  { value: 'name,asc', label: '이름순' },
];

function ProducerTab() {
  const [region, setRegion] = useState('전체');
  const [sort, setSort] = useState(PRODUCER_SORTS[0].value);
  const [sortOpen, setSortOpen] = useState(false);
  const { data: regionList = [] } = useProducerRegions();
  const regions = ['전체', ...regionList];

  const { items, total, isLoading, error, refetch, fetchNextPage, hasNextPage, isFetchingNextPage } =
    useInfiniteProducers({ sort, region: region === '전체' ? undefined : region });

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;

  return (
    <>
      <ChipTabs options={regions} value={region} onChange={setRegion} sticky className="sticky top-28" />
      <div className="animate-fade-up pb-6">
        <SortRow count={`${total}곳`} label="의 추천 농가" options={PRODUCER_SORTS} value={sort} onOpen={() => setSortOpen(true)} />
        {items.length === 0 ? (
          <EmptyState title="농가가 없어요" description="다른 지역을 선택해 보세요." />
        ) : (
          <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft bg-white">
            {items.map((p, idx) => (
              <ProducerRow key={p.id} producer={p} divider={idx < items.length - 1} />
            ))}
          </div>
        )}
        <InfiniteSentinel hasMore={hasNextPage} loading={isFetchingNextPage} onLoadMore={fetchNextPage} />
      </div>
      <SortSheet open={sortOpen} onClose={() => setSortOpen(false)} options={PRODUCER_SORTS} value={sort} onChange={setSort} />
    </>
  );
}
