-- Professor Deivid - Apostilas: instalação inicial do banco no Supabase.
create extension if not exists pgcrypto;

-- Perfis e aprovação. O perfil nunca pode ser promovido pelo próprio aluno via API.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  full_name text,
  role text not null default 'aluno' check (role in ('admin', 'aluno')),
  is_active boolean not null default false,
  year_level smallint check (year_level between 1 and 3),
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now())
);

-- Cadastro de disciplinas, módulos e capítulos (apostilas).
create table if not exists public.disciplines (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null unique,
  description text not null default '',
  skills text[] not null default '{}',
  competencies text[] not null default '{}',
  sort_order integer not null default 0,
  active boolean not null default true,
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now())
);

create table if not exists public.modules (
  id uuid primary key default gen_random_uuid(),
  discipline_slug text not null references public.disciplines(slug) on update cascade on delete cascade,
  slug text not null,
  name text not null,
  sort_order integer not null default 0,
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now()),
  unique (discipline_slug, slug),
  unique (discipline_slug, name)
);

create table if not exists public.student_disciplines (
  user_id uuid not null references public.profiles(id) on delete cascade,
  discipline_slug text not null references public.disciplines(slug) on update cascade on delete cascade,
  assigned_at timestamptz not null default timezone('utc'::text, now()),
  assigned_by uuid references auth.users(id) on delete set null,
  primary key (user_id, discipline_slug)
);

create table if not exists public.apostilas (
  id uuid primary key default gen_random_uuid(),
  slug text not null,
  title text not null,
  discipline_slug text not null references public.disciplines(slug) on update cascade on delete cascade,
  module_id uuid references public.modules(id) on delete set null,
  module text not null default '',
  lesson_order integer not null default 0 check (lesson_order >= 0),
  summary text not null default '',
  tags text[] not null default '{}',
  body_markdown text not null default '',
  practice_markdown text not null default '',
  reading_minutes integer not null default 10 check (reading_minutes between 1 and 999),
  difficulty text not null default 'Introdutório',
  key_idea text not null default '',
  essential_points jsonb not null default '[]'::jsonb,
  shortcut_keys text not null default '',
  shortcut_label text not null default '',
  shortcuts jsonb not null default '[]'::jsonb,
  published boolean not null default true,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now()),
  unique (discipline_slug, slug)
);

-- Dados do aluno.
create table if not exists public.user_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  disciplina_slug text not null,
  lesson_slug text not null,
  content text not null default '',
  updated_at timestamptz not null default timezone('utc'::text, now()),
  unique (user_id, disciplina_slug, lesson_slug)
);

create table if not exists public.lesson_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  disciplina_slug text not null,
  lesson_slug text not null,
  completed_at timestamptz not null default timezone('utc'::text, now()),
  unique (user_id, disciplina_slug, lesson_slug)
);

-- Disciplinas iniciais. Novas disciplinas podem ser criadas no painel.
insert into public.disciplines (slug, name, description, sort_order) values
  ('game-design-i', 'Game Design I', 'Fundamentos de criação de jogos', 1),
  ('game-design-ii', 'Game Design II', 'Projeto e prototipagem de jogos', 2),
  ('producao-multimidia-i', 'Produção Multimídia I', 'Linguagens e ferramentas multimídia', 3),
  ('producao-multimidia-ii', 'Produção Multimídia II', 'Produção e publicação de projetos', 4),
  ('marketing', 'Marketing', 'Estratégia, comunicação e mercado', 5),
  ('game-design-iii', 'Game Design III', 'Projeto avançado de jogos', 6),
  ('producao-multimidia-iii', 'Produção Multimídia III', 'Projeto avançado de produção multimídia', 7)
on conflict (slug) do nothing;

alter table public.profiles add column if not exists year_level smallint check (year_level between 1 and 3);
alter table public.apostilas add column if not exists practice_markdown text not null default '';
alter table public.apostilas add column if not exists reading_minutes integer not null default 10 check (reading_minutes between 1 and 999);
alter table public.apostilas add column if not exists difficulty text not null default 'Introdutório';
alter table public.apostilas add column if not exists key_idea text not null default '';
alter table public.apostilas add column if not exists essential_points jsonb not null default '[]'::jsonb;
alter table public.apostilas add column if not exists shortcut_keys text not null default '';
alter table public.apostilas add column if not exists shortcut_label text not null default '';
alter table public.apostilas add column if not exists shortcuts jsonb not null default '[]'::jsonb;
alter table public.disciplines add column if not exists skills text[] not null default '{}';
alter table public.disciplines add column if not exists competencies text[] not null default '{}';
update public.apostilas set shortcuts = jsonb_build_array(jsonb_build_object('keys', shortcut_keys, 'label', shortcut_label))
where shortcut_keys <> '' and shortcuts = '[]'::jsonb;
create index if not exists apostilas_tags_gin_idx on public.apostilas using gin(tags);

