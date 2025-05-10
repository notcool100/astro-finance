-- AstroFinance Database Seed Data
-- This script populates the database with initial data for development and testing

-- Clear existing data (if any)
TRUNCATE TABLE journal_entry_details CASCADE;
TRUNCATE TABLE journal_entries CASCADE;
TRUNCATE TABLE payment_schedules CASCADE;
TRUNCATE TABLE sms_histories CASCADE;
TRUNCATE TABLE transactions CASCADE;
TRUNCATE TABLE loans CASCADE;
TRUNCATE TABLE customers CASCADE;
TRUNCATE TABLE sms_templates CASCADE;
TRUNCATE TABLE users CASCADE;
-- Note: We're not truncating chart_of_accounts as it was populated in the migration

-- Insert admin user
INSERT INTO users (
    id, 
    email, 
    first_name, 
    last_name, 
    password_hash, 
    role, 
    is_active, 
    created_at
) VALUES (
    '00000000-0000-0000-0000-000000000001', 
    'admin@astrofinance.com', 
    'System', 
    'Administrator', 
    '$2a$12$K8GpYeWkVQvfn0YIH.9qAOUMZI8iFqbkKaWO9e6z.6Tli6n2aw1Wy', -- Password: Admin123!
    'Administrator', 
    TRUE, 
    CURRENT_TIMESTAMP
);

-- Insert loan officer users
INSERT INTO users (
    id, 
    email, 
    first_name, 
    last_name, 
    password_hash, 
    role, 
    is_active, 
    created_at
) VALUES 
(
    '00000000-0000-0000-0000-000000000002', 
    'john.doe@astrofinance.com', 
    'John', 
    'Doe', 
    '$2a$12$K8GpYeWkVQvfn0YIH.9qAOUMZI8iFqbkKaWO9e6z.6Tli6n2aw1Wy', -- Password: Admin123!
    'Loan Officer', 
    TRUE, 
    CURRENT_TIMESTAMP
),
(
    '00000000-0000-0000-0000-000000000003', 
    'jane.smith@astrofinance.com', 
    'Jane', 
    'Smith', 
    '$2a$12$K8GpYeWkVQvfn0YIH.9qAOUMZI8iFqbkKaWO9e6z.6Tli6n2aw1Wy', -- Password: Admin123!
    'Loan Officer', 
    TRUE, 
    CURRENT_TIMESTAMP
);

-- Insert accountant user
INSERT INTO users (
    id, 
    email, 
    first_name, 
    last_name, 
    password_hash, 
    role, 
    is_active, 
    created_at
) VALUES (
    '00000000-0000-0000-0000-000000000004', 
    'accountant@astrofinance.com', 
    'Finance', 
    'Manager', 
    '$2a$12$K8GpYeWkVQvfn0YIH.9qAOUMZI8iFqbkKaWO9e6z.6Tli6n2aw1Wy', -- Password: Admin123!
    'Accountant', 
    TRUE, 
    CURRENT_TIMESTAMP
);

-- Insert SMS templates
INSERT INTO sms_templates (
    id,
    name,
    content,
    created_at,
    created_by
) VALUES
(
    '00000000-0000-0000-0000-000000000010',
    'Loan Approval',
    'Dear {CustomerName}, your loan application for {Amount} has been approved. The funds will be disbursed within 24 hours.',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000001'
),
(
    '00000000-0000-0000-0000-000000000011',
    'Loan Disbursement',
    'Dear {CustomerName}, your loan of {Amount} has been disbursed to your account. Your first payment of {InstallmentAmount} is due on {DueDate}.',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000001'
),
(
    '00000000-0000-0000-0000-000000000012',
    'Payment Reminder',
    'Dear {CustomerName}, this is a reminder that your loan payment of {Amount} is due on {DueDate}. Please ensure funds are available.',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000001'
),
(
    '00000000-0000-0000-0000-000000000013',
    'Overdue Loan Reminder',
    'Dear {CustomerName}, your loan payment of {Amount} was due on {DueDate}. Please make payment as soon as possible to avoid additional penalties.',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000001'
),
(
    '00000000-0000-0000-0000-000000000014',
    'Payment Confirmation',
    'Dear {CustomerName}, we have received your payment of {Amount}. Thank you for your prompt payment.',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000001'
),
(
    '00000000-0000-0000-0000-000000000015',
    'Loan Completion',
    'Dear {CustomerName}, congratulations on completing your loan repayment. We look forward to serving you again.',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000001'
);

