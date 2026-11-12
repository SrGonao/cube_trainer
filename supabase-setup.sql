-- Slotwise sync tables. Run once in the Supabase SQL editor.
create table if not exists public.slotwise_items (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  kind text not null,
  id bigint not null,
  data jsonb,
  deleted boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, kind, id)
);
create table if not exists public.slotwise_kv (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  key text not null,
  value jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, key)
);
create index if not exists slotwise_items_changed on public.slotwise_items (user_id, updated_at);

create or replace function public.slotwise_touch() returns trigger language plpgsql as $$
begin new.updated_at = clock_timestamp(); return new; end $$;
drop trigger if exists slotwise_items_touch on public.slotwise_items;
create trigger slotwise_items_touch before insert or update on public.slotwise_items for each row execute function public.slotwise_touch();
drop trigger if exists slotwise_kv_touch on public.slotwise_kv;
create trigger slotwise_kv_touch before insert or update on public.slotwise_kv for each row execute function public.slotwise_touch();

-- each signed-in user can only see and change their own rows
alter table public.slotwise_items enable row level security;
alter table public.slotwise_kv enable row level security;
drop policy if exists "own rows" on public.slotwise_items;
create policy "own rows" on public.slotwise_items for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "own rows" on public.slotwise_kv;
create policy "own rows" on public.slotwise_kv for all to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
