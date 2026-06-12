'use client';

import { useRouter } from 'next/navigation';
import { ShoppingBag, X } from 'lucide-react';
import { useCart, useUpdateCartItem, useRemoveCartItem } from '@/lib/queries';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { QtyStepper } from '@/components/ui/Misc';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { VegImage } from '@/components/domain/VegImage';
import { wonLabel } from '@/lib/format';

export default function CartPage() {
  const router = useRouter();
  const toast = useToast();
  const { data, isLoading, error, refetch } = useCart();
  const updateItem = useUpdateCartItem();
  const removeItem = useRemoveCartItem();

  const onQty = (cartItemId, qty) => {
    updateItem.mutate(
      { id: cartItemId, qty },
      { onError: () => toast.show('수량 변경에 실패했어요', { type: 'error' }) },
    );
  };

  const onRemove = (cartItemId) => {
    removeItem.mutate(cartItemId, {
      onSuccess: () => toast.show('상품을 삭제했어요'),
      onError: () => toast.show('삭제에 실패했어요', { type: 'error' }),
    });
  };

  const isEmpty = data && (!data.groups || data.groups.length === 0);

  return (
    <>
      <AppHeader title="장바구니" back />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {isEmpty && (
        <EmptyState
          icon={<ShoppingBag size={40} strokeWidth={1.6} />}
          title="장바구니가 비어 있어요"
          description="제철 식재료를 담아 신선하게 받아보세요."
          action={
            <Button onClick={() => router.push('/products')}>제철 상품 보러가기</Button>
          }
        />
      )}

      {data && !isEmpty && (
        <>
          <div className="animate-fade-up bg-surface-soft pb-6">
            {data.groups.map((g) => (
              <ProducerGroup
                key={g.producerId}
                group={g}
                onQty={onQty}
                onRemove={onRemove}
              />
            ))}

            {/* 결제 금액 요약 */}
            <div className="px-4 pt-3.5">
              <div className="rounded-2xl border border-line-soft bg-white p-4">
                <SummaryRow label="상품 금액" value={data.itemsTotal} />
                <SummaryRow label="배송비" value={data.shippingTotal} />
                <div className="mt-2.5 flex items-center justify-between border-t border-line-soft pt-3">
                  <span className="text-[14px] font-extrabold text-ink">결제 예정 금액</span>
                  <span className="text-[18px] font-extrabold tabular text-brand">
                    {wonLabel(data.payTotal)}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <BottomBar>
            <Button block size="lg" onClick={() => router.push('/checkout')}>
              주문하기 ({wonLabel(data.payTotal)})
            </Button>
          </BottomBar>
        </>
      )}
    </>
  );
}

// 농가별 묶음 카드 — 헤더 + 아이템 행 + 소계/배송비.
function ProducerGroup({ group, onQty, onRemove }) {
  return (
    <div className="px-4 pt-3">
      <div className="overflow-hidden rounded-2xl border border-line-soft bg-white">
        <div className="border-b border-line-soft px-4 py-3.5">
          <span className="text-[14px] font-bold text-ink">{group.producerName}</span>
        </div>

        {group.items.map((it, i) => (
          <div
            key={it.cartItemId}
            className={
              'flex items-start gap-3 px-4 py-3' +
              (i < group.items.length - 1 ? ' border-b border-line-soft' : '')
            }
          >
            <VegImage name={it.ingredientName} src={it.imageUrl} size={48} />

            <div className="min-w-0 flex-1">
              <div className="text-[14px] font-bold text-ink">{it.ingredientName}</div>
              <div className="mt-0.5 text-[11.5px] text-ink-soft">
                {it.unit}당 · {wonLabel(it.unitPrice)}
              </div>
              <div className="mt-2">
                <QtyStepper
                  value={it.qty}
                  onChange={(q) => onQty(it.cartItemId, q)}
                  size="sm"
                />
              </div>
            </div>

            <div className="flex flex-col items-end gap-2">
              <button
                onClick={() => onRemove(it.cartItemId)}
                aria-label="삭제"
                className="tap -mr-1 -mt-1 grid h-7 w-7 place-items-center text-ink-soft"
              >
                <X size={16} />
              </button>
              <span className="whitespace-nowrap text-[14px] font-extrabold tabular text-ink">
                {wonLabel(it.unitPrice * it.qty)}
              </span>
            </div>
          </div>
        ))}

        <div className="flex items-center justify-between bg-surface-soft px-4 py-3 text-[12.5px] text-ink-mid">
          <span>
            상품 {group.items.length}개 · 배송비{' '}
            {group.shipping > 0 ? wonLabel(group.shipping) : '무료'}
          </span>
          <span className="font-extrabold tabular text-ink">
            {wonLabel(group.subtotal + group.shipping)}
          </span>
        </div>
      </div>
    </div>
  );
}

function SummaryRow({ label, value }) {
  return (
    <div className="mb-2 flex items-center justify-between text-[13px] text-ink-mid">
      <span>{label}</span>
      <span className="tabular">{wonLabel(value)}</span>
    </div>
  );
}
