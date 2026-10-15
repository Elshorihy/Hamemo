import { createClient, type SupabaseClient } from '@supabase/supabase-js';
const url = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';
export const isSupabaseConfigured = Boolean(url && key && !url.includes('YOUR-HAMEMO-PROJECT') && !key.startsWith('YOUR_'));
export const supabase: SupabaseClient | null = isSupabaseConfigured ? createClient(url,key,{auth:{persistSession:true,autoRefreshToken:true},realtime:{params:{eventsPerSecond:20}}}) : null;