-- Criação automática do perfil. Contas RM e o e-mail do proprietário são ativados.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  email_lower text := lower(coalesce(new.email, ''));
  is_owner boolean := lower(coalesce(new.email, '')) = 'deivid.farias@docente.fieb.edu.br';
begin
  insert into public.profiles (id, email, full_name, role, is_active)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    case when is_owner then 'admin' else 'aluno' end,
    email_lower like 'rm%' or is_owner
  )
  on conflict (id) do update set
    email = excluded.email,
    full_name = coalesce(excluded.full_name, public.profiles.full_name),
    role = case when lower(excluded.email) = 'deivid.farias@docente.fieb.edu.br' then 'admin' else public.profiles.role end,
    is_active = public.profiles.is_active or excluded.is_active,
    updated_at = timezone('utc'::text, now());
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Cria/atualiza perfis para contas que já estavam no Auth antes da instalação.
insert into public.profiles (id, email, full_name, role, is_active)
select
  u.id,
  u.email,
  u.raw_user_meta_data ->> 'full_name',
  case when lower(u.email) = 'deivid.farias@docente.fieb.edu.br' then 'admin' else 'aluno' end,
  lower(u.email) like 'rm%' or lower(u.email) = 'deivid.farias@docente.fieb.edu.br'
from auth.users u
where u.email is not null
on conflict (id) do update set
  email = excluded.email,
  is_active = public.profiles.is_active or excluded.is_active,
  role = case when lower(excluded.email) = 'deivid.farias@docente.fieb.edu.br' then 'admin' else public.profiles.role end,
  updated_at = timezone('utc'::text, now());

alter table public.profiles enable row level security;
alter table public.disciplines enable row level security;
alter table public.modules enable row level security;
alter table public.student_disciplines enable row level security;
alter table public.apostilas enable row level security;
alter table public.user_notes enable row level security;
alter table public.lesson_progress enable row level security;

drop policy if exists "Users read own profile" on public.profiles;
create policy "Users read own profile" on public.profiles for select using (auth.uid() = id);

drop policy if exists "Anyone reads active disciplines" on public.disciplines;
drop policy if exists "Assigned students and admins read disciplines" on public.disciplines;
create policy "Assigned students and admins read disciplines" on public.disciplines for select using (
  active and (
    exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active and p.role = 'admin')
    or exists (select 1 from public.student_disciplines sd join public.profiles p on p.id = sd.user_id where sd.discipline_slug = disciplines.slug and sd.user_id = auth.uid() and p.is_active)
  )
);
drop policy if exists "Admins manage disciplines" on public.disciplines;
create policy "Admins manage disciplines" on public.disciplines for all
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active));

drop policy if exists "Anyone reads modules" on public.modules;
create policy "Anyone reads modules" on public.modules for select using (
  exists (select 1 from public.disciplines d where d.slug = discipline_slug and d.active)
  and (
    exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active and p.role = 'admin')
    or exists (select 1 from public.student_disciplines sd join public.profiles p on p.id = sd.user_id where sd.discipline_slug = modules.discipline_slug and sd.user_id = auth.uid() and p.is_active)
  )
);
drop policy if exists "Admins manage modules" on public.modules;
create policy "Admins manage modules" on public.modules for all
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active));

drop policy if exists "Active students read published apostilas" on public.apostilas;
create policy "Active students read published apostilas" on public.apostilas for select
  using (published and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active)
    and (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin')
      or exists (select 1 from public.student_disciplines sd where sd.user_id = auth.uid() and sd.discipline_slug = apostilas.discipline_slug)));
drop policy if exists "Admins manage apostilas" on public.apostilas;
create policy "Admins manage apostilas" on public.apostilas for all
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active and p.role = 'admin'))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active and p.role = 'admin'));

drop policy if exists "Users manage own notes" on public.user_notes;
create policy "Users manage own notes" on public.user_notes for all
  using (auth.uid() = user_id and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active)
    and exists (select 1 from public.student_disciplines sd where sd.user_id = auth.uid() and sd.discipline_slug = user_notes.disciplina_slug))
  with check (auth.uid() = user_id and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active)
    and exists (select 1 from public.student_disciplines sd where sd.user_id = auth.uid() and sd.discipline_slug = user_notes.disciplina_slug));
drop policy if exists "Users manage own progress" on public.lesson_progress;
create policy "Users manage own progress" on public.lesson_progress for all
  using (auth.uid() = user_id and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active)
    and exists (select 1 from public.student_disciplines sd where sd.user_id = auth.uid() and sd.discipline_slug = lesson_progress.disciplina_slug))
  with check (auth.uid() = user_id and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active)
    and exists (select 1 from public.student_disciplines sd where sd.user_id = auth.uid() and sd.discipline_slug = lesson_progress.disciplina_slug));

