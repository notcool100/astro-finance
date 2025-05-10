-- AstroFinance PostgreSQL Database Schema
-- Designed for microfinance application

-- Enable UUID extension for GUID support
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types for enums
CREATE TYPE loan_status AS ENUM ('Pending', 'Active', 'Completed', 'Defaulted');
CREATE TYPE loan_type AS ENUM ('Flat', 'Diminishing');
CREATE TYPE transaction_type AS ENUM ('Disbursement', 'Repayment', 'Fee', 'Penalty');
CREATE TYPE sms_status AS ENUM ('Pending', 'Sent', 'Failed');

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_login_date TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    last_modified_at TIMESTAMP,
    last_modified_by UUID
);

-- Create index on email for faster login
CREATE INDEX idx_users_email ON users(email);

-- Customers table
CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(20) NOT NULL,
    address TEXT,
    identification_number VARCHAR(50) NOT NULL,
    identification_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP,
    last_modified_by UUID REFERENCES users(id)
);

-- Create indexes for customer search
CREATE INDEX idx_customers_name ON customers(first_name, last_name);
CREATE INDEX idx_customers_phone ON customers(phone_number);
CREATE INDEX idx_customers_id_number ON customers(identification_number);

-- Loans table
CREATE TABLE loans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    amount DECIMAL(15, 2) NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    term INTEGER NOT NULL, -- In months
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status loan_status NOT NULL DEFAULT 'Pending',
    type loan_type NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP,
    last_modified_by UUID REFERENCES users(id)
);

-- Create indexes for loan queries
CREATE INDEX idx_loans_customer ON loans(customer_id);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_loans_dates ON loans(start_date, end_date);

-- Transactions table
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    loan_id UUID REFERENCES loans(id),
    customer_id UUID NOT NULL REFERENCES customers(id),
    amount DECIMAL(15, 2) NOT NULL,
    type transaction_type NOT NULL,
    description TEXT,
    date TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP,
    last_modified_by UUID REFERENCES users(id)
);

-- Create indexes for transaction queries
CREATE INDEX idx_transactions_loan ON transactions(loan_id);
CREATE INDEX idx_transactions_customer ON transactions(customer_id);
CREATE INDEX idx_transactions_date ON transactions(date);
CREATE INDEX idx_transactions_type ON transactions(type);

-- SMS Templates table
CREATE TABLE sms_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP,
    last_modified_by UUID REFERENCES users(id)
);

-- SMS History table
CREATE TABLE sms_histories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    recipient_number VARCHAR(20) NOT NULL,
    recipient_name VARCHAR(200),
    message TEXT NOT NULL,
    status sms_status NOT NULL DEFAULT 'Pending',
    sent_at TIMESTAMP NOT NULL,
    error_message TEXT,
    sms_template_id UUID REFERENCES sms_templates(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP,
    last_modified_by UUID REFERENCES users(id)
);

-- Create indexes for SMS queries
CREATE INDEX idx_sms_histories_recipient ON sms_histories(recipient_number);
CREATE INDEX idx_sms_histories_status ON sms_histories(status);
CREATE INDEX idx_sms_histories_sent_at ON sms_histories(sent_at);

-- Payment Schedule table (for loan repayment schedules)
CREATE TABLE payment_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    loan_id UUID NOT NULL REFERENCES loans(id),
    due_date DATE NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    principal_amount DECIMAL(15, 2) NOT NULL,
    interest_amount DECIMAL(15, 2) NOT NULL,
    is_paid BOOLEAN NOT NULL DEFAULT FALSE,
    payment_date TIMESTAMP,
    transaction_id UUID REFERENCES transactions(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP,
    last_modified_by UUID REFERENCES users(id)
);

-- Create indexes for payment schedule queries
CREATE INDEX idx_payment_schedules_loan ON payment_schedules(loan_id);
CREATE INDEX idx_payment_schedules_due_date ON payment_schedules(due_date);
CREATE INDEX idx_payment_schedules_is_paid ON payment_schedules(is_paid);

-- Journal Entries table (for accounting)
CREATE TABLE journal_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID REFERENCES transactions(id),
    entry_date DATE NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP,
    last_modified_by UUID REFERENCES users(id)
);

