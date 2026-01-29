# Quick Setup Guide - Supabase Integration

## ✅ Step 1: Install Dependencies
Already done! Supabase package is installed.

## ✅ Step 2: Environment Variables
The `.env` file is already created with your Supabase credentials.

## 📝 Step 3: Run SQL Queries in Supabase

Go to **Supabase Dashboard** → **SQL Editor** and run these queries **one by one**:

### Query 1: Enable UUID Extension
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### Query 2: Create Users Table
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

### Query 3: Create Indexes
```sql
CREATE INDEX IF NOT EXISTS idx_eb_users_email ON public.eb_users (email);
CREATE INDEX IF NOT EXISTS idx_eb_users_user_id ON public.eb_users (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_users_phone ON public.eb_users (phone);
```

### Query 4: Enable Row Level Security
```sql
ALTER TABLE public.eb_users ENABLE ROW LEVEL SECURITY;
```

### Query 5: Create RLS Policies
```sql
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

## ✅ Step 4: Test the Application

1. **Start the dev server:**
   ```bash
   npm run dev
   ```

2. **Test Registration:**
   - Go to `/register`
   - Fill in the form
   - Complete registration
   - Check Supabase Dashboard → Table Editor → `eb_users` to see the data

3. **Test Login:**
   - Go to `/login`
   - Login with email or User ID + password
   - Should redirect to dashboard

## 📊 Viewing Data in Supabase

1. Go to **Supabase Dashboard** (https://supabase.com/dashboard)
2. Select your project
3. Click **Table Editor** in the left sidebar
4. Click on **eb_users** table
5. You'll see all registered users with their information

## 🔍 What Gets Stored

When a user registers, the following data is stored in Supabase:

- `user_id`: Auto-generated (e.g., EB123456)
- `first_name`: User's first name
- `last_name`: User's last name
- `email`: User's email (unique)
- `phone`: User's phone number (unique)
- `aadhar`: User's Aadhar number
- `password`: User's password (plain text - consider hashing for production)
- `created_at`: Registration timestamp
- `updated_at`: Last update timestamp

## 🔐 Authentication Flow

1. **Registration:**
   - User fills form → Data validated → Check for duplicates → Insert into Supabase → Success

2. **Login:**
   - User enters email/userId + password → Query Supabase → Verify password → Set session → Redirect to dashboard

3. **Session:**
   - User data stored in localStorage for session management
   - Authentication status stored in localStorage

## 🚨 Important Notes

- **Passwords**: Currently stored in plain text. For production, use Supabase Auth or hash passwords.
- **Security**: RLS policies allow public access for demo. Tighten for production.
- **Unique Fields**: Email, phone, and user_id must be unique (enforced by database).

## 📖 Full Documentation

See `SUPABASE_SETUP_SQL.md` for detailed SQL queries and troubleshooting.

