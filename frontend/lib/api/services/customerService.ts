import api from '../axios';
import { 
  ApiResponse, 
  Customer,
  CreateCustomerRequest,
  PaginatedResponse,
  CustomersListResponse
} from '../types';

export const customerService = {
  /**
   * Get all customers with pagination
   */
  getCustomers: async (page = 1, pageSize = 10): Promise<ApiResponse<CustomersListResponse<Customer>>> => {
    const response = await api.get<ApiResponse<CustomersListResponse<Customer>>>('/customers', {
      params: { page, pageSize }
    });
    return response.data;
  },

  /**
   * Get customer by ID
   */
  getCustomerById: async (id: string): Promise<ApiResponse<Customer>> => {
    const response = await api.get<ApiResponse<Customer>>(`/customers/${id}`);
    return response.data;
  },

  /**
   * Search customers by name or phone number
   */
  searchCustomers: async (query: string): Promise<ApiResponse<Customer[]>> => {
    const response = await api.get<ApiResponse<Customer[]>>('/customers/search', {
      params: { query }
    });
    return response.data;
  },

  /**
   * Create a new customer
   */
  createCustomer: async (data: CreateCustomerRequest): Promise<ApiResponse<Customer>> => {
    const response = await api.post<ApiResponse<Customer>>('/customers', data);
    return response.data;
  },

  /**
   * Update customer
   */
  updateCustomer: async (id: string, data: Partial<CreateCustomerRequest>): Promise<ApiResponse<Customer>> => {
    const response = await api.put<ApiResponse<Customer>>(`/customers/${id}`, data);
    return response.data;
  },

  /**
   * Delete customer
   */
  deleteCustomer: async (id: string): Promise<ApiResponse<void>> => {
    const response = await api.delete<ApiResponse<void>>(`/customers/${id}`);
    return response.data;
  }
};