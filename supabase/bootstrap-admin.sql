-- Execute depois de criar a conta do professor no site.
-- Troque o e-mail abaixo pelo e-mail exato usado no cadastro.
update public.profiles
set role = 'admin', is_active = true, updated_at = timezone('utc'::text, now())
where lower(email) = lower('PROFESSOR_EMAIL_AQUI')
returning id, email, role, is_active;
