-- Acesso de professor eventual aos guias, sem conceder acesso administrativo.
-- Pode ser executado no SQL Editor do Supabase após o schema principal.

alter table public.profiles
  add column if not exists can_access_teacher_guides boolean not null default false;

create or replace function public.admin_list_teacher_accounts()
returns table (id uuid, email text, full_name text, created_at timestamptz)
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin' and p.is_active
  ) then
    raise exception 'Acesso administrativo necessário';
  end if;

  return query
    select p.id, p.email, p.full_name, p.created_at
    from public.profiles p
    where p.can_access_teacher_guides
    order by p.created_at asc;
end;
$$;

create or replace function public.admin_set_teacher_guide_access(target_email text, grant_access boolean)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_id uuid;
begin
  if not exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin' and p.is_active
  ) then
    raise exception 'Acesso administrativo necessário';
  end if;

  select p.id into target_id
  from public.profiles p
  where lower(p.email) = lower(btrim(target_email))
  for update;

  if target_id is null then
    return false;
  end if;
  if target_id = auth.uid() then
    raise exception 'Sua própria conta não pode ser gerenciada por esta tela';
  end if;

  update public.profiles
  set can_access_teacher_guides = grant_access,
      is_active = case when grant_access then true else is_active end,
      updated_at = timezone('utc'::text, now())
  where id = target_id and role <> 'admin';

  if not found then
    raise exception 'Administradores não são gerenciados como professores eventuais';
  end if;
  return true;
end;
$$;

revoke all on function public.admin_list_teacher_accounts() from public, anon;
revoke all on function public.admin_set_teacher_guide_access(text, boolean) from public, anon;
grant execute on function public.admin_list_teacher_accounts() to authenticated;
grant execute on function public.admin_set_teacher_guide_access(text, boolean) to authenticated;

alter table public.teacher_guides enable row level security;
drop policy if exists "Approved teachers read teacher guides" on public.teacher_guides;
create policy "Approved teachers read teacher guides" on public.teacher_guides
  for select to authenticated
  using (exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.is_active
      and (p.role = 'admin' or p.can_access_teacher_guides)
  ));

alter table public.teacher_guide_chapters enable row level security;
drop policy if exists "Approved teachers read teacher guide chapters" on public.teacher_guide_chapters;
create policy "Approved teachers read teacher guide chapters" on public.teacher_guide_chapters
  for select to authenticated
  using (exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.is_active
      and (p.role = 'admin' or p.can_access_teacher_guides)
  ));

alter table public.teacher_guide_notes enable row level security;
drop policy if exists "Teachers manage own teacher guide notes" on public.teacher_guide_notes;
create policy "Teachers manage own teacher guide notes" on public.teacher_guide_notes
  for all to authenticated
  using (
    user_id = auth.uid()
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active
      and (p.role = 'admin' or p.can_access_teacher_guides))
  )
  with check (
    user_id = auth.uid()
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active
      and (p.role = 'admin' or p.can_access_teacher_guides))
  );

drop policy if exists "Approved teachers read teacher guide files" on storage.objects;
create policy "Approved teachers read teacher guide files" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'teacher-guides'
    and exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_active
      and (p.role = 'admin' or p.can_access_teacher_guides))
  );

notify pgrst, 'reload schema';
