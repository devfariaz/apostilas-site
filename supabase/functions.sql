-- Funções e gatilhos da aplicação. Execute depois de schema.sql.

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

-- Criação automática do perfil. O primeiro administrador é definido na instalação.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  email_lower text := lower(coalesce(new.email, ''));
begin
  insert into public.profiles (id, email, full_name, role, is_active)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    'aluno',
    email_lower like 'rm%'
  )
  on conflict (id) do update set
    email = excluded.email,
    full_name = coalesce(excluded.full_name, public.profiles.full_name),
    is_active = public.profiles.is_active or excluded.is_active,
    updated_at = timezone('utc'::text, now());
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

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
