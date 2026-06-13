'use client';

import Link from 'next/link';
import { ChevronRight } from 'lucide-react';
import { useHome, useProducers, useCart } from '@/lib/queries';
import { HomeHeader } from '@/components/layout';
import { Section } from '@/components/ui/Card';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState } from '@/components/ui/States';
import { HeroCarousel } from '@/components/domain/HeroCarousel';
import { IngredientCard } from '@/components/domain/IngredientCard';
import { RecipeCard } from '@/components/domain/RecipeCard';
import { ReelThumb } from '@/components/domain/ReelThumb';
import { ProducerCircle } from '@/components/domain/ProducerCard';

function MoreLink({ href }) {
  return (
    <Link href={href} className="tap flex items-center text-[12.5px] font-semibold text-ink-soft">
      더보기 <ChevronRight size={14} />
    </Link>
  );
}

export default function HomePage() {
  const { data, isLoading, error, refetch } = useHome();
  const { data: cart } = useCart();
  const cartCount = cart?.groups?.reduce((n, g) => n + g.items.length, 0) ?? 0;
  // 히어로 목록 — 헤더의 투명/떠있음(floating) 여부와 -mt-14 적용을 "실제 렌더되는 히어로"에 맞춘다.
  // (백엔드가 heroes:[] 를 줄 수 있어 data 존재만으론 판단하면 안 됨)
  const heroes = (data?.heroes ?? [data?.hero]).filter(Boolean);

  return (
    <>
      <HomeHeader unreadCount={data?.unreadNotificationCount} cartCount={cartCount} floating={heroes.length > 0} />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {data && (
        <div className="animate-fade-up pb-6">
          {/* 히어로 — 큐레이션 (풀블리드, 헤더가 위에 떠 있도록 -mt-14 로 끌어올린다) */}
          {heroes.length > 0 && (
            <div className="-mt-14">
              <HeroCarousel heroes={heroes} />
            </div>
          )}

          {/* 제철 식재료 */}
          <Section title="지금 제철 식재료" action={<MoreLink href="/info" />}>
            <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
              {data.ingredients.map((i) => (
                <IngredientCard key={i.id} ingredient={i} />
              ))}
            </div>
          </Section>

          {/* 인기 레시피 */}
          <Section title="요즘 뜨는 레시피" action={<MoreLink href="/info?tab=recipe" />}>
            <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
              {data.recipes.map((r) => (
                <RecipeCard key={r.id} recipe={r} width={168} className="shrink-0" />
              ))}
            </div>
          </Section>

          {/* 레시피 릴스 */}
          <Section title="레시피 릴스" action={<MoreLink href="/reels" />}>
            <div className="flex gap-3 overflow-x-auto phone-scroll px-4 pb-1">
              {data.reels.map((r) => (
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
