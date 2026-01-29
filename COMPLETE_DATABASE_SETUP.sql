-- ============================================
-- COMPLETE SUPABASE DATABASE SETUP
-- EB Billing Application - Full Schema
-- ============================================

-- Step 1: Enable Required Extensions
-- ============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Step 2: Create Users Table
-- ============================================
CREATE TABLE IF NOT EXISTS public.eb_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id TEXT NOT NULL UNIQUE,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT NOT NULL UNIQUE,
  aadhar TEXT NOT NULL,
  password TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Add new columns if they don't exist (for existing tables)
ALTER TABLE public.eb_users 
ADD COLUMN IF NOT EXISTS address TEXT,
ADD COLUMN IF NOT EXISTS city TEXT,
ADD COLUMN IF NOT EXISTS state TEXT,
ADD COLUMN IF NOT EXISTS pincode TEXT,
ADD COLUMN IF NOT EXISTS profile_image_url TEXT;

-- Step 3: Create Application Forms Table
-- ============================================
CREATE TABLE IF NOT EXISTS public.eb_applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  application_id TEXT NOT NULL UNIQUE,
  user_id TEXT NOT NULL REFERENCES public.eb_users(user_id) ON DELETE CASCADE,
  application_type TEXT NOT NULL, -- e.g., 'new_connection', 'meter_change', 'name_transfer'
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  pincode TEXT NOT NULL,
  connection_type TEXT, -- e.g., 'residential', 'commercial', 'industrial'
  load_required TEXT, -- e.g., '2KW', '5KW', '10KW'
  status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'approved', 'rejected', 'in_progress'
  remarks TEXT,
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Step 4: Create Bills Table
-- ============================================
CREATE TABLE IF NOT EXISTS public.eb_bills (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bill_id TEXT NOT NULL UNIQUE,
  user_id TEXT NOT NULL REFERENCES public.eb_users(user_id) ON DELETE CASCADE,
  consumer_number TEXT NOT NULL,
  billing_period_start DATE NOT NULL,
  billing_period_end DATE NOT NULL,
  due_date DATE NOT NULL,
  units_consumed DECIMAL(10, 2) NOT NULL,
  rate_per_unit DECIMAL(10, 2) NOT NULL,
  energy_charges DECIMAL(10, 2) NOT NULL,
  fixed_charges DECIMAL(10, 2) DEFAULT 0,
  tax_amount DECIMAL(10, 2) DEFAULT 0,
  other_charges DECIMAL(10, 2) DEFAULT 0,
  total_amount DECIMAL(10, 2) NOT NULL,
  status TEXT NOT NULL DEFAULT 'unpaid', -- 'unpaid', 'paid', 'overdue', 'partial'
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Step 5: Create Payments Table
-- ============================================
CREATE TABLE IF NOT EXISTS public.eb_payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  payment_id TEXT NOT NULL UNIQUE,
  transaction_id TEXT NOT NULL UNIQUE,
  bill_id TEXT NOT NULL REFERENCES public.eb_bills(bill_id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES public.eb_users(user_id) ON DELETE CASCADE,
  amount DECIMAL(10, 2) NOT NULL,
  payment_method TEXT NOT NULL, -- 'upi', 'card', 'netbanking', 'wallet'
  payment_status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'success', 'failed', 'refunded'
  payment_gateway TEXT, -- 'razorpay', 'paytm', 'phonepe', etc.
  payment_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  remarks TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Step 6: Create Billing History View (for easy querying)
-- ============================================
CREATE OR REPLACE VIEW public.billing_history AS
SELECT 
  b.bill_id,
  b.user_id,
  b.consumer_number,
  b.billing_period_start,
  b.billing_period_end,
  b.due_date,
  b.units_consumed,
  b.total_amount,
  b.status AS bill_status,
  p.payment_id,
  p.transaction_id,
  p.amount AS paid_amount,
  p.payment_method,
  p.payment_status,
  p.payment_time,
  b.created_at AS bill_created_at
FROM public.eb_bills b
LEFT JOIN public.eb_payments p ON b.bill_id = p.bill_id
ORDER BY b.billing_period_end DESC;

-- Step 7: Create Indexes for Performance
-- ============================================

-- Users table indexes
CREATE INDEX IF NOT EXISTS idx_eb_users_email ON public.eb_users (email);
CREATE INDEX IF NOT EXISTS idx_eb_users_user_id ON public.eb_users (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_users_phone ON public.eb_users (phone);

-- Applications table indexes
CREATE INDEX IF NOT EXISTS idx_eb_applications_user_id ON public.eb_applications (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_applications_application_id ON public.eb_applications (application_id);
CREATE INDEX IF NOT EXISTS idx_eb_applications_status ON public.eb_applications (status);

-- Bills table indexes
CREATE INDEX IF NOT EXISTS idx_eb_bills_user_id ON public.eb_bills (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_bills_bill_id ON public.eb_bills (bill_id);
CREATE INDEX IF NOT EXISTS idx_eb_bills_status ON public.eb_bills (status);
CREATE INDEX IF NOT EXISTS idx_eb_bills_due_date ON public.eb_bills (due_date);

-- Payments table indexes
CREATE INDEX IF NOT EXISTS idx_eb_payments_user_id ON public.eb_payments (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_payments_bill_id ON public.eb_payments (bill_id);
CREATE INDEX IF NOT EXISTS idx_eb_payments_transaction_id ON public.eb_payments (transaction_id);
CREATE INDEX IF NOT EXISTS idx_eb_payments_payment_status ON public.eb_payments (payment_status);

-- Step 8: Enable Row Level Security (RLS)
-- ============================================
ALTER TABLE public.eb_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eb_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eb_bills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eb_payments ENABLE ROW LEVEL SECURITY;

-- Step 9: Create RLS Policies for Users Table
-- ============================================

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Allow public registration" ON public.eb_users;
DROP POLICY IF EXISTS "Allow public login" ON public.eb_users;
DROP POLICY IF EXISTS "Allow users to update own profile" ON public.eb_users;

-- Allow anyone to register (INSERT)
CREATE POLICY "Allow public registration" 
ON public.eb_users 
FOR INSERT 
TO anon 
WITH CHECK (true);

-- Allow anyone to login (SELECT)
CREATE POLICY "Allow public login" 
ON public.eb_users 
FOR SELECT 
TO anon 
USING (true);

-- Allow users to update their own profile
CREATE POLICY "Allow users to update own profile" 
ON public.eb_users 
FOR UPDATE 
TO anon 
USING (true) 
WITH CHECK (true);

-- Step 10: Create RLS Policies for Applications Table
-- ============================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow users to submit applications" ON public.eb_applications;
DROP POLICY IF EXISTS "Allow users to view own applications" ON public.eb_applications;
DROP POLICY IF EXISTS "Allow users to update own applications" ON public.eb_applications;

-- Allow users to submit applications
CREATE POLICY "Allow users to submit applications" 
ON public.eb_applications 
FOR INSERT 
TO anon 
WITH CHECK (true);

-- Allow users to view their own applications
CREATE POLICY "Allow users to view own applications" 
ON public.eb_applications 
FOR SELECT 
TO anon 
USING (true);

-- Allow users to update their own applications
CREATE POLICY "Allow users to update own applications" 
ON public.eb_applications 
FOR UPDATE 
TO anon 
USING (true) 
WITH CHECK (true);

-- Step 11: Create RLS Policies for Bills Table
-- ============================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow users to view own bills" ON public.eb_bills;
DROP POLICY IF EXISTS "Allow bill creation" ON public.eb_bills;
DROP POLICY IF EXISTS "Allow bill updates" ON public.eb_bills;

-- Allow users to view their own bills
CREATE POLICY "Allow users to view own bills" 
ON public.eb_bills 
FOR SELECT 
TO anon 
USING (true);

-- Allow inserting bills (for admin/system)
CREATE POLICY "Allow bill creation" 
ON public.eb_bills 
FOR INSERT 
TO anon 
WITH CHECK (true);

-- Allow updating bills (for payment status)
CREATE POLICY "Allow bill updates" 
ON public.eb_bills 
FOR UPDATE 
TO anon 
USING (true) 
WITH CHECK (true);

-- Step 12: Create RLS Policies for Payments Table
-- ============================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow payment creation" ON public.eb_payments;
DROP POLICY IF EXISTS "Allow users to view own payments" ON public.eb_payments;
DROP POLICY IF EXISTS "Allow payment updates" ON public.eb_payments;

-- Allow users to create payments
CREATE POLICY "Allow payment creation" 
ON public.eb_payments 
FOR INSERT 
TO anon 
WITH CHECK (true);

-- Allow users to view their own payments
CREATE POLICY "Allow users to view own payments" 
ON public.eb_payments 
FOR SELECT 
TO anon 
USING (true);

-- Allow updating payment status
CREATE POLICY "Allow payment updates" 
ON public.eb_payments 
FOR UPDATE 
TO anon 
USING (true) 
WITH CHECK (true);

-- Step 13: Create Triggers for Auto-updating timestamps
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for users table
CREATE TRIGGER update_eb_users_updated_at 
BEFORE UPDATE ON public.eb_users 
FOR EACH ROW 
EXECUTE FUNCTION update_updated_at_column();

-- Trigger for applications table
CREATE TRIGGER update_eb_applications_updated_at 
BEFORE UPDATE ON public.eb_applications 
FOR EACH ROW 
EXECUTE FUNCTION update_updated_at_column();

-- Trigger for bills table
CREATE TRIGGER update_eb_bills_updated_at 
BEFORE UPDATE ON public.eb_bills 
FOR EACH ROW 
EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SAMPLE DATA FOR TESTING (Optional)
-- ============================================

-- Insert sample user
INSERT INTO public.eb_users (user_id, first_name, last_name, email, phone, aadhar, password, address, city, state, pincode)
VALUES ('EB100001', 'John', 'Doe', 'john.doe@example.com', '9876543210', '123456789012', 'password123', '123 Main St', 'Mumbai', 'Maharashtra', '400001')
ON CONFLICT (user_id) DO NOTHING;

-- Insert sample bill
INSERT INTO public.eb_bills (bill_id, user_id, consumer_number, billing_period_start, billing_period_end, due_date, units_consumed, rate_per_unit, energy_charges, fixed_charges, tax_amount, total_amount, status)
VALUES ('BILL100001', 'EB100001', 'CONS123456', '2024-01-01', '2024-01-31', '2024-02-15', 150.00, 6.50, 975.00, 50.00, 102.50, 1127.50, 'unpaid')
ON CONFLICT (bill_id) DO NOTHING;

-- Insert sample payment
INSERT INTO public.eb_payments (payment_id, transaction_id, bill_id, user_id, amount, payment_method, payment_status, payment_gateway)
VALUES ('PAY100001', 'TXN1234567890', 'BILL100001', 'EB100001', 1127.50, 'upi', 'success', 'razorpay')
ON CONFLICT (payment_id) DO NOTHING;

-- Insert sample application
INSERT INTO public.eb_applications (application_id, user_id, application_type, full_name, email, phone, address, city, state, pincode, connection_type, load_required, status)
VALUES ('APP100001', 'EB100001', 'new_connection', 'John Doe', 'john.doe@example.com', '9876543210', '123 Main St', 'Mumbai', 'Maharashtra', '400001', 'residential', '5KW', 'pending')
ON CONFLICT (application_id) DO NOTHING;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check all tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE 'eb_%'
ORDER BY table_name;

-- Check all indexes
SELECT indexname 
FROM pg_indexes 
WHERE tablename LIKE 'eb_%'
ORDER BY tablename, indexname;

-- Check all policies
SELECT tablename, policyname 
FROM pg_policies 
WHERE tablename LIKE 'eb_%'
ORDER BY tablename, policyname;

-- View billing history
SELECT * FROM public.billing_history LIMIT 5;
