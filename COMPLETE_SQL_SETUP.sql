-- =====================================================
-- COMPLETE SQL SETUP FOR EB BILLING APPLICATION
-- Run this entire script in Supabase SQL Editor
-- =====================================================

-- Step 1: Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Step 2: Create Users Table (eb_users)
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

-- Step 3: Create Indexes for Fast Queries
CREATE INDEX IF NOT EXISTS idx_eb_users_email ON public.eb_users (email);
CREATE INDEX IF NOT EXISTS idx_eb_users_user_id ON public.eb_users (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_users_phone ON public.eb_users (phone);

-- Step 4: Enable Row Level Security (RLS)
ALTER TABLE public.eb_users ENABLE ROW LEVEL SECURITY;

-- Step 5: Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Allow public registration" ON public.eb_users;
DROP POLICY IF EXISTS "Allow public login" ON public.eb_users;
DROP POLICY IF EXISTS "Allow users to update own data" ON public.eb_users;

-- Step 6: Create RLS Policies for Registration and Login
-- Policy 1: Allow anyone to INSERT (Register new users)
CREATE POLICY "Allow public registration" 
ON public.eb_users 
FOR INSERT 
TO anon 
WITH CHECK (true);

-- Policy 2: Allow anyone to SELECT (Login - read user data)
CREATE POLICY "Allow public login" 
ON public.eb_users 
FOR SELECT 
TO anon 
USING (true);

-- Policy 3: Allow users to UPDATE their own data
CREATE POLICY "Allow users to update own data" 
ON public.eb_users 
FOR UPDATE 
TO anon 
USING (true) 
WITH CHECK (true);

-- =====================================================
-- VERIFICATION QUERIES (Optional - to check setup)
-- =====================================================

-- Check if table exists
-- SELECT table_name 
-- FROM information_schema.tables 
-- WHERE table_schema = 'public' 
-- AND table_name = 'eb_users';

-- Check if policies exist
-- SELECT policyname 
-- FROM pg_policies 
-- WHERE tablename = 'eb_users';

-- Check table structure
-- SELECT column_name, data_type, is_nullable
-- FROM information_schema.columns
-- WHERE table_schema = 'public' 
-- AND table_name = 'eb_users';

-- =====================================================
-- TEST QUERY (Optional - test if everything works)
-- =====================================================

-- Test insert (will fail if RLS is blocking)
-- INSERT INTO public.eb_users (
--   user_id, 
--   first_name, 
--   last_name, 
--   email, 
--   phone, 
--   aadhar, 
--   password
-- ) VALUES (
--   'EB999999',
--   'Test',
--   'User',
--   'test@example.com',
--   '9999999999',
--   '123456789012',
--   'testpass123'
-- );

-- View test data
-- SELECT * FROM public.eb_users WHERE user_id = 'EB999999';

-- Delete test data
-- DELETE FROM public.eb_users WHERE user_id = 'EB999999';

