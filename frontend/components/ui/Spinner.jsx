import { cn } from '@/lib/cn';

export function Spinner({ size = 20, className }) {
  return (
    <svg
      className={cn('animate-spin', className)}
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      aria-label="로딩 중"
    >
      <circle cx="12" cy="12" r="9" stroke="currentColor" strokeOpacity="0.2" strokeWidth="3" />
      <path d="M21 12a9 9 0 0 0-9-9" stroke="currentColor" strokeWidth="3" strokeLinecap="round" />
    </svg>
  );
}

// 화면 중앙 로딩 (스크롤 영역 안에서 사용)
export function LoadingScreen({ label = '불러오는 중...' }) {
  return (
    <div className="flex flex-1 flex-col items-center justify-center gap-3 py-20 text-ink-soft">
      <Spinner size={28} className="text-brand" />
      <span className="text-[13px]">{label}</span>
    </div>
  );
}
