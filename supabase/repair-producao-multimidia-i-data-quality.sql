-- Repara inconsistências identificadas na revisão dos registros de Produção Multimídia I.
-- Mantém, entre itens essenciais repetidos, a descrição mais completa.
with ranked as (
  select
    a.id,
    item.value as point,
    item.ordinality,
    row_number() over (
      partition by a.id, lower(btrim(item.value->>'title'))
      order by length(coalesce(item.value->>'description', '')) desc, item.ordinality
    ) as duplicate_rank
  from public.apostilas a
  cross join lateral jsonb_array_elements(a.essential_points) with ordinality as item(value, ordinality)
  where a.discipline_slug = 'producao-multimidia-i'
), deduped as (
  select id, jsonb_agg(point order by ordinality) as points
  from ranked
  where duplicate_rank = 1
  group by id
)
update public.apostilas a
set essential_points = d.points,
    updated_at = timezone('utc'::text, now())
from deduped d
where a.id = d.id
  and jsonb_array_length(a.essential_points) > jsonb_array_length(d.points);

-- Este capítulo tinha a seção “O essencial” vazia, apesar de a teoria e a prática
-- cobrirem bitmap, vetor e pixel art.
update public.apostilas
set essential_points = '[
  {"title":"Bitmap (Raster)","description":"Imagem formada por uma grade de pixels; ao ampliar além da resolução original, perde nitidez e pode ficar serrilhada."},
  {"title":"Vetor","description":"Imagem descrita por coordenadas e curvas matemáticas, que pode ser redimensionada sem perder definição."},
  {"title":"Pixel Art","description":"Estilo que usa pixels visíveis de forma intencional, com atenção à leitura da silhueta e à organização dos degraus."},
  {"title":"Matriz 16 × 16","description":"Uma grade limitada exige escolhas precisas: cada pixel precisa contribuir para a forma e a leitura do ícone."}
]'::jsonb,
    updated_at = timezone('utc'::text, now())
where discipline_slug = 'producao-multimidia-i'
  and slug = 'bitmap-vs-vetor-e-a-filosofia-da-pixel-art'
  and essential_points = '[]'::jsonb;

-- Sincroniza atalhos que já estavam citados nos passos práticos, mas não no
-- campo usado pelo painel “Atalhos da aula” e pelo formulário administrativo.
update public.apostilas as a
set shortcuts = source.shortcuts::jsonb,
    updated_at = timezone('utc'::text, now())
from (values
  ('padroes-visuais-e-texturas-infinitas', '[{"keys":"L","label":"Ferramenta Elipse"},{"keys":"V","label":"Ferramenta Seleção"},{"keys":"M","label":"Ferramenta Retângulo"},{"keys":"S","label":"Ferramenta Escala"},{"keys":"~","label":"Redimensionar a textura sem alterar a forma"}]'),
  ('volume-interno-mobiliando-o-quarto', '[{"keys":"M","label":"Ferramenta Retângulo"},{"keys":"P","label":"Ferramenta Caneta"},{"keys":"C","label":"Ferramenta Tesoura"}]'),
  ('apresentacao-de-portfolio-e-montagem-de-mockups', '[{"keys":"M","label":"Ferramenta Retângulo"},{"keys":"P","label":"Ferramenta Caneta"},{"keys":"L","label":"Ferramenta Elipse"}]'),
  ('camadas-sistema-rgb-e-o-coracao-8-bit', '[{"keys":"F7","label":"Abrir o painel Camadas"},{"keys":"M","label":"Ferramenta Retângulo"},{"keys":"Alt + Ctrl + X","label":"Criar Pintura em Tempo Real"},{"keys":"K","label":"Balde de Pintura em Tempo Real"},{"keys":"V","label":"Ferramenta Seleção"}]'),
  ('hue-shifting-basico-a-moeda-reluzente', '[{"keys":"Alt + Ctrl + X","label":"Criar Pintura em Tempo Real"},{"keys":"K","label":"Balde de Pintura em Tempo Real"},{"keys":"V","label":"Ferramenta Seleção"}]'),
  ('desenhando-itens-classicos-de-inventario', '[{"keys":"Alt + Ctrl + X","label":"Criar Pintura em Tempo Real"},{"keys":"K","label":"Balde de Pintura em Tempo Real"},{"keys":"V","label":"Ferramenta Seleção"}]')
) as source(slug, shortcuts)
where a.discipline_slug = 'producao-multimidia-i'
  and a.slug = source.slug
  and a.shortcuts = '[]'::jsonb;

-- Padroniza um título que estava com barra e espaçamento pouco claros.
update public.apostilas
set title = 'Proporção Estilizada: Personagem Chibi (Cartoon)',
    updated_at = timezone('utc'::text, now())
where discipline_slug = 'producao-multimidia-i'
  and slug = 'proporcao-estilizada-o-estilo-chibi-cartoon'
  and title = 'Proporção Estilizada: O Estilo Chibi / Cartoon';
