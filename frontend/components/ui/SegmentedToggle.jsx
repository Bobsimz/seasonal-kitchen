'use client';

import { cn } from '@/lib/cn';
import { motion } from 'framer-motion';

// 세그먼트 토글 (예: 정보 탭의 식재료 / 레시피 / 농가).
// options: [{ value, label }], value, onChange
export function SegmentedToggle({ options, value, onChange, className }) {
  return (
    <div className={cn('flex gap-1 rounded-2xl bg-line-soft p-1', className)}>
      {options.map((opt) => {
        const active = opt.value === value;
        return (
          <button
            key={opt.value}
            onClick={() => onChange(opt.value)}
            className={cn(
              'tap relative flex-1 rounded-xl py-2 text-[13.5px] font-bold tracking-tight transition-colors',
              active ? 'text-ink' : 'text-ink-soft',
            )}
          >
            {active && (
              <motion.span
                layoutId="segmented-bg"
                className="absolute inset-0 rounded-xl bg-white shadow-card"
                transition={{ type: 'spring', stiffness: 420, damping: 36 }}
              />
            )}
            <span className="relative z-10">{opt.label}</span>
          </button>
        );
      })}
    </div>
  );
}

// 카테고리 칩 줄 (가로 스크롤). options: string[] | [{value,label}]
export function ChipTabs({ options, value, onChange, className }) {
  const items = options.map((o) => (typeof o === 'string' ? { value: o, label: o } : o));
  return (
    <div className={cn('flex gap-2 overflow-x-auto phone-scroll px-4 pb-1', className)}>
      {items.map((opt) => {
        const active = opt.value === value;
        return (
          <button
            key={opt.value}
            onClick={() => onChange(opt.value)}
            className={cn(
              'tap shrink-0 rounded-full px-3.5 py-1.5 text-[13px] font-semibold transition-colors',
              active ? 'bg-ink text-white' : 'bg-line-soft text-ink-mid',
            )}
          >
            {opt.label}
          </button>
        );
      })}
    </div>
  );
}
