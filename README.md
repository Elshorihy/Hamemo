# Hamemo — Stay close

Arabic-first messaging app built with Next.js 14, TypeScript, Tailwind CSS and Supabase Auth/Postgres/Realtime.

## Current status
- Next.js project scaffolding and responsive Arabic login/register screen.
- Supabase Auth session persistence.
- Conversation list and realtime message subscription wiring.
- Database schema migration with row-level security (RLS).
- **A separate Supabase project is required. Do not reuse ChwMe's project.**
- This is a foundation; do not consider production messaging fully ready until the database migration, auth confirmation settings, and end-to-end tests are completed.

## Setup
1. Create a **new Supabase project only for Hamemo**.
2. In Supabase SQL Editor, run `supabase/migrations/001_schema_and_rls.sql`.
3. In Project Settings → API, copy the Project URL and the publishable/anon key.
4. Set `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` as environment variables in your hosting provider. Use `.env.example` as a template for local development.
5. In Supabase Authentication → URL Configuration, set the production Site URL and add the local/production callback URLs.
6. Deploy the Next.js app on Vercel or another host supporting Next.js 14, then add the same environment variables to that host.

## Security notes
- Never expose a Supabase service-role key in browser code or any `NEXT_PUBLIC_*` variable.
- Keep RLS enabled. Review policies and test with two separate user accounts before opening registration to everyone.
- Use a separate storage bucket for Hamemo media and configure its policies before enabling uploads.
- Email confirmation behavior depends on the settings and SMTP configuration of the new Supabase project.

## Commands
```bash
npm install
npm run dev
npm run build
```
