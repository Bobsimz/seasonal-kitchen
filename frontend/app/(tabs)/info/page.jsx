'use client';

import { Suspense, useState, useEffect, useRef } from 'react';
import { useSearchParams } from 'next/navigation';
import { Bell, Search, ShoppingCart, ChevronDown } from 'lucide-react';
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

// 정렬 행 — "N개의 ..." + 정렬 드롭다운. options: [{ value, label, cmp }].
function SortRow({ count, label, options, value, onChange }) {
  const [open, setOpen] = useState(false);
  const ref = useRef(null);
  const current = options.find((o) => o.value === value) || options[0];

  // 바깥 클릭 시 닫기.
  useEffect(() => {
    if (!open) return;
    const onDoc = (e) => {
      if (ref.current && !ref.current.contains(e.target)) setOpen(false);
    };
    document.addEventListener('mousedown', onDoc);
    return () => document.removeEventListener('mousedown', onDoc);
  }, [open]);

  return (
    <div className="flex items-center justify-between px-4 pb-2 pt-3">
      <span className="text-[12.5px] text-ink-mid">
        <b className="text-ink">{count}</b>
        {label}
      </span>
      <div className="relative" ref={ref}>
        <button
          type="button"
          onClick={() => setOpen((v) => !v)}
          aria-haspopup="listbox"
          aria-expanded={open}
          className="tap flex items-center gap-1 text-[12.5px] font-bold text-ink"
        >
          {current.label}
          <ChevronDown size={13} className={cn('text-ink-soft transition-transform', open && 'rotate-180')} />
        </button>
        {open && (
          <ul
            role="listbox"
            className="absolute right-0 z-30 mt-1.5 min-w-[128px] overflow-hidden rounded-xl border border-line-soft bg-white py-1 shadow-lg"
          >
            {options.map((o) => (
              <li key={o.value} role="option" aria-selected={o.value === value}>
                <button
                  type="button"
                  onClick={() => {
                    onChange(o.value);
                    setOpen(false);
                  }}
                  className={cn(
                    'tap block w-full px-3.5 py-2 text-left text-[12.5px]',
                    o.value === value ? 'font-bold text-brand' : 'text-ink-mid',
                  )}
                >
                  {o.label}
                </button>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
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
  const { data: catList = [] } = useIngredientCategories();
  const cats = ['전체', ...catList];

  const { items, isLoading, error, refetch, fetchNextPage, hasNextPage, isFetchingNextPage } =
    useInfiniteIngredients({ sort, category: cat === '전체' ? undefined : cat });

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;

  return (
    <>
      <ChipTabs options={cats} value={cat} onChange={setCat} sticky className="sticky top-28" />
      <div className="animate-fade-up pb-6">
        <SortRow count={`${items.length}개${hasNextPage ? '+' : ''}`} label="의 제철 식재료" options={INGREDIENT_SORTS} value={sort} onChange={setSort} />
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
    </>
  );
}

// ── 레시피 탭 (2-col 그리드) ── (필터/정렬은 서버에서 처리)
const RECIPE_SORTS = [
  { value: 'likes', label: '좋아요 많은 순' },
  { value: 'time_asc', label: '조리 빠른 순' },
  { value: 'title', label: '이름순' },
];

function RecipeTab() {
  const [tag, setTag] = useState('전체');
  const [sort, setSort] = useState(RECIPE_SORTS[0].value);
  const { data: tagList = [] } = useRecipeTags();
  const tags = ['전체', ...tagList];

  const { items, isLoading, error, refetch, fetchNextPage, hasNextPage, isFetchingNextPage } =
    useInfiniteRecipes({ sort, tag: tag === '전체' ? undefined : tag });

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;

  return (
    <>
      <ChipTabs options={tags} value={tag} onChange={setTag} sticky className="sticky top-28" />
      <div className="animate-fade-up pb-6">
        <SortRow count={`${items.length}개${hasNextPage ? '+' : ''}`} label="의 레시피" options={RECIPE_SORTS} value={sort} onChange={setSort} />
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
  const { data: regionList = [] } = useProducerRegions();
  const regions = ['전체', ...regionList];

  const { items, isLoading, error, refetch, fetchNextPage, hasNextPage, isFetchingNextPage } =
    useInfiniteProducers({ sort, region: region === '전체' ? undefined : region });

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;

  return (
    <>
      <ChipTabs options={regions} value={region} onChange={setRegion} sticky className="sticky top-28" />
      <div className="animate-fade-up pb-6">
        <SortRow count={`${items.length}곳${hasNextPage ? '+' : ''}`} label="의 추천 농가" options={PRODUCER_SORTS} value={sort} onChange={setSort} />
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
    </>
  );
}
