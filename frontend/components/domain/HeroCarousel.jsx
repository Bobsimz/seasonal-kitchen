'use client';

import Link from 'next/link';
import { useCallback, useRef, useState } from 'react';
import { cn } from '@/lib/cn';

// 홈 상단 히어로 — 풀블리드 큐레이션 캐러셀.
// 큐레이션의 메인 이미지/타이틀/서브타이틀만 보여주고, 카드 탭 → 큐레이션 상세(/curation/{id}).
// 헤더(HomeHeader)가 그 위에 글래스 버튼으로 떠 있다. 좌우 스와이프(scroll-snap)로 넘긴다.
export function HeroCarousel({ heroes }) {
  const trackRef = useRef(null);
  const [active, setActive] = useState(0);

  const handleScroll = useCallback(() => {
    const el = trackRef.current;
    if (!el || el.children.length === 0) return;
    const stride =
      el.children.length > 1 ? el.children[1].offsetLeft - el.children[0].offsetLeft : el.clientWidth;
    const idx = Math.round(el.scrollLeft / stride);
    setActive(Math.max(0, Math.min(heroes.length - 1, idx)));
  }, [heroes.length]);

  return (
    <div className="relative">
      <div
        ref={trackRef}
        onScroll={handleScroll}
        className="flex snap-x snap-mandatory overflow-x-auto scroll-smooth phone-scroll"
      >
        {heroes.map((h, i) => (
          <Link key={h.id ?? i} href={`/curation/${h.id}`} className="relative block w-full shrink-0 snap-center">
            <div className="relative h-[clamp(320px,46svh,400px)] w-full overflow-hidden">
              {/* 배경 이미지 */}
              <img
                src={h.imageUrl}
                alt={h.title ?? '제철 큐레이션'}
                className="absolute inset-0 h-full w-full object-cover"
                style={{ objectPosition: 'center 32%' }}
              />
              {/* 다크 오버레이 — 상단(헤더 아이콘 가독)·하단(타이틀/서브) 진하게, 가운데는 옅게 */}
              <div
                className="absolute inset-0"
                style={{
                  background:
                    'linear-gradient(180deg, rgba(15,26,20,0.42) 0%, rgba(15,26,20,0.22) 38%, rgba(15,26,20,0.82) 100%)',
                }}
              />

              {/* 카피 — 메인 타이틀 + 서브타이틀 (하단 정렬) */}
              <div className="relative flex h-full flex-col justify-end px-5 pb-9 pt-[72px] text-white">
                <h2
                  className="font-display text-[26px] font-extrabold leading-[1.15] tracking-[-0.5px]"
                  style={{ textShadow: '0 2px 18px rgba(0,0,0,0.4)' }}
                >
                  {h.title}
                </h2>
                {h.subtitle && (
                  <p
                    className="mt-2 max-w-[92%] text-[13.5px] font-medium leading-snug text-white/85"
                    style={{ textShadow: '0 1px 10px rgba(0,0,0,0.45)' }}
                  >
                    {h.subtitle}
                  </p>
                )}
              </div>
            </div>
          </Link>
        ))}
      </div>

      {/* 페이지 인디케이터 — 히어로 하단 중앙(이미지 위) */}
      {heroes.length > 1 && (
        <div className="pointer-events-none absolute inset-x-0 bottom-3 flex items-center justify-center gap-1.5">
          {heroes.map((_, i) => (
            <span
              key={i}
              className={cn(
                'h-[5px] rounded-full transition-all duration-200',
                i === active ? 'w-3.5 bg-white' : 'w-[5px] bg-white/45',
              )}
            />
          ))}
        </div>
      )}
    </div>
  );
}