-- Insert customers
INSERT INTO customers (
    id,
    first_name,
    last_name,
    email,
    phone_number,
    address,
    identification_number,
    identification_type,
    created_at,
    created_by
) VALUES
(
    '00000000-0000-0000-0000-000000000020',
    'Michael',
    'Johnson',
    'michael.johnson@example.com',
    '+1234567890',
    '123 Main St, Anytown, AT 12345',
    'ID123456789',
    'National ID',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
),
(
    '00000000-0000-0000-0000-000000000021',
    'Sarah',
    'Williams',
    'sarah.williams@example.com',
    '+1234567891',
    '456 Oak Ave, Anytown, AT 12345',
    'ID987654321',
    'National ID',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
),
(
    '00000000-0000-0000-0000-000000000022',
    'Robert',
    'Brown',
    'robert.brown@example.com',
    '+1234567892',
    '789 Pine Rd, Anytown, AT 12345',
    'PP12345678',
    'Passport',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000003'
),
(
    '00000000-0000-0000-0000-000000000023',
    'Emily',
    'Davis',
    'emily.davis@example.com',
    '+1234567893',
    '321 Cedar Ln, Anytown, AT 12345',
    'PP87654321',
    'Passport',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000003'
),
(
    '00000000-0000-0000-0000-000000000024',
    'David',
    'Miller',
    'david.miller@example.com',
    '+1234567894',
    '654 Birch Blvd, Anytown, AT 12345',
    'ID135792468',
    'National ID',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Insert loans
-- Active loan with flat interest
INSERT INTO loans (
    id,
    customer_id,
    amount,
    interest_rate,
    term,
    start_date,
    end_date,
    status,
    type,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000030',
    '00000000-0000-0000-0000-000000000020',
    5000.00,
    12.00,
    12,
    CURRENT_DATE - INTERVAL '2 months',
    CURRENT_DATE + INTERVAL '10 months',
    'Active',
    'Flat',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Active loan with diminishing interest
INSERT INTO loans (
    id,
    customer_id,
    amount,
    interest_rate,
    term,
    start_date,
    end_date,
    status,
    type,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000031',
    '00000000-0000-0000-0000-000000000021',
    10000.00,
    15.00,
    24,
    CURRENT_DATE - INTERVAL '3 months',
    CURRENT_DATE + INTERVAL '21 months',
    'Active',
    'Diminishing',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Pending loan
INSERT INTO loans (
    id,
    customer_id,
    amount,
    interest_rate,
    term,
    start_date,
    end_date,
    status,
    type,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000032',
    '00000000-0000-0000-0000-000000000022',
    7500.00,
    14.00,
    18,
    CURRENT_DATE + INTERVAL '1 week',
    CURRENT_DATE + INTERVAL '19 months',
    'Pending',
    'Diminishing',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000003'
);

-- Completed loan
INSERT INTO loans (
    id,
    customer_id,
    amount,
    interest_rate,
    term,
    start_date,
    end_date,
    status,
    type,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000033',
    '00000000-0000-0000-0000-000000000023',
    3000.00,
    10.00,
    6,
    CURRENT_DATE - INTERVAL '8 months',
    CURRENT_DATE - INTERVAL '2 months',
    'Completed',
    'Flat',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000003'
);

-- Defaulted loan
INSERT INTO loans (
    id,
    customer_id,
    amount,
    interest_rate,
    term,
    start_date,
    end_date,
    status,
    type,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000034',
    '00000000-0000-0000-0000-000000000024',
    8000.00,
    16.00,
    12,
    CURRENT_DATE - INTERVAL '6 months',
    CURRENT_DATE + INTERVAL '6 months',
    'Defaulted',
    'Diminishing',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Generate payment schedules for active loans
SELECT generate_payment_schedule('00000000-0000-0000-0000-000000000030', '00000000-0000-0000-0000-000000000002');
SELECT generate_payment_schedule('00000000-0000-0000-0000-000000000031', '00000000-0000-0000-0000-000000000002');

-- Insert transactions for the active flat loan (2 payments made)
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000040',
    '00000000-0000-0000-0000-000000000030',
    '00000000-0000-0000-0000-000000000020',
    5000.00,
    'Disbursement',
    'Loan disbursement',
    CURRENT_DATE - INTERVAL '2 months',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- First payment
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000041',
    '00000000-0000-0000-0000-000000000030',
    '00000000-0000-0000-0000-000000000020',
    466.67,
    'Repayment',
    'Loan repayment - Month 1',
    CURRENT_DATE - INTERVAL '1 month',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Second payment
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000042',
    '00000000-0000-0000-0000-000000000030',
    '00000000-0000-0000-0000-000000000020',
    466.67,
    'Repayment',
    'Loan repayment - Month 2',
    CURRENT_DATE,
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Update payment schedules for the flat loan
UPDATE payment_schedules
SET is_paid = TRUE, payment_date = CURRENT_DATE - INTERVAL '1 month', transaction_id = '00000000-0000-0000-0000-000000000041'
WHERE loan_id = '00000000-0000-0000-0000-000000000030' AND due_date = (SELECT start_date + INTERVAL '1 month' FROM loans WHERE id = '00000000-0000-0000-0000-000000000030');

UPDATE payment_schedules
SET is_paid = TRUE, payment_date = CURRENT_DATE, transaction_id = '00000000-0000-0000-0000-000000000042'
WHERE loan_id = '00000000-0000-0000-0000-000000000030' AND due_date = (SELECT start_date + INTERVAL '2 month' FROM loans WHERE id = '00000000-0000-0000-0000-000000000030');

-- Insert transactions for the active diminishing loan (3 payments made)
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000043',
    '00000000-0000-0000-0000-000000000031',
    '00000000-0000-0000-0000-000000000021',
    10000.00,
    'Disbursement',
    'Loan disbursement',
    CURRENT_DATE - INTERVAL '3 months',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- First payment
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000044',
    '00000000-0000-0000-0000-000000000031',
    '00000000-0000-0000-0000-000000000021',
    483.65,
    'Repayment',
    'Loan repayment - Month 1',
    CURRENT_DATE - INTERVAL '2 months',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Second payment
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000045',
    '00000000-0000-0000-0000-000000000031',
    '00000000-0000-0000-0000-000000000021',
    483.65,
    'Repayment',
    'Loan repayment - Month 2',
    CURRENT_DATE - INTERVAL '1 month',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Third payment
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000046',
    '00000000-0000-0000-0000-000000000031',
    '00000000-0000-0000-0000-000000000021',
    483.65,
    'Repayment',
    'Loan repayment - Month 3',
    CURRENT_DATE,
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Update payment schedules for the diminishing loan
UPDATE payment_schedules
SET is_paid = TRUE, payment_date = CURRENT_DATE - INTERVAL '2 month', transaction_id = '00000000-0000-0000-0000-000000000044'
WHERE loan_id = '00000000-0000-0000-0000-000000000031' AND due_date = (SELECT start_date + INTERVAL '1 month' FROM loans WHERE id = '00000000-0000-0000-0000-000000000031');

UPDATE payment_schedules
SET is_paid = TRUE, payment_date = CURRENT_DATE - INTERVAL '1 month', transaction_id = '00000000-0000-0000-0000-000000000045'
WHERE loan_id = '00000000-0000-0000-0000-000000000031' AND due_date = (SELECT start_date + INTERVAL '2 month' FROM loans WHERE id = '00000000-0000-0000-0000-000000000031');

UPDATE payment_schedules
SET is_paid = TRUE, payment_date = CURRENT_DATE, transaction_id = '00000000-0000-0000-0000-000000000046'
WHERE loan_id = '00000000-0000-0000-0000-000000000031' AND due_date = (SELECT start_date + INTERVAL '3 month' FROM loans WHERE id = '00000000-0000-0000-0000-000000000031');

-- Insert transactions for the completed loan
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000047',
    '00000000-0000-0000-0000-000000000033',
    '00000000-0000-0000-0000-000000000023',
    3000.00,
    'Disbursement',
    'Loan disbursement',
    CURRENT_DATE - INTERVAL '8 months',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000003'
);

-- Full repayment (lump sum)
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000048',
    '00000000-0000-0000-0000-000000000033',
    '00000000-0000-0000-0000-000000000023',
    3150.00,
    'Repayment',
    'Loan repayment - Full settlement',
    CURRENT_DATE - INTERVAL '2 months',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000003'
);

-- Insert transactions for the defaulted loan
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000049',
    '00000000-0000-0000-0000-000000000034',
    '00000000-0000-0000-0000-000000000024',
    8000.00,
    'Disbursement',
    'Loan disbursement',
    CURRENT_DATE - INTERVAL '6 months',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Only first payment made
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000050',
    '00000000-0000-0000-0000-000000000034',
    '00000000-0000-0000-0000-000000000024',
    773.84,
    'Repayment',
    'Loan repayment - Month 1',
    CURRENT_DATE - INTERVAL '5 months',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Add a penalty
INSERT INTO transactions (
    id,
    loan_id,
    customer_id,
    amount,
    type,
    description,
    date,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000051',
    '00000000-0000-0000-0000-000000000034',
    '00000000-0000-0000-0000-000000000024',
    100.00,
    'Penalty',
    'Late payment penalty',
    CURRENT_DATE - INTERVAL '3 months',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
);

-- Insert daily transactions
INSERT INTO daily_transactions (
    id,
    customer_id,
    transaction_type,
    amount,
    transaction_date,
    description,
    created_by,
    created_at
) VALUES
(
    '00000000-0000-0000-0000-000000000100',
    '00000000-0000-0000-0000-000000000020', -- Michael Johnson
    'Deposit',
    1000.00,
    CURRENT_DATE - INTERVAL '1 day',
    'Customer deposited funds into their account',
    '00000000-0000-0000-0000-000000000002', -- Created by John Doe
    CURRENT_TIMESTAMP
),
(
    '00000000-0000-0000-0000-000000000101',
    '00000000-0000-0000-0000-000000000021', -- Sarah Williams
    'Withdraw',
    500.00,
    CURRENT_DATE - INTERVAL '2 days',
    'Customer withdrew funds from their account',
    '00000000-0000-0000-0000-000000000003', -- Created by Jane Smith
    CURRENT_TIMESTAMP
),
(
    '00000000-0000-0000-0000-000000000102',
    '00000000-0000-0000-0000-000000000022', -- Robert Brown
    'Bal Bachant',
    200.00,
    CURRENT_DATE - INTERVAL '3 days',
    'Customer performed a Bal Bachant transaction',
    '00000000-0000-0000-0000-000000000004', -- Created by Finance Manager
    CURRENT_TIMESTAMP
),
(
    '00000000-0000-0000-0000-000000000103',
    '00000000-0000-0000-0000-000000000023', -- Emily Davis
    'Deposit',
    1500.00,
    CURRENT_DATE - INTERVAL '4 days',
    'Customer deposited funds into their account',
    '00000000-0000-0000-0000-000000000002', -- Created by John Doe
    CURRENT_TIMESTAMP
),
(
    '00000000-0000-0000-0000-000000000104',
    '00000000-0000-0000-0000-000000000024', -- David Miller
    'Withdraw',
    300.00,
    CURRENT_DATE - INTERVAL '5 days',
    'Customer withdrew funds from their account',
    '00000000-0000-0000-0000-000000000003', -- Created by Jane Smith
    CURRENT_TIMESTAMP
);

-- Insert SMS history records
INSERT INTO sms_histories (
    id,
    recipient_number,
    recipient_name,
    message,
    status,
    sent_at,
    sms_template_id,
    created_at,
    created_by
) VALUES (
    '00000000-0000-0000-0000-000000000060',
    '+1234567890',
    'Michael Johnson',
    'Dear Michael Johnson, your loan application for 5000.00 has been approved. The funds will be disbursed within 24 hours.',
    'Sent',
    CURRENT_DATE - INTERVAL '2 months' - INTERVAL '1 day',
    '00000000-0000-0000-0000-000000000010',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
),
(
    '00000000-0000-0000-0000-000000000061',
    '+1234567890',
    'Michael Johnson',
    'Dear Michael Johnson, your loan of 5000.00 has been disbursed to your account. Your first payment of 466.67 is due on ' || to_char(CURRENT_DATE - INTERVAL '1 month', 'YYYY-MM-DD') || '.',
    'Sent',
    CURRENT_DATE - INTERVAL '2 months',
    '00000000-0000-0000-0000-000000000011',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
),
(
    '00000000-0000-0000-0000-000000000062',
    '+1234567890',
    'Michael Johnson',
    'Dear Michael Johnson, this is a reminder that your loan payment of 466.67 is due on ' || to_char(CURRENT_DATE - INTERVAL '1 month', 'YYYY-MM-DD') || '. Please ensure funds are available.',
    'Sent',
    CURRENT_DATE - INTERVAL '1 month' - INTERVAL '3 days',
    '00000000-0000-0000-0000-000000000012',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
),
(
    '00000000-0000-0000-0000-000000000063',
    '+1234567890',
    'Michael Johnson',
    'Dear Michael Johnson, we have received your payment of 466.67. Thank you for your prompt payment.',
    'Sent',
    CURRENT_DATE - INTERVAL '1 month',
    '00000000-0000-0000-0000-000000000014',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
),
(
    '00000000-0000-0000-0000-000000000064',
    '+1234567894',
    'David Miller',
    'Dear David Miller, your loan payment of 773.84 was due on ' || to_char(CURRENT_DATE - INTERVAL '4 months', 'YYYY-MM-DD') || '. Please make payment as soon as possible to avoid additional penalties.',
    'Sent',
    CURRENT_DATE - INTERVAL '4 months' + INTERVAL '5 days',
    '00000000-0000-0000-0000-000000000013',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000002'
),
(
    '00000000-0000-0000-0000-000000000065',
    '+1234567893',
    'Emily Davis',
    'Dear Emily Davis, congratulations on completing your loan repayment. We look forward to serving you again.',
    'Sent',
    CURRENT_DATE - INTERVAL '2 months',
    '00000000-0000-0000-0000-000000000015',
    CURRENT_TIMESTAMP,
    '00000000-0000-0000-0000-000000000003'
);

-- Create journal entries for transactions
SELECT create_journal_entry('00000000-0000-0000-0000-000000000040', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000041', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000042', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000043', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000044', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000045', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000046', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000047', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000048', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000049', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000050', '00000000-0000-0000-0000-000000000004');
SELECT create_journal_entry('00000000-0000-0000-0000-000000000051', '00000000-0000-0000-0000-000000000004');

-- Refresh materialized views
REFRESH MATERIALIZED VIEW mvw_monthly_financial_summary;