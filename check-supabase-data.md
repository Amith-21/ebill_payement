# How to Check Stored Data in Supabase

## Method 1: Supabase Dashboard (Easiest) ✅

### Step-by-Step:

1. **Go to Supabase Dashboard**
   - Visit: https://supabase.com/dashboard
   - Sign in with your account

2. **Select Your Project**
   - Click on your project: `ooolevwiybkqnrlnvyfz`
   - Or look for the project matching your URL: `https://ooolevwiybkqnrlnvyfz.supabase.co`

3. **Open Table Editor**
   - In the left sidebar, click **"Table Editor"**
   - You'll see a list of all tables

4. **View User Data**
   - Click on the **`eb_users`** table
   - You'll see all registered users in a table format
   - Each row shows one user's complete information

5. **What You'll See:**
   ```
   | id | user_id | first_name | last_name | email | phone | aadhar | password | created_at | updated_at |
   |----|---------|------------|-----------|-------|-------|--------|----------|------------|------------|
   | ...| EB123456| John       | Doe       | ...   | ...   | ...    | ...      | ...        | ...        |
   ```

---

## Method 2: SQL Editor (Advanced)

### Step-by-Step:

1. **Open SQL Editor**
   - In Supabase Dashboard, click **"SQL Editor"** in the left sidebar

2. **Run Query to View All Users**
   ```sql
   SELECT * FROM public.eb_users;
   ```

3. **Run Query to View Specific User**
   ```sql
   SELECT * FROM public.eb_users WHERE email = 'user@example.com';
   ```

4. **Run Query to Count Users**
   ```sql
   SELECT COUNT(*) as total_users FROM public.eb_users;
   ```

5. **Run Query to View Recent Registrations**
   ```sql
   SELECT user_id, first_name, last_name, email, created_at 
   FROM public.eb_users 
   ORDER BY created_at DESC 
   LIMIT 10;
   ```

---

## Method 3: Check from Browser Console (Developer)

### Step-by-Step:

1. **Open Your App**
   - Start your app: `npm run dev`
   - Open in browser: http://localhost:5173

2. **Open Browser Developer Tools**
   - Press `F12` or `Right-click` → `Inspect`
   - Go to **Console** tab

3. **Run This Code in Console**
   ```javascript
   // Import Supabase (you'll need to adjust this based on your setup)
   // Or use the network tab to see API calls
   ```

4. **Check Network Tab**
   - Go to **Network** tab in Developer Tools
   - Register a new user
   - Look for requests to `supabase.co`
   - Click on the request to see the data being sent/received

---

## Method 4: Quick Verification Query

### Run This in SQL Editor:

```sql
-- View all users with formatted output
SELECT 
  user_id,
  first_name || ' ' || last_name as full_name,
  email,
  phone,
  created_at
FROM public.eb_users
ORDER BY created_at DESC;
```

---

## What Data You'll See

When you view the `eb_users` table, you'll see:

| Column | Description | Example |
|--------|-------------|---------|
| `id` | Unique database ID (UUID) | `550e8400-e29b-41d4-a716-446655440000` |
| `user_id` | User's EB ID | `EB123456` |
| `first_name` | First name | `John` |
| `last_name` | Last name | `Doe` |
| `email` | Email address | `john@example.com` |
| `phone` | Phone number | `1234567890` |
| `aadhar` | Aadhar number | `123456789012` |
| `password` | Password (plain text) | `userpassword123` |
| `created_at` | Registration timestamp | `2024-01-15 10:30:00` |
| `updated_at` | Last update timestamp | `2024-01-15 10:30:00` |

---

## Troubleshooting

### If you don't see the `eb_users` table:
- Make sure you ran all the SQL queries to create the table
- Check if you're in the correct project
- Refresh the page

### If the table is empty:
- Register a test user in your app
- Check browser console for errors
- Verify RLS policies are set up correctly

### If you see permission errors:
- Make sure RLS policies are created (see SQL setup guide)
- Check that the anon key in `.env` is correct

---

## Quick Test

1. Register a test user in your app
2. Go to Supabase Dashboard → Table Editor → `eb_users`
3. You should see the new user immediately!

