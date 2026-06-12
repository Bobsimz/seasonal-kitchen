'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Heart, Crown, Megaphone, ChevronRight } from 'lucide-react';
import {
  useProducer,
  useProducerOffers,
  useProducerReviews,
  useProducerNews,
  useFavorites,
  useToggleFavorite,
} from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { AppHeader } from '@/components/layout';
import { Card } from '@/components/ui/Card';
import { Chip } from '@/components/ui/Chip';
import { SegmentedToggle } from '@/components/ui/SegmentedToggle';
import { RatingStars } from '@/components/ui/Misc';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';
import { ProducerAvatar, StyleBadge, OfferRow } from '@/components/domain';
import { compact, date } from '@/lib/format';
import { cn } from '@/lib/cn';

const TABS = [
  { value: 'offers', label: '상품' },
  { value: 'reviews', label: '리뷰' },
  { value: 'news', label: '소식' },
];

export default function ProducerDetailPage({ params }) {
  const id = params.id;
  const [tab, setTab] = useState('offers');

  const { data: producer, isLoading, error, refetch } = useProducer(id);

  return (
    <>
      <AppHeader title={producer ? `${producer.region} ${producer.name}` : '농가'} back transparent />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {producer && (
        <div className="-mt-14 animate-fade-up pb-10">
          {/* 농가 헤더 블록 */}
          <ProducerHero producer={producer} id={id} />

          {/* 탭 */}
          <div className="px-4 pt-4">
            <SegmentedToggle options={TABS} value={tab} onChange={setTab} />
          </div>

          <div className="mt-4">
            {tab === 'offers' && <OffersTab id={id} />}
            {tab === 'reviews' && <ReviewsTab id={id} producer={producer} />}
            {tab === 'news' && <NewsTab id={id} />}
          </div>
        </div>
      )}
    </>
  );
}

// ── 헤더 (히어로 이미지 + 농가 정보 + 찜) ──────────────────────────
function ProducerHero({ producer, id }) {
  const router = useRouter();
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const { data: favorites = [] } = useFavorites();
  const toggleFavorite = useToggleFavorite();

  const fav = favorites.find((f) => f.targetType === 'PRODUCER' && Number(f.targetId) === Number(id));
  const isFav = !!fav;

  const onToggleFavorite = () => {
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.push('/login?next=' + encodeURIComponent(`/producers/${id}`));
      return;
    }
    toggleFavorite.mutate(
      isFav
        ? { action: 'remove', favoriteId: fav.id, targetType: 'PRODUCER', targetId: id }
        : { action: 'add', targetType: 'PRODUCER', targetId: id },
      {
        onSuccess: () => toast.show(isFav ? '찜을 해제했어요' : '농가를 찜했어요', { type: 'success' }),
        onError: () => toast.show('잠시 후 다시 시도해 주세요', { type: 'error' }),
      },
    );
  };

  return (
    <div className="relative overflow-hidden">
      {/* 배경 이미지 */}
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{ backgroundImage: producer.photoUrl ? `url(${producer.photoUrl})` : undefined, backgroundColor: '#2c3a2e' }}
      />
      <div className="absolute inset-0 bg-gradient-to-b from-black/45 via-black/10 to-black/80" />

      <div className="relative px-5 pb-5 pt-20">
        <div className="flex items-end gap-3">
          <ProducerAvatar producer={producer} size={68} />
          <div className="min-w-0 flex-1 pb-1">
            <div className="mb-1.5 flex flex-wrap items-center gap-1.5">
              {producer.honorary && (
                <Chip tone="brand" className="bg-brand text-white">
                  <Crown size={12} className="fill-white" /> 명예생산자
                </Chip>
              )}
              <StyleBadge style={producer.style} />
            </div>
            <h1 className="text-[22px] font-extrabold leading-tight tracking-tight text-white">
              {producer.region} {producer.name}
            </h1>
          </div>
          <button
            onClick={onToggleFavorite}
            disabled={toggleFavorite.isPending}
            aria-label={isFav ? '찜 해제' : '찜하기'}
            className="tap grid h-11 w-11 shrink-0 place-items-center rounded-full border border-white/25 bg-white/15 backdrop-blur-md disabled:opacity-50"
          >
            <Heart size={20} className={cn('text-white', isFav && 'fill-hot text-hot')} />
          </button>
        </div>

        <div className="mt-3 flex items-center gap-2 text-[13px] font-bold text-white">
          <span className="text-warn-bg">★ {producer.rating}</span>
          <span className="text-white/80">리뷰 {compact(producer.reviewCount)}</span>
        </div>

        {producer.tagline && <p className="mt-2 text-[13px] leading-relaxed text-white/90">{producer.tagline}</p>}
      </div>

      {/* 명예 농가 안내 + 배지 칩 */}
      <div className="relative px-4 pb-1">
        <Card className="p-4">
          {producer.honorary && (
            <div className="mb-3 flex items-center gap-2 rounded-xl bg-brand-bg px-3 py-2.5">
              <Crown size={16} className="shrink-0 fill-brand-dark text-brand-dark" />
              <p className="text-[12.5px] font-semibold leading-snug text-brand-dark">
                제철식탁이 인증한 명예생산자예요. 믿고 구매하세요.
              </p>
            </div>
          )}
          {producer.badges?.length > 0 && (
            <div className="flex flex-wrap gap-1.5">
              {producer.badges.map((b) => (
                <Chip key={b} tone="neutral">
                  {b}
                </Chip>
              ))}
            </div>
          )}
        </Card>
      </div>
    </div>
  );
}

