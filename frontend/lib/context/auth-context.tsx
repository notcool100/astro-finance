"use client";
import React, { createContext, useContext, useEffect, useState } from 'react';
import { User } from '../api/types';
import { authService } from '../api/services';
import Cookies from 'js-cookie';

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
}

// Create the AuthContext
const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const token = Cookies.get('token');
        console.log('Checking auth, token exists:', !!token);

        if (token) {
          const tokenParts = token.split('.');
          if (tokenParts.length === 3) {
            const payload = JSON.parse(atob(tokenParts[1]));
            const expiry = payload.exp * 1000;

            console.log('Token payload:', payload);
            console.log('Token expiry time:', new Date(expiry).toISOString());
            console.log('Current time:', new Date().toISOString());

            if (Date.now() >= expiry) {
              console.log('Token expired, logging out');
              Cookies.remove('token', { path: '/' });
              setIsLoading(false);
              return;
            }
          }

          const response = await authService.getCurrentUser();
          console.log('Current user response:', response);

          if (response.data) {
            setUser(response.data);
          } else {
            console.error('getCurrentUser response missing data');
            Cookies.remove('token', { path: '/' });
          }
        }
      } catch (error) {
        console.error('Error fetching current user:', error);

        // Only remove the token if the error is a 401
        if (error.response && error.response.status === 401) {
          Cookies.remove('token', { path: '/' });
        }
      } finally {
        setIsLoading(false);
      }
    };

    checkAuth();
  }, []);

  const login = async (email: string, password: string) => {
    setIsLoading(true);
    try {
      const response = await authService.login({ email, password });
      console.log('Login response:', response);

      if (response.success && response.token) {
        const tokenParts = response.token.split('.');
        let expiryDate = new Date();
        expiryDate.setDate(expiryDate.getDate() + 1);

        if (tokenParts.length === 3) {
          try {
            const payload = JSON.parse(atob(tokenParts[1]));
            if (payload.exp) {
              expiryDate = new Date(payload.exp * 1000);
            }
          } catch (e) {
            console.error('Error parsing token payload:', e);
          }
        }

        Cookies.set('token', response.token, {
          expires: expiryDate,
          path: '/',
          secure: window.location.protocol === 'https:',
          sameSite: 'strict',
        });

        console.log('Token set:', response.token);
        console.log('Token expiry set to:', expiryDate);

        const userObj: User = {
          id: response.userId,
          firstName: response.userName.split(' ')[0] || '',
          lastName: response.userName.split(' ').slice(1).join(' ') || '',
          role: response.userRole,
          email: '',
        };

        setUser(userObj);
        window.location.href = '/dashboard';
      } else {
        console.error('Login response missing expected data');
      }
    } catch (error) {
      console.error('Login error:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const logout = async () => {
    setIsLoading(true);
    try {
      console.log('Logging out...');
      
      try {
        // Try to call the backend logout endpoint
        await authService.logout();
        console.log('Backend logout successful');
      } catch (error) {
        // If the backend logout fails, just log it and continue with client-side logout
        console.warn('Backend logout failed, continuing with client-side logout:', error);
      }
      
      // Remove the token cookie
      Cookies.remove('token', { path: '/' });
      console.log('Token cookie removed');
      
      // Clear user state
      setUser(null);
      
      // Redirect to login page
      console.log('Redirecting to login page');
      window.location.href = '/login';
    } catch (error) {
      console.error('Logout error:', error);
      
      // Ensure token is removed even if there's an error
      Cookies.remove('token', { path: '/' });
      
      // Force redirect to login
      window.location.href = '/login';
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
