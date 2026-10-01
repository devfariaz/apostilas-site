-- Execute no SQL Editor do Supabase para habilitar vários atalhos por capítulo.
alter table public.apostilas
  add column if not exists shortcuts jsonb not null default '[]'::jsonb;

-- Migra os atalhos já cadastrados para o novo formato sem apagar os campos antigos.
update public.apostilas
set shortcuts = jsonb_build_array(jsonb_build_object('keys', shortcut_keys, 'label', shortcut_label))
where shortcut_keys <> '' and shortcuts = '[]'::jsonb;

-- Atalhos usados no capítulo do escudo vetorial cadastrado em Produção Multimídia I.
update public.apostilas
set shortcuts = '[
  {"keys":"M","label":"Ferramenta Retângulo"},
  {"keys":"L","label":"Ferramenta Elipse"},
  {"keys":"V","label":"Ferramenta Seleção"},
  {"keys":"Shift","label":"Manter proporções ao desenhar"},
  {"keys":"Shift + M","label":"Construtor de Formas"},
  {"keys":"Alt","label":"Subtrair áreas com o Construtor de Formas"}
]'::jsonb
where discipline_slug = 'producao-multimidia-i'
  and slug = 'o-ponto-a-linha-e-o-segredo-dos-vetores';

-- Índice para consultas futuras por tags no PostgreSQL.
create index if not exists apostilas_tags_gin_idx
  on public.apostilas using gin (tags);