-- Create index for journal entries
CREATE INDEX idx_journal_entries_date ON journal_entries(entry_date);
CREATE INDEX idx_journal_entries_transaction ON journal_entries(transaction_id);

-- Journal Entry Details table (for double-entry accounting)
CREATE TABLE journal_entry_details (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    journal_entry_id UUID NOT NULL REFERENCES journal_entries(id),
    account_name VARCHAR(100) NOT NULL,
    is_debit BOOLEAN NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP,
    last_modified_by UUID REFERENCES users(id)
);

-- Create index for journal entry details
CREATE INDEX idx_journal_entry_details_entry ON journal_entry_details(journal_entry_id);

-- Chart of Accounts table
CREATE TABLE chart_of_accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_code VARCHAR(20) NOT NULL UNIQUE,
    account_name VARCHAR(100) NOT NULL UNIQUE,
    account_type VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP,
    last_modified_by UUID REFERENCES users(id)
);

-- Create index for chart of accounts
CREATE INDEX idx_chart_of_accounts_type ON chart_of_accounts(account_type);

-- Audit Log table (for tracking all changes)
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_name VARCHAR(100) NOT NULL,
    record_id UUID NOT NULL,
    action VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    old_values JSONB,
    new_values JSONB,
    changed_by UUID REFERENCES users(id),
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for audit logs
CREATE INDEX idx_audit_logs_table ON audit_logs(table_name);
CREATE INDEX idx_audit_logs_record ON audit_logs(record_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_changed_at ON audit_logs(changed_at);

-- Create a function to automatically update last_modified_at
CREATE OR REPLACE FUNCTION update_last_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers to automatically update last_modified_at
CREATE TRIGGER update_users_last_modified
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_customers_last_modified
BEFORE UPDATE ON customers
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_loans_last_modified
BEFORE UPDATE ON loans
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_transactions_last_modified
BEFORE UPDATE ON transactions
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_sms_templates_last_modified
BEFORE UPDATE ON sms_templates
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_sms_histories_last_modified
BEFORE UPDATE ON sms_histories
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_payment_schedules_last_modified
BEFORE UPDATE ON payment_schedules
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_journal_entries_last_modified
BEFORE UPDATE ON journal_entries
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_journal_entry_details_last_modified
BEFORE UPDATE ON journal_entry_details
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

CREATE TRIGGER update_chart_of_accounts_last_modified
BEFORE UPDATE ON chart_of_accounts
FOR EACH ROW EXECUTE FUNCTION update_last_modified_column();

-- Create audit trigger function
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
DECLARE
    old_row JSONB := NULL;
    new_row JSONB := NULL;
BEGIN
    IF TG_OP IN ('UPDATE', 'DELETE') THEN
        old_row := to_jsonb(OLD);
    END IF;

    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        new_row := to_jsonb(NEW);
    END IF;

    INSERT INTO audit_logs (
        table_name,
        record_id,
        action,
        old_values,
        new_values,
        changed_by,
        changed_at
    ) VALUES (
        TG_TABLE_NAME,
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.id
            ELSE NEW.id
        END,
        TG_OP,
        old_row,
        new_row,
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.last_modified_by
            ELSE NEW.last_modified_by
        END,
        CURRENT_TIMESTAMP
    );

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create audit triggers for all tables
CREATE TRIGGER audit_users_trigger
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_customers_trigger
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_loans_trigger
AFTER INSERT OR UPDATE OR DELETE ON loans
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_transactions_trigger
AFTER INSERT OR UPDATE OR DELETE ON transactions
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_sms_templates_trigger
AFTER INSERT OR UPDATE OR DELETE ON sms_templates
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_sms_histories_trigger
AFTER INSERT OR UPDATE OR DELETE ON sms_histories
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_payment_schedules_trigger
AFTER INSERT OR UPDATE OR DELETE ON payment_schedules
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_journal_entries_trigger
AFTER INSERT OR UPDATE OR DELETE ON journal_entries
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_journal_entry_details_trigger
AFTER INSERT OR UPDATE OR DELETE ON journal_entry_details
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_chart_of_accounts_trigger
AFTER INSERT OR UPDATE OR DELETE ON chart_of_accounts
FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- Create views for reporting
CREATE VIEW vw_loan_summary AS
SELECT 
    l.id AS loan_id,
    c.id AS customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    l.amount AS loan_amount,
    l.interest_rate,
    l.term,
    l.start_date,
    l.end_date,
    l.status,
    l.type,
    COALESCE(SUM(CASE WHEN t.type = 'Repayment' THEN t.amount ELSE 0 END), 0) AS total_repaid,
    l.amount - COALESCE(SUM(CASE WHEN t.type = 'Repayment' THEN t.amount ELSE 0 END), 0) AS outstanding_balance
FROM 
    loans l
JOIN 
    customers c ON l.customer_id = c.id
LEFT JOIN 
    transactions t ON l.id = t.loan_id
GROUP BY 
    l.id, c.id, c.first_name, c.last_name;

CREATE VIEW vw_overdue_loans AS
SELECT 
    l.id AS loan_id,
    c.id AS customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.phone_number,
    ps.due_date,
    ps.amount AS installment_amount,
    CURRENT_DATE - ps.due_date AS days_overdue
FROM 
    payment_schedules ps
JOIN 
    loans l ON ps.loan_id = l.id
JOIN 
    customers c ON l.customer_id = c.id
WHERE 
    ps.is_paid = FALSE 
    AND ps.due_date < CURRENT_DATE
    AND l.status = 'Active'
ORDER BY 
    ps.due_date;

CREATE VIEW vw_daily_transactions AS
SELECT 
    DATE(t.date) AS transaction_date,
    t.type,
    COUNT(*) AS transaction_count,
    SUM(t.amount) AS total_amount
FROM 
    transactions t
GROUP BY 
    DATE(t.date), t.type
ORDER BY 
    DATE(t.date) DESC, t.type;

-- Create materialized view for monthly financial reports
CREATE MATERIALIZED VIEW mvw_monthly_financial_summary AS
SELECT 
    DATE_TRUNC('month', t.date) AS month,
    SUM(CASE WHEN t.type = 'Disbursement' THEN t.amount ELSE 0 END) AS total_disbursements,
    SUM(CASE WHEN t.type = 'Repayment' THEN t.amount ELSE 0 END) AS total_repayments,
    SUM(CASE WHEN t.type = 'Fee' THEN t.amount ELSE 0 END) AS total_fees,
    SUM(CASE WHEN t.type = 'Penalty' THEN t.amount ELSE 0 END) AS total_penalties,
    COUNT(DISTINCT CASE WHEN t.type = 'Disbursement' THEN t.loan_id END) AS new_loans_count,
    COUNT(DISTINCT CASE WHEN l.status = 'Completed' AND l.last_modified_at >= DATE_TRUNC('month', t.date) 
                        AND l.last_modified_at < DATE_TRUNC('month', t.date) + INTERVAL '1 month' 
                        THEN l.id END) AS completed_loans_count
FROM 
    transactions t
LEFT JOIN 
    loans l ON t.loan_id = l.id
WHERE 
    t.date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '12 months')
