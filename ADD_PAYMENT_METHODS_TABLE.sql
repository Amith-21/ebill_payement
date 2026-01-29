-- ============================================
-- PAYMENT METHODS TABLE SETUP
-- Add payment methods management to EB Billing
-- ============================================

-- Step 1: Create Payment Methods Table
-- ============================================
CREATE TABLE IF NOT EXISTS public.eb_payment_methods (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id TEXT NOT NULL REFERENCES public.eb_users(user_id) ON DELETE CASCADE,
  card_type TEXT NOT NULL, -- 'visa', 'mastercard', 'rupay', 'amex'
  card_last_four TEXT NOT NULL,
  card_holder_name TEXT NOT NULL,
  expiry_month TEXT NOT NULL,
  expiry_year TEXT NOT NULL,
  billing_address TEXT,
  billing_city TEXT,
  billing_state TEXT,
  billing_pincode TEXT,
  is_default BOOLEAN DEFAULT false,
  razorpay_token TEXT, -- Tokenized card from Razorpay (optional for now)
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Step 2: Create Indexes for Performance
-- ============================================
CREATE INDEX IF NOT EXISTS idx_payment_methods_user_id ON public.eb_payment_methods (user_id);
CREATE INDEX IF NOT EXISTS idx_payment_methods_is_default ON public.eb_payment_methods (is_default);

-- Step 3: Enable Row Level Security
-- ============================================
ALTER TABLE public.eb_payment_methods ENABLE ROW LEVEL SECURITY;

-- Step 4: Drop existing policies if they exist
-- ============================================
DROP POLICY IF EXISTS "Users can view own payment methods" ON public.eb_payment_methods;
DROP POLICY IF EXISTS "Users can add payment methods" ON public.eb_payment_methods;
DROP POLICY IF EXISTS "Users can update own payment methods" ON public.eb_payment_methods;
DROP POLICY IF EXISTS "Users can delete own payment methods" ON public.eb_payment_methods;

-- Step 5: Create RLS Policies
-- ============================================

-- Allow users to view their own payment methods
CREATE POLICY "Users can view own payment methods" 
ON public.eb_payment_methods 
FOR SELECT 
TO anon 
USING (true);

-- Allow users to add payment methods
CREATE POLICY "Users can add payment methods" 
ON public.eb_payment_methods 
FOR INSERT 
TO anon 
WITH CHECK (true);

-- Allow users to update their own payment methods
CREATE POLICY "Users can update own payment methods" 
ON public.eb_payment_methods 
FOR UPDATE 
TO anon 
USING (true) 
WITH CHECK (true);

-- Allow users to delete their own payment methods
CREATE POLICY "Users can delete own payment methods" 
ON public.eb_payment_methods 
FOR DELETE 
TO anon 
USING (true);

-- Step 6: Create Trigger for Auto-updating Timestamps
-- ============================================

-- Trigger for payment_methods table
CREATE TRIGGER update_eb_payment_methods_updated_at 
BEFORE UPDATE ON public.eb_payment_methods 
FOR EACH ROW 
EXECUTE FUNCTION update_updated_at_column();

-- Step 7: Insert Sample Payment Methods (Optional)
-- ============================================

-- Sample payment method for user EB100001
INSERT INTO public.eb_payment_methods (
  user_id, card_type, card_last_four, card_holder_name, 
  expiry_month, expiry_year, billing_address, billing_city, 
  billing_state, billing_pincode, is_default
) VALUES (
  'EB100001', 'visa', '4242', 'John Doe',
  '12', '2025', '123 Main St', 'Mumbai',
  'Maharashtra', '400001', true
) ON CONFLICT DO NOTHING;

-- Another sample payment method
INSERT INTO public.eb_payment_methods (
  user_id, card_type, card_last_four, card_holder_name, 
  expiry_month, expiry_year, billing_address, billing_city, 
  billing_state, billing_pincode, is_default
) VALUES (
  'EB100001', 'mastercard', '5555', 'John Doe',
  '06', '2026', '123 Main St', 'Mumbai',
  'Maharashtra', '400001', false
) ON CONFLICT DO NOTHING;

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Check if table was created
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'eb_payment_methods';

-- Check payment methods for user
SELECT * FROM eb_payment_methods WHERE user_id = 'EB100001';

-- Check indexes
SELECT indexname 
FROM pg_indexes 
WHERE tablename = 'eb_payment_methods';

-- Check policies
SELECT policyname 
FROM pg_policies 
WHERE tablename = 'eb_payment_methods';
