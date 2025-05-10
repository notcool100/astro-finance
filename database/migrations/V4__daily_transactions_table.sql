-- Migration V4: Add daily_transactions table

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
