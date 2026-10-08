-- Funções seguras para listar e gerenciar administradores pelo painel Astro.
-- Execute uma vez no Supabase SQL Editor antes de usar a guia Administradores.

create or replace function public.admin_list_administrators()
returns table (
  id uuid,
  email text,
  full_name text,
  created_at timestamptz
)
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
    where p.role = 'admin'
    order by p.created_at asc;
end;
$$;

create or replace function public.admin_set_administrator(target_email text, make_admin boolean)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  target_id uuid;
  target_role text;
  target_active boolean;
  active_admin_count integer;
begin
  if not exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin' and p.is_active
  ) then
    raise exception 'Acesso administrativo necessário';
  end if;

  select p.id, p.role, p.is_active
    into target_id, target_role, target_active
    from public.profiles p
    where lower(p.email) = lower(btrim(target_email))
    for update;

  if target_id is null then
    return false;
  end if;

  if make_admin then
    update public.profiles
      set role = 'admin', is_active = true, updated_at = timezone('utc'::text, now())
      where id = target_id;
    return true;
  end if;

  if target_role <> 'admin' then
    return true;
  end if;
  if target_id = auth.uid() then
    raise exception 'Você não pode remover seu próprio acesso administrativo';
  end if;

  if target_active then
    select count(*) into active_admin_count
      from public.profiles p
      where p.role = 'admin' and p.is_active;
    if active_admin_count <= 1 then
      raise exception 'O último administrador ativo não pode ser removido';
    end if;
  end if;

  update public.profiles
    set role = 'aluno', updated_at = timezone('utc'::text, now())
    where id = target_id;
  return true;
end;
$$;

revoke all on function public.admin_list_administrators() from public, anon;
revoke all on function public.admin_set_administrator(text, boolean) from public, anon;
grant execute on function public.admin_list_administrators() to authenticated;
grant execute on function public.admin_set_administrator(text, boolean) to authenticated;

notify pgrst, 'reload schema';
