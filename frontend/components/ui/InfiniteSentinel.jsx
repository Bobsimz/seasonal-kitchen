'use client';

import { useEffect, useRef } from 'react';

// 무한 스크롤 센티넬 — 뷰포트에 들어오면 다음 페이지를 요청한다.
export function InfiniteSentinel({ hasMore, loading, onLoadMore }) {
  const ref = useRef(null);
  useEffect(() => {
    if (!hasMore) return;
    const el = ref.current;
    if (!el) return;
    const io = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting && !loading) onLoadMore();
      },
      { rootMargin: '300px' },
    );
    io.observe(el);
    return () => io.disconnect();
  }, [hasMore, loading, onLoadMore]);

  if (!hasMore && !loading) return null;
  return (
    <div ref={ref} className="flex justify-center py-5 text-[12.5px] text-ink-soft">
      {loading ? '불러오는 중…' : ''}
    </div>
  );
}
