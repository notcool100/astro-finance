import axios from 'axios';
import { cookies } from 'next/headers';
import Cookies from 'js-cookie';

// Create an axios instance with default config
const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5000/api',
  withCredentials: true, 
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor for adding auth token
api.interceptors.request.use(
  (config) => {
    const token = Cookies.get('token');
    console.log('Axios request interceptor, token:', token);
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor for handling common errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    const { response } = error;
    console.log(response," this is the response")
    // Handle authentication errors
    if (response?.status === 401) {
      // Clear cookies and redirect to login
      if (typeof window !== 'undefined') {
        console.log('Unauthorized request, clearing token');
        Cookies.remove('token', { path: '/' });
        
        // Only redirect if not already on login page to avoid redirect loops
        if (!window.location.pathname.includes('/login')) {
          window.location.href = '/login';
        }
      }
    }
    
    return Promise.reject(error);
  }
);

export default api;
