-- ============================================
-- ADD MORE SAMPLE BILLS TO MATCH WEBSITE
-- This will add 4 more bills (total 5 bills)
-- ============================================

-- Bill 2: February 2024
INSERT INTO public.eb_bills (
  bill_id, user_id, consumer_number, 
  billing_period_start, billing_period_end, due_date,
  units_consumed, rate_per_unit, energy_charges, 
  fixed_charges, tax_amount, total_amount, status
) VALUES (
  'BILL100002', 'EB100001', 'CONS123456',
  '2024-02-01', '2024-02-29', '2024-03-15',
  175.00, 6.50, 1137.50, 50.00, 118.75, 1306.25, 'paid'
) ON CONFLICT (bill_id) DO NOTHING;

-- Bill 3: March 2024
INSERT INTO public.eb_bills (
  bill_id, user_id, consumer_number, 
  billing_period_start, billing_period_end, due_date,
  units_consumed, rate_per_unit, energy_charges, 
  fixed_charges, tax_amount, total_amount, status
) VALUES (
  'BILL100003', 'EB100001', 'CONS123456',
  '2024-03-01', '2024-03-31', '2024-04-15',
  200.00, 6.50, 1300.00, 50.00, 135.00, 1485.00, 'paid'
) ON CONFLICT (bill_id) DO NOTHING;

-- Bill 4: April 2024
INSERT INTO public.eb_bills (
  bill_id, user_id, consumer_number, 
  billing_period_start, billing_period_end, due_date,
  units_consumed, rate_per_unit, energy_charges, 
  fixed_charges, tax_amount, total_amount, status
) VALUES (
  'BILL100004', 'EB100001', 'CONS123456',
  '2024-04-01', '2024-04-30', '2024-05-15',
  165.00, 6.50, 1072.50, 50.00, 112.25, 1234.75, 'paid'
) ON CONFLICT (bill_id) DO NOTHING;

-- Bill 5: May 2024 (Most Recent)
INSERT INTO public.eb_bills (
  bill_id, user_id, consumer_number, 
  billing_period_start, billing_period_end, due_date,
  units_consumed, rate_per_unit, energy_charges, 
  fixed_charges, tax_amount, total_amount, status
) VALUES (
  'BILL100005', 'EB100001', 'CONS123456',
  '2024-05-01', '2024-05-31', '2024-06-15',
  180.00, 6.50, 1170.00, 50.00, 122.00, 1342.00, 'unpaid'
) ON CONFLICT (bill_id) DO NOTHING;

-- Add corresponding payments for paid bills
-- Payment for Bill 2
INSERT INTO public.eb_payments (
  payment_id, transaction_id, bill_id, user_id, 
  amount, payment_method, payment_status, payment_gateway, payment_time
) VALUES (
  'PAY100002', 'TXN1234567891', 'BILL100002', 'EB100001',
  1306.25, 'card', 'success', 'razorpay', '2024-03-10 15:30:00'
) ON CONFLICT (payment_id) DO NOTHING;

-- Payment for Bill 3
INSERT INTO public.eb_payments (
  payment_id, transaction_id, bill_id, user_id, 
  amount, payment_method, payment_status, payment_gateway, payment_time
) VALUES (
  'PAY100003', 'TXN1234567892', 'BILL100003', 'EB100001',
  1485.00, 'upi', 'success', 'phonepe', '2024-04-12 10:15:00'
) ON CONFLICT (payment_id) DO NOTHING;

-- Payment for Bill 4
INSERT INTO public.eb_payments (
  payment_id, transaction_id, bill_id, user_id, 
  amount, payment_method, payment_status, payment_gateway, payment_time
) VALUES (
  'PAY100004', 'TXN1234567893', 'BILL100004', 'EB100001',
  1234.75, 'netbanking', 'success', 'paytm', '2024-05-08 14:20:00'
) ON CONFLICT (payment_id) DO NOTHING;

-- ============================================
-- VERIFICATION QUERY
-- ============================================

-- Check all bills for user EB100001
SELECT 
  bill_id,
  billing_period_start || ' to ' || billing_period_end AS period,
  units_consumed || ' kWh' AS consumption,
  '₹' || total_amount AS amount,
  status,
  due_date
FROM eb_bills
WHERE user_id = 'EB100001'
ORDER BY billing_period_end DESC;

-- Check billing history with payments
SELECT * FROM billing_history 
WHERE user_id = 'EB100001'
ORDER BY billing_period_end DESC;
