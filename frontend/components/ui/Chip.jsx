import { cn } from '@/lib/cn';

// 작은 알약형 라벨. tone: neutral | brand | hot | warn | dark
const TONES = {
  neutral: 'bg-line-soft text-ink-mid',
  brand: 'bg-brand-bg text-brand-dark',
  hot: 'bg-hot-bg text-hot',
  warn: 'bg-warn-bg text-warn',
  dark: 'bg-ink text-white',
  outline: 'border border-line text-ink-mid bg-white',
};

export function Chip({ tone = 'neutral', className, children, ...props }) {
  return (
    <span
      className={cn(
        'inline-flex items-center gap-1 whitespace-nowrap rounded-full px-2.5 py-1 text-[11.5px] font-semibold',
        TONES[tone],
        className,
      )}
      {...props}
    >
      {children}
    </span>
  );
}
