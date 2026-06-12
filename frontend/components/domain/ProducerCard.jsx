import Link from 'next/link';
import { ChevronRight, Crown } from 'lucide-react';
import { cn } from '@/lib/cn';
import { compact } from '@/lib/format';
import { StyleBadge } from './StyleBadge';

// 농가 아바타 (+명예 왕관 배지).
export function ProducerAvatar({ producer, size = 52 }) {
  const crown = Math.round(size * 0.34);
  return (
    <div className="relative shrink-0" style={{ width: size, height: size }}>
      <div
        className="h-full w-full rounded-full border-2 border-white bg-cover bg-center shadow-[0_2px_10px_rgba(20,40,30,0.12)]"
        style={{ backgroundImage: producer.photoUrl ? `url(${producer.photoUrl})` : undefined, backgroundColor: '#e8f1de' }}
      />
      {producer.honorary && (
        <span
          className="absolute -bottom-0.5 -right-0.5 grid place-items-center rounded-full border-2 border-white bg-brand text-white shadow"
          style={{ width: crown, height: crown }}
        >
          <Crown size={crown * 0.55} className="fill-white" />
        </span>
      )}
    </div>
  );
}

// 원형 캐러셀 카드 (홈 명예농가 등).
export function ProducerCircle({ producer, size = 72 }) {
  return (
    <Link href={`/producers/${producer.id}`} className="tap block shrink-0 text-center" style={{ width: size + 22 }}>
      <div className="flex justify-center">
        <ProducerAvatar producer={producer} size={size} />
      </div>
      <p className="mt-2 truncate text-[12.5px] font-extrabold leading-tight tracking-tight text-ink">
        {producer.region} {producer.name}
      </p>
      <p className="truncate text-[10.5px] text-ink-soft">{producer.tagline}</p>
    </Link>
  );
}

// 리스트/검색 행. trailing: 우측 슬롯, footer: 하단 슬롯.
export function ProducerRow({ producer, trailing, footer, divider = true, href, className }) {
  const Wrap = href === null ? 'div' : Link;
  return (
    <Wrap
      href={href === null ? undefined : href || `/producers/${producer.id}`}
      className={cn('tap block px-4 py-3.5', divider && 'border-b border-line-soft', className)}
    >
      <div className="flex items-center gap-3">
        <ProducerAvatar producer={producer} size={52} />
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-1.5">
            <span className="truncate text-[14.5px] font-bold text-ink">
              {producer.region} {producer.name}
            </span>
            <StyleBadge style={producer.style} />
          </div>
          <p className="mt-0.5 truncate text-[11.5px] text-ink-soft">{producer.tagline}</p>
          <div className="mt-1.5 flex items-center gap-2 text-[11px] text-ink-mid">
            <span className="font-bold text-warn">★ {producer.rating}</span>
            <span className="text-ink-soft">리뷰 {compact(producer.reviewCount)}</span>
            {producer.badges?.[0] && <span className="text-ink-soft">· {producer.badges[0]}</span>}
          </div>
        </div>
        {trailing ? (
          <div className="shrink-0 text-right">{trailing}</div>
        ) : (
          <ChevronRight size={18} className="shrink-0 text-ink-soft" />
        )}
      </div>
      {footer && <div className="mt-2.5 border-t border-line-soft pt-2.5">{footer}</div>}
    </Wrap>
  );
}
