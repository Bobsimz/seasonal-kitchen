'use client';

import Link from 'next/link';
import { ChevronRight, Eye, Heart, MessageSquare, ShoppingBag, Plus, Sprout } from 'lucide-react';
import { useMyProducer } from '@/lib/queries';
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
      <AppHeader title="판매자 센터" back />

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
  const stats = deriveStats(producer);
  const offers = deriveOffers(producer);

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

      {/* 통계 카드 (데모) */}
      <Section
        title="판매 현황"
        action={<span className="text-[11px] font-semibold text-ink-soft">데모 통계</span>}
      >
        <div className="grid grid-cols-2 gap-2.5 px-4">
          <StatCard icon={ShoppingBag} label="총 판매" value={`${won(stats.totalSold)}건`} tone="brand" />
          <StatCard icon={Eye} label="상품 조회수" value={won(stats.views)} tone="ink" />
          <StatCard icon={Heart} label="찜" value={won(stats.favorites)} tone="hot" />
          <StatCard
            icon={MessageSquare}
            label="리뷰"
            value={`${producer.rating || 0} · ${compact(producer.reviewCount || 0)}개`}
            tone="warn"
          />
        </div>
      </Section>

      {/* 최근 7일 매출 요약 (데모) */}
      <Section title="최근 7일 매출">
        <div className="px-4">
          <Card className="p-4">
            <div className="mb-3.5 flex items-baseline justify-between">
              <span className="text-[13px] font-bold text-ink">이번 주 합계</span>
              <span className="text-[12px] text-ink-soft">
                일 평균 {wonLabel(stats.dailyAvg)}
              </span>
            </div>
            <div className="flex h-28 items-end justify-between gap-2">
              {stats.week.map((b) => (
                <div key={b.d} className="flex h-full flex-1 flex-col items-center justify-end gap-1.5">
                  <div
                    className={cn(
                      'w-full rounded-md',
                      b.peak ? 'bg-gradient-to-b from-brand to-brand-dark' : 'bg-brand-bg',
                    )}
                    style={{ height: `${b.v}%` }}
                  />
                  <span className="text-[10.5px] text-ink-soft">{b.d}</span>
                </div>
              ))}
            </div>
            <p className="mt-3 text-[11px] text-ink-soft">실제 정산 데이터가 연동되면 자동으로 갱신돼요.</p>
          </Card>
        </div>
      </Section>

      {/* 내 판매 상품 */}
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
                <div
                  key={o.ingredientName}
                  className={cn(
                    'flex items-center gap-3 px-4 py-3',
                    i < offers.length - 1 && 'border-b border-line-soft',
                  )}
                >
                  <span className="w-5 text-center text-[14px] font-extrabold text-ink-soft tabular">
                    {i + 1}
                  </span>
                  <VegImage name={o.ingredientName} size={44} />
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[13.5px] font-bold text-ink">{o.title}</p>
                    <p className="mt-0.5 text-[11.5px] text-ink-soft">{o.soldLabel}</p>
                  </div>
                  <span className="shrink-0 text-[13.5px] font-extrabold text-ink tabular">
                    {wonLabel(o.price)}
                  </span>
                </div>
              ))}
            </Card>
          ) : (
            <Card className="px-4 py-8 text-center">
              <p className="text-[13.5px] font-bold text-ink">아직 등록한 상품이 없어요</p>
              <p className="mt-1 text-[12px] text-ink-soft">첫 상품을 등록하고 판매를 시작해 보세요.</p>
            </Card>
          )}
          <p className="mt-2 px-1 text-[11px] text-ink-soft">
            가격은 예시이며, 상품 등록 시 직접 설정한 가격으로 표시돼요.
          </p>
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

// ── 데모 통계 산출 ──────────────────────────────────────────
// 실제 판매/조회 데이터가 없으므로 농가 정보(rating/reviewCount/specialties)에서
// 안정적으로 파생한 예시 수치. (라벨에 '데모 통계' 표기)
function deriveStats(producer) {
  const reviews = producer.reviewCount || 0;
  const specCount = producer.specialties?.length || 1;
  const totalSold = reviews * 7 + specCount * 18 + 24;
  const views = totalSold * 67 + 1240;
  const favorites = Math.round(totalSold * 1.8) + 36;
  const week = [62, 48, 80, 56, 95, 100, 74].map((v, i) => ({
    d: ['월', '화', '수', '목', '금', '토', '일'][i],
    v,
    peak: i === 5,
  }));
  const dailyAvg = Math.round((totalSold * 9800) / 7 / 1000) * 1000;
  return { totalSold, views, favorites, week, dailyAvg };
}

// specialties → offer 형태의 표시용 목록 (가격은 placeholder)
function deriveOffers(producer) {
  const list = producer.specialties || [];
  return list.slice(0, 6).map((name, i) => ({
    ingredientName: name,
    title: `${producer.region} ${name} 산지직송`,
    price: 8900 + i * 1500,
    soldLabel: `누적 ${won((producer.reviewCount || 0) * 4 + (i + 1) * 11)}건 판매`,
  }));
}
