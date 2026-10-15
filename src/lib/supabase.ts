import { createClient, type SupabaseClient } from '@supabase/supabase-js';

// This app is intentionally isolated from ChwMe: always use Hamemo's own Supabase project.
// Configure production secrets/environment separately if the project is moved in the future.
const url = 'https://ehrewlvtjemuoftlbdcs.supabase.co';
const key = 'sb_publishable_8p1nBgSZsZlXScFRBiGBKg_2a6VN1zQ';

export const isSupabaseConfigured = true;
export const supabase: SupabaseClient = createClient(url, key, {
  auth: { persistSession: true, autoRefreshToken: true },
  realtime: { params: { eventsPerSecond: 20 } },
});
