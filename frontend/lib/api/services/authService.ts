import api from '../axios';
import { ApiResponse, LoginRequest, LoginResponse, User } from '../types';

export const authService = {
  /**
   * Login user with email and password
   */
  login: async (data: LoginRequest): Promise<ApiResponse<LoginResponse>> => {
    const response = await api.post<ApiResponse<LoginResponse>>('/auth/login', data);
    return response.data;
  },

  /**
   * Get current user profile
   */
  getCurrentUser: async (): Promise<ApiResponse<User>> => {
    console.log('getCurrentUser');
    const response = await api.get<ApiResponse<User>>('/auth/me');
    return response.data;
  },

  /**
   * Logout user
   */
  logout: async (): Promise<void> => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('token');
    }
  }
};