"use client";
import React, { createContext, useContext, useEffect, useState } from 'react';
import { User } from '@/lib/api/types';
import { authService } from '@/lib/api/services';
import Cookies from 'js-cookie';

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Check if user is logged in
    const checkAuth = async () => {
      try {
        const token = Cookies.get('token');
        if (token) {
          const { data } = await authService.getCurrentUser();
          setUser(data);
        }
      } catch (error) {
        console.error('Authentication error:', error);
        Cookies.remove('token');
      } finally {
        setIsLoading(false);
      }
    };

    checkAuth();
  }, []);

  const login = async (email: string, password: string) => {
    setIsLoading(true);
    try {
      const loginresponse = await authService.login({ email, password });
      console.log('loginresponse', loginresponse);
  
      // Set cookie with proper path
      Cookies.set('token', loginresponse.data.token, {
        expires: 1, // 1 day
        path: '/',  // crucial so it's accessible site-wide
      });
  
      // Force full reload so cookie is sent with request
      window.location.href = '/dashboard';
    } finally {
      setIsLoading(false);
    }
  };

  const logout = async () => {
    setIsLoading(true);
    try {
      await authService.logout();
      setUser(null);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        isLoading,
        isAuthenticated: !!user,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}