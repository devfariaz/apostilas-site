-- Log de atividade usado pela rotina diária da Vercel.
create table if not exists public.logs_health (
  id bigint generated always as identity primary key,
  checked_at timestamptz not null default now(),
  status text not null default 'ok' check (status in ('ok', 'error'))
);

alter table public.logs_health enable row level security;

revoke all on table public.logs_health from anon, authenticated;
grant all on table public.logs_health to service_role;
grant usage, select on sequence public.logs_health_id_seq to service_role;
