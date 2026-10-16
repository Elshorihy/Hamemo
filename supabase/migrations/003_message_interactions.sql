-- Hamemo interaction upgrades: enable removing one's own reactions and realtime sync.
alter table public.messages
  add column if not exists reply_to_id uuid references public.messages(id) on delete set null,
  add column if not exists edited_at timestamptz;

alter table public.message_reactions enable row level security;

drop policy if exists reactions_self_delete on public.message_reactions;
create policy reactions_self_delete
on public.message_reactions for delete to authenticated
using (
  user_id = auth.uid()
  and exists (
    select 1 from public.messages m
    where m.id = message_id
      and public.is_conversation_member(m.conversation_id)
  )
);

do $$
begin
  alter publication supabase_realtime add table public.message_reactions;
exception when duplicate_object then null;
end $$;
