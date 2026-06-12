'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useSavePreferences } from '@/lib/queries';
import { AppHeader } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { cn } from '@/lib/cn';

const HOUSEHOLDS = ['1인', '2인', '3인', '4인 이상'];
const LIFESTYLES = [
  { label: '신선한', emoji: '🌿' },
  { label: '저렴한', emoji: '💰' },
  { label: '유기농', emoji: '🍃' },
  { label: '프리미엄', emoji: '✨' },
  { label: '친환경', emoji: '♻️' },
  { label: '빠른 배송', emoji: '⚡' },
];
const ALLERGENS = ['난류', '우유', '메밀', '땅콩', '대두', '밀', '고등어', '게', '새우', '돼지고기', '복숭아', '토마토', '호두', '닭고기', '쇠고기', '오징어', '조개류', '잣'];

function Pill({ active, onClick, children }) {
  return (
    <button
      onClick={onClick}
      className={cn(
        'tap rounded-full border px-3.5 py-2 text-[13px] transition-colors',
        active ? 'border-brand bg-brand-bg font-bold text-brand-dark' : 'border-line-soft bg-white font-medium text-ink-mid',
      )}
    >
      {children}
    </button>
  );
}

export default function SurveyPage() {
  const router = useRouter();
  const save = useSavePreferences();

  const [household, setHousehold] = useState('2인');
  const [lifestyles, setLifestyles] = useState(['신선한', '저렴한']);
  const [spicyAvoid, setSpicyAvoid] = useState(false);
  const [allergens, setAllergens] = useState([]);

  const toggle = (list, setList, v) => setList(list.includes(v) ? list.filter((x) => x !== v) : [...list, v]);

  const finish = async () => {
    try {
      await save.mutateAsync({ household, lifestyles, spicyAvoid, allergens });
    } catch {
      /* 데모/실패 무시 */
    }
    router.replace('/');
  };

  return (
    <>
      <AppHeader title="가입하고 시작하기" back right={<button onClick={() => router.replace('/')} className="tap px-2 text-[13px] font-semibold text-ink-soft">건너뛰기</button>} />
      <div className="px-6 pb-8 pt-3">
        <div className="mb-5 flex gap-1">
          <span className="h-1 flex-1 rounded-full bg-brand" />
          <span className="h-1 flex-1 rounded-full bg-brand" />
        </div>

        <h1 className="font-display text-[22px] font-bold tracking-tight text-ink">조금만 더 알려주세요</h1>
        <p className="mt-1.5 text-[13px] text-ink-mid">가구·취향·알레르기에 맞춰 추천해드려요</p>

        {/* 가구원 수 */}
        <section className="mt-7">
          <h2 className="text-[14px] font-bold text-ink">가구원 수</h2>
          <p className="mt-1 text-[12px] text-ink-soft">메뉴와 식재료 양을 맞추는 데 써요</p>
          <div className="mt-3 flex gap-1.5 rounded-2xl bg-surface-soft p-1">
            {HOUSEHOLDS.map((h) => (
              <button
                key={h}
                onClick={() => setHousehold(h)}
                className={cn('tap h-10 flex-1 rounded-xl text-[13px] transition', household === h ? 'bg-white font-bold text-ink shadow-card' : 'font-medium text-ink-mid')}
              >
                {h}
              </button>
            ))}
          </div>
        </section>

        {/* 소비 유형 */}
        <section className="mt-6">
          <h2 className="text-[14px] font-bold text-ink">선호하는 소비 유형</h2>
          <p className="mt-1 text-[12px] text-ink-soft">취향에 맞는 농가와 상품을 먼저 보여드려요</p>
          <div className="mt-3 flex flex-wrap gap-2">
            {LIFESTYLES.map((l) => (
              <Pill key={l.label} active={lifestyles.includes(l.label)} onClick={() => toggle(lifestyles, setLifestyles, l.label)}>
                <span className="mr-1">{l.emoji}</span>
                {l.label}
              </Pill>
            ))}
          </div>
        </section>

        {/* 매운 음식 */}
        <section className="mt-6 flex items-center gap-3 rounded-2xl border border-line-soft bg-white p-4">
          <div className="min-w-0 flex-1">
            <h2 className="text-[14px] font-bold text-ink">매운 음식은 빼주세요</h2>
            <p className="mt-0.5 text-[12px] text-ink-soft">매운 양념 레시피를 추천에서 제외</p>
          </div>
          <button
            onClick={() => setSpicyAvoid((v) => !v)}
            className={cn('relative h-7 w-12 shrink-0 rounded-full transition-colors', spicyAvoid ? 'bg-brand' : 'bg-line')}
          >
            <span className={cn('absolute top-0.5 h-6 w-6 rounded-full bg-white shadow transition-all', spicyAvoid ? 'left-[22px]' : 'left-0.5')} />
          </button>
        </section>

        {/* 알레르기 */}
        <section className="mt-6">
          <div className="flex items-baseline justify-between">
            <h2 className="text-[14px] font-bold text-ink">알레르기</h2>
            <span className="text-[11.5px] text-ink-soft">{allergens.length}개 선택</span>
          </div>
          <p className="mt-1 text-[12px] text-ink-soft">선택한 재료가 든 레시피는 추천에서 제외돼요</p>
          <div className="mt-3 flex flex-wrap gap-2">
            {ALLERGENS.map((a) => (
              <Pill key={a} active={allergens.includes(a)} onClick={() => toggle(allergens, setAllergens, a)}>
                {a}
              </Pill>
            ))}
          </div>
        </section>

        <Button block size="lg" loading={save.isPending} onClick={finish} className="mt-8">
          시작하기
        </Button>
        <button onClick={() => router.replace('/')} className="mt-3 w-full text-center text-[12.5px] text-ink-soft">
          나중에 입력할게요
        </button>
      </div>
    </>
  );
}
