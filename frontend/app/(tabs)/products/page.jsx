'use client';

import { useState } from 'react';
import Link from 'next/link';
import { Plus, Bell, Search, ShoppingCart, ChevronDown, Check } from 'lucide-react';
import { useInfiniteProductCatalog, useMyProducer, useHome, useCart } from '@/lib/queries';
import { AppHeader, HeaderIconButton } from '@/components/layout';
import { ChipTabs } from '@/components/ui/SegmentedToggle';
import { Sheet } from '@/components/ui/Sheet';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { InfiniteSentinel } from '@/components/ui/InfiniteSentinel';
import { ProductCard } from '@/components/domain/ProductCard';
import { cn } from '@/lib/cn';

// 카테고리 칩은 상품에 실제 존재하는 값에서 동적 생성 — 이 배열은 노출 순서만 정한다.
const CAT_ORDER = ['채소', '과일', '곡류', '기타'];

// 정렬은 서버에서 처리한다(무한스크롤과 클라이언트 정렬은 충돌 — 페이지가 쌓일 때마다 순서가 흔들림).
// value 는 백엔드 sort 파라미터값. recommended = 기본(최신순).
const SORTS = [
  { value: 'recommended', label: '추천순' },
  { value: 'price_asc', label: '낮은가격순' },
];

export default function ProductsPage() {
  const [category, setCategory] = useState('ALL');
  const [sort, setSort] = useState('recommended');
  const [sortOpen, setSortOpen] = useState(false);

  // 카테고리 필터는 서버에 맡기고, 목록은 무한 스크롤로 페이지 단위로 받는다.
  // category 가 바뀌면 queryKey 가 바뀌어 해당 카테고리부터 다시 받아온다.
  const {
    items: allProducts,
    total,
    isLoading,
    error,
    refetch,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
  } = useInfiniteProductCatalog({
    category: category === 'ALL' ? undefined : category,
    sort: sort === 'recommended' ? undefined : sort,
  });
  const { data: myProducer } = useMyProducer();
  const { data: home } = useHome();
  const { data: cart } = useCart();
  const cartCount = cart?.groups?.reduce((n, g) => n + g.items.length, 0) ?? 0;

  // 칩은 고정 분류(채소·과일·곡류·기타) — 로드된 상품에 의존하지 않는다.
  const filters = [{ value: 'ALL', label: '전체' }, ...CAT_ORDER.map((c) => ({ value: c, label: c }))];

  // 서버가 카테고리 필터 + 정렬을 끝냈으니 그대로 사용(클라이언트 재정렬 X — 무한스크롤 순서 안정).
  const list = allProducts;

  const sortLabel = SORTS.find((s) => s.value === sort)?.label ?? '추천순';

  // 판매 등록 진입: 내 농가가 있으면 상품 등록, 없으면 농가 등록.
  const sellHref = myProducer ? '/my/seller/offers/new' : '/my/seller/register';

  return (
    <>
      <AppHeader
        title="상품"
        right={
          <>
            <HeaderIconButton icon={Bell} href="/notifications" label="알림" badge={home?.unreadNotificationCount} />
            <HeaderIconButton icon={Search} href="/search" label="검색" />
            <HeaderIconButton icon={ShoppingCart} href="/cart" label="장바구니" badge={cartCount} />
          </>
        }
      />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && (
        <>
          {/* 카테고리 칩 — 스크롤 시 헤더 바로 아래 고정 (animate 컨테이너 밖에 둬서 sticky 유지) */}
          <ChipTabs options={filters} value={category} onChange={setCategory} sticky className="sticky top-14" />

          <div className="animate-fade-up pb-24">
            {/* 개수 / 정렬 행 */}
            <div className="flex items-center justify-between px-5 pb-2.5 pt-3.5">
              <span className="text-[12.5px] text-ink-mid">
                <b className="text-ink">{total}개</b>의 상품
              </span>
              <button
                onClick={() => setSortOpen(true)}
                aria-haspopup="dialog"
                aria-expanded={sortOpen}
                aria-label="정렬 기준 선택"
                className="tap flex items-center gap-0.5 text-[12.5px] font-bold text-ink-mid"
              >
                {sortLabel}
                <ChevronDown size={14} />
              </button>
            </div>

            {list.length === 0 ? (
              <EmptyState
                title="조건에 맞는 상품이 없어요"
                description="다른 카테고리를 선택해 보세요."
              />
            ) : (
              <div className="grid grid-cols-2 gap-3 px-4">
                {list.map((p) => (
                  <ProductCard
                    key={p.id}
                    product={p}
                    href={`/products/${p.producerId}?offer=${p.id}`}
                  />
                ))}
              </div>
            )}
            <InfiniteSentinel hasMore={hasNextPage} loading={isFetchingNextPage} onLoadMore={fetchNextPage} />
          </div>
        </>
      )}

      {/* 정렬 바텀시트 */}
      <Sheet open={sortOpen} onClose={() => setSortOpen(false)} title="정렬">
        <div className="flex flex-col">
          {SORTS.map((s) => {
            const active = s.value === sort;
            return (
              <button
                key={s.value}
                onClick={() => {
                  setSort(s.value);
                  setSortOpen(false);
                }}
                className={cn(
                  'tap flex items-center justify-between py-3 text-[14.5px]',
                  active ? 'font-extrabold text-brand-dark' : 'font-semibold text-ink',
                )}
              >
                {s.label}
                {active && <Check size={18} strokeWidth={2.6} />}
              </button>
            );
          })}
        </div>
      </Sheet>

      {/* 우하단 + FAB — 판매 등록 진입 (프레임 내부 고정) */}
      <Link
        href={sellHref}
        aria-label="판매 등록"
        className="tap fixed bottom-[96px] right-4 z-30 flex h-[52px] items-center gap-1.5 rounded-full bg-gradient-to-br from-brand to-brand-dark pl-4 pr-5 text-white shadow-[0_8px_20px_rgba(22,193,114,0.4)] sm:bottom-[102px]"
      >
        <Plus size={20} strokeWidth={2.4} />
        <span className="text-[14.5px] font-extrabold tracking-tight">판매 등록</span>
      </Link>
    </>
  );
}
