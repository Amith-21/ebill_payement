# Quick Supabase Setup for EB Billing System

## ⚠️ IMPORTANT: Run These SQL Queries First!

If user registration is not working, you need to set up the database tables in Supabase.

---

## Step 1: Create eb_users Table

Go to **Supabase Dashboard** → **SQL Editor** and run this:

```sql
-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create eb_users table
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

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_eb_users_email ON public.eb_users (email);
CREATE INDEX IF NOT EXISTS idx_eb_users_user_id ON public.eb_users (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_users_phone ON public.eb_users (phone);

-- Enable Row Level Security
ALTER TABLE public.eb_users ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies
CREATE POLICY "Allow public registration" 
ON public.eb_users 
FOR INSERT 
TO anon 
WITH CHECK (true);

CREATE POLICY "Allow public login" 
ON public.eb_users 
FOR SELECT 
TO anon 
USING (true);

CREATE POLICY "Allow users to update own data" 
ON public.eb_users 
FOR UPDATE 
TO anon 
USING (true) 
WITH CHECK (true);
```

---

## Step 2: Create eb_payments Table (for payment gateway)

```sql
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

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_eb_payments_user_id ON public.eb_payments (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_payments_transaction_id ON public.eb_payments (transaction_id);
CREATE INDEX IF NOT EXISTS idx_eb_payments_bill_no ON public.eb_payments (bill_no);

-- Enable RLS
ALTER TABLE public.eb_payments ENABLE ROW LEVEL SECURITY;

-- Create RLS Policies
CREATE POLICY "Allow users to insert payments" 
ON public.eb_payments 
FOR INSERT 
TO anon 
WITH CHECK (true);

CREATE POLICY "Allow users to view own payments" 
ON public.eb_payments 
FOR SELECT 
TO anon 
USING (true);
```

---

## Step 3: Verify Tables Were Created

Run this to check:

```sql
-- Check if tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('eb_users', 'eb_payments');

-- View eb_users table structure
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'eb_users';

-- Check RLS policies
SELECT tablename, policyname 
FROM pg_policies 
WHERE tablename IN ('eb_users', 'eb_payments');
```

---

## Step 4: Test Registration Again

After running the SQL:

1. Go to `http://localhost:8080/register`
2. Fill in the registration form
3. Complete registration
4. Check Supabase Dashboard → **Table Editor** → **eb_users**
5. You should see your new user!

---

## Troubleshooting

### If registration still fails:

1. **Check browser console** (F12) for errors
2. **Verify Supabase URL and Key** in `.env` file match your project
3. **Check RLS policies** are created (run Step 3 verification)
4. **Try disabling RLS temporarily** to test:
   ```sql
   ALTER TABLE public.eb_users DISABLE ROW LEVEL SECURITY;
   ```
   (Re-enable after testing!)

### Common Errors:

**"relation 'eb_users' does not exist"**
- Run Step 1 SQL to create the table

**"permission denied for table eb_users"**
- Run the RLS policy creation SQL from Step 1

**"duplicate key value violates unique constraint"**
- Email or phone already exists, use different values

---

## Quick Copy-Paste (All SQL at Once)

```sql
-- Complete setup - run all at once
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

CREATE INDEX IF NOT EXISTS idx_eb_users_email ON public.eb_users (email);
CREATE INDEX IF NOT EXISTS idx_eb_users_user_id ON public.eb_users (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_users_phone ON public.eb_users (phone);

ALTER TABLE public.eb_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public registration" ON public.eb_users FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow public login" ON public.eb_users FOR SELECT TO anon USING (true);
CREATE POLICY "Allow users to update own data" ON public.eb_users FOR UPDATE TO anon USING (true) WITH CHECK (true);

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

CREATE INDEX IF NOT EXISTS idx_eb_payments_user_id ON public.eb_payments (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_payments_transaction_id ON public.eb_payments (transaction_id);
CREATE INDEX IF NOT EXISTS idx_eb_payments_bill_no ON public.eb_payments (bill_no);

ALTER TABLE public.eb_payments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow users to insert payments" ON public.eb_payments FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "Allow users to view own payments" ON public.eb_payments FOR SELECT TO anon USING (true);
```
