import api from '../axios';
import { ApiResponse, LoginRequest, LoginResponse, User } from '../types';

export const authService = {
  /**
   * Login user with email and password
   * Note: The actual response structure is different from what's defined in types
   */
  login: async (data: LoginRequest): Promise<any> => {
    const response = await api.post('/auth/login', data);
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
    try {
      // Call the backend logout endpoint
      await api.post('/auth/logout');
    } catch (error) {
      console.log('Logout API call failed:', error);
      throw error; // Propagate the error to be handled by the caller
    }
  }
};