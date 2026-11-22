-- Dados auxiliares para bancos que já possuíam usuários ou atalhos antes
-- da instalação do schema sem seed. Não é necessário em um Supabase novo.

-- Cria perfis para usuários do Auth que existiam antes da instalação do gatilho.
insert into public.profiles (id, email, full_name, role, is_active)
select
  u.id,
  u.email,
  u.raw_user_meta_data ->> 'full_name',
  'aluno',
  lower(u.email) like 'rm%'
from auth.users u
where u.email is not null
on conflict (id) do update set
  email = excluded.email,
  is_active = public.profiles.is_active or excluded.is_active,
  updated_at = timezone('utc'::text, now());

-- Converte os atalhos antigos para o formato JSON usado pela interface.
update public.apostilas
set shortcuts = jsonb_build_array(jsonb_build_object('keys', shortcut_keys, 'label', shortcut_label))
where shortcut_keys <> '' and shortcuts = '[]'::jsonb;
