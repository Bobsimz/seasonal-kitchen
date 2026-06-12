'use client';

import { useRouter } from 'next/navigation';
import { Plus, ShoppingBag } from 'lucide-react';
import { useAddToCart } from '@/lib/queries';
import { useAuth } from '@/lib/auth';
import { useToast } from '@/components/ui/Toast';
import { Button } from '@/components/ui/Button';
import { cn } from '@/lib/cn';

// 장바구니 담기 버튼. 비로그인 시 로그인 유도. 성공 시 토스트.
// variant: 'icon'(작은 원형 +) | 'full'(가로 버튼)
export function AddToCartButton({ offerId, qty = 1, variant = 'icon', label = '담기', className }) {
  const router = useRouter();
  const { isAuthenticated } = useAuth();
  const addToCart = useAddToCart();
  const toast = useToast();

  const onAdd = () => {
    if (!isAuthenticated) {
      toast.show('로그인이 필요해요', { type: 'error' });
      router.push('/login?next=' + encodeURIComponent(typeof window !== 'undefined' ? window.location.pathname : '/'));
      return;
    }
    addToCart.mutate(
      { offerId, qty },
      {
        onSuccess: () => toast.show('장바구니에 담았어요', { type: 'success' }),
        onError: () => toast.show('담기에 실패했어요', { type: 'error' }),
      },
    );
  };

  if (variant === 'full') {
    return (
      <Button onClick={onAdd} loading={addToCart.isPending} block className={className}>
        <ShoppingBag size={18} /> {label}
      </Button>
    );
  }

  return (
    <button
      onClick={onAdd}
      disabled={addToCart.isPending}
      aria-label="장바구니 담기"
      className={cn('tap grid h-9 w-9 place-items-center rounded-full bg-brand-bg text-brand-dark disabled:opacity-50', className)}
    >
      <Plus size={18} strokeWidth={2.6} />
    </button>
  );
}
