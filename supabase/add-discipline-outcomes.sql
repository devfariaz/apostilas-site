-- Execute no SQL Editor do Supabase para guardar a apresentação e os resultados
-- de aprendizagem de cada disciplina.
alter table public.disciplines
  add column if not exists skills text[] not null default '{}',
  add column if not exists competencies text[] not null default '{}';
