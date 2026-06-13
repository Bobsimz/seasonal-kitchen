import { cn } from '@/lib/cn';

// 스켈레톤 — pulse 회색 둥근 박스. 응답 완료 시 레이아웃이 바뀌지 않도록 실제 요소와 같은 크기로 둔다.
export function Skeleton({ className, rounded = 'rounded-lg' }) {
  return <div className={cn('animate-pulse bg-black/[0.07]', rounded, className)} aria-hidden="true" />;
}
