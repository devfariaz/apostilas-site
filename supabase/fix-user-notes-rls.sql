-- Permite que a conta administrativa teste e salve notas nas apostilas.
-- Alunos continuam limitados às disciplinas atribuídas à própria conta.
alter table public.user_notes enable row level security;

drop policy if exists "Users manage own notes" on public.user_notes;
create policy "Users manage own notes" on public.user_notes
  for all to authenticated
  using (
    auth.uid() = user_id
    and exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.is_active
    )
    and (
      exists (
        select 1 from public.profiles p
        where p.id = auth.uid() and p.is_active and p.role = 'admin'
      )
      or exists (
        select 1 from public.student_disciplines sd
        where sd.user_id = auth.uid()
          and sd.discipline_slug = user_notes.disciplina_slug
      )
    )
  )
  with check (
    auth.uid() = user_id
    and exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.is_active
    )
    and (
      exists (
        select 1 from public.profiles p
        where p.id = auth.uid() and p.is_active and p.role = 'admin'
      )
      or exists (
        select 1 from public.student_disciplines sd
        where sd.user_id = auth.uid()
          and sd.discipline_slug = user_notes.disciplina_slug
      )
    )
  );

notify pgrst, 'reload schema';