GROUP BY 
    DATE_TRUNC('month', t.date)
ORDER BY 
    DATE_TRUNC('month', t.date) DESC;

-- Create index on the materialized view
CREATE UNIQUE INDEX idx_mvw_monthly_financial_summary ON mvw_monthly_financial_summary(month);

-- Create a function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_monthly_financial_summary()
RETURNS VOID AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mvw_monthly_financial_summary;
END;
$$ LANGUAGE plpgsql;

-- Create a function to generate payment schedule for a loan
CREATE OR REPLACE FUNCTION generate_payment_schedule(
    p_loan_id UUID,
    p_created_by UUID
)
RETURNS VOID AS $$
DECLARE
    v_loan RECORD;
    v_monthly_rate DECIMAL;
    v_emi DECIMAL;
    v_remaining_principal DECIMAL;
    v_interest_payment DECIMAL;
    v_principal_payment DECIMAL;
    v_payment_date DATE;
    v_month INTEGER;
BEGIN
    -- Get loan details
    SELECT * INTO v_loan FROM loans WHERE id = p_loan_id;
    
    IF v_loan.type = 'Flat' THEN
        -- For flat rate loans
        v_monthly_rate := v_loan.interest_rate / 100 / 12;
        v_emi := v_loan.amount / v_loan.term + (v_loan.amount * v_monthly_rate);
        
        FOR v_month IN 1..v_loan.term LOOP
            v_payment_date := v_loan.start_date + (v_month * INTERVAL '1 month');
            v_principal_payment := v_loan.amount / v_loan.term;
            v_interest_payment := v_loan.amount * v_monthly_rate;
            
            INSERT INTO payment_schedules (
                loan_id,
                due_date,
                amount,
                principal_amount,
                interest_amount,
                is_paid,
                created_by,
                created_at
            ) VALUES (
                p_loan_id,
                v_payment_date,
                v_emi,
                v_principal_payment,
                v_interest_payment,
                FALSE,
                p_created_by,
                CURRENT_TIMESTAMP
            );
        END LOOP;
    ELSE
        -- For diminishing rate loans
        v_monthly_rate := v_loan.interest_rate / 100 / 12;
        v_emi := v_loan.amount * v_monthly_rate * POWER(1 + v_monthly_rate, v_loan.term) / 
                (POWER(1 + v_monthly_rate, v_loan.term) - 1);
        v_remaining_principal := v_loan.amount;
        
        FOR v_month IN 1..v_loan.term LOOP
            v_payment_date := v_loan.start_date + (v_month * INTERVAL '1 month');
            v_interest_payment := v_remaining_principal * v_monthly_rate;
            v_principal_payment := v_emi - v_interest_payment;
            v_remaining_principal := v_remaining_principal - v_principal_payment;
            
            INSERT INTO payment_schedules (
                loan_id,
                due_date,
                amount,
                principal_amount,
                interest_amount,
                is_paid,
                created_by,
                created_at
            ) VALUES (
                p_loan_id,
                v_payment_date,
                v_emi,
                v_principal_payment,
                v_interest_payment,
                FALSE,
                p_created_by,
                CURRENT_TIMESTAMP
            );
        END LOOP;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Create a function to record a loan repayment
