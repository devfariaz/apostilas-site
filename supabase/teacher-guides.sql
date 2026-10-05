-- Biblioteca privada dos guias de professor, separada das apostilas dos alunos.
create table if not exists public.teacher_guides (
  id uuid primary key default gen_random_uuid(),
  discipline_slug text not null references public.disciplines(slug) on delete cascade,
  module_id uuid not null references public.modules(id) on delete cascade,
  title text not null,
  source_filename text not null,
  storage_path text not null unique,
  page_count integer not null check (page_count > 0),
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now()),
  unique (discipline_slug, module_id)
);

create or replace function public.touch_teacher_guide_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$;

drop trigger if exists teacher_guides_updated_at on public.teacher_guides;
create trigger teacher_guides_updated_at
  before update on public.teacher_guides
  for each row execute procedure public.touch_teacher_guide_updated_at();

alter table public.teacher_guides enable row level security;
drop policy if exists "Admins manage teacher guides" on public.teacher_guides;
create policy "Admins manage teacher guides" on public.teacher_guides
  for all to authenticated
  using (exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin' and p.is_active
  ))
  with check (exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin' and p.is_active
  ));

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('teacher-guides', 'teacher-guides', false, 20971520, array['application/pdf'])
on conflict (id) do update set public = false, file_size_limit = excluded.file_size_limit, allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Admins manage teacher guide files" on storage.objects;
create policy "Admins manage teacher guide files" on storage.objects
  for all to authenticated
  using (
    bucket_id = 'teacher-guides'
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active)
  )
  with check (
    bucket_id = 'teacher-guides'
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active)
  );

insert into public.teacher_guides (discipline_slug, module_id, title, source_filename, storage_path, page_count)
select d.slug, m.id, source.title, source.source_filename, source.storage_path, source.page_count
from (values
  ('producao-multimidia-i', 'modulo-1', 'Módulo I: O Alfabeto Visual e o Pensamento Vetorial', 'MODULO1_PRODUCAOMULTIMIDIAI.pdf', 'producao-multimidia-i/modulo-1.pdf', 15),
  ('game-design-i', 'modulo-1', 'Módulo I: Concepção de Ideias, Gestão de Escopo e Foco no Jogador', 'MODULOI_GAMEDESIGNI.pdf', 'game-design-i/modulo-1.pdf', 18)
) as source(discipline_slug, module_slug, title, source_filename, storage_path, page_count)
join public.disciplines d on d.slug = source.discipline_slug
join public.modules m on m.discipline_slug = d.slug and m.slug = source.module_slug
on conflict (discipline_slug, module_id) do update set
  title = excluded.title,
  source_filename = excluded.source_filename,
  storage_path = excluded.storage_path,
  page_count = excluded.page_count,
  updated_at = timezone('utc'::text, now());
