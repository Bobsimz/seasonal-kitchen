'use client';

import Link from 'next/link';
import { ChevronRight, ShoppingBag, Wallet, CalendarDays, Star, Plus, Sprout } from 'lucide-react';
import { useMyProducer, useMyStats, useMyOffers } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { Card, Section } from '@/components/ui/Card';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { ProducerAvatar, StyleBadge, VegImage } from '@/components/domain';
import { won, wonLabel, compact } from '@/lib/format';
import { cn } from '@/lib/cn';

export default function SellerDashboardPage() {
  const { data: producer, isLoading, error, refetch } = useMyProducer();

  return (
    <>
      <AppHeader title="농가 센터" back />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && !producer && (
        <EmptyState
          icon={<Sprout size={40} strokeWidth={1.6} />}
          title="아직 농가로 등록하지 않았어요"
          description="농가로 등록하면 제철식탁에서 직접 상품을 판매하고 판매 통계를 볼 수 있어요."
          action={
            <Link href="/my/seller/register">
              <Button size="md">농가 등록하기</Button>
            </Link>
          }
        />
      )}

      {!isLoading && !error && producer && <Dashboard producer={producer} />}
    </>
  );
}

function Dashboard({ producer }) {
  const { data: stats } = useMyStats();
  const { data: offers = [] } = useMyOffers();

  const summary = stats?.summary;
  const series = stats?.revenueSeries ?? [];
  const maxAmt = Math.max(1, ...series.map((d) => Number(d.amount) || 0));

  return (
    <div className="animate-fade-up pb-28">
      {/* 농가 헤더 */}
      <div className="px-4 pt-2">
        <Card className="flex items-center gap-3 p-4">
          <ProducerAvatar producer={producer} size={56} />
          <div className="min-w-0 flex-1">
            <div className="flex items-center gap-1.5">
              <span className="truncate text-[16px] font-extrabold tracking-tight text-ink">
                {producer.region} {producer.name}
              </span>
              <StyleBadge style={producer.style} />
            </div>
            {producer.tagline && (
              <p className="mt-0.5 truncate text-[12px] text-ink-soft">{producer.tagline}</p>
            )}
          </div>
          <Link
            href={`/producers/${producer.id}`}
            className="tap flex shrink-0 items-center text-[12.5px] font-semibold text-ink-soft"
          >
            내 농가 보기 <ChevronRight size={14} />
          </Link>
        </Card>
      </div>

      {/* 판매 현황 (실데이터) */}
      <Section title="판매 현황">
        <div className="grid grid-cols-2 gap-2.5 px-4">
          <StatCard icon={Wallet} label="이번 달 매출" value={`${won(summary?.monthlyRevenue ?? 0)}원`} tone="brand" />
          <StatCard icon={ShoppingBag} label="이번 달 주문" value={`${summary?.orderCount ?? 0}건`} tone="ink" />
          <StatCard icon={CalendarDays} label="오늘 매출" value={`${won(summary?.todayRevenue ?? 0)}원`} tone="hot" />
          <StatCard
            icon={Star}
            label="평점 · 리뷰"
            value={`${producer.rating || 0} · ${compact(producer.reviewCount || 0)}개`}
            tone="warn"
          />
        </div>
      </Section>

      {/* 최근 7일 매출 (실데이터) */}
      <Section title="최근 7일 매출">
        <div className="px-4">
          <Card className="p-4">
            {series.length === 0 ? (
              <p className="py-6 text-center text-[12.5px] text-ink-soft">
                아직 매출 데이터가 없어요. 첫 판매가 발생하면 표시됩니다.
              </p>
            ) : (
              <>
                <div className="mb-3.5 flex items-baseline justify-between">
                  <span className="text-[13px] font-bold text-ink">최근 7일</span>
                  <span className="text-[12px] text-ink-soft">
                    일 평균 {wonLabel(stats?.dailyAverage ?? 0)}
                  </span>
                </div>
                <div className="flex h-28 items-end justify-between gap-2">
                  {series.map((d) => {
                    const amt = Number(d.amount) || 0;
                    const isPeak = amt === maxAmt && amt > 0;
                    return (
                      <div key={d.date} className="flex h-full flex-1 flex-col items-center justify-end gap-1.5">
                        <div
                          className={cn(
                            'w-full rounded-md',
                            isPeak ? 'bg-gradient-to-b from-brand to-brand-dark' : 'bg-brand-bg',
                          )}
                          style={{ height: `${Math.max(4, (amt / maxAmt) * 100)}%` }}
                        />
                        <span className="text-[10.5px] text-ink-soft">{dayLabel(d.date)}</span>
                      </div>
                    );
                  })}
                </div>
              </>
            )}
          </Card>
        </div>
      </Section>

      {/* 내 판매 상품 (실데이터) */}
      <Section
        title="내 판매 상품"
        action={
          <Link
            href="/my/seller/offers/new"
            className="tap flex items-center text-[12.5px] font-semibold text-brand"
          >
            <Plus size={14} className="mr-0.5" /> 추가
          </Link>
        }
      >
        <div className="px-4">
          {offers.length > 0 ? (
            <Card className="overflow-hidden">
              {offers.map((o, i) => (
                <Link
                  key={o.id}
                  href={`/products/${o.producerId}?offer=${o.id}`}
                  className={cn(
                    'tap flex items-center gap-3 px-4 py-3',
                    i < offers.length - 1 && 'border-b border-line-soft',
                  )}
                >
                  {o.photoUrls?.[0] ? (
                    <img src={o.photoUrls[0]} alt={o.title || o.ingredientName} className="h-11 w-11 shrink-0 rounded-xl object-cover" />
                  ) : (
                    <VegImage name={o.ingredientName} size={44} />
                  )}
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[13.5px] font-bold text-ink">{o.title || o.ingredientName}</p>
                    <p className="mt-0.5 text-[11.5px] text-ink-soft">
                      {o.category || '기타'} · {o.unit}
                      {o.freshnessLabel ? ` · ${o.freshnessLabel}` : ''}
                    </p>
                  </div>
                  <span className="shrink-0 text-[13.5px] font-extrabold text-ink tabular">
                    {wonLabel(o.price)}
                  </span>
                </Link>
              ))}
            </Card>
          ) : (
            <Card className="px-4 py-8 text-center">
              <p className="text-[13.5px] font-bold text-ink">아직 등록한 상품이 없어요</p>
              <p className="mt-1 text-[12px] text-ink-soft">첫 상품을 등록하고 판매를 시작해 보세요.</p>
            </Card>
          )}
        </div>
      </Section>

      {/* 상품 등록 CTA */}
      <div className="mt-6 px-4">
        <Link href="/my/seller/offers/new" className="block">
          <Button block size="lg">
            <Plus size={18} className="mr-1" /> 상품 등록
          </Button>
        </Link>
      </div>
    </div>
  );
}

function StatCard({ icon: Icon, label, value, tone = 'ink' }) {
  const toneCls = {
    brand: 'text-brand bg-brand-bg',
    hot: 'text-hot bg-hot-bg',
    warn: 'text-warn bg-warn-bg',
    ink: 'text-ink-mid bg-surface-soft',
  }[tone];
  return (
    <Card className="p-3.5">
      <div className="flex items-center gap-2">
        <span className={cn('grid h-7 w-7 place-items-center rounded-lg', toneCls)}>
          <Icon size={15} />
        </span>
        <span className="text-[11.5px] font-semibold text-ink-soft">{label}</span>
      </div>
      <p className="mt-2 text-[19px] font-extrabold tracking-tight text-ink tabular">{value}</p>
    </Card>
  );
}

// "2026-06-12" → 요일 라벨
function dayLabel(dateStr) {
  const d = new Date(dateStr);
  if (Number.isNaN(d.getTime())) return '';
  return ['일', '월', '화', '수', '목', '금', '토'][d.getDay()];
}
