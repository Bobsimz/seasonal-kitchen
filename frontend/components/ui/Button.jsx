'use client';

import { cn } from '@/lib/cn';
import { Spinner } from './Spinner';

// 기본 버튼. variant: primary | secondary | soft | ghost | outline | danger
// size: sm | md | lg | block(가로 꽉 채움)
const VARIANTS = {
  primary: 'bg-brand text-white shadow-[0_6px_16px_rgba(22,193,114,0.28)] hover:brightness-105 active:brightness-95',
  secondary: 'bg-ink text-white hover:brightness-105',
  soft: 'bg-brand-bg text-brand-dark hover:bg-brand-soft/60',
  ghost: 'bg-transparent text-ink-mid hover:bg-line-soft',
  outline: 'bg-white text-ink border border-line hover:bg-line-soft',
  danger: 'bg-hot text-white hover:brightness-105',
};

const SIZES = {
  sm: 'h-9 px-3.5 text-[13px] rounded-xl',
  md: 'h-11 px-4 text-[14px] rounded-2xl',
  lg: 'h-[52px] px-5 text-[15px] rounded-2xl',
};

export function Button({
  variant = 'primary',
  size = 'md',
  block = false,
  loading = false,
  className,
  children,
  disabled,
  ...props
}) {
  return (
    <button
      disabled={disabled || loading}
      className={cn(
        'tap inline-flex items-center justify-center gap-1.5 whitespace-nowrap font-bold tracking-tight transition disabled:cursor-not-allowed disabled:opacity-50',
        VARIANTS[variant],
        SIZES[size],
        block && 'w-full',
        className,
      )}
      {...props}
    >
      {loading && <Spinner size={16} className={variant === 'outline' || variant === 'ghost' || variant === 'soft' ? 'text-brand' : 'text-white'} />}
      {children}
    </button>
  );
}
