'use client';

import { useMemo, useState } from 'react';
import Link from 'next/link';
import { Plus, Bell, Search, ShoppingCart, ChevronDown, Check } from 'lucide-react';
import { useProducts, useMyProducer, useHome, useCart } from '@/lib/queries';
import { AppHeader, HeaderIconButton } from '@/components/layout';
import { ChipTabs } from '@/components/ui/SegmentedToggle';
import { Sheet } from '@/components/ui/Sheet';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { ProductCard } from '@/components/domain/ProductCard';
import { cn } from '@/lib/cn';

// 카테고리 칩은 상품에 실제 존재하는 값에서 동적 생성 — 이 배열은 노출 순서만 정한다.
const CAT_ORDER = ['잎채소', '뿌리채소', '열매채소', '꽃채소', '과일', '양념채소', '기타'];

const SORTS = [
  { value: 'RECOMMENDED', label: '추천순' },
  { value: 'PRICE_ASC', label: '낮은가격순' },
  { value: 'REVIEW_DESC', label: '리뷰많은순' },
];
const SORT_FNS = {
  RECOMMENDED: (a, b) => b.rating - a.rating || b.reviewCount - a.reviewCount,
  PRICE_ASC: (a, b) => a.price - b.price,
  REVIEW_DESC: (a, b) => b.reviewCount - a.reviewCount,
};

export default function ProductsPage() {
  const [category, setCategory] = useState('ALL');
  const [sort, setSort] = useState('RECOMMENDED');
  const [sortOpen, setSortOpen] = useState(false);

  const { data: allProducts = [], isLoading, error, refetch } = useProducts();
  const { data: myProducer } = useMyProducer();
  const { data: home } = useHome();
  const { data: cart } = useCart();
  const cartCount = cart?.groups?.reduce((n, g) => n + g.items.length, 0) ?? 0;

  // 노출 순서를 적용해 실제 존재하는 카테고리만 칩으로.
  const filters = useMemo(() => {
    const present = new Set(allProducts.map((p) => p.category));
    const cats = CAT_ORDER.filter((c) => present.has(c)).map((c) => ({ value: c, label: c }));
    return [{ value: 'ALL', label: '전체' }, ...cats];
  }, [allProducts]);

  const list = useMemo(() => {
    const arr = category === 'ALL' ? allProducts : allProducts.filter((p) => p.category === category);
    return [...arr].sort(SORT_FNS[sort] || SORT_FNS.RECOMMENDED);
  }, [allProducts, category, sort]);

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

      {/* 카테고리 칩 — 스크롤 시 헤더 바로 아래 고정 */}
      <ChipTabs options={filters} value={category} onChange={setCategory} sticky className="sticky top-14" />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && (
        <div className="animate-fade-up pb-24">
          {/* 개수 / 정렬 행 */}
          <div className="flex items-center justify-between px-5 pb-2.5 pt-3.5">
            <span className="text-[12.5px] text-ink-mid">
              <b className="text-ink">{list.length}</b>개 상품
            </span>
            <button
              onClick={() => setSortOpen(true)}
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
        </div>
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
