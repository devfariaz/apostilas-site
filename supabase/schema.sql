-- Estrutura inicial do banco da plataforma de apostilas. Sem dados de seed.
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
create index if not exists apostilas_tags_gin_idx on public.apostilas using gin(tags);

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
create policy "Users manage own notes" on public.user_notes for all to authenticated
  using (auth.uid() = user_id and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active)
    and (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active and p.role = 'admin')
      or exists (select 1 from public.student_disciplines sd where sd.user_id = auth.uid() and sd.discipline_slug = user_notes.disciplina_slug)))
  with check (auth.uid() = user_id and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active)
    and (exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active and p.role = 'admin')
      or exists (select 1 from public.student_disciplines sd where sd.user_id = auth.uid() and sd.discipline_slug = user_notes.disciplina_slug)));
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
create index if not exists modules_discipline_order_idx on public.modules(discipline_slug, sort_order);
create index if not exists student_disciplines_discipline_idx on public.student_disciplines(discipline_slug);
create index if not exists apostilas_discipline_order_idx on public.apostilas(discipline_slug, lesson_order);
create index if not exists user_notes_owner_idx on public.user_notes(user_id);
create index if not exists lesson_progress_owner_idx on public.lesson_progress(user_id);
