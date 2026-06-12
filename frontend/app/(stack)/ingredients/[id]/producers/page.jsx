'use client';

import Link from 'next/link';
import { ChevronRight, Star, Sprout } from 'lucide-react';
import { useIngredient, useIngredientProducers } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { ProducerAvatar } from '@/components/domain/ProducerCard';
import { StyleBadge } from '@/components/domain/StyleBadge';
import { AddToCartButton } from '@/components/domain/AddToCartButton';
import { won } from '@/lib/format';
import { cn } from '@/lib/cn';

export default function IngredientProducersPage({ params }) {
  const id = params.id;
  const { data: ingredient } = useIngredient(id);
  const { data: offers = [], isLoading, error, refetch } = useIngredientProducers(id);

  const name = ingredient?.name || '';

  return (
    <>
      <AppHeader title={name ? `농가 직거래 · ${name}` : '농가 직거래'} back />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && offers.length === 0 && (
        <EmptyState
          title="아직 직거래 농가가 없어요"
          description="이 재료를 취급하는 농가가 등록되면 알려드릴게요."
        />
      )}

      {!isLoading && !error && offers.length > 0 && (
        <div className="animate-fade-up pb-6">
          {/* 상단 안내 */}
          <div className="flex items-center justify-between px-4 pb-2 pt-3">
            <p className="text-[12.5px] font-bold text-ink-mid">
              전체 비교 · <span className="text-ink">{offers.length}곳</span>
            </p>
            <p className="text-[11.5px] text-ink-soft">가격은 농가 직거래 기준</p>
          </div>

          {/* 가격순 랭킹 리스트 */}
          <div className="mx-4 overflow-hidden rounded-2xl border border-line-soft bg-surface">
            {offers.map((row, i) => (
              <ProducerOfferRow key={row.id} row={row} rank={i + 1} last={i === offers.length - 1} />
            ))}
          </div>

          {/* 참고 */}
          <div className="mx-4 mt-3 rounded-xl border border-dashed border-line px-3.5 py-3 text-[11.5px] leading-relaxed text-ink-mid">
            <b className="text-ink">참고</b> · 가격은 농가 직거래 기준이에요. 배송비 · 수확일은 각 농가에서 확인하세요.
          </div>
        </div>
      )}
    </>
  );
}

// 농가 비교 한 줄 — 좌: 농가 정보(탭 시 농가 상세), 우: 가격 + 담기.
function ProducerOfferRow({ row, rank, last }) {
  const lowest = rank === 1;

  return (
    <div className={cn('px-4 py-3.5', !last && 'border-b border-line-soft')}>
      {/* 농가 정보 — 탭하면 농가 상세로 */}
      <Link href={`/producers/${row.producerId}`} className="tap flex items-center gap-3">
        <div className="grid h-6 w-6 shrink-0 place-items-center rounded-full bg-surface-soft text-[12px] font-extrabold text-ink-soft">
          {rank}
        </div>
        <ProducerAvatar producer={{ photoUrl: row.photoUrl, honorary: row.honorary }} size={44} />
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-1.5">
            <span className="truncate text-[14px] font-bold text-ink">
              {row.region} {row.producerName}
            </span>
            {lowest && (
              <span className="shrink-0 rounded-full bg-brand-bg px-1.5 py-0.5 text-[10.5px] font-extrabold text-brand-dark">
                최저가
              </span>
            )}
          </div>
          <div className="mt-1 flex items-center gap-2">
            <StyleBadge style={row.style} className="!px-1.5 !py-0.5 !text-[10.5px]" />
            <span className="flex items-center gap-0.5 text-[11.5px] font-semibold text-ink-mid">
              <Star size={11} className="fill-warn text-warn" />
              {row.rating}
              <span className="font-normal text-ink-soft">({row.reviewCount})</span>
            </span>
          </div>
        </div>
        <ChevronRight size={16} className="shrink-0 text-ink-soft" />
      </Link>

      {/* 가격 + 담기 */}
      <div className="mt-2.5 flex items-center gap-2 border-t border-line-soft pt-2.5">
        <div className="flex items-baseline gap-1">
          <span className="text-[16px] font-extrabold tabular-nums text-ink">{won(row.price)}원</span>
          <span className="text-[12px] text-ink-mid">/{row.unit}</span>
        </div>
        {row.freshnessLabel && (
          <span className="ml-1.5 flex items-center gap-0.5 text-[11.5px] font-bold text-brand">
            <Sprout size={12} />
            {row.freshnessLabel}
          </span>
        )}
        <div className="ml-auto">
          <AddToCartButton offerId={row.id} />
        </div>
      </div>
    </div>
  );
}
