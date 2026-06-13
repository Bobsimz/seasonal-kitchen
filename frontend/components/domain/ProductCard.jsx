import Link from 'next/link';
import { cn } from '@/lib/cn';
import { won } from '@/lib/format';
import { Card } from '@/components/ui/Card';
import { VegImage } from './VegImage';
import { AddToCartButton } from './AddToCartButton';

// 식재료 상세의 "상품 리스트"용 상품 카드 (2열 그리드).
// /products(ProductCardResponse) 형태를 그대로 받는다 — id = producer_offers.id = 담기용 offerId.
// 카드 본문 탭 → 농가 스토어. 담기 버튼은 <Link> 밖에 둬서 네비게이션과 충돌하지 않게 한다.
export function ProductCard({ product: p, className }) {
  const soldOut = p.stockStatus === 'SOLD_OUT';
  const sub = [p.region, p.producerName].filter(Boolean).join(' ');

  return (
    <Card className={cn('flex flex-col overflow-hidden', className)}>
      <Link href={`/producers/${p.producerId}`} className="tap block">
        <div className="relative aspect-square w-full overflow-hidden bg-brand-bg">
          {p.imageUrl ? (
            <img src={p.imageUrl} alt={p.name} className="h-full w-full object-cover" />
          ) : (
            <div className="grid h-full w-full place-items-center">
              <VegImage name={p.ingredientName || p.name} size={72} />
            </div>
          )}
          {soldOut && (
            <div className="absolute inset-0 grid place-items-center bg-black/45">
              <span className="rounded-full bg-white/90 px-2.5 py-1 text-[11px] font-extrabold text-ink">품절</span>
            </div>
          )}
        </div>
        <div className="px-3 pt-2.5">
          <p className="line-clamp-2 min-h-[34px] text-[13px] font-bold leading-snug text-ink">{p.name}</p>
          {sub && <p className="mt-1 truncate text-[11px] text-ink-soft">{sub}</p>}
        </div>
      </Link>
      <div className="mt-auto flex items-end justify-between px-3 pb-3 pt-2">
        <div className="flex items-baseline gap-0.5">
          <span className="text-[15px] font-extrabold text-ink tabular">{won(p.price)}</span>
          <span className="text-[10.5px] text-ink-soft">원/{p.unit}</span>
        </div>
        {!soldOut && <AddToCartButton offerId={p.id} />}
      </div>
    </Card>
  );
}
