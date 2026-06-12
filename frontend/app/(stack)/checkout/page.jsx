'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { CreditCard, MapPin, ShoppingBag, Sparkles, Wallet } from 'lucide-react';
import { useCart, useCreateOrder } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { Card, Section } from '@/components/ui/Card';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { won, wonLabel } from '@/lib/format';
import { cn } from '@/lib/cn';

// 결제 수단(목업) — 로컬 상태로만 동작.
const PAY_METHODS = [
  { value: 'EASY', label: '간편결제', desc: '제철페이 · 카카오페이 · 네이버페이', icon: Wallet },
  { value: 'CARD', label: '신용/체크카드', desc: '국내 모든 카드', icon: CreditCard },
];

// 배송지(목업).
const ADDRESS = {
  name: '홍길동',
  phone: '010-1234-5678',
  line: '서울특별시 마포구 어울마당로 35, 101동 1203호',
};

function PayMethodRow({ method, selected, onSelect }) {
  const Icon = method.icon;
  return (
    <button
      type="button"
      onClick={() => onSelect(method.value)}
      className={cn(
        'tap flex w-full items-center gap-3 rounded-2xl border px-4 py-3.5 text-left transition',
        selected ? 'border-brand bg-brand-bg' : 'border-line bg-white',
      )}
    >
      <span
        className={cn(
          'grid h-9 w-9 shrink-0 place-items-center rounded-xl',
          selected ? 'bg-brand text-white' : 'bg-line-soft text-ink-soft',
        )}
      >
        <Icon size={18} />
      </span>
      <span className="min-w-0 flex-1">
        <span className="block text-[14px] font-bold text-ink">{method.label}</span>
        <span className="block truncate text-[12px] text-ink-soft">{method.desc}</span>
      </span>
      <span
        className={cn(
          'grid h-5 w-5 shrink-0 place-items-center rounded-full border-2',
          selected ? 'border-brand' : 'border-line',
        )}
      >
        {selected && <span className="h-2.5 w-2.5 rounded-full bg-brand" />}
      </span>
    </button>
  );
}

function PriceLine({ label, value, strong }) {
  return (
    <div className="flex items-center justify-between text-[13.5px]">
      <span className={cn(strong ? 'font-bold text-ink' : 'text-ink-mid')}>{label}</span>
      <span className={cn(strong ? 'text-[17px] font-extrabold text-ink' : 'font-semibold text-ink')}>{value}</span>
    </div>
  );
}

