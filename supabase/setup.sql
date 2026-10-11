-- WHIRL shared chase log: run once in Supabase > SQL Editor > New query.
-- Safe to run inside an existing project: every table starts with "whirl_".

-- 1. Who is on the team (sign-in emails)
create table if not exists public.whirl_team (email text primary key);

-- 2. Chase log: one row per scored day
create table if not exists public.whirl_log (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  author_email text default (auth.jwt() ->> 'email'),
  date date,
  place text,
  outcome text not null default 'pending' check (outcome in ('pending','tornado','bust')),
  notes text,
  inputs jsonb,
  score numeric,
  engine text
);

-- 3. Cases your team adds to the case library
create table if not exists public.whirl_cases (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  author_email text default (auth.jwt() ->> 'email'),
  name text, date date, time text, "out" int, rating text, radar text,
  lat double precision, lon double precision, env text, src text
);

-- Only signed-in team members can read or change anything
create or replace function public.whirl_is_team() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.whirl_team where lower(email) = lower(auth.jwt() ->> 'email'));
$$;

alter table public.whirl_team  enable row level security;
alter table public.whirl_log   enable row level security;
alter table public.whirl_cases enable row level security;

drop policy if exists whirl_log_team on public.whirl_log;
create policy whirl_log_team on public.whirl_log for all to authenticated
  using (public.whirl_is_team()) with check (public.whirl_is_team());

drop policy if exists whirl_cases_team on public.whirl_cases;
create policy whirl_cases_team on public.whirl_cases for all to authenticated
  using (public.whirl_is_team()) with check (public.whirl_is_team());
-- whirl_team has no policies, so nobody can read or edit the list from the website.

-- Live updates on the site when a teammate saves
alter publication supabase_realtime add table public.whirl_log, public.whirl_cases;

-- 4. Add your team's sign-in emails (edit these two lines)
insert into public.whirl_team (email) values
  ('keith@example.com'),
  ('brian@example.com')
on conflict do nothing;