CREATE OR REPLACE FUNCTION record_loan_payment(
    p_loan_id UUID,
    p_amount DECIMAL,
    p_payment_date TIMESTAMP,
    p_created_by UUID
)
RETURNS UUID AS $$
DECLARE
    v_customer_id UUID;
    v_transaction_id UUID;
    v_remaining_amount DECIMAL;
    v_payment_schedule RECORD;
BEGIN
    -- Get customer ID from loan
    SELECT customer_id INTO v_customer_id FROM loans WHERE id = p_loan_id;
    
    -- Create transaction record
    INSERT INTO transactions (
        loan_id,
        customer_id,
        amount,
        type,
        description,
        date,
        created_by,
        created_at
    ) VALUES (
        p_loan_id,
        v_customer_id,
        p_amount,
        'Repayment',
        'Loan repayment',
        p_payment_date,
        p_created_by,
        CURRENT_TIMESTAMP
    ) RETURNING id INTO v_transaction_id;
    
    -- Apply payment to unpaid schedules
    v_remaining_amount := p_amount;
    
    FOR v_payment_schedule IN 
        SELECT * FROM payment_schedules 
        WHERE loan_id = p_loan_id AND is_paid = FALSE 
        ORDER BY due_date
    LOOP
        IF v_remaining_amount >= v_payment_schedule.amount THEN
            -- Full payment
            UPDATE payment_schedules 
            SET is_paid = TRUE, 
                payment_date = p_payment_date, 
                transaction_id = v_transaction_id,
                last_modified_by = p_created_by,
                last_modified_at = CURRENT_TIMESTAMP
            WHERE id = v_payment_schedule.id;
            
            v_remaining_amount := v_remaining_amount - v_payment_schedule.amount;
        ELSIF v_remaining_amount > 0 THEN
            -- Partial payment (not implemented in this simplified version)
            -- In a real system, you would track partial payments
            EXIT;
        ELSE
            EXIT;
        END IF;
    END LOOP;
    
    -- Check if loan is fully paid
    IF NOT EXISTS (SELECT 1 FROM payment_schedules WHERE loan_id = p_loan_id AND is_paid = FALSE) THEN
        UPDATE loans 
        SET status = 'Completed', 
            last_modified_by = p_created_by,
            last_modified_at = CURRENT_TIMESTAMP
        WHERE id = p_loan_id;
    END IF;
    
    RETURN v_transaction_id;
