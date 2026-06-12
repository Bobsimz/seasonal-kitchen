'use client';

import { Minus, Plus, Star } from 'lucide-react';
import { cn } from '@/lib/cn';

// 별점 표시 (읽기 전용 또는 클릭 입력).
export function RatingStars({ value = 0, size = 16, editable = false, onChange, className }) {
  return (
    <div className={cn('flex items-center gap-0.5', className)}>
      {[1, 2, 3, 4, 5].map((n) => (
        <button
          key={n}
          type="button"
          disabled={!editable}
          onClick={() => editable && onChange?.(n)}
          className={cn(editable && 'tap')}
        >
          <Star
            size={size}
            className={n <= Math.round(value) ? 'fill-warn text-warn' : 'fill-line text-line'}
          />
        </button>
      ))}
    </div>
  );
}

// 수량 스테퍼 (− N +).
export function QtyStepper({ value, onChange, min = 1, max = 99, size = 'md' }) {
  const h = size === 'sm' ? 'h-8' : 'h-9';
  const btn = size === 'sm' ? 'w-8' : 'w-9';
  return (
    <div className={cn('inline-flex items-center rounded-xl border border-line bg-white', h)}>
      <button
        onClick={() => onChange(Math.max(min, value - 1))}
        disabled={value <= min}
        className={cn('tap grid place-items-center text-ink-mid disabled:opacity-30', btn, h)}
      >
        <Minus size={15} />
      </button>
      <span className="min-w-[24px] text-center text-[14px] font-bold tabular">{value}</span>
      <button
        onClick={() => onChange(Math.min(max, value + 1))}
        disabled={value >= max}
        className={cn('tap grid place-items-center text-ink-mid disabled:opacity-30', btn, h)}
      >
        <Plus size={15} />
      </button>
    </div>
  );
}

// 가격 변동 라벨 (▲ +8% / ▼ -15% / 보합).
export function TrendBadge({ direction, label, className }) {
  const up = direction === 'UP';
  const flat = direction === 'FLAT' || !direction;
  return (
    <span
      className={cn(
        'inline-flex items-center gap-0.5 text-[12px] font-bold tabular',
        flat ? 'text-ink-soft' : up ? 'text-hot' : 'text-brand-dark',
        className,
      )}
    >
      {!flat && <span>{up ? '▲' : '▼'}</span>}
      {label}
    </span>
  );
}
