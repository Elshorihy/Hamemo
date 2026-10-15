-- Hamemo chat enhancements: secure read receipts and realtime receipt updates.
drop policy if exists receipts_self_insert on public.message_receipts;
create policy receipts_self_insert
on public.message_receipts for insert to authenticated
with check (
  user_id = auth.uid()
  and exists (
    select 1 from public.messages m
    where m.id = message_id
      and public.is_conversation_member(m.conversation_id)
  )
);

drop policy if exists receipts_self_update on public.message_receipts;
create policy receipts_self_update
on public.message_receipts for update to authenticated
using (user_id = auth.uid())
with check (
  user_id = auth.uid()
  and exists (
    select 1 from public.messages m
    where m.id = message_id
      and public.is_conversation_member(m.conversation_id)
  )
);

do $$
begin
  alter publication supabase_realtime add table public.message_receipts;
exception when duplicate_object then null;
end $$;
