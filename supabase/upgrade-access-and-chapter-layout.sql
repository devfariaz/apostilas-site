-- Atualização do Professor Deivid - Apostilas: alocação por aluno e campos editoriais.
-- Pode ser executado sobre uma instalação existente; as alterações são idempotentes.

create extension if not exists pgcrypto;

alter table public.profiles
  add column if not exists year_level smallint check (year_level between 1 and 3);

insert into public.disciplines (slug, name, description, sort_order) values
  ('game-design-iii', 'Game Design III', 'Projeto avançado de jogos', 6),
  ('producao-multimidia-iii', 'Produção Multimídia III', 'Projeto avançado de produção multimídia', 7)
on conflict (slug) do nothing;

create table if not exists public.student_disciplines (
  user_id uuid not null references public.profiles(id) on delete cascade,
  discipline_slug text not null references public.disciplines(slug) on update cascade on delete cascade,
  assigned_at timestamptz not null default timezone('utc'::text, now()),
  assigned_by uuid references auth.users(id) on delete set null,
  primary key (user_id, discipline_slug)
);

alter table public.apostilas add column if not exists practice_markdown text not null default '';
alter table public.apostilas add column if not exists reading_minutes integer not null default 10 check (reading_minutes between 1 and 999);
alter table public.apostilas add column if not exists difficulty text not null default 'Introdutório';
alter table public.apostilas add column if not exists key_idea text not null default '';
alter table public.apostilas add column if not exists essential_points jsonb not null default '[]'::jsonb;
alter table public.apostilas add column if not exists shortcut_keys text not null default '';
alter table public.apostilas add column if not exists shortcut_label text not null default '';
alter table public.apostilas add column if not exists shortcuts jsonb not null default '[]'::jsonb;
update public.apostilas set shortcuts = jsonb_build_array(jsonb_build_object('keys', shortcut_keys, 'label', shortcut_label))
where shortcut_keys <> '' and shortcuts = '[]'::jsonb;
create index if not exists apostilas_tags_gin_idx on public.apostilas using gin(tags);

alter table public.student_disciplines enable row level security;
drop policy if exists "Students read own discipline assignments" on public.student_disciplines;
create policy "Students read own discipline assignments" on public.student_disciplines for select
  using (user_id = auth.uid() and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active));
drop policy if exists "Admins manage discipline assignments" on public.student_disciplines;
create policy "Admins manage discipline assignments" on public.student_disciplines for all
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active));

create or replace function public.admin_update_student_access(target_user uuid, target_year smallint, target_disciplines text[])
returns boolean language plpgsql security definer set search_path = '' as $$
declare
  requested_count integer;
  matched_count integer;
begin
  if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active) then
    raise exception 'Acesso administrativo necessário';
  end if;
  if target_year is not null and target_year not between 1 and 3 then raise exception 'Ano inválido'; end if;
  if not exists (select 1 from public.profiles p where p.id = target_user and p.role = 'aluno') then raise exception 'Aluno não encontrado'; end if;
  select count(distinct slug) into requested_count from unnest(coalesce(target_disciplines, '{}'::text[])) as requested(slug);
  select count(*) into matched_count from public.disciplines d where d.slug = any(coalesce(target_disciplines, '{}'::text[]));
  if requested_count <> matched_count then raise exception 'Uma ou mais disciplinas não existem'; end if;
  update public.profiles set year_level = target_year, updated_at = timezone('utc'::text, now()) where id = target_user;
  delete from public.student_disciplines where user_id = target_user;
  insert into public.student_disciplines (user_id, discipline_slug, assigned_by)
    select target_user, d.slug, auth.uid() from public.disciplines d
    where d.slug = any(coalesce(target_disciplines, '{}'::text[]));
  return true;
end;
$$;
revoke all on function public.admin_update_student_access(uuid, smallint, text[]) from public;
grant execute on function public.admin_update_student_access(uuid, smallint, text[]) to authenticated;

create index if not exists student_disciplines_discipline_idx on public.student_disciplines(discipline_slug);

create or replace function public.admin_bulk_update_student_access(target_users uuid[], target_year smallint, target_disciplines text[])
returns integer language plpgsql security definer set search_path = '' as $$
declare
  requested_users integer;
  matched_users integer;
  requested_disciplines integer;
  matched_disciplines integer;
begin
  if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active) then raise exception 'Acesso administrativo necessário'; end if;
  if target_year not between 1 and 3 then raise exception 'Ano inválido'; end if;
  select count(distinct id) into requested_users from unnest(coalesce(target_users, '{}'::uuid[])) as selected(id);
  select count(*) into matched_users from public.profiles p where p.id = any(coalesce(target_users, '{}'::uuid[])) and p.role = 'aluno';
  if requested_users = 0 or requested_users <> matched_users then raise exception 'Uma ou mais contas selecionadas não são alunos válidos'; end if;
  select count(distinct slug) into requested_disciplines from unnest(coalesce(target_disciplines, '{}'::text[])) as requested(slug);
  select count(*) into matched_disciplines from public.disciplines d where d.slug = any(coalesce(target_disciplines, '{}'::text[]));
  if requested_disciplines <> matched_disciplines then raise exception 'Uma ou mais disciplinas não existem'; end if;
  update public.profiles set year_level = target_year, updated_at = timezone('utc'::text, now()) where id = any(target_users) and role = 'aluno';
  delete from public.student_disciplines where user_id = any(target_users);
  insert into public.student_disciplines (user_id, discipline_slug, assigned_by)
    select selected.id, d.slug, auth.uid() from unnest(target_users) as selected(id) cross join public.disciplines d
    where d.slug = any(coalesce(target_disciplines, '{}'::text[]));
  return requested_users;
end;
$$;
revoke all on function public.admin_bulk_update_student_access(uuid[], smallint, text[]) from public;
grant execute on function public.admin_bulk_update_student_access(uuid[], smallint, text[]) to authenticated;

-- Recria a listagem para o painel exibir imediatamente ano e disciplinas atuais.
drop function if exists public.admin_list_students();
create function public.admin_list_students()
returns table (id uuid, email text, full_name text, is_active boolean, year_level smallint, discipline_slugs text[], created_at timestamptz)
language plpgsql security definer set search_path = '' as $$
begin
  if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active) then
    raise exception 'Acesso administrativo necessário';
  end if;
  return query
    select p.id, p.email, p.full_name, p.is_active, p.year_level,
      coalesce(array_agg(sd.discipline_slug order by sd.discipline_slug) filter (where sd.discipline_slug is not null), '{}'::text[]), p.created_at
    from public.profiles p left join public.student_disciplines sd on sd.user_id = p.id
    where p.role = 'aluno' group by p.id order by p.is_active, p.created_at desc;
end;
$$;
revoke all on function public.admin_list_students() from public;
grant execute on function public.admin_list_students() to authenticated;

notify pgrst, 'reload schema';