// ── 상품 탭 ────────────────────────────────────────────────────────
function OffersTab({ id }) {
  const { data: offers = [], isLoading, error, refetch } = useProducerOffers(id);

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;
  if (offers.length === 0) {
    return <EmptyState title="판매 중인 상품이 없어요" description="곧 새로운 제철 상품이 등록될 거예요." />;
  }

  return (
    <div className="px-4">
      <div className="mb-2.5 px-1 text-[15px] font-extrabold tracking-tight text-ink">
        판매 중인 재료 <span className="text-brand">{offers.length}</span>
      </div>
      <Card className="overflow-hidden p-0">
        {offers.map((offer, i) => (
          <OfferRow key={offer.id} offer={offer} divider={i < offers.length - 1} />
        ))}
      </Card>
    </div>
  );
}

// ── 리뷰 탭 ────────────────────────────────────────────────────────
function ReviewsTab({ id, producer }) {
  const { data: reviews = [], isLoading, error, refetch } = useProducerReviews(id);

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;
  if (reviews.length === 0) {
    return <EmptyState title="아직 리뷰가 없어요" description="첫 리뷰의 주인공이 되어주세요." />;
  }

  return (
    <div className="px-4">
      <div className="mb-2.5 flex items-center justify-between px-1">
        <div className="text-[15px] font-extrabold tracking-tight text-ink">
          리뷰 <span className="text-brand">{compact(producer.reviewCount)}</span>
        </div>
        <span className="text-[13px] font-bold text-warn">★ {producer.rating}</span>
      </div>
      <div className="space-y-2.5">
        {reviews.map((rv) => (
          <Card key={rv.id} className="p-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="text-[13px] font-bold text-ink">{rv.author}</span>
                <RatingStars value={rv.rating} size={13} />
              </div>
              <span className="text-[11px] text-ink-soft">{date(rv.createdAt)}</span>
            </div>
            <p className="mt-2 text-[13px] leading-relaxed text-ink-mid">{rv.body}</p>
            {rv.item && (
              <div className="mt-2.5">
                <Chip tone="neutral">{rv.item} 구매</Chip>
              </div>
            )}
          </Card>
        ))}
      </div>
    </div>
  );
}

// ── 소식 탭 (NEWS 타임라인) ──────────────────────────────────────
function NewsTab({ id }) {
  const { data: news = [], isLoading, error, refetch } = useProducerNews(id);

  if (isLoading) return <LoadingScreen />;
  if (error) return <ErrorState onRetry={refetch} />;
  if (news.length === 0) {
    return <EmptyState title="등록된 소식이 없어요" description="농가의 새 소식을 기다려 주세요." />;
  }

  return (
    <div className="px-4">
      <div className="mb-3 px-1 text-[15px] font-extrabold tracking-tight text-ink">스토어 소식</div>
      {news.map((n, i) => {
        const last = i === news.length - 1;
        return (
          <div key={n.id} className="flex gap-3">
            {/* 타임라인 레일 */}
            <div className="flex w-7 shrink-0 flex-col items-center">
              <span className="grid h-7 w-7 place-items-center rounded-full border border-line bg-surface-soft text-brand-dark">
                <Megaphone size={13} />
              </span>
              {!last && <span className="mt-1 w-0.5 flex-1 bg-line-soft" />}
            </div>
            {/* 내용 */}
            <div className={cn('min-w-0 flex-1', last ? 'pb-0' : 'pb-6')}>
              <div className="flex items-center gap-2 text-[10.5px] text-ink-soft">
                <span className="font-extrabold tracking-wide text-ink-mid">NEWS</span>
                <span>{n.date}</span>
              </div>
              <div className="mt-1 flex items-center gap-1.5">
                <span className="text-[14.5px] font-extrabold leading-snug tracking-tight text-ink">{n.title}</span>
                <ChevronRight size={14} className="shrink-0 text-ink-soft" />
              </div>
              {n.imageUrl && (
                <div className="mt-2.5 aspect-[16/9] overflow-hidden rounded-2xl border border-line-soft">
                  <img src={n.imageUrl} alt={n.title} className="h-full w-full object-cover" />
                </div>
              )}
              <p className="mt-2.5 line-clamp-3 text-[12.5px] leading-relaxed text-ink-mid">{n.body}</p>
            </div>
          </div>
        );
      })}
    </div>
  );
}
