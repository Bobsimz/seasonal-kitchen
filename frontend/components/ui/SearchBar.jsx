'use client';

import { Search, X } from 'lucide-react';
import { cn } from '@/lib/cn';

// 검색 입력. readOnly=true 면 클릭 시 onClick(검색 페이지로 이동)만 하는 "버튼형" 으로 동작.
export function SearchBar({
  value,
  onChange,
  onSubmit,
  onClick,
  placeholder = '제철 식재료, 레시피, 농가 검색',
  readOnly = false,
  autoFocus = false,
  className,
}) {
  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        onSubmit?.(value);
      }}
      onClick={onClick}
      className={cn(
        'flex h-11 items-center gap-2 rounded-2xl bg-line-soft px-3.5 text-ink',
        readOnly && 'tap cursor-pointer',
        className,
      )}
    >
      <Search size={18} className="shrink-0 text-ink-soft" />
      <input
        value={value ?? ''}
        onChange={(e) => onChange?.(e.target.value)}
        placeholder={placeholder}
        readOnly={readOnly}
        autoFocus={autoFocus}
        className="min-w-0 flex-1 bg-transparent text-[14px] font-medium placeholder:text-ink-soft focus:outline-none"
      />
      {!readOnly && value ? (
        <button type="button" onClick={() => onChange?.('')} className="tap shrink-0 text-ink-soft">
          <X size={16} />
        </button>
      ) : null}
    </form>
  );
}
