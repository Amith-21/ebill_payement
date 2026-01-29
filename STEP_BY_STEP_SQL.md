# Step-by-Step SQL Setup for Supabase

## 🎯 Goal
When users register in your app, their data should appear in Supabase Table Editor → `eb_users`

---

## 📋 Method 1: Run Complete Script (Recommended)

### Step 1: Open Supabase SQL Editor
1. Go to **Supabase Dashboard**
2. Click **"SQL Editor"** in the left sidebar
3. Click **"New query"**

### Step 2: Copy and Paste This Complete Script

```sql
-- Enable UUID Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create Users Table
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

-- Create Indexes
CREATE INDEX IF NOT EXISTS idx_eb_users_email ON public.eb_users (email);
CREATE INDEX IF NOT EXISTS idx_eb_users_user_id ON public.eb_users (user_id);
CREATE INDEX IF NOT EXISTS idx_eb_users_phone ON public.eb_users (phone);

-- Enable Row Level Security
ALTER TABLE public.eb_users ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow public registration" ON public.eb_users;
DROP POLICY IF EXISTS "Allow public login" ON public.eb_users;
DROP POLICY IF EXISTS "Allow users to update own data" ON public.eb_users;

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

### Step 3: Run the Query
1. Click **"Run"** button (or press `Ctrl+Enter`)
2. You should see: **"Success. No rows returned"**

### Step 4: Verify Setup
1. Go to **Table Editor** → Click **`eb_users`** table
2. You should see the table structure with all columns
3. Table will be empty (no data yet)

---

## 📋 Method 2: Run Queries One by One

If you prefer to run queries separately:

### Query 1: Enable UUID Extension
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

### Query 2: Create Table
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

### Query 4: Enable RLS
```sql
ALTER TABLE public.eb_users ENABLE ROW LEVEL SECURITY;
```

### Query 5: Create Policies
```sql
-- Drop existing policies first
DROP POLICY IF EXISTS "Allow public registration" ON public.eb_users;
DROP POLICY IF EXISTS "Allow public login" ON public.eb_users;
DROP POLICY IF EXISTS "Allow users to update own data" ON public.eb_users;

-- Create new policies
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

- [ ] Table `eb_users` exists in Table Editor
- [ ] Table has all columns: `id`, `user_id`, `first_name`, `last_name`, `email`, `phone`, `aadhar`, `password`, `created_at`, `updated_at`
- [ ] RLS is enabled (shown in table settings)
- [ ] Policies exist (check Authentication → Policies)

---

## 🧪 Test Registration

1. **Start your app:** `npm run dev`
2. **Go to registration page:** `http://localhost:5173/register`
3. **Fill in the form:**
   - First Name: `John`
   - Last Name: `Doe`
   - Email: `john@example.com`
   - Phone: `1234567890`
   - Aadhar: `123456789012`
   - Password: `password123`
4. **Click "Complete Registration"**
5. **Check Supabase:**
   - Go to **Table Editor** → **`eb_users`**
   - You should see the new user data!

---

## 🔍 If Data Still Doesn't Appear

### Check 1: Browser Console
1. Open browser Developer Tools (F12)
2. Go to **Console** tab
3. Register a user
4. Look for any error messages

### Check 2: Network Tab
1. Open Developer Tools (F12)
2. Go to **Network** tab
3. Register a user
4. Look for requests to `supabase.co`
5. Check if they succeeded (status 200) or failed (status 400/500)

### Check 3: Verify RLS Policies
Run this query in SQL Editor:
```sql
SELECT policyname 
FROM pg_policies 
WHERE tablename = 'eb_users';
```

Should return 3 policies:
- Allow public registration
- Allow public login
- Allow users to update own data

### Check 4: Test Direct Insert
Run this in SQL Editor to test if insert works:
```sql
INSERT INTO public.eb_users (
  user_id, first_name, last_name, email, phone, aadhar, password
) VALUES (
  'EB999999', 'Test', 'User', 'test@test.com', '9999999999', '123456789012', 'test123'
);

SELECT * FROM public.eb_users WHERE user_id = 'EB999999';
```

If this works, the database is set up correctly. If it fails, check the error message.

---

## 📝 Important Notes

1. **Table Name:** Must be exactly `eb_users` (matches code)
2. **Column Names:** Must be snake_case (`first_name`, `user_id`, etc.)
3. **RLS Policies:** Required for data to be inserted from the app
4. **Unique Constraints:** Email, phone, and user_id must be unique

---

## 🎉 Success!

Once you see data in the `eb_users` table after registration, everything is working correctly!

