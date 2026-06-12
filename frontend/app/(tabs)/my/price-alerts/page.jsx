'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { Plus, BellRing } from 'lucide-react';
import { usePriceAlerts } from '@/lib/queries';
import { AppHeader, HeaderIconButton } from '@/components/layout';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { TrendBadge } from '@/components/ui/Misc';
import { useToast } from '@/components/ui/Toast';
import { Button } from '@/components/ui/Button';
import { VegImage } from '@/components/domain/VegImage';
import { wonLabel } from '@/lib/format';
import { cn } from '@/lib/cn';

export default function PriceAlertsPage() {
  const { data: alerts = [], isLoading, error, refetch } = usePriceAlerts();
  const toast = useToast();

  const onAdd = () => toast.show('곧 제공돼요');

  return (
    <>
      <AppHeader
        title="가격 알림"
        back
        right={<HeaderIconButton icon={Plus} onClick={onAdd} label="알림 추가" />}
      />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && alerts.length === 0 && (
        <EmptyState
          icon={<BellRing size={40} strokeWidth={1.5} />}
          title="설정한 가격 알림이 없어요"
          description="식재료 상세에서 목표가를 정해두면, 그 가격 이하로 떨어졌을 때 알려드려요."
          action={
            <Link href="/info">
              <Button variant="soft" size="sm">
                제철 식재료 둘러보기
              </Button>
            </Link>
          }
        />
      )}

      {!isLoading && !error && alerts.length > 0 && (
        <div className="animate-fade-up px-4 pb-6 pt-3">
          <p className="mb-3 text-[12.5px] text-ink-soft">
            목표가 이하로 떨어지면 알려드려요 · 총 {alerts.length}개
          </p>
          <div className="space-y-2.5">
            {alerts.map((a) => (
              <AlertCard key={a.id} alert={a} />
            ))}
          </div>
        </div>
      )}
    </>
  );
}

// 가격 알림 카드 — VegImage + 이름 + 목표가 안내 + 현재가(+달성 배지) + 활성 토글.
function AlertCard({ alert: a }) {
  const [active, setActive] = useState(a.active);
  const toast = useToast();

  // 서버 데이터가 갱신되면 로컬 토글도 동기화.
  useEffect(() => setActive(a.active), [a.active]);

  const reached = typeof a.currentPrice === 'number' && typeof a.targetPrice === 'number' && a.currentPrice <= a.targetPrice;

  const onToggle = (e) => {
    e.preventDefault();
    e.stopPropagation();
    const next = !active;
    setActive(next);
    toast.show(next ? '알림을 켰어요' : '알림을 껐어요');
  };

  return (
    <Link
      href={`/ingredients/${a.ingredientId}`}
      className="tap flex items-center gap-3 rounded-2xl border border-line-soft bg-white p-3 shadow-card"
    >
      <VegImage name={a.ingredientName} src={a.imageUrl} size={56} />

      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-1.5">
          <span className="truncate text-[15px] font-bold text-ink">{a.ingredientName}</span>
          {reached && (
            <span className="shrink-0 rounded-full bg-brand-soft px-2 py-0.5 text-[10.5px] font-bold text-brand-dark">
              목표가 도달
            </span>
          )}
        </div>
        <p className="mt-0.5 text-[12px] text-ink-soft">
          목표가 <span className="font-semibold text-ink-mid">{wonLabel(a.targetPrice)}</span> 이하면 알림
        </p>
        <div className="mt-1 flex items-center gap-1.5">
          <span className="text-[13px] font-extrabold text-ink tabular">
            현재가 {wonLabel(a.currentPrice)}
            <span className="ml-0.5 text-[11px] font-medium text-ink-soft">/{a.unit}</span>
          </span>
          {reached && <TrendBadge direction="DOWN" label="목표 달성" />}
        </div>
      </div>

      {/* 활성 토글 스위치 (로컬 상태) */}
      <button
        type="button"
        role="switch"
        aria-checked={active}
        aria-label={`${a.ingredientName} 알림 ${active ? '켜짐' : '꺼짐'}`}
        onClick={onToggle}
        className={cn(
          'tap relative h-7 w-12 shrink-0 rounded-full transition-colors',
          active ? 'bg-brand' : 'bg-line',
        )}
      >
        <span
          className={cn(
            'absolute top-0.5 grid h-6 w-6 place-items-center rounded-full bg-white shadow transition-all',
            active ? 'left-[22px]' : 'left-0.5',
          )}
        />
      </button>
    </Link>
  );
}
