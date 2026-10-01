-- Atualiza os campos de ano e disciplinas devolvidos ao painel administrativo.
-- O ano é lido do perfil; as disciplinas vêm da tabela de vínculos e não são
-- usadas para inferir o ano, pois um aluno pode cursar disciplinas de anos distintos.
alter table public.profiles
  add column if not exists year_level smallint check (year_level between 1 and 3);

drop function if exists public.admin_list_students();
create function public.admin_list_students()
returns table (
  id uuid,
  email text,
  full_name text,
  is_active boolean,
  year_level smallint,
  discipline_slugs text[],
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
    select
      p.id,
      p.email,
      p.full_name,
      p.is_active,
      p.year_level,
      coalesce(
        array_agg(sd.discipline_slug order by sd.discipline_slug)
          filter (where sd.discipline_slug is not null),
        '{}'::text[]
      ),
      p.created_at
    from public.profiles p
    left join public.student_disciplines sd on sd.user_id = p.id
    where p.role = 'aluno'
    group by p.id
    order by p.is_active, p.created_at desc;
end;
$$;

revoke all on function public.admin_list_students() from public;
grant execute on function public.admin_list_students() to authenticated;
notify pgrst, 'reload schema';
