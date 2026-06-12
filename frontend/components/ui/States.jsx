'use client';

import { cn } from '@/lib/cn';
import { Button } from './Button';

// 빈 상태 / 에러 상태 / 스켈레톤 등 공통 상태 표현.

export function EmptyState({ icon, title, description, action, className }) {
  return (
    <div className={cn('flex flex-1 flex-col items-center justify-center gap-2 px-8 py-16 text-center', className)}>
      {icon && <div className="mb-1 text-ink-soft/70">{icon}</div>}
      <p className="text-[15px] font-bold text-ink">{title}</p>
      {description && <p className="text-[13px] leading-relaxed text-ink-soft">{description}</p>}
      {action && <div className="mt-3">{action}</div>}
    </div>
  );
}

export function ErrorState({ onRetry, message = '잠시 후 다시 시도해 주세요.' }) {
  return (
    <EmptyState
      title="문제가 발생했어요"
      description={message}
      action={
        onRetry ? (
          <Button variant="soft" size="sm" onClick={onRetry}>
            다시 시도
          </Button>
        ) : null
      }
    />
  );
}

export function Skeleton({ className }) {
  return <div className={cn('skeleton rounded-xl', className)} />;
}
