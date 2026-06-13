'use client';

import { useEffect } from 'react';
import { AnimatePresence, motion } from 'framer-motion';
import { cn } from '@/lib/cn';

// 하단에서 올라오는 바텀시트. 모바일 프레임 내부(absolute inset-0)에 갇힙니다.
export function Sheet({ open, onClose, title, children, className }) {
  // ESC 로 닫기 (열려 있을 때만 리스너 부착).
  useEffect(() => {
    if (!open) return undefined;
    const onKey = (e) => {
      if (e.key === 'Escape') onClose?.();
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [open, onClose]);

  return (
    <AnimatePresence>
      {open && (
        <div className="absolute inset-0 z-[120] flex flex-col justify-end">
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="absolute inset-0 bg-black/40"
          />
          <motion.div
            role="dialog"
            aria-modal="true"
            aria-label={title || undefined}
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', stiffness: 360, damping: 36 }}
            className={cn('relative max-h-[85%] overflow-y-auto phone-scroll rounded-t-4xl bg-white pb-6', className)}
          >
            <div className="sticky top-0 z-10 flex flex-col items-center bg-white pt-3">
              <span className="h-1.5 w-10 rounded-full bg-line" />
              {title && <h3 className="mt-3 w-full px-5 text-[17px] font-extrabold tracking-tight text-ink">{title}</h3>}
            </div>
            <div className="px-5 pt-2">{children}</div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}
