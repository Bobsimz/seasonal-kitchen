'use client';

import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { setToken } from './api';
import { STORAGE_KEYS } from './config';
import { endpoints } from './endpoints';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [ready, setReady] = useState(false);

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

  const login = useCallback(
    async ({ email, password }) => {
      const res = await endpoints.login({ email, password });
      persist(res.accessToken, { id: res.userId, nickname: res.nickname, email });
      return res;
    },
    [persist],
  );

  const signup = useCallback(
    async ({ email, password, nickname }) => {
      const res = await endpoints.signup({ email, password, nickname });
      persist(res.accessToken, { id: res.userId, nickname: res.nickname, email });
      return res;
    },
    [persist],
  );

  const logout = useCallback(() => persist(null, null), [persist]);

  const value = useMemo(
    () => ({ user, ready, isAuthenticated: !!user, login, signup, logout, setUser }),
    [user, ready, login, signup, logout],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within <AuthProvider>');
  return ctx;
}
