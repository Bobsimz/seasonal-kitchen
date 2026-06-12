'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { Plus, Store, Sparkles } from 'lucide-react';
import { useMyProducer, useAddMyOffer } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { cn } from '@/lib/cn';
import { wonLabel } from '@/lib/format';
import { AppHeader, BottomBar } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { Card } from '@/components/ui/Card';
import { LoadingScreen } from '@/components/ui/Spinner';
import { ErrorState, EmptyState } from '@/components/ui/States';
import { useToast } from '@/components/ui/Toast';

const PRESET_INGREDIENTS = ['봄동', '냉이', '달래', '시금치', '무', '대파', '애호박', '딸기'];
const UNITS = ['개', '봉', '포기', '단', 'kg'];
const FRESHNESS = ['당일수확', '수확 1일 이내', '산지직송'];

function FieldLabel({ label, required, hint }) {
  return (
    <div className="mb-2">
      <div className="flex items-center gap-1.5">
        <span className="text-[12.5px] font-extrabold text-ink">{label}</span>
        {required && (
          <span className="rounded-full bg-hot-bg px-1.5 py-0.5 text-[10px] font-extrabold text-hot">필수</span>
        )}
      </div>
      {hint && <p className="mt-1 text-[11px] text-ink-soft">{hint}</p>}
    </div>
  );
}

function Pill({ active, onClick, children }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={cn(
        'tap rounded-full px-3.5 py-2 text-[12.5px] font-bold transition-colors',
        active ? 'bg-brand text-white' : 'border border-line bg-white text-ink-mid',
      )}
    >
      {children}
    </button>
  );
}

export default function SellerOfferNewPage() {
  const router = useRouter();
  const toast = useToast();
  const { isAuthenticated } = useAuth();
  const { data: producer, isLoading, error, refetch } = useMyProducer();
  const addOffer = useAddMyOffer();

  const [ingredientName, setIngredientName] = useState('');
  const [price, setPrice] = useState('');
  const [unit, setUnit] = useState('개');
  const [freshnessLabel, setFreshnessLabel] = useState('당일수확');

  const canSubmit = ingredientName.trim().length > 0 && Number(price) > 0;

  const onSubmit = async () => {
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.push('/login?next=/my/seller/offers/new');
      return;
    }
    if (!canSubmit) {
      toast.show('식재료명과 가격을 입력해주세요', { type: 'error' });
      return;
    }
    try {
      await addOffer.mutateAsync({
        ingredientName: ingredientName.trim(),
        price: Number(price),
        unit,
        freshnessLabel,
      });
      toast.show('상품을 등록했어요', { type: 'success' });
      router.replace('/my/seller/dashboard');
    } catch (e) {
      toast.show(e?.message || '등록에 실패했어요', { type: 'error' });
    }
  };

  return (
    <>
      <AppHeader title="상품 등록" back />

      {isLoading && <LoadingScreen />}
      {error && <ErrorState onRetry={refetch} />}

      {!isLoading && !error && !producer && (
        <div className="px-4 pt-10">
          <EmptyState
            icon={<Store size={34} />}
            title="먼저 농가 등록이 필요해요"
            description="판매 상품을 올리려면 농가 정보를 먼저 등록해주세요."
            action={
              <Link href="/my/seller/register">
                <Button size="sm">농가 등록하기</Button>
              </Link>
            }
          />
        </div>
      )}

      {!isLoading && !error && producer && (
        <div className="animate-fade-up px-5 pb-28 pt-4">
          {/* 상품 사진 (mock) */}
          <FieldLabel label="상품 사진" hint="최대 10장 · 첫 사진이 대표 이미지예요" />
          <div className="flex gap-2 overflow-x-auto phone-scroll pb-1">
            <button
              type="button"
              onClick={() => toast.show('사진 업로드는 준비 중이에요')}
              className="tap flex h-[84px] w-[84px] shrink-0 flex-col items-center justify-center gap-1 rounded-2xl border-[1.5px] border-dashed border-line bg-surface-soft text-ink-soft"
            >
              <Plus size={22} />
              <span className="text-[10.5px] font-bold">0/10</span>
            </button>
          </div>

          {/* 식재료명 */}
          <div className="mt-5">
            <FieldLabel label="식재료명" required />
            <input
              value={ingredientName}
              onChange={(e) => setIngredientName(e.target.value)}
              placeholder="예: 해남 황토밭 봄동"
              className="w-full rounded-xl border border-line bg-surface-soft px-3.5 py-3 text-[13.5px] text-ink outline-none placeholder:text-ink-soft focus:border-brand"
            />
            <div className="mt-2 flex flex-wrap gap-1.5">
              {PRESET_INGREDIENTS.map((name) => (
                <button
                  key={name}
                  type="button"
                  onClick={() => setIngredientName(name)}
                  className={cn(
                    'tap rounded-full px-3 py-1.5 text-[12px] font-semibold transition-colors',
                    ingredientName === name
                      ? 'bg-brand-bg text-brand-dark'
                      : 'border border-line-soft bg-white text-ink-mid',
                  )}
                >
                  {name}
                </button>
              ))}
            </div>
          </div>

          {/* 가격 · 단위 */}
          <div className="mt-5">
            <FieldLabel label="가격 · 단위" required />
            <div className="flex gap-2">
              <div className="flex flex-[1.4] items-center gap-1 rounded-xl border border-line bg-surface-soft px-3.5 py-3">
                <span className="text-ink-soft">₩</span>
                <input
                  inputMode="numeric"
                  value={price}
                  onChange={(e) => setPrice(e.target.value.replace(/[^0-9]/g, ''))}
                  placeholder="4,000"
                  className="w-full bg-transparent text-[13.5px] text-ink outline-none placeholder:text-ink-soft"
                />
              </div>
              <div className="flex flex-1 items-center justify-center rounded-xl border border-line bg-white px-2 py-1.5">
                <div className="flex flex-wrap justify-center gap-1.5">
                  {UNITS.map((u) => (
                    <Pill key={u} active={unit === u} onClick={() => setUnit(u)}>
                      {u}
                    </Pill>
                  ))}
                </div>
              </div>
            </div>

            {/* 권장가 안내 (정보 카드) */}
            <Card className="mt-2.5 flex items-start gap-2.5 border border-brand-soft p-3">
              <div className="mt-0.5 grid h-6 w-6 shrink-0 place-items-center rounded-lg bg-brand-bg text-brand-dark">
                <Sparkles size={14} />
              </div>
              <div>
                <p className="text-[12.5px] font-extrabold text-ink">권장가 안내</p>
                <p className="mt-0.5 text-[12px] leading-relaxed text-ink-mid">
                  최근 시세 기준 {wonLabel(4000)}~{wonLabel(5000)} 사이를 추천해요. 신선도가 좋을수록 조금 더 받아도 좋아요.
                </p>
              </div>
            </Card>
          </div>

          {/* 신선도 라벨 */}
          <div className="mt-5">
            <FieldLabel label="신선도 라벨" hint="구매자에게 보여줄 신선도 표시를 골라주세요" />
            <div className="flex flex-wrap gap-1.5">
              {FRESHNESS.map((f) => (
                <Pill key={f} active={freshnessLabel === f} onClick={() => setFreshnessLabel(f)}>
                  {f}
                </Pill>
              ))}
            </div>
          </div>
        </div>
      )}

      {!isLoading && !error && producer && (
        <BottomBar>
          <Button block size="lg" loading={addOffer.isPending} disabled={!canSubmit} onClick={onSubmit}>
            등록하기
          </Button>
        </BottomBar>
      )}
    </>
  );
}