END;
$$ LANGUAGE plpgsql;

-- Create a function to create journal entries for transactions
CREATE OR REPLACE FUNCTION create_journal_entry(
    p_transaction_id UUID,
    p_created_by UUID
)
RETURNS UUID AS $$
DECLARE
    v_transaction RECORD;
    v_journal_entry_id UUID;
BEGIN
    -- Get transaction details
    SELECT * INTO v_transaction FROM transactions WHERE id = p_transaction_id;
    
    -- Create journal entry
    INSERT INTO journal_entries (
        transaction_id,
        entry_date,
        description,
        created_by,
        created_at
    ) VALUES (
        p_transaction_id,
        v_transaction.date,
        CASE 
            WHEN v_transaction.type = 'Disbursement' THEN 'Loan disbursement'
            WHEN v_transaction.type = 'Repayment' THEN 'Loan repayment'
            WHEN v_transaction.type = 'Fee' THEN 'Fee collection'
            WHEN v_transaction.type = 'Penalty' THEN 'Penalty collection'
        END,
        p_created_by,
        CURRENT_TIMESTAMP
    ) RETURNING id INTO v_journal_entry_id;
    
    -- Create journal entry details based on transaction type
    IF v_transaction.type = 'Disbursement' THEN
        -- Debit: Loans Receivable
        INSERT INTO journal_entry_details (
            journal_entry_id, account_name, is_debit, amount, created_by, created_at
        ) VALUES (
            v_journal_entry_id, 'Loans Receivable', TRUE, v_transaction.amount, p_created_by, CURRENT_TIMESTAMP
        );
        
        -- Credit: Cash
        INSERT INTO journal_entry_details (
            journal_entry_id, account_name, is_debit, amount, created_by, created_at
        ) VALUES (
            v_journal_entry_id, 'Cash', FALSE, v_transaction.amount, p_created_by, CURRENT_TIMESTAMP
        );
    ELSIF v_transaction.type = 'Repayment' THEN
        -- Get loan details to calculate interest portion
        DECLARE
            v_loan RECORD;
            v_interest_portion DECIMAL;
            v_principal_portion DECIMAL;
        BEGIN
            SELECT * INTO v_loan FROM loans WHERE id = v_transaction.loan_id;
            
            -- Simplified calculation - in a real system, you would use the payment schedule
            v_interest_portion := v_transaction.amount * 0.3; -- Assuming 30% of payment is interest
            v_principal_portion := v_transaction.amount - v_interest_portion;
            
            -- Debit: Cash
            INSERT INTO journal_entry_details (
                journal_entry_id, account_name, is_debit, amount, created_by, created_at
            ) VALUES (
                v_journal_entry_id, 'Cash', TRUE, v_transaction.amount, p_created_by, CURRENT_TIMESTAMP
            );
            
            -- Credit: Loans Receivable
            INSERT INTO journal_entry_details (
                journal_entry_id, account_name, is_debit, amount, created_by, created_at
            ) VALUES (
                v_journal_entry_id, 'Loans Receivable', FALSE, v_principal_portion, p_created_by, CURRENT_TIMESTAMP
            );
            
            -- Credit: Interest Income
            INSERT INTO journal_entry_details (
                journal_entry_id, account_name, is_debit, amount, created_by, created_at
            ) VALUES (
                v_journal_entry_id, 'Interest Income', FALSE, v_interest_portion, p_created_by, CURRENT_TIMESTAMP
            );
        END;
    ELSIF v_transaction.type = 'Fee' THEN
        -- Debit: Cash
        INSERT INTO journal_entry_details (
            journal_entry_id, account_name, is_debit, amount, created_by, created_at
        ) VALUES (
            v_journal_entry_id, 'Cash', TRUE, v_transaction.amount, p_created_by, CURRENT_TIMESTAMP
        );
        
        -- Credit: Fee Income
        INSERT INTO journal_entry_details (
            journal_entry_id, account_name, is_debit, amount, created_by, created_at
        ) VALUES (
            v_journal_entry_id, 'Fee Income', FALSE, v_transaction.amount, p_created_by, CURRENT_TIMESTAMP
        );
    ELSIF v_transaction.type = 'Penalty' THEN
        -- Debit: Cash
        INSERT INTO journal_entry_details (
            journal_entry_id, account_name, is_debit, amount, created_by, created_at
        ) VALUES (
            v_journal_entry_id, 'Cash', TRUE, v_transaction.amount, p_created_by, CURRENT_TIMESTAMP
        );
        
        -- Credit: Penalty Income
        INSERT INTO journal_entry_details (
            journal_entry_id, account_name, is_debit, amount, created_by, created_at
        ) VALUES (
            v_journal_entry_id, 'Penalty Income', FALSE, v_transaction.amount, p_created_by, CURRENT_TIMESTAMP
        );
    END IF;
    
    RETURN v_journal_entry_id;
