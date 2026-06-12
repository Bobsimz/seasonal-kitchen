'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Plus, ShoppingBag } from 'lucide-react';
import { useProducers, useMyProducer, useProducerOffers } from '@/lib/queries';
import { AppHeader, HeaderIconButton } from '@/components/layout';
import { SearchBar } from '@/components/ui/SearchBar';
import { ChipTabs } from '@/components/ui/SegmentedToggle';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { ProducerRow } from '@/components/domain/ProducerCard';
import { wonLabel } from '@/lib/format';

// 명예/스타일 필터 칩 → 농가 style enum 매핑. value=null 이면 전체.
const FILTERS = [
  { value: 'ALL', label: '전체' },
  { value: 'ORGANIC', label: '유기농' },
  { value: 'PREMIUM', label: '프리미엄' },
  { value: 'VALUE', label: '실속' },
];

export default function ProductsPage() {
  const router = useRouter();
  const [filter, setFilter] = useState('ALL');
  const { data: producers = [], isLoading, error, refetch } = useProducers();
  const { data: myProducer } = useMyProducer();

  const list = filter === 'ALL' ? producers : producers.filter((p) => p.style === filter);

  // 판매 등록 진입: 내 농가가 있으면 상품 등록, 없으면 농가 등록.
  const sellHref = myProducer ? '/my/seller/offers/new' : '/my/seller/register';

  return (
    <>
      <AppHeader
        title="상품"
        right={<HeaderIconButton icon={ShoppingBag} href="/cart" label="장바구니" />}
      />

      <div className="px-4 pb-3 pt-3">
        <SearchBar readOnly onClick={() => router.push('/search')} placeholder="농가·상품 검색" />
      </div>

      {/* 필터 칩 — 스크롤 시 헤더 바로 아래 고정 (검색바는 위로 사라짐) */}
      <ChipTabs options={FILTERS} value={filter} onChange={setFilter} sticky className="sticky top-14" />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && (
        <div className="animate-fade-up pb-24">
          {/* 정렬/개수 행 */}
          <div className="flex items-center justify-between px-5 pb-2 pt-3.5">
            <span className="text-[12.5px] text-ink-mid">
              <b className="text-ink">{list.length}</b>개 농가
            </span>
            <span className="text-[12.5px] font-bold text-ink-mid">추천순</span>
          </div>

          {list.length === 0 ? (
            <EmptyState
              title="조건에 맞는 농가가 없어요"
              description="다른 필터를 선택해 보세요."
            />
          ) : (
            <div className="px-2">
              {list.map((p) => (
                <ProducerRow
                  key={p.id}
                  producer={p}
                  href={`/products/${p.id}`}
                  footer={<OffersFooter producerId={p.id} />}
                />
              ))}
            </div>
          )}
        </div>
      )}

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

// 농가별 대표 상품 2-3개를 행 하단에 노출 (ingredientName + price).
function OffersFooter({ producerId }) {
  const { data: offers = [] } = useProducerOffers(producerId);
  if (offers.length === 0) return null;
  return (
    <div className="flex gap-2 overflow-x-auto phone-scroll">
      {offers.slice(0, 3).map((o) => (
        <Link
          key={o.id}
          href={`/products/${producerId}`}
          className="tap flex shrink-0 items-center gap-2 rounded-xl border border-line-soft bg-surface-soft px-2.5 py-1.5"
        >
          <span className="text-[12px] font-bold text-ink">{o.ingredientName}</span>
          <span className="text-[12px] font-extrabold text-brand-dark">
            {wonLabel(o.price)}
            <span className="font-medium text-ink-soft">/{o.unit}</span>
          </span>
        </Link>
      ))}
    </div>
  );
}
