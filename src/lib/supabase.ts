import { createClient, type SupabaseClient } from '@supabase/supabase-js';

// Hamemo's dedicated Supabase project. Public publishable keys are safe for browser use
// when Row Level Security (RLS) is correctly enabled; never use a service-role key here.
const url = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://ehrewlvtjemuoftlbdcs.supabase.co';
const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'sb_publishable_8p1nBgSZsZlXScFRBiGBKg_2a6VN1zQ';

export const isSupabaseConfigured = Boolean(url && key);
export const supabase: SupabaseClient | null = isSupabaseConfigured
  ? createClient(url, key, {
      auth: { persistSession: true, autoRefreshToken: true },
      realtime: { params: { eventsPerSecond: 20 } },
    })
  : null;