END;
$$ LANGUAGE plpgsql;

-- Create a function to send SMS notifications for overdue loans
CREATE OR REPLACE FUNCTION send_overdue_loan_notifications(
    p_days_overdue INTEGER,
    p_created_by UUID
)
RETURNS INTEGER AS $$
DECLARE
    v_overdue_loan RECORD;
    v_template_id UUID;
    v_message TEXT;
    v_count INTEGER := 0;
BEGIN
    -- Get SMS template for overdue loans
    SELECT id INTO v_template_id FROM sms_templates WHERE name = 'Overdue Loan Reminder' LIMIT 1;
    
    -- If template doesn't exist, create one
    IF v_template_id IS NULL THEN
        INSERT INTO sms_templates (
            name,
            content,
            created_by,
            created_at
        ) VALUES (
            'Overdue Loan Reminder',
            'Dear {CustomerName}, your loan payment of {Amount} was due on {DueDate}. Please make payment as soon as possible to avoid additional penalties.',
            p_created_by,
            CURRENT_TIMESTAMP
        ) RETURNING id INTO v_template_id;
    END IF;
    
    -- Get template content
    SELECT content INTO v_message FROM sms_templates WHERE id = v_template_id;
    
    -- Process overdue loans
    FOR v_overdue_loan IN 
        SELECT 
            c.id AS customer_id,
            c.first_name || ' ' || c.last_name AS customer_name,
            c.phone_number,
            ps.due_date,
            ps.amount,
            CURRENT_DATE - ps.due_date AS days_overdue
        FROM 
            payment_schedules ps
        JOIN 
            loans l ON ps.loan_id = l.id
        JOIN 
            customers c ON l.customer_id = c.id
        WHERE 
            ps.is_paid = FALSE 
            AND ps.due_date < CURRENT_DATE
            AND CURRENT_DATE - ps.due_date = p_days_overdue
            AND l.status = 'Active'
    LOOP
        -- Replace placeholders in message
        v_message := REPLACE(v_message, '{CustomerName}', v_overdue_loan.customer_name);
        v_message := REPLACE(v_message, '{Amount}', v_overdue_loan.amount::TEXT);
        v_message := REPLACE(v_message, '{DueDate}', v_overdue_loan.due_date::TEXT);
        
        -- Create SMS history record
        INSERT INTO sms_histories (
            recipient_number,
            recipient_name,
            message,
            status,
            sent_at,
            sms_template_id,
            created_by,
            created_at
        ) VALUES (
            v_overdue_loan.phone_number,
            v_overdue_loan.customer_name,
            v_message,
            'Pending',
            CURRENT_TIMESTAMP,
            v_template_id,
            p_created_by,
            CURRENT_TIMESTAMP
        );
        
        v_count := v_count + 1;
    END LOOP;
    
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

-- Insert initial chart of accounts
INSERT INTO chart_of_accounts (account_code, account_name, account_type, created_at)
VALUES
    ('1000', 'Cash', 'Asset', CURRENT_TIMESTAMP),
    ('1100', 'Loans Receivable', 'Asset', CURRENT_TIMESTAMP),
    ('1200', 'Interest Receivable', 'Asset', CURRENT_TIMESTAMP),
    ('2000', 'Accounts Payable', 'Liability', CURRENT_TIMESTAMP),
    ('3000', 'Capital', 'Equity', CURRENT_TIMESTAMP),
    ('4000', 'Interest Income', 'Income', CURRENT_TIMESTAMP),
    ('4100', 'Fee Income', 'Income', CURRENT_TIMESTAMP),
    ('4200', 'Penalty Income', 'Income', CURRENT_TIMESTAMP),
    ('5000', 'Salaries Expense', 'Expense', CURRENT_TIMESTAMP),
    ('5100', 'Rent Expense', 'Expense', CURRENT_TIMESTAMP),
    ('5200', 'Utilities Expense', 'Expense', CURRENT_TIMESTAMP),
    ('5300', 'Bad Debt Expense', 'Expense', CURRENT_TIMESTAMP);

