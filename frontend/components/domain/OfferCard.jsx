import { cn } from '@/lib/cn';
import { won } from '@/lib/format';
import { VegImage } from './VegImage';
import { AddToCartButton } from './AddToCartButton';

// 농가 판매 상품(offer) 행 — 식재료 이미지 + 이름 + 신선도 + 가격 + 담기.
// rank: 가격 비교에서 순위 표시(1=최저가).
export function OfferRow({ offer, rank, showProducer = false, divider = true, className }) {
  return (
    <div className={cn('flex items-center gap-3 px-4 py-3', divider && 'border-b border-line-soft', className)}>
      <VegImage name={offer.ingredientName} size={48} />
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-1.5">
          {rank === 1 && (
            <span className="rounded-md bg-brand px-1.5 py-0.5 text-[10px] font-bold text-white">최저가</span>
          )}
          <span className="truncate text-[14.5px] font-bold text-ink">{offer.ingredientName}</span>
        </div>
        {showProducer && (
          <p className="mt-0.5 truncate text-[12px] text-ink-mid">
            {offer.region} {offer.producerName}
          </p>
        )}
        {offer.freshnessLabel && <p className="mt-0.5 text-[11.5px] font-semibold text-brand-dark">{offer.freshnessLabel}</p>}
      </div>
      <div className="flex shrink-0 items-center gap-2.5">
        <div className="text-right">
          <p className="text-[15px] font-extrabold text-ink tabular">{won(offer.price)}</p>
          <p className="text-[10.5px] text-ink-soft">원/{offer.unit}</p>
        </div>
        <AddToCartButton offerId={offer.id} />
      </div>
    </div>
  );
}
