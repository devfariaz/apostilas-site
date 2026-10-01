-- Acrescenta dicas no passo a passo do primeiro capítulo da Produção Multimídia I.
-- Seguro para reexecução: não duplica as dicas se já estiverem presentes.
begin;
do $$
declare
  current_markdown text;
begin
  select practice_markdown into current_markdown
  from public.apostilas
  where discipline_slug = 'producao-multimidia-i'
    and slug = 'o-ponto-a-linha-e-o-segredo-dos-vetores'
  for update;

  if current_markdown is null then
    raise exception 'Capítulo não encontrado: o-ponto-a-linha-e-o-segredo-dos-vetores';
  end if;

  if position('DICA DE BANCADA' in current_markdown) > 0 then
    raise notice 'O capítulo já contém dicas de bancada; nenhuma alteração foi feita.';
    return;
  end if;

  if position('- **e.** Segure a tecla Shift no teclado' in current_markdown) = 0
    or position('- **e.** Solte o mouse: o Illustrator solda as duas peças' in current_markdown) = 0
    or position('- **f.** Com o Alt apertado, dê um clique' in current_markdown) = 0
    or position('- **d.** Clique na caixinha de Traçado (Stroke)' in current_markdown) = 0 then
    raise exception 'O texto esperado do passo a passo não foi encontrado; nenhuma alteração foi feita.';
  end if;

  current_markdown := replace(current_markdown,
    '- **e.** Segure a tecla Shift no teclado (ela funciona como uma trava para não deixar a forma achatar), clique e arraste para desenhar um círculo perfeito com cerca de 400 px de diâmetro.',
    '- **e.** Segure a tecla Shift no teclado (ela funciona como uma trava para não deixar a forma achatar), clique e arraste para desenhar um círculo perfeito com cerca de 400 px de diâmetro.' || E'\n\n> **DICA DE BANCADA**\n>\n> Pressione Shift enquanto desenha para manter a mesma largura e altura e formar um círculo perfeito.');
  current_markdown := replace(current_markdown,
    '- **e.** Solte o mouse: o Illustrator solda as duas peças na hora, transformando-as em uma única silhueta lisa de escudo!',
    '- **e.** Solte o mouse: o Illustrator solda as duas peças na hora, transformando-as em uma única silhueta lisa de escudo!' || E'\n\n> **DICA DE BANCADA**\n>\n> Arraste sobre todas as regiões que devem fazer parte do escudo; o Construtor de Formas une as áreas selecionadas.');
  current_markdown := replace(current_markdown,
    '- **f.** Com o Alt apertado, dê um clique na parte do círculo que invade o escudo: ela vai cortar a lateral como se fosse uma mordida ou um corte de navalha.',
    '- **f.** Com o Alt apertado, dê um clique na parte do círculo que invade o escudo: ela vai cortar a lateral como se fosse uma mordida ou um corte de navalha.' || E'\n\n> **DICA DE BANCADA**\n>\n> Sem Alt, o Construtor de Formas une as peças. Com Alt pressionado, ele subtrai a região clicada.');
  current_markdown := replace(current_markdown,
    '- **d.** Clique na caixinha de Traçado (Stroke) logo atrás e selecione o quadradinho branco com o risco diagonal vermelho para desativar a borda preta.',
    '- **d.** Clique na caixinha de Traçado (Stroke) logo atrás e selecione o quadradinho branco com o risco diagonal vermelho para desativar a borda preta.' || E'\n\n> **DICA DE BANCADA**\n>\n> O preenchimento define a cor interna da forma; o traçado controla a linha ao redor dela.');

  update public.apostilas
  set practice_markdown = current_markdown,
      updated_at = timezone('utc'::text, now())
  where discipline_slug = 'producao-multimidia-i'
    and slug = 'o-ponto-a-linha-e-o-segredo-dos-vetores';
end $$;
commit;
