import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

// 조건부 className 합성 + Tailwind 충돌 정리 헬퍼.
//   cn('px-2', isActive && 'text-brand', className)
export function cn(...inputs) {
  return twMerge(clsx(inputs));
}
