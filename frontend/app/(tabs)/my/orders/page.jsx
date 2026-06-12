'use client';

import Link from 'next/link';
import { ChevronRight, Receipt } from 'lucide-react';
import { useOrders } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { Card } from '@/components/ui/Card';
import { Chip } from '@/components/ui/Chip';
import { Button } from '@/components/ui/Button';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { wonLabel, date } from '@/lib/format';

// 주문 상태 → 라벨 + Chip 톤. (데모는 PAID 만 생성하지만 라이프사이클 전체를 매핑)
const STATUS = {
  PENDING: { label: '결제대기', tone: 'warn' },
  PAID: { label: '결제완료', tone: 'brand' },
  PREPARING: { label: '상품준비중', tone: 'brand' },
  SHIPPED: { label: '배송중', tone: 'brand' },
  DELIVERED: { label: '배송완료', tone: 'neutral' },
  CANCELLED: { label: '주문취소', tone: 'neutral' },
};

function StatusChip({ status }) {
  const s = STATUS[status] || { label: status || '주문', tone: 'neutral' };
  return <Chip tone={s.tone}>{s.label}</Chip>;
}

function OrderCard({ order }) {
  return (
    <Card as={Link} href={`/orders/${order.id}`} className="tap block p-0">
      <div className="flex items-center justify-between border-b border-line-soft px-4 py-3">
        <span className="text-[12px] text-ink-soft">
          {date(order.orderedAt)}
          {order.orderNumber ? ` · ${order.orderNumber}` : ''}
        </span>
        <StatusChip status={order.status} />
      </div>

      <div className="flex items-center gap-3 px-4 py-3.5">
        <div className="min-w-0 flex-1">
          <p className="truncate text-[14px] font-bold text-ink">{order.summary}</p>
          <p className="mt-1 text-[13px] text-ink-mid">
            총 결제 <b className="ml-0.5 text-ink">{wonLabel(order.totalAmount)}</b>
          </p>
        </div>
        <ChevronRight size={18} className="shrink-0 text-ink-soft" />
      </div>
    </Card>
  );
}

export default function OrdersPage() {
  const { data: orders, isLoading, error, refetch } = useOrders();

  return (
    <>
      <AppHeader title="주문 내역" back />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {orders && orders.length === 0 && (
        <EmptyState
          icon={<Receipt size={40} strokeWidth={1.5} />}
          title="아직 주문 내역이 없어요"
          description="제철 식재료를 둘러보고 첫 주문을 시작해 보세요."
          action={
            <Link href="/products">
              <Button>제철 상품 보러가기</Button>
            </Link>
          }
        />
      )}

      {orders && orders.length > 0 && (
        <div className="animate-fade-up space-y-3 px-4 py-3 pb-6">
          {orders.map((o) => (
            <OrderCard key={o.id} order={o} />
          ))}
        </div>
      )}
    </>
  );
}
