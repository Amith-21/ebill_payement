// Quick script to verify anon key
const anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVmZ2ltaG1zeWZ0c2hpdmh3Y3FrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1NzI5OTcsImV4cCI6MjA3OTE0ODk5N30.oyDfK-G8Q-HaGlghePbmWDhT2sux9edaTtDBSnXu7QU";

// Decode JWT payload (middle part)
const payload = anonKey.split('.')[1];
const decoded = JSON.parse(Buffer.from(payload, 'base64').toString());

console.log('Anon Key Verification:');
console.log('====================');
console.log('Project Reference (ref):', decoded.ref);
console.log('Role:', decoded.role);
console.log('Issued At:', new Date(decoded.iat * 1000).toLocaleString());
console.log('Expires At:', new Date(decoded.exp * 1000).toLocaleString());
console.log('');
console.log('Expected URL: https://efgimhmsyftshivhwcqk.supabase.co');
console.log('URL matches:', decoded.ref === 'efgimhmsyftshivhwcqk' ? '✅ YES' : '❌ NO');

