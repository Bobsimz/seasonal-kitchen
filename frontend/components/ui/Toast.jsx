'use client';

import { createContext, useCallback, useContext, useState } from 'react';
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

  return (
    <ToastContext.Provider value={{ show }}>
      {children}
      {/* 모바일 프레임 안쪽에 뜨도록 컨테이너 기준 absolute */}
      <div className="pointer-events-none fixed inset-x-0 bottom-24 z-[200] mx-auto flex max-w-phone flex-col items-center gap-2 px-4">
        <AnimatePresence>
          {toasts.map((t) => (
            <motion.div
              key={t.id}
              initial={{ opacity: 0, y: 16, scale: 0.96 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, scale: 0.96 }}
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
