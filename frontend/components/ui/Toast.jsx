'use client';

import { createContext, useCallback, useContext, useMemo, useState } from 'react';
import { AnimatePresence, motion } from 'framer-motion';

const ToastContext = createContext(null);

let seq = 0;

export function ToastProvider({ children }) {
  const [toasts, setToasts] = useState([]);

  const show = useCallback((message, opts = {}) => {
    const id = ++seq;
    setToasts((t) => [...t, { id, message, type: opts.type || 'default' }]);
    setTimeout(() => setToasts((t) => t.filter((x) => x.id !== id)), opts.duration || 2200);
  }, []);

  // value를 메모이제이션해 context identity를 고정한다. (안 하면 매 렌더 새 객체 →
  // toast 를 useEffect deps 에 넣은 소비자가 무한 루프; 예: checkout 로그인 가드.)
  const value = useMemo(() => ({ show }), [show]);

  return (
    <ToastContext.Provider value={value}>
      {children}
      {/* 모바일 프레임 안쪽에 뜨도록 컨테이너 기준 absolute */}
      <div className="pointer-events-none fixed inset-0 z-[200] mx-auto flex max-w-phone flex-col items-center justify-center gap-2 px-4">
        <AnimatePresence>
          {toasts.map((t) => (
            <motion.div
              key={t.id}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.9 }}
              className={
                'pointer-events-auto rounded-full px-4 py-2.5 text-[13px] font-semibold shadow-float ' +
                (t.type === 'error'
                  ? 'bg-danger text-white'
                  : t.type === 'success'
                    ? 'bg-brand text-white'
                    : 'bg-ink/90 text-white')
              }
            >
              {t.message}
            </motion.div>
          ))}
        </AnimatePresence>
      </div>
    </ToastContext.Provider>
  );
}

export function useToast() {
  const ctx = useContext(ToastContext);
  return ctx || { show: () => {} };
}
