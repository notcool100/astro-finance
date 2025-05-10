// Common API response type
export interface ApiResponse<T> {
  data: T;
  message?: string;
  success: boolean;
}

// Pagination response type
export interface PaginatedResponse<T> {
  items: T[];
  totalCount: number;
  pageNumber: number;
  pageSize: number;
  totalPages: number;
}

// Customers list response type matching backend response
export interface CustomersListResponse<T> {
  customers: T[];
  totalCount: number;
  pageNumber: number;
  pageSize: number;
  totalPages: number;
}

// Error response from API
export interface ApiError {
  message: string;
  errors?: Record<string, string[]>;
  statusCode: number;
}

// Auth types
export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  user: User;
}

export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: string;
}

// Customer types
export interface Customer {
  id: string;
  firstName: string;
  lastName: string;
  email?: string;
  accountType?: string;
  status?: string;
  phoneNumber: string;
  address?: string;
  identificationNumber: string;
  identificationType: string;
  fullName: string;
  createdAt: string;
  updatedAt?: string;
}

export interface CreateCustomerRequest {
  firstName: string;
  lastName: string;
  accountType?: string;
  status?: string;
  email?: string;
  phoneNumber: string;
  address?: string;
  identificationNumber: string;
  identificationType: string;
}

// Loan types
export interface Loan {
  id: string;
  customerId: string;
  customerName: string;
  amount: number;
  interestRate: number;
  term: number;
  startDate: string;
  endDate: string;
  status: LoanStatus;
  type: LoanType;
  createdAt: string;
  updatedAt: string;
}

export enum LoanStatus {
  Pending = 'Pending',
  Active = 'Active',
  Completed = 'Completed',
  Defaulted = 'Defaulted'
}

export enum LoanType {
  Flat = 'Flat',
  Diminishing = 'Diminishing'
}

export interface CreateLoanRequest {
  customerId: string;
  amount: number;
  interestRate: number;
  term: number;
  startDate: string;
  type: LoanType;
}

export interface PaymentSchedule {
  id: string;
  loanId: string;
  dueDate: string;
  amount: number;
  principalAmount: number;
  interestAmount: number;
  isPaid: boolean;
  paymentDate?: string;
  transactionId?: string;
}

// Transaction types
export interface Transaction {
  id: string;
  loanId?: string;
  customerId: string;
  amount: number;
  type: TransactionType;
  description: string;
  date: string;
  createdBy: string;
  createdAt: string;
}

export enum TransactionType {
  Disbursement = 'Disbursement',
  Repayment = 'Repayment',
  Fee = 'Fee',
  Penalty = 'Penalty'
}

// SMS types
export interface SmsTemplate {
  id: string;
  name: string;
  content: string;
  createdAt: string;
  updatedAt: string;
}

export interface SmsHistory {
  id: string;
  recipientNumber: string;
  recipientName?: string;
  message: string;
  status: SmsStatus;
  sentAt: string;
}

export enum SmsStatus {
  Sent = 'Sent',
  Failed = 'Failed',
  Pending = 'Pending'
}

// Report types
export interface ReportParams {
  startDate: string;
  endDate: string;
  [key: string]: any;
}