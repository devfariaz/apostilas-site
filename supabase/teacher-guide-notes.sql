-- Notas privadas do professor, vinculadas ao capítulo do guia e separadas das notas dos alunos.
create table if not exists public.teacher_guide_notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  chapter_id uuid not null references public.teacher_guide_chapters(id) on delete cascade,
  content text not null default '',
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now()),
  unique (user_id, chapter_id)
);

create index if not exists teacher_guide_notes_owner_idx on public.teacher_guide_notes(user_id);
alter table public.teacher_guide_notes enable row level security;
drop policy if exists "Admins manage own teacher guide notes" on public.teacher_guide_notes;
create policy "Admins manage own teacher guide notes" on public.teacher_guide_notes
  for all to authenticated
  using (
    user_id = auth.uid()
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active)
  )
  with check (
    user_id = auth.uid()
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active)
  );

drop trigger if exists teacher_guide_notes_updated_at on public.teacher_guide_notes;
create trigger teacher_guide_notes_updated_at
  before update on public.teacher_guide_notes
  for each row execute procedure public.touch_teacher_guide_updated_at();
