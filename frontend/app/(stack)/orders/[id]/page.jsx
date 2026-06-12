'use client';

import Link from 'next/link';
import { CheckCircle2, Sprout, Truck } from 'lucide-react';
import { useOrder } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { VegImage } from '@/components/domain/VegImage';
import { won, wonLabel, date } from '@/lib/format';

export default function OrderDetailPage({ params }) {
  const id = params.id;
  const { data: order, isLoading, error, refetch } = useOrder(id);

  if (isLoading) {
    return (
      <>
        <AppHeader title="주문 완료" back />
        <LoadingScreen />
      </>
    );
  }

  if (error) {
    return (
      <>
        <AppHeader title="주문 완료" back />
        <ErrorState onRetry={refetch} />
      </>
    );
  }

  if (!order) {
    return (
      <>
        <AppHeader title="주문 완료" back />
        <EmptyState
          title="주문을 찾을 수 없어요"
          description="이미 취소되었거나 잘못된 주문이에요."
          action={
            <Link href="/my/orders">
              <Button variant="soft" size="sm">
                주문 내역 보기
              </Button>
            </Link>
          }
        />
      </>
    );
  }

  const items = order.items || [];

  return (
    <>
      <AppHeader title="주문 완료" back />

      <div className="animate-fade-up pb-8">
        {/* 완료 헤드라인 */}
        <div className="px-5 pb-5 pt-7 text-center">
          <CheckCircle2 size={64} strokeWidth={2.2} className="mx-auto text-brand" />
          <h1 className="mt-4 text-[20px] font-extrabold tracking-tight text-ink">주문이 완료되었어요</h1>
          <p className="mt-1.5 text-[12.5px] text-ink-soft tabular-nums">
            주문번호 {order.orderNumber}
            {order.orderedAt ? ` · ${date(order.orderedAt)}` : ''}
          </p>

          {order.pointsEarned > 0 && (
            <div className="mt-4 inline-flex items-center gap-1.5 rounded-full bg-brand-bg px-3.5 py-1.5 text-[12.5px] font-bold text-brand-dark tabular-nums">
              <Sprout size={14} />
              {won(order.pointsEarned)}P 적립 예정
            </div>
          )}
        </div>

        {/* 주문 상품 */}
        <div className="px-4">
          <div className="overflow-hidden rounded-2xl border border-line-soft bg-white">
            <div className="border-b border-line-soft px-4 py-3 text-[13px] font-extrabold text-ink">
              주문 상품 {items.length}개
            </div>
            {items.map((it, i) => (
              <div
                key={i}
                className="flex items-center gap-3 border-b border-line-soft px-4 py-3 last:border-b-0"
              >
                <VegImage name={it.ingredientName} size={40} />
                <div className="min-w-0 flex-1">
                  <p className="truncate text-[11.5px] font-semibold text-ink-soft">{it.producerName}</p>
                  <p className="truncate text-[13.5px] font-bold text-ink">{it.ingredientName}</p>
                  <p className="mt-0.5 text-[11.5px] text-ink-soft tabular-nums">{it.qty}개</p>
                </div>
                <div className="text-[13.5px] font-extrabold text-ink tabular-nums">
                  {wonLabel(it.unitPrice * it.qty)}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* 결제 금액 */}
        <div className="px-4 pt-3">
          <div className="rounded-2xl border border-line-soft bg-white p-4">
            <div className="mb-2 flex items-center justify-between text-[13px] text-ink-mid">
              <span>상품 금액</span>
              <span className="tabular-nums">{wonLabel(order.itemsTotal)}</span>
            </div>
            <div className="mb-3 flex items-center justify-between text-[13px] text-ink-mid">
              <span>배송비</span>
              <span className="tabular-nums">{wonLabel(order.shippingFee)}</span>
            </div>
            <div className="flex items-center justify-between border-t border-line-soft pt-3">
              <span className="text-[14px] font-extrabold text-ink">결제 금액</span>
              <span className="text-[18px] font-extrabold text-brand tabular-nums">
                {wonLabel(order.totalAmount)}
              </span>
            </div>
          </div>
        </div>

        {/* 배송 안내 */}
        <div className="px-4 pt-3">
          <div className="flex items-center gap-3 rounded-2xl bg-brand-bg px-4 py-3.5">
            <Truck size={22} className="shrink-0 text-brand-dark" />
            <div className="min-w-0 flex-1">
              <p className="text-[13px] font-extrabold text-brand-dark">산지직송 · 수확 후 1~2일 내 출고</p>
              <p className="mt-0.5 text-[11.5px] text-ink-mid">배송 시작되면 알림으로 알려드릴게요</p>
            </div>
          </div>
        </div>

        {/* 액션 버튼 */}
        <div className="flex gap-3 px-4 pt-6">
          <Link href="/my/orders" className="flex-1">
            <Button variant="outline" size="lg" block>
              주문 내역 보기
            </Button>
          </Link>
          <Link href="/" className="flex-1">
            <Button variant="primary" size="lg" block>
              홈으로
            </Button>
          </Link>
        </div>
      </div>
    </>
  );
}
