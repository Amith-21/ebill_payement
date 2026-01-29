# Supabase Database Setup - Step by Step SQL Queries

## 📋 Overview
This guide provides step-by-step SQL queries to set up your Supabase database for the EB Billing application.

## 🗄️ Database Schema
The application stores:
- **User Registration Data**: firstName, lastName, email, phone, aadhar, password, userId
- **User Authentication**: Login with email or userId + password

---

## Step 1: Enable UUID Extension
**Purpose**: Generate unique IDs for records

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

---

## Step 2: Create Users Table
**Purpose**: Store all registered user information

```sql
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
```

---

## Step 3: Create Indexes for Faster Queries
**Purpose**: Improve query performance for login and lookups

```sql
-- Index for email lookups (login)
CREATE INDEX IF NOT EXISTS idx_eb_users_email ON public.eb_users (email);

-- Index for user_id lookups (login)
CREATE INDEX IF NOT EXISTS idx_eb_users_user_id ON public.eb_users (user_id);

-- Index for phone lookups (duplicate check)
CREATE INDEX IF NOT EXISTS idx_eb_users_phone ON public.eb_users (phone);
```

---

## Step 4: Enable Row Level Security (RLS)
**Purpose**: Secure the table (required for Supabase)

```sql
ALTER TABLE public.eb_users ENABLE ROW LEVEL SECURITY;
```

---

## Step 5: Create RLS Policies for Authentication
**Purpose**: Allow users to register and login

### Policy 1: Allow anyone to INSERT (Register)
```sql
CREATE POLICY "Allow public registration" 
ON public.eb_users 
FOR INSERT 
TO anon 
WITH CHECK (true);
```

### Policy 2: Allow anyone to SELECT (Login)
```sql
CREATE POLICY "Allow public login" 
ON public.eb_users 
FOR SELECT 
TO anon 
USING (true);
```

### Policy 3: Allow users to UPDATE their own data
```sql
CREATE POLICY "Allow users to update own data" 
ON public.eb_users 
FOR UPDATE 
TO anon 
USING (true) 
WITH CHECK (true);
```

---

## Step 6: Verify Table Creation
**Purpose**: Confirm everything was created correctly

```sql
-- Check if table exists
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'eb_users';

-- Check if indexes exist
SELECT indexname 
FROM pg_indexes 
WHERE tablename = 'eb_users';

-- Check if policies exist
SELECT policyname 
FROM pg_policies 
WHERE tablename = 'eb_users';
```

---

## Step 7: Test the Setup
**Purpose**: Verify the database works correctly

### Test Insert (Registration)
```sql
INSERT INTO public.eb_users (
  user_id, 
  first_name, 
  last_name, 
  email, 
  phone, 
  aadhar, 
  password
) VALUES (
  'EB123456',
  'Test',
  'User',
  'test@example.com',
  '1234567890',
  '123456789012',
  'testpass123'
);
```

### Test Select (Login)
```sql
-- Login by email
SELECT * FROM public.eb_users WHERE email = 'test@example.com';

-- Login by user_id
SELECT * FROM public.eb_users WHERE user_id = 'EB123456';
```

### Clean Up Test Data
```sql
DELETE FROM public.eb_users WHERE user_id = 'EB123456';
```

---

## 📝 Complete Setup Script (Run All at Once)

If you want to run everything at once, copy and paste this entire block:

```sql
-- Step 1: Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Step 2: Create Users Table
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

-- Step 3: Create Indexes
CREATE INDEX IF NOT EXISTS idx_eb_users_email ON public.eb_users (email);
CREATE INDEX IF NOT EXISTS idx_eb_users_user_id ON public.eb_users (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_users_phone ON public.eb_users (phone);

-- Step 4: Enable RLS
ALTER TABLE public.eb_users ENABLE ROW LEVEL SECURITY;

-- Step 5: Create RLS Policies
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

## ✅ Verification Checklist

After running the SQL queries, verify:

- [ ] Table `eb_users` exists in Supabase Dashboard → Table Editor
- [ ] You can see the table structure with all columns
- [ ] RLS is enabled (shown in table settings)
- [ ] Policies are visible in Authentication → Policies
- [ ] Test insert works (try registering a user in the app)
- [ ] Test select works (try logging in)

---

## 🔍 Viewing Data in Supabase

1. Go to **Supabase Dashboard** → **Table Editor**
2. Click on **eb_users** table
3. You'll see all registered users with their information
4. Data includes: user_id, first_name, last_name, email, phone, aadhar, password, created_at

---

## 🚨 Important Notes

1. **Password Storage**: Currently passwords are stored in plain text. For production, use Supabase Auth or hash passwords.
2. **Security**: RLS policies allow public access for demo purposes. Tighten security for production.
3. **Unique Constraints**: Email, phone, and user_id must be unique (enforced by database).
4. **Environment Variables**: Make sure `.env` file has correct Supabase URL and anon key.

---

## 📊 Data Flow

1. **Registration**: User fills form → Data sent to Supabase → Stored in `eb_users` table
2. **Login**: User enters email/userId + password → Query Supabase → Verify credentials → Set authentication
3. **Dashboard**: Fetch user data from Supabase → Display user information

---

## 🛠️ Troubleshooting

### Error: "relation 'eb_users' does not exist"
**Solution**: Run Step 2 (Create Users Table)

### Error: "permission denied for table eb_users"
**Solution**: Run Step 5 (Create RLS Policies)

### Error: "duplicate key value violates unique constraint"
**Solution**: Email, phone, or user_id already exists. This is expected behavior.

### Data not appearing in Table Editor
**Solution**: 
- Check RLS policies are created
- Verify `.env` file has correct credentials
- Check browser console for errors
- Ensure Supabase project is active

