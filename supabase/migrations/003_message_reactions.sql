-- Hamemo message reactions: persistent reactions shared between chat participants.
create table if not exists public.message_reactions (
  message_id uuid not null references public.messages(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  emoji text not null check (char_length(emoji) between 1 and 16),
  created_at timestamptz not null default now(),
  primary key (message_id, user_id, emoji)
);

alter table public.message_reactions enable row level security;

drop policy if exists "Chat members can read message reactions" on public.message_reactions;
create policy "Chat members can read message reactions"
on public.message_reactions for select to authenticated
using (
  exists (
    select 1
    from public.messages m
    join public.conversation_members cm on cm.conversation_id = m.conversation_id
    where m.id = message_reactions.message_id
      and cm.user_id = (select auth.uid())
  )
);

drop policy if exists "Chat members can add their own reactions" on public.message_reactions;
create policy "Chat members can add their own reactions"
on public.message_reactions for insert to authenticated
with check (
  user_id = (select auth.uid())
  and exists (
    select 1
    from public.messages m
    join public.conversation_members cm on cm.conversation_id = m.conversation_id
    where m.id = message_reactions.message_id
      and cm.user_id = (select auth.uid())
  )
);

drop policy if exists "Users can remove their own reactions" on public.message_reactions;
create policy "Users can remove their own reactions"
on public.message_reactions for delete to authenticated
using (user_id = (select auth.uid()));

create index if not exists message_reactions_message_id_idx
  on public.message_reactions (message_id);

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