-- Create a function to mark defaulted loans
CREATE OR REPLACE FUNCTION mark_defaulted_loans(
    p_days_threshold INTEGER,
    p_created_by UUID
)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER := 0;
BEGIN
    UPDATE loans
    SET 
        status = 'Defaulted',
        last_modified_by = p_created_by,
        last_modified_at = CURRENT_TIMESTAMP
    WHERE 
        id IN (
            SELECT DISTINCT l.id
            FROM loans l
            JOIN payment_schedules ps ON l.id = ps.loan_id
            WHERE 
                l.status = 'Active'
                AND ps.is_paid = FALSE
                AND CURRENT_DATE - ps.due_date > p_days_threshold
        );
    
    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

-- Create a function to calculate portfolio at risk (PAR)
CREATE OR REPLACE FUNCTION calculate_par(
    p_days_threshold INTEGER
)
RETURNS TABLE (
    par_ratio DECIMAL,
    total_outstanding DECIMAL,
    at_risk_outstanding DECIMAL,
    loan_count INTEGER,
    at_risk_loan_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    WITH loan_summary AS (
        SELECT
            l.id,
            l.amount,
            COALESCE(SUM(CASE WHEN t.type = 'Repayment' THEN t.amount ELSE 0 END), 0) AS total_repaid,
            l.amount - COALESCE(SUM(CASE WHEN t.type = 'Repayment' THEN t.amount ELSE 0 END), 0) AS outstanding,
            CASE
                WHEN EXISTS (
                    SELECT 1 FROM payment_schedules ps
                    WHERE ps.loan_id = l.id
                    AND ps.is_paid = FALSE
                    AND CURRENT_DATE - ps.due_date > p_days_threshold
                ) THEN TRUE
                ELSE FALSE
            END AS is_at_risk
        FROM
            loans l
        LEFT JOIN
            transactions t ON l.id = t.loan_id
        WHERE
            l.status = 'Active'
        GROUP BY
            l.id, l.amount
    )
    SELECT
        CASE
            WHEN SUM(outstanding) = 0 THEN 0
            ELSE SUM(CASE WHEN is_at_risk THEN outstanding ELSE 0 END) / SUM(outstanding)
        END AS par_ratio,
        SUM(outstanding) AS total_outstanding,
        SUM(CASE WHEN is_at_risk THEN outstanding ELSE 0 END) AS at_risk_outstanding,
        COUNT(*) AS loan_count,
        SUM(CASE WHEN is_at_risk THEN 1 ELSE 0 END) AS at_risk_loan_count
    FROM
        loan_summary;
END;
$$ LANGUAGE plpgsql;

-- Create a backup function
CREATE OR REPLACE FUNCTION backup_database(
    p_backup_path TEXT
)
RETURNS TEXT AS $$
DECLARE
    v_timestamp TEXT;
    v_command TEXT;
    v_result TEXT;
BEGIN
    v_timestamp := TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD_HH24MISS');
    v_command := 'pg_dump -Fc -f ' || p_backup_path || '/astrofinance_' || v_timestamp || '.dump';
    
    -- Execute the command (this requires superuser privileges)
    -- In a real system, you would use a scheduled job outside the database
    EXECUTE 'COPY (SELECT ''' || v_command || ''') TO PROGRAM ''' || v_command || '''';
    
    v_result := 'Backup created at ' || p_backup_path || '/astrofinance_' || v_timestamp || '.dump';
    RETURN v_result;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Backup failed: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Create a database maintenance function
CREATE OR REPLACE FUNCTION perform_database_maintenance()
RETURNS TEXT AS $$
DECLARE
    v_result TEXT;
BEGIN
    -- Vacuum analyze all tables
    VACUUM ANALYZE;
    
    -- Refresh materialized views
    REFRESH MATERIALIZED VIEW CONCURRENTLY mvw_monthly_financial_summary;
    
    -- Reindex important indexes
    REINDEX INDEX idx_loans_customer;
    REINDEX INDEX idx_transactions_loan;
    REINDEX INDEX idx_payment_schedules_loan;
    
    v_result := 'Database maintenance completed at ' || CURRENT_TIMESTAMP;
    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Create a function to generate a database documentation
CREATE OR REPLACE FUNCTION generate_database_documentation()
RETURNS TABLE (
    table_name TEXT,
    column_name TEXT,
    data_type TEXT,
    is_nullable TEXT,
    column_description TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.table_name::TEXT,
        c.column_name::TEXT,
        c.data_type::TEXT,
        c.is_nullable::TEXT,
        pg_catalog.col_description(
            format('%I.%I', c.table_schema, c.table_name)::regclass::oid,
            c.ordinal_position
        )::TEXT AS column_description
    FROM
        information_schema.columns c
    WHERE
        c.table_schema = 'public'
    ORDER BY
        c.table_name,
        c.ordinal_position;
END;
$$ LANGUAGE plpgsql;

-- Add comments to tables and columns for documentation
COMMENT ON TABLE users IS 'Stores user information for authentication and authorization';
COMMENT ON TABLE customers IS 'Stores customer information for microfinance clients';
COMMENT ON TABLE loans IS 'Stores loan information including amount, interest rate, and status';
COMMENT ON TABLE transactions IS 'Records all financial transactions related to loans';
COMMENT ON TABLE payment_schedules IS 'Stores the repayment schedule for each loan';
COMMENT ON TABLE sms_templates IS 'Stores templates for SMS notifications';
COMMENT ON TABLE sms_histories IS 'Records history of all SMS notifications sent';
COMMENT ON TABLE journal_entries IS 'Stores accounting journal entries';
COMMENT ON TABLE journal_entry_details IS 'Stores the details of each journal entry for double-entry accounting';
COMMENT ON TABLE chart_of_accounts IS 'Defines the chart of accounts for the accounting system';
COMMENT ON TABLE audit_logs IS 'Records all changes to the database for auditing purposes';

-- Add comments to columns
COMMENT ON COLUMN loans.amount IS 'The principal amount of the loan';
COMMENT ON COLUMN loans.interest_rate IS 'Annual interest rate as a percentage';
COMMENT ON COLUMN loans.term IS 'Loan duration in months';
COMMENT ON COLUMN loans.type IS 'Type of loan: Flat or Diminishing interest calculation method';
COMMENT ON COLUMN transactions.amount IS 'The amount of the transaction';
COMMENT ON COLUMN transactions.type IS 'Type of transaction: Disbursement, Repayment, Fee, or Penalty';
COMMENT ON COLUMN payment_schedules.principal_amount IS 'The principal portion of the installment';
COMMENT ON COLUMN payment_schedules.interest_amount IS 'The interest portion of the installment';

-- Daily Transactions table
CREATE TABLE daily_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    transaction_type VARCHAR(50) NOT NULL, -- e.g., Deposit, Withdraw, Bal Bachant, etc.
    amount DECIMAL(15, 2) NOT NULL,
    transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
    description TEXT,
    created_by UUID REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_modified_by UUID REFERENCES users(id),
    last_modified_at TIMESTAMP
);

-- Create indexes for daily transaction queries
CREATE INDEX idx_daily_transactions_customer ON daily_transactions(customer_id);
CREATE INDEX idx_daily_transactions_type ON daily_transactions(transaction_type);
CREATE INDEX idx_daily_transactions_date ON daily_transactions(transaction_date);

-- Add comments for documentation
COMMENT ON TABLE daily_transactions IS 'Tracks daily transactions of customers, such as deposits, withdrawals, and other types';
COMMENT ON COLUMN daily_transactions.transaction_type IS 'Type of transaction: Deposit, Withdraw, Bal Bachant, etc.';
COMMENT ON COLUMN daily_transactions.amount IS 'The amount of the transaction';
COMMENT ON COLUMN daily_transactions.transaction_date IS 'The date of the transaction';