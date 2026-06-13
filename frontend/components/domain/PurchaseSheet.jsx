'use client';

import { useEffect, useMemo, useState } from 'react';
import { Check, Truck } from 'lucide-react';
import { Sheet } from '@/components/ui/Sheet';
import { Button } from '@/components/ui/Button';
import { QtyStepper } from '@/components/ui/Misc';
import { won, wonLabel } from '@/lib/format';
import { cn } from '@/lib/cn';

// 옵션 라벨: 백엔드 OfferOption {quantity, unit} → "3봉" / "1.5kg".
export const optionLabel = (o) => `${o.quantity ?? ''}${o.unit || ''}`.trim() || '기본';

// 네이버식 구매 옵션 시트 — 옵션 선택 + 수량 + 배송 요약 + [장바구니 담기 / 바로 구매].
// 옵션/수량은 내부 상태로 관리하고, 결정은 onSubmit({ option, qty, mode }) 로 위임한다(mode: 'cart' | 'buy').
// pendingMode: 진행 중인 CTA('cart'|'buy'|null) — 누른 버튼만 로딩 표시하고 둘 다 비활성화한다.
export function PurchaseSheet({ open, onClose, options = [], pendingMode = null, onSubmit }) {
  const busy = pendingMode != null;
  const [optionId, setOptionId] = useState(null);
  const [qty, setQty] = useState(1);

  // 열릴 때마다 첫 옵션 + 수량 1 로 초기화.
  useEffect(() => {
    if (open) {
      setOptionId(null);
      setQty(1);
    }
  }, [open]);

  const selected = useMemo(
    () => options.find((o) => o.id === optionId) || options[0] || null,
    [options, optionId],
  );
  const total = selected ? selected.price * qty : 0;

  return (
    <Sheet open={open} onClose={onClose} title="구매 옵션">
      {/* 옵션 선택 */}
      <div className="flex flex-col gap-2 pt-1">
        {options.map((o) => {
          const active = selected?.id === o.id;
          return (
            <button
              key={o.id}
              onClick={() => setOptionId(o.id)}
              aria-pressed={active}
              className={cn(
                'tap flex items-center justify-between rounded-2xl border px-4 py-3 text-left transition-colors',
                active ? 'border-brand bg-brand-bg' : 'border-line-soft bg-white',
              )}
            >
              <span className="flex items-center gap-1.5 text-[14px] font-bold text-ink">
                <Check size={16} className={cn('text-brand-dark', !active && 'opacity-0')} />
                {optionLabel(o)}
              </span>
              <span className="text-[14px] font-extrabold tabular text-ink">
                {won(o.price)}
                <span className="text-[11px] font-medium text-ink-soft">원</span>
              </span>
            </button>
          );
        })}
      </div>

      {/* 수량 */}
      <div className="mt-3 flex items-center justify-between rounded-2xl border border-line-soft bg-white px-4 py-3">
        <span className="text-[13px] font-bold text-ink">수량</span>
        <QtyStepper value={qty} onChange={setQty} />
      </div>

      {/* 배송 요약 */}
      <p className="mt-3 flex items-center gap-1.5 text-[12px] text-ink-mid">
        <Truck size={14} className="shrink-0 text-brand-dark" />
        산지직송 · 배송비 3,000원 (3만원 이상 무료)
      </p>

      {/* 결제금액 */}
      <div className="mt-3 flex items-center justify-between border-t border-line-soft pt-3">
        <span className="text-[13px] font-bold text-ink-mid">결제금액</span>
        <span className="text-[20px] font-extrabold tabular text-ink">{wonLabel(total)}</span>
      </div>

      {/* CTA */}
      <div className="mt-3 flex gap-2.5">
        <Button
          variant="outline"
          block
          loading={pendingMode === 'cart'}
          disabled={!selected || busy}
          onClick={() => selected && onSubmit?.({ option: selected, qty, mode: 'cart' })}
        >
          장바구니 담기
        </Button>
        <Button
          block
          loading={pendingMode === 'buy'}
          disabled={!selected || busy}
          onClick={() => selected && onSubmit?.({ option: selected, qty, mode: 'buy' })}
        >
          바로 구매
        </Button>
      </div>
    </Sheet>
  );
}
