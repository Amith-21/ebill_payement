-- =====================================================
-- SUPABASE PAYMENTS TABLE SETUP
-- =====================================================
-- Run this SQL in Supabase Dashboard → SQL Editor
-- This creates the table to store payment transactions
-- =====================================================

-- Create payments table
CREATE TABLE IF NOT EXISTS public.eb_payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  transaction_id TEXT NOT NULL UNIQUE,
  user_id TEXT NOT NULL,
  bill_no TEXT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  payment_method TEXT NOT NULL,
  payment_status TEXT NOT NULL,
  card_last_four TEXT,
  upi_id TEXT,
  bank_name TEXT,
  paytm_mobile TEXT,
  phonepe_mobile TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_eb_payments_user_id ON public.eb_payments (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_payments_transaction_id ON public.eb_payments (transaction_id);
CREATE INDEX IF NOT EXISTS idx_eb_payments_bill_no ON public.eb_payments (bill_no);
CREATE INDEX IF NOT EXISTS idx_eb_payments_created_at ON public.eb_payments (created_at DESC);

-- Enable Row Level Security
ALTER TABLE public.eb_payments ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies
-- Allow users to insert their own payment records
CREATE POLICY "Allow users to insert payments" 
ON public.eb_payments 
FOR INSERT 
TO anon 
WITH CHECK (true);

-- Allow users to view their own payment records
CREATE POLICY "Allow users to view own payments" 
ON public.eb_payments 
FOR SELECT 
TO anon 
USING (true);

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check if table exists
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'eb_payments';

-- Check table structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'eb_payments'
ORDER BY ordinal_position;

-- Check indexes
SELECT indexname 
FROM pg_indexes 
WHERE tablename = 'eb_payments';

-- Check policies
SELECT policyname 
FROM pg_policies 
WHERE tablename = 'eb_payments';

-- =====================================================
-- TEST QUERIES (Optional)
-- =====================================================

-- View all payments
SELECT * FROM public.eb_payments ORDER BY created_at DESC;

-- View payments for a specific user
SELECT * FROM public.eb_payments 
WHERE user_id = 'EB123456' 
ORDER BY created_at DESC;

-- View payments by payment method
SELECT payment_method, COUNT(*), SUM(amount) as total_amount
FROM public.eb_payments
GROUP BY payment_method;

-- =====================================================
-- CLEANUP (Use with caution!)
-- =====================================================

-- Delete all test payments (uncomment to use)
-- DELETE FROM public.eb_payments WHERE user_id = 'EB123456';

-- Drop table (uncomment to use)
-- DROP TABLE IF EXISTS public.eb_payments CASCADE;
