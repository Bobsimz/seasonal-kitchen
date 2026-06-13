'use client';

import Link from 'next/link';
import { useCallback, useRef, useState } from 'react';
import { cn } from '@/lib/cn';

// 홈 상단 히어로 — 여러 제철 카드를 좌우로 넘기는 캐러셀.
// scroll-snap 으로 손가락/트랙패드 스와이프에 자연스럽게 붙고, 활성 카드만 100%·
// 양옆 카드는 살짝 축소돼 "뒤에 카드가 있는 것처럼 삐죽" 보이는 코버플로우 느낌을 준다.
// 카드 탭 → 제철 큐레이션(07) 화면.
export function HeroCarousel({ heroes, locationLabel }) {
  const trackRef = useRef(null);
  const [active, setActive] = useState(0);

  const handleScroll = useCallback(() => {
    const el = trackRef.current;
    if (!el || el.children.length === 0) return;
    // 카드 간 이동 거리(stride)는 첫 두 카드의 위치 차로 계산 — 축소(scale) 변형은
    // offsetLeft(레이아웃 위치)를 바꾸지 않으므로 stride 가 일정하게 유지된다.
    const stride =
      el.children.length > 1
        ? el.children[1].offsetLeft - el.children[0].offsetLeft
        : el.clientWidth;
    const idx = Math.round(el.scrollLeft / stride);
    setActive(Math.max(0, Math.min(heroes.length - 1, idx)));
  }, [heroes.length]);

  return (
    <div>
      <div
        ref={trackRef}
        onScroll={handleScroll}
        className="flex snap-x snap-mandatory gap-3 overflow-x-auto scroll-smooth phone-scroll px-4"
      >
        {heroes.map((h, i) => (
          <Link
            key={h.ingredientId ?? i}
            href="/curation"
            className={cn(
              'tap block w-[85%] shrink-0 snap-center overflow-hidden rounded-3xl transition-[transform,opacity] duration-300 ease-out',
              i === active ? 'scale-100 opacity-100' : 'scale-[0.92] opacity-70',
            )}
          >
            <div className="relative aspect-[16/10] w-full">
              <img src={h.imageUrl} alt={h.title} className="h-full w-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-t from-black/75 via-black/10 to-transparent" />
              <div className="absolute inset-x-0 bottom-0 p-4 text-white">
                <span className="inline-block rounded-full bg-brand px-2.5 py-1 text-[11px] font-bold">
                  {locationLabel}
                </span>
                <h2 className="mt-2 text-[24px] font-extrabold leading-tight tracking-tight">{h.title}</h2>
                <p className="mt-1 text-[13.5px] font-medium text-white/85">{h.subtitle}</p>
                <div className="mt-2 flex items-center gap-2 text-[14px] font-bold">
                  <span>{h.priceLabel}</span>
                  {h.trendLabel && (
                    <span className="rounded-md bg-white/20 px-1.5 py-0.5 text-[12px]">{h.trendLabel}</span>
                  )}
                </div>
              </div>
            </div>
          </Link>
        ))}
      </div>

      {/* 페이지 인디케이터 */}
      {heroes.length > 1 && (
        <div className="mt-3 flex items-center justify-center gap-1.5">
          {heroes.map((_, i) => (
            <span
              key={i}
              className={cn(
                'h-1.5 rounded-full transition-all duration-200',
                i === active ? 'w-3.5 bg-ink/85' : 'w-1.5 bg-ink/25',
              )}
            />
          ))}
        </div>
      )}
    </div>
  );
}
