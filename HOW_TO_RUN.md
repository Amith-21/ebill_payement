# How to Run the Application 🚀

## Prerequisites Check ✅

Before running, make sure you have:
- [x] Node.js installed (check with: `node --version`)
- [x] npm installed (check with: `npm --version`)
- [x] `.env` file created with Supabase credentials
- [x] Supabase database tables created (run SQL queries)

---

## Step 1: Install Dependencies

**First time setup** (if you haven't already):

```bash
npm install
```

This installs all required packages including:
- React
- Supabase client
- UI components
- Other dependencies

**Expected output:**
```
added 389 packages, and audited 389 packages in 5s
```

---

## Step 2: Verify Environment Variables

Make sure `.env` file exists in project root with:

```
VITE_SUPABASE_URL=https://ooolevwiybkqnrlnvyfz.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vb2xldndpeWJrcW5ybG52eWZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0NDc4OTYsImV4cCI6MjA3OTAyMzg5Nn0.Bb_EbWH92ZQEa2_Ashmyc6QSisvPmjwCO7zMk5sbMtA
```

---

## Step 3: Start the Development Server

Run this command:

```bash
npm run dev
```

**Expected output:**
```
  VITE v5.4.19  ready in 500 ms

  ➜  Local:   http://localhost:5173/
  ➜  Network: use --host to expose
  ➜  press h to show help
```

---

## Step 4: Open in Browser

1. **Copy the URL** from terminal: `http://localhost:5173/`
2. **Open in your browser** (Chrome, Firefox, Edge, etc.)
3. You should see the **EB Billing** homepage

---

## Step 5: Test the Application

### Test Registration:
1. Click **"Register"** or go to `/register`
2. Fill in the registration form:
   - First Name
   - Last Name
   - Email
   - Phone Number
   - Aadhar Number (12 digits)
   - Password
3. Click **"Complete Registration"**
4. You should see: **"Registration successful! Your User ID is EB123456"**

### Test Login:
1. Go to `/login` page
2. Enter your **User ID** (e.g., EB123456) or **Email**
3. Enter your **Password**
4. Click **"Login"**
5. You should be redirected to **Dashboard**

### Verify Data in Supabase:
1. Go to **Supabase Dashboard** → **Table Editor**
2. Click on **`eb_users`** table
3. You should see your registered user data!

---

## Available Commands

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run preview` | Preview production build |
| `npm run lint` | Run ESLint |

---

## Troubleshooting

### Error: "Cannot find module"
**Solution:** Run `npm install` first

### Error: "Port 5173 already in use"
**Solution:** 
- Close other applications using port 5173
- Or change port in `vite.config.ts`

### Error: "Missing Supabase configuration"
**Solution:** 
- Check `.env` file exists
- Verify `.env` has correct Supabase URL and key
- Restart dev server after creating `.env`

### Error: "Failed to fetch" or Network errors
**Solution:**
- Check Supabase database tables are created
- Verify RLS policies are set up
- Check browser console for specific errors

### App not loading
**Solution:**
- Check terminal for errors
- Make sure you're on `http://localhost:5173/`
- Clear browser cache and reload

---

## Development Workflow

1. **Start server:** `npm run dev`
2. **Make changes** to code
3. **See changes instantly** (hot reload)
4. **Check browser console** (F12) for errors
5. **Test features** (register, login, etc.)

---

## Quick Start (All Steps)

```bash
# 1. Install dependencies (first time only)
npm install

# 2. Start development server
npm run dev

# 3. Open browser to http://localhost:5173/

# 4. Test registration and login
```

---

## Production Build

To create a production build:

```bash
npm run build
```

Output will be in `dist/` folder.

To preview production build:

```bash
npm run preview
```

---

## 🎉 You're Ready!

Once the server is running:
- ✅ App is available at `http://localhost:5173/`
- ✅ Hot reload is enabled (changes appear instantly)
- ✅ Ready to test registration and login
- ✅ Data will be stored in Supabase

**Happy coding!** 🚀

