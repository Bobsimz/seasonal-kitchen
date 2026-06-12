'use client';

import { Suspense, useMemo, useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { Star, Truck, Package, Snowflake, ChevronRight } from 'lucide-react';
import { useProducer, useProducerOffers, useAddToCart } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { AppHeader } from '@/components/layout';
import { BottomBar } from '@/components/layout/BottomBar';
import { Button } from '@/components/ui/Button';
import { Chip } from '@/components/ui/Chip';
import { QtyStepper } from '@/components/ui/Misc';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { VegImage } from '@/components/domain/VegImage';
import { ProducerAvatar } from '@/components/domain/ProducerCard';
import { StyleBadge } from '@/components/domain/StyleBadge';
import { won, wonLabel, compact } from '@/lib/format';

export default function ProductDetailPage({ params }) {
  const producerId = params.id;
  return (
    <Suspense fallback={<LoadingScreen />}>
      <ProductDetail producerId={producerId} />
    </Suspense>
  );
}

function ProductDetail({ producerId }) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const focusedOfferId = searchParams.get('offer');
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const addToCart = useAddToCart();

  const { data: producer, isLoading: producerLoading, error: producerError, refetch: refetchProducer } = useProducer(producerId);
  const { data: offers = [], isLoading: offersLoading, error: offersError, refetch: refetchOffers } = useProducerOffers(producerId);

  const [qty, setQty] = useState(1);

  const offer = useMemo(() => {
    if (!offers.length) return null;
    if (focusedOfferId) {
      const hit = offers.find((o) => String(o.id) === String(focusedOfferId));
      if (hit) return hit;
    }
    return offers[0];
  }, [offers, focusedOfferId]);

  const otherOffers = useMemo(
    () => (offer ? offers.filter((o) => o.id !== offer.id) : []),
    [offers, offer],
  );

  const isLoading = producerLoading || offersLoading;
  const error = producerError || offersError;

  const onAddToCart = () => {
    if (!offer) return;
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.push('/login?next=' + encodeURIComponent(typeof window !== 'undefined' ? window.location.pathname + window.location.search : '/'));
      return;
    }
    addToCart.mutate(
      { offerId: offer.id, qty },
      {
        onSuccess: () => {
          toast.show('장바구니에 담았어요', { type: 'success' });
          router.push('/cart');
        },
        onError: () => toast.show('담기에 실패했어요', { type: 'error' }),
      },
    );
  };

  return (
    <>
      <AppHeader title="상품 상세" back />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={() => { refetchProducer(); refetchOffers(); }} />}

      {!isLoading && !error && (!offer || !producer) && (
        <EmptyState title="상품을 찾을 수 없어요" description="판매 중인 상품이 없거나 삭제되었어요." />
      )}

      {!isLoading && !error && offer && producer && (
        <>
          <div className="animate-fade-up bg-surface-soft pb-28">
            {/* 농가 헤더 */}
            <div className="px-4 pt-3">
              <Link
                href={`/producers/${producer.id}`}
                className="tap flex items-center gap-2 rounded-2xl border border-line-soft bg-white p-4"
              >
                <div className="flex min-w-0 flex-1 items-center gap-3">
                  <ProducerAvatar producer={producer} size={48} />
                  <div className="min-w-0">
                    <div className="flex items-center gap-1.5">
                      <span className="truncate text-[14.5px] font-bold text-ink">
                        {producer.region} {producer.name}
                      </span>
                      <StyleBadge style={producer.style} />
                    </div>
                    <p className="mt-0.5 truncate text-[11.5px] text-ink-soft">{producer.tagline}</p>
                  </div>
                </div>
                <div className="flex shrink-0 items-center gap-0.5 text-[12px] font-bold text-warn">
                  <Star size={13} className="fill-warn" />
                  {producer.rating}
                  <span className="font-semibold text-ink-soft">({compact(producer.reviewCount)})</span>
                </div>
              </Link>
            </div>

            {/* 상품 hero + 가격 */}
            <div className="px-4 pt-3">
              <div className="flex gap-3.5 rounded-2xl border border-line-soft bg-white p-4">
                <VegImage name={offer.ingredientName} size={84} />
                <div className="min-w-0 flex-1">
                  <h1 className="text-[18px] font-extrabold tracking-tight text-ink">{offer.ingredientName}</h1>
                  <div className="mt-1.5 flex flex-wrap gap-1.5">
                    {offer.freshnessLabel && (
                      <Chip tone="brand">🌱 {offer.freshnessLabel}</Chip>
                    )}
                    <Chip tone="brand">📍 {producer.region}</Chip>
                  </div>
                  <div className="mt-2.5 text-[20px] font-extrabold tabular text-ink">
                    {won(offer.price)}
                    <span className="text-[13px] font-semibold text-ink-mid"> 원 /{offer.unit}</span>
                  </div>
                </div>
              </div>
            </div>

            {/* 수량 */}
            <div className="px-4 pt-3">
              <div className="flex items-center justify-between rounded-2xl border border-line-soft bg-white p-4">
                <span className="text-[13px] font-bold text-ink">수량</span>
                <QtyStepper value={qty} onChange={setQty} />
              </div>
            </div>

            {/* 배송 안내 */}
            <div className="px-4 pt-3">
              <div className="rounded-2xl border border-line-soft bg-white px-4">
                {[
                  { icon: Truck, k: '배송', v: '산지직송 · 수확 후 1~2일 내 출고' },
                  { icon: Package, k: '배송비', v: '3,000원 · 3만원 이상 무료' },
                  { icon: Snowflake, k: '신선도', v: '아이스박스 포장 · 콜드체인' },
                ].map((r, i, arr) => (
                  <div
                    key={r.k}
                    className={
                      'flex items-center gap-3 py-3 ' +
                      (i < arr.length - 1 ? 'border-b border-line-soft' : '')
                    }
                  >
                    <r.icon size={17} className="shrink-0 text-brand-dark" />
                    <span className="w-[52px] shrink-0 text-[12.5px] font-semibold text-ink-soft">{r.k}</span>
                    <span className="flex-1 text-[12.5px] text-ink-mid">{r.v}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* 같은 농가의 다른 상품 */}
            {otherOffers.length > 0 && (
              <div className="pt-6">
                <div className="mb-3 flex items-center justify-between px-4">
                  <h2 className="text-[15.5px] font-extrabold tracking-tight text-ink">같은 농가의 다른 상품</h2>
                  <Link href={`/producers/${producer.id}`} className="tap flex items-center text-[12.5px] font-semibold text-ink-soft">
                    농가 보기 <ChevronRight size={14} />
                  </Link>
                </div>
                <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
                  {otherOffers.map((o) => (
                    <Link
                      key={o.id}
                      href={`/products/${producer.id}?offer=${o.id}`}
                      className="tap block w-[132px] shrink-0 rounded-2xl border border-line-soft bg-white p-3"
                    >
                      <VegImage name={o.ingredientName} size={56} className="mx-auto" />
                      <p className="mt-2 truncate text-center text-[13px] font-bold text-ink">{o.ingredientName}</p>
                      <p className="mt-0.5 text-center text-[13px] font-extrabold tabular text-ink">
                        {won(o.price)}
                        <span className="text-[11px] font-semibold text-ink-mid"> 원/{o.unit}</span>
                      </p>
                    </Link>
                  ))}
                </div>
              </div>
            )}
          </div>

          <BottomBar>
            <div className="flex-1">
              <p className="text-[11px] font-semibold text-ink-soft">총 상품금액</p>
              <p className="text-[18px] font-extrabold tabular text-ink">{wonLabel(offer.price * qty)}</p>
            </div>
            <Button block className="flex-[1.4]" loading={addToCart.isPending} onClick={onAddToCart}>
              장바구니 담기
            </Button>
          </BottomBar>
        </>
      )}
    </>
  );
}
