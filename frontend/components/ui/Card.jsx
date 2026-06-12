import { cn } from '@/lib/cn';

// 기본 카드 컨테이너. 흰 배경 + 라운드 + 카드 그림자.
export function Card({ as: Tag = 'div', className, children, ...props }) {
  return (
    <Tag className={cn('rounded-2xl bg-white shadow-card', className)} {...props}>
      {children}
    </Tag>
  );
}

// 섹션 묶음 — 제목 + 우측 액션(더보기 등) + 본문
export function Section({ title, action, className, children, padded = true }) {
  return (
    <section className={cn('mt-5', className)}>
      {(title || action) && (
        <div className={cn('mb-3 flex items-center justify-between', padded && 'px-4')}>
          {title && <h2 className="text-[16px] font-extrabold tracking-tight text-ink">{title}</h2>}
          {action}
        </div>
      )}
      {children}
    </section>
  );
}
