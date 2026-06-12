'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth';
import { AppHeader } from '@/components/layout';
import { Button } from '@/components/ui/Button';
import { useToast } from '@/components/ui/Toast';
import { Field } from '../login/page';

const OAUTH = [
  { label: '카카오로 시작', cls: 'bg-[#FEE500] text-[#191919]' },
  { label: 'Apple로 계속', cls: 'bg-black text-white' },
  { label: '구글로 계속', cls: 'bg-white text-ink border border-line' },
];

export default function SignupPage() {
  const router = useRouter();
  const { signup } = useAuth();
  const toast = useToast();
  const [form, setForm] = useState({ email: '', password: '', nickname: '' });
  const [loading, setLoading] = useState(false);
  const [err, setErr] = useState(null);

  const onSubmit = async (e) => {
    e.preventDefault();
    setErr(null);
    setLoading(true);
    try {
      await signup(form);
      toast.show('가입을 환영해요!', { type: 'success' });
      router.replace('/signup/survey');
    } catch (e2) {
      setErr(e2?.message || '가입에 실패했어요.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <AppHeader title="가입하고 시작하기" back />
      <div className="px-7 pb-8 pt-3">
        <h1 className="font-display text-[22px] font-bold leading-snug tracking-tight text-ink">
          간편하게 시작하고
          <br />
          맞춤 추천을 받아보세요
        </h1>
        <p className="mt-1.5 text-[13px] text-ink-mid">가격 알림 · 찜한 재료 추천 · 개인화된 레시피</p>

        <div className="mt-7 space-y-2.5">
          {OAUTH.map((o) => (
            <button
              key={o.label}
              onClick={() => toast.show('소셜 로그인은 준비 중이에요')}
              className={'tap h-[52px] w-full rounded-2xl text-[15px] font-bold ' + o.cls}
            >
              {o.label}
            </button>
          ))}
        </div>

        <div className="my-6 flex items-center gap-3 text-[12px] text-ink-soft">
          <span className="h-px flex-1 bg-line" /> 이메일로 가입 <span className="h-px flex-1 bg-line" />
        </div>

        <form onSubmit={onSubmit} className="space-y-3">
          <Field label="닉네임" value={form.nickname} onChange={(v) => setForm({ ...form, nickname: v })} placeholder="제철러버" />
          <Field label="이메일" type="email" value={form.email} onChange={(v) => setForm({ ...form, email: v })} placeholder="example@email.com" autoComplete="email" />
          <Field label="비밀번호" type="password" value={form.password} onChange={(v) => setForm({ ...form, password: v })} placeholder="8자 이상" autoComplete="new-password" />
          {err && <p className="text-[13px] font-semibold text-danger">{err}</p>}
          <Button type="submit" block size="lg" loading={loading} className="!mt-5">
            가입하기
          </Button>
        </form>

        <p className="mt-6 text-center text-[11.5px] leading-relaxed text-ink-soft">
          가입 시 <span className="font-semibold text-ink">이용약관</span>과{' '}
          <span className="font-semibold text-ink">개인정보처리방침</span>에 동의합니다
        </p>
        <div className="mt-4 text-center text-[14px] text-ink-soft">
          이미 회원이신가요? <Link href="/login" className="font-bold text-brand">로그인</Link>
        </div>
      </div>
    </>
  );
}
