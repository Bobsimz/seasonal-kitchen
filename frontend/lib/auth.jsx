'use client';

import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { onUnauthorized, setToken } from './api';
import { STORAGE_KEYS } from './config';
import { endpoints } from './endpoints';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [ready, setReady] = useState(false);
  // 백엔드가 인증 호출에 401 을 돌려줬을 때 켜진다 → SessionGate 가 안내 모달을 띄운다.
  const [sessionExpired, setSessionExpired] = useState(false);
  // 'expired'(토큰이 있었으나 만료) | 'required'(애초에 로그인 안 함)
  const [expiryReason, setExpiryReason] = useState('expired');

  // 새로고침 시 저장된 세션 복구
  useEffect(() => {
    try {
      const raw = window.localStorage.getItem(STORAGE_KEYS.user);
      if (raw) setUser(JSON.parse(raw));
    } catch {
      /* ignore */
    }
    setReady(true);
  }, []);

  const persist = useCallback((token, nextUser) => {
    setToken(token);
    setUser(nextUser);
    if (nextUser) window.localStorage.setItem(STORAGE_KEYS.user, JSON.stringify(nextUser));
    else window.localStorage.removeItem(STORAGE_KEYS.user);
  }, []);

  // api 계층의 401 통지를 세션 상태 변화로 번역한다.
  useEffect(() => {
    return onUnauthorized(({ hadToken }) => {
      persist(null, null); // 만료/무효 세션 정리
      setExpiryReason(hadToken ? 'expired' : 'required');
      setSessionExpired(true);
    });
  }, [persist]);

  const dismissSessionExpired = useCallback(() => setSessionExpired(false), []);

  const login = useCallback(
    async ({ email, password }) => {
      const res = await endpoints.login({ email, password });
      persist(res.accessToken, { id: res.userId, nickname: res.nickname, email });
      setSessionExpired(false);
      return res;
    },
    [persist],
  );

  const signup = useCallback(
    async ({ email, password, nickname }) => {
      const res = await endpoints.signup({ email, password, nickname });
      persist(res.accessToken, { id: res.userId, nickname: res.nickname, email });
      setSessionExpired(false);
      return res;
    },
    [persist],
  );

  const logout = useCallback(() => persist(null, null), [persist]);

  const value = useMemo(
    () => ({
      user,
      ready,
      isAuthenticated: !!user,
      login,
      signup,
      logout,
      setUser,
      sessionExpired,
      expiryReason,
      dismissSessionExpired,
    }),
    [user, ready, login, signup, logout, sessionExpired, expiryReason, dismissSessionExpired],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within <AuthProvider>');
  return ctx;
}