drop policy if exists "Students read own discipline assignments" on public.student_disciplines;
create policy "Students read own discipline assignments" on public.student_disciplines for select
  using (user_id = auth.uid() and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active));
drop policy if exists "Admins manage discipline assignments" on public.student_disciplines;
create policy "Admins manage discipline assignments" on public.student_disciplines for all
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active));

-- Funções administrativas para listar alunos e aprovar/revogar contas sem
-- conceder aos clientes permissão direta para alterar profiles.role/is_active.
drop function if exists public.admin_list_students();
create function public.admin_list_students()
returns table (id uuid, email text, full_name text, is_active boolean, year_level smallint, discipline_slugs text[], created_at timestamptz)
language plpgsql security definer set search_path = '' as $$
begin
  if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active) then
    raise exception 'Acesso administrativo necessário';
  end if;
  return query select p.id, p.email, p.full_name, p.is_active, p.year_level,
      coalesce(array_agg(sd.discipline_slug) filter (where sd.discipline_slug is not null), '{}'::text[]), p.created_at
    from public.profiles p left join public.student_disciplines sd on sd.user_id = p.id
    where p.role = 'aluno' group by p.id order by p.is_active, p.created_at desc;
end;
$$;

create or replace function public.admin_set_student_active(target_user uuid, new_active boolean)
returns boolean language plpgsql security definer set search_path = '' as $$
begin
  if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active) then
    raise exception 'Acesso administrativo necessário';
  end if;
  update public.profiles p set is_active = new_active, updated_at = timezone('utc'::text, now())
    where p.id = target_user and p.role = 'aluno';
  return found;
end;
$$;

revoke all on function public.admin_list_students() from public;
revoke all on function public.admin_set_student_active(uuid, boolean) from public;
grant execute on function public.admin_list_students() to authenticated;
grant execute on function public.admin_set_student_active(uuid, boolean) to authenticated;

create or replace function public.admin_update_student_access(target_user uuid, target_year smallint, target_disciplines text[])
returns boolean language plpgsql security definer set search_path = '' as $$
declare
  requested_count integer;
  matched_count integer;
begin
  if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active) then
    raise exception 'Acesso administrativo necessário';
  end if;
  if target_year is not null and target_year not between 1 and 3 then
    raise exception 'Ano inválido';
  end if;
  if not exists (select 1 from public.profiles p where p.id = target_user and p.role = 'aluno') then
    raise exception 'Aluno não encontrado';
  end if;
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

create index if not exists modules_discipline_order_idx on public.modules(discipline_slug, sort_order);
create index if not exists student_disciplines_discipline_idx on public.student_disciplines(discipline_slug);
create index if not exists apostilas_discipline_order_idx on public.apostilas(discipline_slug, lesson_order);
create index if not exists user_notes_owner_idx on public.user_notes(user_id);
create index if not exists lesson_progress_owner_idx on public.lesson_progress(user_id);

create or replace function public.admin_bulk_update_student_access(target_users uuid[], target_year smallint, target_disciplines text[])
returns integer language plpgsql security definer set search_path = '' as $$
declare
  requested_users integer;
  matched_users integer;
  requested_disciplines integer;
  matched_disciplines integer;
begin
  if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active) then
    raise exception 'Acesso administrativo necessário';
  end if;
  if target_year not between 1 and 3 then raise exception 'Ano inválido'; end if;
  select count(distinct id) into requested_users from unnest(coalesce(target_users, '{}'::uuid[])) as selected(id);
  select count(*) into matched_users from public.profiles p where p.id = any(coalesce(target_users, '{}'::uuid[])) and p.role = 'aluno';
  if requested_users = 0 or requested_users <> matched_users then raise exception 'Uma ou mais contas selecionadas não são alunos válidos'; end if;
  select count(distinct slug) into requested_disciplines from unnest(coalesce(target_disciplines, '{}'::text[])) as requested(slug);
  select count(*) into matched_disciplines from public.disciplines d where d.slug = any(coalesce(target_disciplines, '{}'::text[]));
  if requested_disciplines <> matched_disciplines then raise exception 'Uma ou mais disciplinas não existem'; end if;
  update public.profiles set year_level = target_year, updated_at = timezone('utc'::text, now())
    where id = any(target_users) and role = 'aluno';
  delete from public.student_disciplines where user_id = any(target_users);
  insert into public.student_disciplines (user_id, discipline_slug, assigned_by)
    select selected.id, d.slug, auth.uid()
    from unnest(target_users) as selected(id) cross join public.disciplines d
    where d.slug = any(coalesce(target_disciplines, '{}'::text[]));
  return requested_users;
end;
$$;
revoke all on function public.admin_bulk_update_student_access(uuid[], smallint, text[]) from public;
grant execute on function public.admin_bulk_update_student_access(uuid[], smallint, text[]) to authenticated;
