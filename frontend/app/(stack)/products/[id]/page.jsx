'use client';

import { Suspense, useEffect, useMemo, useRef, useState } from 'react';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { Star, Truck, Package, Snowflake, ChevronRight, ChevronDown, ChevronUp } from 'lucide-react';
import { useProducer, useProducerOffers, useProduct, useAddToCart } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { AppHeader } from '@/components/layout';
import { BottomBar } from '@/components/layout/BottomBar';
import { Button } from '@/components/ui/Button';
import { Chip } from '@/components/ui/Chip';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { VegImage } from '@/components/domain/VegImage';
import { ProducerAvatar } from '@/components/domain/ProducerCard';
import { StyleBadge } from '@/components/domain/StyleBadge';
import { FavoriteHeart } from '@/components/domain/FavoriteHeart';
import { PurchaseSheet } from '@/components/domain/PurchaseSheet';
import { won, wonLabel, compact } from '@/lib/format';
import { cn } from '@/lib/cn';

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

  const [purchaseOpen, setPurchaseOpen] = useState(false);
  const [submitMode, setSubmitMode] = useState(null); // 'cart' | 'buy' | null — 어느 CTA가 진행 중인지

  const offer = useMemo(() => {
    if (!offers.length) return null;
    if (focusedOfferId) {
      const hit = offers.find((o) => String(o.id) === String(focusedOfferId));
      if (hit) return hit;
    }
    return offers[0];
  }, [offers, focusedOfferId]);

  // 상품 상세 보강(옵션·상세섹션) — offer 확정 후 조회. 실패/미로딩 시 폴백으로 대체.
  const { data: product } = useProduct(offer?.id);

  // 옵션: 백엔드 options 가 있으면 그대로, 없으면 기준가 단일 옵션으로 폴백 → 구매 플로우 항상 동작.
  const options = useMemo(() => {
    if (product?.options?.length) return product.options;
    if (offer) return [{ id: offer.id, quantity: 1, unit: offer.unit, price: offer.price }];
    return [];
  }, [product, offer]);

  // 상세섹션: detailSections(리스트)가 우선, 없으면 description 단일 섹션.
  const detailSections = useMemo(() => {
    if (product?.detailSections?.length) return product.detailSections;
    if (product?.description) return [{ heading: '상품 정보', body: product.description }];
    return [];
  }, [product]);

  const otherOffers = useMemo(
    () => (offer ? offers.filter((o) => o.id !== offer.id) : []),
    [offers, offer],
  );

  const isLoading = producerLoading || offersLoading;
  const error = producerError || offersError;

  const onSubmit = ({ option, qty, mode }) => {
    if (!offer) return;
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.push('/login?next=' + encodeURIComponent(typeof window !== 'undefined' ? window.location.pathname + window.location.search : '/'));
      return;
    }
    // 실제 옵션이 있을 때만 옵션을 전달. 기준가 폴백 옵션(id=offerId)은 백엔드 offerOptionId 로 보내면 안 됨.
    const sendOption = product?.options?.length ? option : null;
    setSubmitMode(mode);
    addToCart.mutate(
      { offerId: offer.id, qty, option: sendOption },
      {
        onSuccess: () => {
          setSubmitMode(null);
          setPurchaseOpen(false);
          if (mode === 'buy') router.push('/checkout');
          else toast.show('장바구니에 담았어요', { type: 'success' });
        },
        onError: () => {
          setSubmitMode(null);
          toast.show('담기에 실패했어요', { type: 'error' });
        },
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

            {/* 상품 상세정보 — 접기/펼치기 */}
            <DetailSections sections={detailSections} />

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

          {/* 하단바 — 찜하기 + 구매하기 */}
          <BottomBar>
            <FavoriteHeart
              targetType="PRODUCT"
              targetId={offer.id}
              size={24}
              nextHref={`/products/${producer.id}?offer=${offer.id}`}
              className="grid h-[52px] w-[52px] shrink-0 place-items-center rounded-2xl border border-line"
              iconClassName="text-ink-mid"
            />
            <Button size="lg" block className="flex-1" onClick={() => setPurchaseOpen(true)}>
              구매하기
            </Button>
          </BottomBar>

          <PurchaseSheet
            open={purchaseOpen}
            onClose={() => setPurchaseOpen(false)}
            options={options}
            pendingMode={submitMode}
            onSubmit={onSubmit}
          />
        </>
      )}
    </>
  );
}

// 상품 상세정보(detailSections)를 접기/펼치기로 렌더.
// 내용이 180px 를 넘을 때만 클램프+페이드+토글을 노출(짧으면 죽은 펼치기 버튼이 안 생김).
const DETAIL_MAX_H = 180;
function DetailSections({ sections }) {
  const [expanded, setExpanded] = useState(false);
  const [overflows, setOverflows] = useState(false);
  const bodyRef = useRef(null);

  // scrollHeight 는 클램프 여부와 무관하게 전체 콘텐츠 높이. 이미지 로드 후 높이가 늘어나므로 onLoad 에서 재측정.
  const measure = () => {
    const el = bodyRef.current;
    if (el) setOverflows(el.scrollHeight > DETAIL_MAX_H + 1);
  };
  useEffect(() => {
    measure();
  }, [sections]);

  if (!sections || sections.length === 0) return null;
  const collapsed = !expanded && overflows;

  return (
    <div className="px-4 pt-6">
      <h2 className="mb-3 text-[15.5px] font-extrabold tracking-tight text-ink">상품 상세정보</h2>
      <div className="relative overflow-hidden rounded-2xl border border-line-soft bg-white">
        <div ref={bodyRef} className={cn('px-4 py-4', collapsed && 'max-h-[180px] overflow-hidden')}>
          {sections.map((s, i) => (
            <div key={i} className={i > 0 ? 'mt-4' : ''}>
              {s.heading && <h3 className="text-[14px] font-bold text-ink">{s.heading}</h3>}
              {s.imageUrl && (
                <img
                  src={s.imageUrl}
                  alt={s.heading || ''}
                  loading="lazy"
                  onLoad={measure}
                  className="mt-2 aspect-[16/10] w-full rounded-xl border border-line-soft object-cover bg-surface-soft"
                />
              )}
              {s.body && (
                <p className="mt-2 whitespace-pre-line text-[13px] leading-relaxed text-ink-mid">{s.body}</p>
              )}
            </div>
          ))}
        </div>
        {collapsed && (
          <div className="pointer-events-none absolute inset-x-0 bottom-0 h-16 bg-gradient-to-t from-white to-transparent" />
        )}
      </div>
      {overflows && (
        <button
          onClick={() => setExpanded((v) => !v)}
          aria-expanded={expanded}
          className="tap mt-2 flex w-full items-center justify-center gap-1 rounded-2xl border border-line py-2.5 text-[13px] font-bold text-ink-mid"
        >
          {expanded ? '접기' : '상세정보 펼쳐보기'}
          {expanded ? <ChevronUp size={15} /> : <ChevronDown size={15} />}
        </button>
      )}
    </div>
  );
}
