'use client';

import { Suspense, useMemo, useState } from 'react';
import { useSearchParams } from 'next/navigation';
import { Bell, Search, ShoppingCart, ChevronDown } from 'lucide-react';
import { useIngredients, useRecipes, useProducers, useHome, useCart } from '@/lib/queries';
import { AppHeader, HeaderIconButton } from '@/components/layout';
import { SegmentedToggle, ChipTabs } from '@/components/ui/SegmentedToggle';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { IngredientRow } from '@/components/domain/IngredientCard';
import { RecipeCard } from '@/components/domain/RecipeCard';
import { ProducerRow } from '@/components/domain/ProducerCard';

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

// 정렬 표시 행 (legacy 의 "N개의 ... · 정렬기준" 행 — 표시 전용).
function SortRow({ count, label, sortLabel }) {
  return (
    <div className="flex items-center justify-between px-4 pb-2 pt-3">
      <span className="text-[12.5px] text-ink-mid">
        <b className="text-ink">{count}</b>
        {label}
      </span>
      <span className="flex items-center gap-1 text-[12.5px] font-bold text-ink">
        {sortLabel}
        <ChevronDown size={13} className="text-ink-soft" />
      </span>
    </div>
  );
}

// ── 식재료 탭 ──
function IngredientTab() {
  const { data: items = [], isLoading, error, refetch } = useIngredients();
  const [cat, setCat] = useState('전체');

  const cats = useMemo(
    () => ['전체', ...Array.from(new Set(items.map((i) => i.category).filter(Boolean)))],
    [items],
  );
  const filtered = cat === '전체' ? items : items.filter((i) => i.category === cat);

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;

  return (
    <>
      <ChipTabs options={cats} value={cat} onChange={setCat} sticky className="sticky top-28" />
      <div className="animate-fade-up pb-6">
        <SortRow count={`${filtered.length}개`} label="의 제철 식재료" sortLabel="가격 낮은 순" />
        {filtered.length === 0 ? (
          <EmptyState title="식재료가 없어요" description="다른 카테고리를 선택해 보세요." />
        ) : (
          <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft bg-white">
            {filtered.map((i, idx) => (
              <IngredientRow key={i.id} ingredient={i} divider={idx < filtered.length - 1} />
            ))}
          </div>
        )}
      </div>
    </>
  );
}

// ── 레시피 탭 (2-col 그리드) ──
function RecipeTab() {
  const { data: items = [], isLoading, error, refetch } = useRecipes();
  const [tag, setTag] = useState('전체');

  const tags = useMemo(
    () => ['전체', ...Array.from(new Set(items.flatMap((r) => r.tags || [])))],
    [items],
  );
  const filtered = tag === '전체' ? items : items.filter((r) => (r.tags || []).includes(tag));

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;

  return (
    <>
      <ChipTabs options={tags} value={tag} onChange={setTag} sticky className="sticky top-28" />
      <div className="animate-fade-up pb-6">
        <SortRow count={`${filtered.length}개`} label="의 레시피" sortLabel="좋아요 많은 순" />
        {filtered.length === 0 ? (
          <EmptyState title="레시피가 없어요" description="다른 태그를 선택해 보세요." />
        ) : (
          <div className="grid grid-cols-2 gap-x-3 gap-y-4 px-4">
            {filtered.map((r) => (
              <RecipeCard key={r.id} recipe={r} />
            ))}
          </div>
        )}
      </div>
    </>
  );
}

// ── 농가 탭 ──
function ProducerTab() {
  const { data: items = [], isLoading, error, refetch } = useProducers();
  const [region, setRegion] = useState('전체');

  const regions = useMemo(
    () => ['전체', ...Array.from(new Set(items.map((p) => p.region).filter(Boolean)))],
    [items],
  );
  const filtered = region === '전체' ? items : items.filter((p) => p.region === region);

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;

  return (
    <>
      <ChipTabs options={regions} value={region} onChange={setRegion} sticky className="sticky top-28" />
      <div className="animate-fade-up pb-6">
        <SortRow count={`${filtered.length}곳`} label="의 추천 농가" sortLabel="평점 높은 순" />
        {filtered.length === 0 ? (
          <EmptyState title="농가가 없어요" description="다른 지역을 선택해 보세요." />
        ) : (
          <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft bg-white">
            {filtered.map((p, idx) => (
              <ProducerRow key={p.id} producer={p} divider={idx < filtered.length - 1} />
            ))}
          </div>
        )}
      </div>
    </>
  );
}
