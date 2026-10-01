-- Adds one contextual bench tip to the first actionable step of each remaining
-- published chapter in Produção Multimídia I. Safe to rerun.
begin;

do $$
declare
  chapter record;
  current_markdown text;
  first_step text;
  step_end integer;
  changed_count integer := 0;
  expected_count constant integer := 28;
begin
  for chapter in
    select * from (values
      ('geometria-primitiva-e-o-rosto-de-um-mascote', 'Antes de unir as formas, confira se os círculos estão bem posicionados e se cada peça tem a cor certa; isso facilita corrigir o rosto sem refazer o desenho.'),
      ('percepcao-de-silhueta-e-decalque-de-acessorios', 'Use uma imagem nítida e com bom contraste. Depois de posicioná-la, bloqueie a referência para evitar selecioná-la enquanto traça o contorno.'),
      ('simetria-bilateral-e-a-forja-do-escudo-perfeito', 'Confira se a guia passa exatamente pelo centro da prancheta. Um eixo bem posicionado evita uma emenda visível quando as metades forem espelhadas.'),
      ('padroes-visuais-e-texturas-infinitas', 'Deixe um pequeno espaço entre os elementos e varie suas posições antes de criar a amostra; isso ajuda a evitar uma repetição visual muito rígida.'),
      ('a-fisica-da-luz-e-o-sombreamento-em-blocos-cel-shading', 'Defina de onde vem a luz antes de desenhar sombra e brilho. Mantenha essa direção em todas as formas para o volume parecer coerente.'),
      ('transicoes-suaves-e-escala-tonal', 'Desenhe a lâmina com uma silhueta simples antes de aplicar o degradê. Assim, você consegue avaliar melhor como as faixas de cor acompanham o formato.'),
      ('iluminacao-geometrica-o-bau-de-tesouro-3d', 'Gire o hexágono até ter um vértice no alto e outro na base; essa orientação deixa as três faces do baú mais fáceis de construir e colorir.'),
      ('cores-atmosfera-e-iluminacao-estilizada', 'Separe mentalmente céu, chão e objeto. A paleta de cada plano deve combinar com a mesma fonte de luz noturna.'),
      ('texturas-estilizadas-a-madeira-e-o-metal', 'Escolha primeiro a direção da luz. Desenhe as linhas claras ao lado iluminado dos veios escuros para que a madeira ganhe relevo.'),
      ('matematica-do-espaco-1-ponto-o-quarto-do-jogador', 'Antes de traçar paredes e chão, marque o ponto de fuga e mantenha as linhas de profundidade convergindo para ele.'),
      ('volume-interno-mobiliando-o-quarto', 'Use as linhas do piso como referência para posicionar os móveis. A base de cada objeto precisa seguir a perspectiva do quarto.'),
      ('proporcao-estilizada-o-estilo-chibi-cartoon', 'Compare cabeça e corpo em miniatura antes de adicionar detalhes. Silhuetas simples ajudam a manter a proporção Chibi consistente.'),
      ('a-alma-do-movimento-poses-de-acao', 'Prefira uma referência com gesto claro e membros visíveis. Uma linha de ação bem definida torna a pose mais expressiva.'),
      ('ancoragem-simples-o-personagem-no-espaco', 'Confira a linha do chão e o ponto de fuga antes de ajustar o personagem; os pés precisam parecer apoiados no mesmo plano do cenário.'),
      ('narrativa-visual-detalhes-que-contam-historias', 'Escolha poucos detalhes que revelem algo sobre o personagem ou o lugar. Muitos elementos competindo entre si enfraquecem a leitura da cena.'),
      ('expressoes-e-emocoes-cartoon-as-reacoes-do-heroi', 'Duplique a cabeça antes de experimentar. Alterar sobrancelhas, olhos e boca em cópias facilita comparar emoções sem perder a versão original.'),
      ('psicologia-visual-gestalt-e-o-design-subtrativo', 'Comece pela forma geral e reduza os detalhes. Se a silhueta continuar reconhecível em tamanho pequeno, a leitura visual está funcionando.'),
      ('equilibrio-visual-contraste-e-a-regra-dos-tercos', 'Ative as guias de terços e teste mais de uma posição para o elemento principal; escolha a composição que equilibra foco e espaço vazio.'),
      ('hierarquia-visual-e-notan-o-limite-preto-e-branco', 'Afaste o zoom ou reduza a arte para miniatura. Se a área principal ainda se destacar em preto e branco, a hierarquia está clara.'),
      ('apresentacao-de-portfolio-e-montagem-de-mockups', 'Deixe a arte em destaque e use o mockup apenas para dar contexto. Confira se o trabalho continua legível sem depender da apresentação.'),
      ('a-arte-de-omitir-informacao-cortes-e-tensao', 'Faça o corte conduzir o olhar ao ponto principal. Evite cortar justamente as formas que explicam a ação ou a identidade do objeto.'),
      ('linhas-guias-leading-lines-setas-invisiveis', 'Faça as linhas convergirem para o assunto principal e remova as que desviam o olhar; elas devem orientar sem competir com a cena.'),
      ('bitmap-vs-vetor-e-a-filosofia-da-pixel-art', 'Para pixel art, trabalhe com uma grade de dimensões inteiras e amplie a visualização; isso facilita perceber degraus irregulares na silhueta.'),
      ('camadas-sistema-rgb-e-o-coracao-8-bit', 'Nomeie e bloqueie a camada de fundo antes de desenhar o coração. Assim, os cliques de pintura ficam restritos ao sprite.'),
      ('hue-shifting-basico-a-moeda-reluzente', 'Mantenha a paleta curta e desloque o matiz entre sombra, base e luz. Essa variação costuma dar mais riqueza do que apenas clarear o mesmo amarelo.'),
      ('desenhando-itens-classicos-de-inventario', 'Confira se as células da grade estão fechadas antes de pintar. Uma pequena abertura no contorno pode fazer o preenchimento escapar para outras áreas.'),
      ('otimizacao-e-eficiencia-o-truque-do-palette-swap', 'Guarde uma cópia intacta da arma base antes de trocar as cores. Use a mesma estrutura de luz e sombra nas versões para comparar a evolução com clareza.'),
      ('fechando-o-inventario-organizacao-e-exportacao', 'Padronize o espaçamento e o tamanho visual dos quatro itens antes de criar as pranchetas; isso deixa o inventário alinhado e os arquivos exportados consistentes.')
    ) as entries(slug, tip)
    order by slug
  loop
    select practice_markdown into current_markdown
    from public.apostilas
    where discipline_slug = 'producao-multimidia-i'
      and slug = chapter.slug
      and published = true
    for update;

    if current_markdown is null then
      raise exception 'Capítulo publicado não encontrado: %', chapter.slug;
    end if;

    if position('DICA DE BANCADA' in current_markdown) > 0 then
      continue;
    end if;

    select line into first_step
    from unnest(string_to_array(current_markdown, E'\n')) with ordinality as lines(line, line_number)
    where line like '- **a.**%'
    order by line_number
    limit 1;

    if first_step is null then
      raise exception 'Não foi encontrado um passo inicial no capítulo: %', chapter.slug;
    end if;

    step_end := position(first_step in current_markdown) + length(first_step) - 1;
    current_markdown := substring(current_markdown from 1 for step_end)
      || E'\n\n> **DICA DE BANCADA**\n>\n> '
      || chapter.tip
      || substring(current_markdown from step_end + 1);

    update public.apostilas
    set practice_markdown = current_markdown,
        updated_at = timezone('utc'::text, now())
    where discipline_slug = 'producao-multimidia-i'
      and slug = chapter.slug;

    changed_count := changed_count + 1;
  end loop;

  if changed_count <> expected_count then
    raise exception 'Esperadas % inserções de dicas, mas foram feitas %; nenhuma alteração foi confirmada.', expected_count, changed_count;
  end if;
end $$;

commit;
