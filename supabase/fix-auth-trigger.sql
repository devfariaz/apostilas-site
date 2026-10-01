-- Execute no SQL Editor se o Supabase mostrar "Database error saving new user".
-- Este patch completa a tabela profiles caso ela tenha sido criada com um
-- esquema anterior e reinstala o gatilho de cadastro.
begin;

alter table public.profiles add column if not exists email text;
alter table public.profiles add column if not exists full_name text;
alter table public.profiles add column if not exists role text not null default 'aluno';
alter table public.profiles add column if not exists is_active boolean not null default false;
alter table public.profiles add column if not exists created_at timestamptz not null default timezone('utc'::text, now());
alter table public.profiles add column if not exists updated_at timestamptz not null default timezone('utc'::text, now());

update public.profiles p
set email = u.email,
    full_name = coalesce(p.full_name, u.raw_user_meta_data ->> 'full_name'),
    role = case when lower(u.email) = 'deivid.farias@docente.fieb.edu.br' then 'admin' else coalesce(p.role, 'aluno') end,
    is_active = coalesce(p.is_active, false) or lower(coalesce(u.email, '')) like 'rm%'
      or lower(coalesce(u.email, '')) = 'deivid.farias@docente.fieb.edu.br',
    updated_at = timezone('utc'::text, now())
from auth.users u
where p.id = u.id;

update public.profiles
set role = 'aluno'
where role is null or role not in ('admin', 'aluno');

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'profiles_role_check' and conrelid = 'public.profiles'::regclass) then
    alter table public.profiles add constraint profiles_role_check check (role in ('admin', 'aluno'));
  end if;
end;
$$;

create unique index if not exists profiles_email_unique_idx on public.profiles(email);
alter table public.profiles alter column email set not null;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  normalized_email text := pg_catalog.lower(coalesce(new.email, ''));
  is_owner boolean := pg_catalog.lower(coalesce(new.email, '')) = 'deivid.farias@docente.fieb.edu.br';
begin
  insert into public.profiles as current_profile (id, email, full_name, role, is_active)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    case when is_owner then 'admin' else 'aluno' end,
    normalized_email like 'rm%' or is_owner
  )
  on conflict (id) do update set
    email = excluded.email,
    full_name = coalesce(excluded.full_name, current_profile.full_name),
    role = case when pg_catalog.lower(excluded.email) = 'deivid.farias@docente.fieb.edu.br' then 'admin' else current_profile.role end,
    is_active = current_profile.is_active or excluded.is_active,
    updated_at = pg_catalog.timezone('utc'::text, pg_catalog.now());
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

commit;