export default function CheckoutPage() {
  const router = useRouter();
  const { isAuthenticated, ready } = useAuth();
  const toast = useToast();
  const { data: cart, isLoading, error, refetch } = useCart();
  const createOrder = useCreateOrder();
  const [payMethod, setPayMethod] = useState('EASY');

  // 로그인 가드 — 비로그인 시 로그인으로.
  useEffect(() => {
    if (ready && !isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.replace('/login?next=' + encodeURIComponent('/checkout'));
    }
  }, [ready, isAuthenticated, router, toast]);

  const onPay = async () => {
    if (!cart || cart.payTotal == null) return;
    try {
      const order = await createOrder.mutateAsync();
      router.replace('/orders/' + order.id);
    } catch {
      toast.show('결제에 실패했어요', { type: 'error' });
    }
  };

  const isEmpty = cart && (!cart.groups || cart.groups.length === 0);
  const pointsEarned = cart ? Math.round((cart.itemsTotal || 0) * 0.01) : 0;

  return (
    <>
      <AppHeader title="주문/결제" back />

      {(isLoading || !ready || !isAuthenticated) && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {ready && isAuthenticated && cart && isEmpty && (
        <EmptyState
          icon={<ShoppingBag size={40} strokeWidth={1.5} />}
          title="장바구니가 비어 있어요"
          description="결제할 상품을 먼저 담아 주세요."
          action={
            <Button onClick={() => router.replace('/products')}>제철 상품 보러가기</Button>
          }
        />
      )}

      {ready && isAuthenticated && cart && !isEmpty && (
        <>
          <div className="animate-fade-up pb-6">
            {/* 배송지 */}
            <Section title="배송지">
              <div className="px-4">
                <Card className="p-4">
                  <div className="flex items-start gap-3">
                    <span className="mt-0.5 grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-brand-bg text-brand-dark">
                      <MapPin size={18} />
                    </span>
                    <div className="min-w-0 flex-1">
                      <p className="text-[14px] font-bold text-ink">
                        {ADDRESS.name}
                        <span className="ml-2 text-[12.5px] font-medium text-ink-soft">{ADDRESS.phone}</span>
                      </p>
                      <p className="mt-1 text-[13px] leading-relaxed text-ink-mid">{ADDRESS.line}</p>
                    </div>
                    <button
                      type="button"
                      onClick={() => toast.show('배송지 변경은 준비 중이에요')}
                      className="tap shrink-0 rounded-lg border border-line px-2.5 py-1 text-[12px] font-semibold text-ink-mid"
                    >
                      변경
                    </button>
                  </div>
                </Card>
              </div>
            </Section>

            {/* 주문 상품 */}
            <Section title="주문 상품">
              <div className="px-4">
                <Card className="divide-y divide-line-soft p-0">
                  {cart.groups.map((g) => (
                    <div key={g.producerId} className="px-4 py-3.5">
                      <p className="mb-2.5 text-[12.5px] font-bold text-ink-mid">{g.producerName}</p>
                      <div className="space-y-2.5">
                        {g.items.map((it) => (
                          <div key={it.cartItemId} className="flex items-center gap-3">
                            <div className="h-12 w-12 shrink-0 overflow-hidden rounded-xl bg-line-soft">
                              {it.imageUrl && (
                                <img src={it.imageUrl} alt={it.ingredientName} className="h-full w-full object-cover" />
                              )}
                            </div>
                            <div className="min-w-0 flex-1">
                              <p className="truncate text-[13.5px] font-bold text-ink">{it.ingredientName}</p>
                              <p className="mt-0.5 text-[12px] text-ink-soft">
                                {wonLabel(it.unitPrice)}/{it.unit} · {it.qty}개
                              </p>
                            </div>
                            <span className="shrink-0 text-[13.5px] font-bold text-ink">
                              {wonLabel(it.unitPrice * it.qty)}
                            </span>
                          </div>
                        ))}
                      </div>
                    </div>
                  ))}
                </Card>
              </div>
            </Section>

            {/* 결제 수단 */}
            <Section title="결제 수단">
              <div className="space-y-2 px-4">
                {PAY_METHODS.map((m) => (
                  <PayMethodRow key={m.value} method={m} selected={payMethod === m.value} onSelect={setPayMethod} />
                ))}
              </div>
            </Section>

            {/* 결제 금액 */}
            <Section title="결제 금액">
              <div className="px-4">
                <Card className="space-y-3 p-4">
                  <PriceLine label="상품 금액" value={wonLabel(cart.itemsTotal)} />
                  <PriceLine
                    label="배송비"
                    value={cart.shippingTotal ? wonLabel(cart.shippingTotal) : '무료'}
                  />
                  <div className="h-px bg-line-soft" />
                  <PriceLine label="총 결제 금액" value={wonLabel(cart.payTotal)} strong />
                  <div className="flex items-center gap-1.5 rounded-xl bg-brand-bg px-3 py-2 text-[12.5px] font-semibold text-brand-dark">
                    <Sparkles size={14} />
                    결제 시 <b>{won(pointsEarned)}P</b> 적립 예정 (1%)
                  </div>
                </Card>
              </div>
            </Section>
          </div>

          <BottomBar>
            <Button block size="lg" loading={createOrder.isPending} disabled={isEmpty} onClick={onPay}>
              {wonLabel(cart.payTotal)} 결제하기
            </Button>
          </BottomBar>
        </>
      )}
    </>
  );
}
