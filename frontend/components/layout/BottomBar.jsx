import { cn } from '@/lib/cn';

// 상세/결제 화면 하단에 고정되는 액션 바 (가격 요약 + CTA 버튼).
// 탭바가 없는 스택 화면에서 사용합니다.
export function BottomBar({ children, className }) {
  return (
    <div
      className={cn(
        'sticky bottom-0 z-30 flex items-center gap-3 border-t border-line-soft bg-white/95 px-4 py-3 pb-[max(12px,env(safe-area-inset-bottom))] backdrop-blur-xl',
        className,
      )}
    >
      {children}
    </div>
  );
}
