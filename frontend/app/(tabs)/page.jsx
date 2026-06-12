'use client';

import Link from 'next/link';
import { Bell, ChevronRight } from 'lucide-react';
import { useHome, useProducers } from '@/lib/queries';
import { AppHeader, HeaderIconButton } from '@/components/layout';
import { SearchBar } from '@/components/ui/SearchBar';
import { Section } from '@/components/ui/Card';
import { Chip } from '@/components/ui/Chip';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState } from '@/components/ui/States';
import { IngredientCard } from '@/components/domain/IngredientCard';
import { RecipeCard } from '@/components/domain/RecipeCard';
import { ReelThumb } from '@/components/domain/ReelThumb';
import { ProducerCircle } from '@/components/domain/ProducerCard';
import { useRouter } from 'next/navigation';

function MoreLink({ href }) {
  return (
    <Link href={href} className="tap flex items-center text-[12.5px] font-semibold text-ink-soft">
      더보기 <ChevronRight size={14} />
    </Link>
  );
}

export default function HomePage() {
  const router = useRouter();
  const { data, isLoading, error, refetch } = useHome();

  return (
    <>
      <AppHeader
        title="제철식탁"
        right={
          <HeaderIconButton icon={Bell} href="/notifications" label="알림" badge={data?.unreadNotificationCount} />
        }
      />

      <div className="px-4 pb-3 pt-3">
        <SearchBar readOnly onClick={() => router.push('/search')} />
      </div>

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {data && (
        <div className="animate-fade-up pb-6">
          {/* 히어로 — 이번 주 제철 */}
          <Link href={`/ingredients/${data.hero.ingredientId}`} className="tap mx-4 block overflow-hidden rounded-3xl">
            <div className="relative aspect-[16/10] w-full">
              <img src={data.hero.imageUrl} alt={data.hero.title} className="h-full w-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-t from-black/75 via-black/10 to-transparent" />
              <div className="absolute inset-x-0 bottom-0 p-4 text-white">
                <span className="inline-block rounded-full bg-brand px-2.5 py-1 text-[11px] font-bold">
                  {data.locationLabel}
                </span>
                <h2 className="mt-2 text-[24px] font-extrabold leading-tight tracking-tight">{data.hero.title}</h2>
                <p className="mt-1 text-[13.5px] font-medium text-white/85">{data.hero.subtitle}</p>
                <div className="mt-2 flex items-center gap-2 text-[14px] font-bold">
                  <span>{data.hero.priceLabel}</span>
                  <span className="rounded-md bg-white/20 px-1.5 py-0.5 text-[12px]">{data.hero.trendLabel}</span>
                </div>
              </div>
            </div>
          </Link>

          {/* 제철 식재료 */}
          <Section title="지금 제철 식재료" action={<MoreLink href="/info" />}>
            <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
              {data.seasonalIngredients.map((i) => (
                <IngredientCard key={i.id} ingredient={i} />
              ))}
            </div>
          </Section>

          {/* 인기 레시피 */}
          <Section title="요즘 뜨는 레시피" action={<MoreLink href="/info?tab=recipe" />}>
            <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
              {data.trendingRecipes.map((r) => (
                <RecipeCard key={r.id} recipe={r} width={168} className="shrink-0" />
              ))}
            </div>
          </Section>

          {/* 레시피 릴스 */}
          <Section title="레시피 릴스" action={<MoreLink href="/reels" />}>
            <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
              {data.trendingReels.map((r) => (
                <ReelThumb key={r.id} reel={r} />
              ))}
            </div>
          </Section>

          {/* 명예 농가 */}
          <Section title="믿고 사는 명예 농가" action={<MoreLink href="/producers" />}>
            <div className="flex gap-4 overflow-x-auto phone-scroll px-4 pb-1">
              <HonoraryProducers />
            </div>
          </Section>

          {/* 인기 검색어 */}
          <Section title="인기 검색어">
            <div className="flex flex-wrap gap-2 px-4">
              {data.trendingKeywords.map((k, idx) => (
                <Link key={k} href={`/search?q=${encodeURIComponent(k)}`}>
                  <Chip tone="neutral" className="gap-1.5 px-3 py-1.5 text-[13px]">
                    <span className="font-extrabold text-brand">{idx + 1}</span> {k}
                  </Chip>
                </Link>
              ))}
            </div>
          </Section>
        </div>
      )}
    </>
  );
}

// 명예 농가 캐러셀 — producers 목록에서 honorary 만 (home 응답엔 농가가 없어 별도 조회).
function HonoraryProducers() {
  const { data: producers = [] } = useProducers();
  return (
    <>
      {producers
        .filter((p) => p.honorary)
        .slice(0, 8)
        .map((p) => (
          <ProducerCircle key={p.id} producer={p} />
        ))}
    </>
  );
}
