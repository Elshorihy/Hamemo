-- Ensure reactions can be added, removed, and synced live by chat members.
alter table public.message_reactions enable row level security;

drop policy if exists "reactions_self_delete" on public.message_reactions;
drop policy if exists "Users can remove their own reactions" on public.message_reactions;
create policy "reactions_self_delete"
on public.message_reactions for delete to authenticated
using (user_id = (select auth.uid()));

grant select, insert, delete on public.message_reactions to authenticated;

do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime')
     and not exists (
       select 1 from pg_publication_tables
       where pubname = 'supabase_realtime'
         and schemaname = 'public'
         and tablename = 'message_reactions'
     ) then
    alter publication supabase_realtime add table public.message_reactions;
  end if;
end $$;
