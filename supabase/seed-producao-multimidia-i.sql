-- Importação da apostila Produção Multimídia I (5 módulos, 29 capítulos).
-- Gerado a partir do PDF fornecido. Execute no Supabase SQL Editor.
-- A operação é idempotente: completa o esquema editorial, reutiliza módulos existentes e atualiza capítulos pelos slugs.
begin;

alter table public.apostilas add column if not exists module_id uuid references public.modules(id) on delete set null;
alter table public.apostilas add column if not exists module text not null default '';
alter table public.apostilas add column if not exists lesson_order integer not null default 0;
alter table public.apostilas add column if not exists summary text not null default '';
alter table public.apostilas add column if not exists tags text[] not null default '{}';
alter table public.apostilas add column if not exists body_markdown text not null default '';
alter table public.apostilas add column if not exists practice_markdown text not null default '';
alter table public.apostilas add column if not exists reading_minutes integer not null default 10;
alter table public.apostilas add column if not exists difficulty text not null default 'Introdutório';
alter table public.apostilas add column if not exists key_idea text not null default '';
alter table public.apostilas add column if not exists essential_points jsonb not null default '[]'::jsonb;
alter table public.apostilas add column if not exists shortcut_keys text not null default '';
alter table public.apostilas add column if not exists shortcut_label text not null default '';
alter table public.apostilas add column if not exists shortcuts jsonb not null default '[]'::jsonb;
alter table public.apostilas add column if not exists published boolean not null default true;
alter table public.apostilas add column if not exists updated_at timestamptz not null default timezone('utc'::text, now());

insert into public.disciplines (slug, name, description, sort_order, active)
values ('producao-multimidia-i', 'Produção Multimídia I', 'Linguagens e ferramentas multimídia', 3, true)
on conflict (slug) do update set name = excluded.name, active = true, updated_at = timezone('utc'::text, now());

do $$
declare
  module_row record;
  module_id uuid;
begin
  for module_row in select * from (values
    ('modulo-1', 'Módulo 1: O Alfabeto Visual e o Pensamento Vetorial', 1),
    ('modulo-2', 'Módulo 2: Luz, Sombra e a Ilusão do Volume', 2),
    ('modulo-3', 'Módulo 3: O Espaço Tridimensional e a Figura no Cenário', 3),
    ('modulo-4', 'Módulo 4: Composição, Psicologia Visual e Narrativa da Câmera', 4),
    ('modulo-5', 'Módulo 5: Arte Digital, Teoria da Cor e Pixel Art Vetorial', 5)
  ) as rows(slug, name, sort_order)
  loop
    select id into module_id from public.modules
    where discipline_slug = 'producao-multimidia-i' and (slug = module_row.slug or lower(regexp_replace(name, '^Módulo[[:space:]]+[^:]+:[[:space:]]*', '', 'i')) = lower(regexp_replace(module_row.name, '^Módulo[[:space:]]+[^:]+:[[:space:]]*', '', 'i')) or sort_order = module_row.sort_order)
    order by (slug = module_row.slug) desc, (lower(regexp_replace(name, '^Módulo[[:space:]]+[^:]+:[[:space:]]*', '', 'i')) = lower(regexp_replace(module_row.name, '^Módulo[[:space:]]+[^:]+:[[:space:]]*', '', 'i'))) desc, (sort_order = module_row.sort_order) desc limit 1 for update;
    if module_id is null then
      insert into public.modules (discipline_slug, slug, name, sort_order) values ('producao-multimidia-i', module_row.slug, module_row.name, module_row.sort_order) returning id into module_id;
    else
      update public.modules set slug = module_row.slug, name = module_row.name, sort_order = module_row.sort_order, updated_at = timezone('utc'::text, now()) where id = module_id;
    end if;
  end loop;
end $$;

with source (discipline_slug, module_slug, slug, title, lesson_order, summary, tags, body_markdown, practice_markdown, reading_minutes, difficulty, key_idea, essential_points, shortcuts) as (
  values
    ('producao-multimidia-i', 'modulo-1', 'o-ponto-a-linha-e-o-segredo-dos-vetores', 'O Ponto, a Linha e o Segredo dos Vetores', 0, 'A Semente, o Rastro e a Filosofia Lego', ARRAY['ponto', 'linha', 'segredo', 'vetores', 'illustrator', 'arte digital', 'design visual']::text[], 'Quando você olha para o design de uma skin de jogo, um logotipo famoso ou a interface de um app no celular, parece que tudo aquilo foi desenhado com um passe de mágica. Só que no computador ninguém cria arte dando rabisco aleatório. O design digital funciona com lógica pura e blocos de construção. Um artista russo chamado Wassily Kandinsky, professor na famosa escola Bauhaus, explicou isso usando uma ideia muito visual: o ponto é a semente, e a linha é o ponto que resolveu dar um passeio.

- O Ponto: É o clique seco, a semente parada no lugar. Ele marca uma coordenada exata na tela.

- A Linha: É o rastro que o ponto deixa quando ganha velocidade e direção.

O modo como essa linha se movimenta mexe direto com as nossas emoções:

- Linhas retas (horizontais e verticais): Passam calma, equilíbrio e segurança — igual à linha reta do mar calmo ou às colunas de uma parede firme.

- Linhas diagonais e quebradas: Passam urgência, perigo e adrenalina — pensa no desenho de um raio caindo ou no zigue-zague de um batimento cardíaco acelerado.

Mais tarde, outro pintor chamado Paul Cézanne mostrou que você não precisa se desesperar para desenhar coisas difíceis, porque tudo no mundo pode ser reduzido a formas simples: quadrados, círculos e cones. No Illustrator, chamamos isso de Filosofia Lego: você não tenta desenhar um escudo ou uma nave de uma vez só. Você empilha círculos e retângulos perfeitos e depois junta ou corta essas peças. E o melhor: aqui nós trabalhamos com Vetores. Diferente de uma foto que você pega na internet e que fica toda borrada e pixelada quando dá zoom, o vetor é matemática pura calculada pelo computador. Você pode esticar o seu desenho do tamanho de uma figurinha de WhatsApp até o tamanho de um outdoor gigante de prédio que ele não perde nem um pingo de nitidez.', '## Criando o Ícone de um Escudo de Super-Herói

Abra o Illustrator para criar um escudo heróico combinando blocos geométricos, fusões e cortes inteligentes.

### Passo 1: Preparando a Prancheta

- **a.** Abra o Adobe Illustrator.

- **b.** Clique no botão Criar Novo (Create New).

- **c.** Na barra de categorias superior, clique na opção Web.

- **d.** No painel à direita, defina a largura em 1920 px e a altura em 1080 px.

- **e.** Deixe a orientação marcada em Paisagem (horizontal) e clique no botão azul Criar.

### Passo 2: Construindo a Base com Formas Perfeitas

- **a.** Vá na barra de ferramentas à esquerda e selecione a Ferramenta Retângulo (Atalho: letra M).

- **b.** Dê um clique simples na prancheta para abrir a janela de medidas.

- **c.** Digite 400 px de largura por 500 px de altura e clique em OK.

- **d.** Volte na barra de ferramentas, clique e segure sobre a ferramenta do Retângulo para abrir as outras opções e escolha a Ferramenta Elipse (Atalho: letra L).

- **e.** Segure a tecla Shift no teclado (ela funciona como uma trava para não deixar a forma achatar), clique e arraste para desenhar um círculo perfeito com cerca de 400 px de diâmetro.

- **f.** Pegue a Ferramenta Seleção (a Seta Preta - Atalho: letra V).

- **g.** Clique no círculo e arraste-o até cobrir a metade inferior do retângulo, formando a curva da base do escudo.

> **DICA DE BANCADA**
>
> Pressione Shift enquanto desenha para manter a mesma largura e altura e formar um círculo perfeito.

### Passo 3: A Mágica do Construtor de Formas

- **a.** Com a Seta Preta (V), clique fora das figuras e arraste uma caixa de seleção por cima de tudo para selecionar o retângulo e o círculo ao mesmo tempo.

- **b.** Ative a ferramenta Construtor de Formas (Shape Builder Tool - Atalho: Shift + M).

- **c.** Passe o mouse por cima das peças: você verá uma malha cinza pontilhada cobrindo as áreas.

- **d.** Clique no retângulo e, sem soltar o botão do mouse, arraste o traço até entrar no círculo.

- **e.** Solte o mouse: o Illustrator solda as duas peças na hora, transformando-as em uma única silhueta lisa de escudo!

> **DICA DE BANCADA**
>
> Arraste sobre todas as regiões que devem fazer parte do escudo; o Construtor de Formas une as áreas selecionadas.

### Passo 4: Esculpindo com a Tecla Alt (Subtração)

- **a.** Pegue a Ferramenta Elipse (L) e desenhe outro círculo menor na tela.

- **b.** Com a Seta Preta (V), arraste esse círculo menor e coloque-o em cima de uma das bordas laterais do escudo.

- **c.** Selecione o escudo e esse círculo juntos com a Seta Preta (V).

- **d.** Ative o Construtor de Formas (Shift + M).

- **e.** Segure a tecla Alt no teclado (o cursor vai ganhar um sinal de menos -, avisando que entrou em modo de corte).

- **f.** Com o Alt apertado, dê um clique na parte do círculo que invade o escudo: ela vai cortar a lateral como se fosse uma mordida ou um corte de navalha.

> **DICA DE BANCADA**
>
> Sem Alt, o Construtor de Formas une as peças. Com Alt pressionado, ele subtrai a região clicada.

### Passo 5: Colorindo o Escudo

- **a.** Selecione a forma final com a Seta Preta (V).

- **b.** Na barra de ferramentas à esquerda (ou no menu superior), dê um clique duplo na caixinha de Preenchimento (Fill).

- **c.** Escolha uma cor sólida vibrante (como Vermelho ou Azul Marinho) e confirme no OK.

- **d.** Clique na caixinha de Traçado (Stroke) logo atrás e selecione o quadradinho branco com o risco diagonal vermelho para desativar a borda preta.

> **DICA DE BANCADA**
>
> O preenchimento define a cor interna da forma; o traçado controla a linha ao redor dela.', 6, 'Introdutório', '', '[{"title":"Ponto e Linha","description":"O ponto é a semente parada; a linha é o rastro da semente em movimento."},{"title":"Psicologia das Linhas","description":"Retas trazem calma e estabilidade; diagonais e quebradas trazem tensão e movimento."},{"title":"Filosofia Lego","description":"Não desenhe no desespero; quebre qualquer desenho complexo em blocos geométricos fáceis."},{"title":"Vetor","description":"Imagem calculada por fórmulas matemáticas; pode aumentar o quanto quiser sem perder definição."},{"title":"Trava do Shift","description":"Manter a tecla pressionada ao criar formas garante quadrados e círculos perfeitos."},{"title":"Construtor de Formas (Shift + M)","description":"Arrastar normal une as peças; arrastar segurando Alt corta e apaga pedaços indesejados."}]'::jsonb, '[{"keys":"Shift + M","label":"Construtor de Formas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-1', 'geometria-primitiva-e-o-rosto-de-um-mascote', 'Geometria Primitiva e o Rosto de um Mascote', 1, 'A Psicologia das Formas e o Esqueleto do Personagem', ARRAY['geometria', 'primitiva', 'rosto', 'mascote', 'illustrator', 'arte digital', 'design visual']::text[], 'Sabe quando você bate o olho em um personagem de game ou animação e, em menos de um segundo, já sabe se ele é o herói gente boa ou o vilão perigoso? Isso não acontece por acaso. O nosso cérebro reage de forma automática à geometria básica. Na comunicação visual, cada forma geométrica passa uma sensação diferente:

- O Círculo: Como não tem pontas ou quinas afiadas, ele transmite proteção, fofura, infância e amizade. É a base de personagens queridos e amigáveis, como o Mickey Mouse ou o Kirby.

- O Quadrado: Passa a sensação de peso, estabilidade, lógica e força bruta. É a forma padrão para criar robôs resistentes, armaduras pesadas e blocos de cenário.

- O Triângulo: Como aponta para uma direção específica e tem arestas pontiagudas, ele gera alerta, dinamismo ou perigo.

Preste atenção nos vilões e monstros dos desenhos: a maioria tem queixo fino, olhos triangulares, chifres e espinhos. O segredo de estúdios profissionais para criar um mascote incrível não é sair riscando a tela à mão livre tentando adivinhar as curvas da bochecha ou da orelha. O artista cria primeiro o "esqueleto" com grandes blocos geométricos primitivos (círculos e quadrados), organizando os volumes do rosto antes de pensar em qualquer detalhe de acabamento.', '## Montando o Rosto de um Urso Mascote

Siga as etapas abaixo para construir o rosto de um mascote do zero utilizando formas geométricas, sobreposição de camadas e unificação.

### Passo 1: A Cabeça (Círculo Base)

- **a.** Na barra de ferramentas à esquerda, ative a Ferramenta Elipse (Atalho: tecla L).

- **b.** Segure a tecla Shift, clique na tela e arraste para desenhar um círculo perfeito de tamanho médio.

- **c.** No painel de cores ou na barra superior, escolha um tom de Marrom Médio para o preenchimento.

### Passo 2: As Orelhas e a Sobreposição de Planos

- **a.** Ainda com a Ferramenta Elipse (L), segure o Shift e desenhe um círculo menor em uma área livre para ser a orelha.

- **b.** Com o círculo pequeno selecionado, pressione Ctrl + C para copiar e depois Ctrl + V para colar a segunda orelha idêntica.

- **c.** Ative a Ferramenta Seleção (Seta Preta - Atalho: tecla V).

- **d.** Arraste uma das orelhas para o canto superior esquerdo da cabeça e a outra para o canto superior direito.

- **e.** Com a Seta Preta (V), selecione as duas orelhas segurando Shift.

- **f.** Clique com o botão direito do mouse em cima de uma delas e vá em: Organizar > Enviar para Trás (Arrange > Send to Back). As orelhas ficarão escondidas atrás da cabeça.

### Passo 3: O Focinho e o Nariz

- **a.** Pegue a Ferramenta Elipse (L).

- **b.** Desta vez, não segure a tecla Shift: clique e arraste livremente para desenhar uma forma oval horizontal (mais larga do que alt a).

- **c.** Pinte essa elipse com um tom de Bege Claro.

- **d.** Com a Seta Preta (V), posicione o focinho oval sobre a metade inferior do círculo da cabeça.

- **e.** Vá na barra de ferramentas, clique e segure na ferramenta Retângulo para abrir o menu oculto e escolha a Ferramenta Polígono.

- **f.** Dê um clique simples na tela; na janela que surgir, digite Lados: 3 e confirme em OK para gerar um triângulo.

- **g.** Com a Seta Preta (V), aproxime o mouse de uma das quinas da caixa de seleção até a seta virar um ícone curvo. Gire o triângulo de ponta-cabeça, deixando a ponta virada para baixo.

- **h.** Pinte o triângulo de Preto e posicione-o no centro do focinho bege para formar o nariz.

### Passo 4: Os Olhos Perfeitos e o Agrupamento

- **a.** Com a Ferramenta Elipse (L), segure a tecla Shift e crie um pequeno círculo preto para a pupila do olho.

- **b.** Desenhe outro círculo bem pequenininho, pinte de branco e posicione-o no canto de dentro da pupila para fazer o ponto de brilho do olhar.

- **c.** Com a Seta Preta (V), selecione o círculo preto e o brilho branco juntos.

- **d.** Pressione o atalho Ctrl + G (Group) para agrupar as duas peças em um único bloco.

- **e.** Posicione o olho na lateral do rosto. Em seguida, segure a tecla Alt no teclado, clique e arraste o olho para o outro lado: o Illustrator soltará uma cópia duplicada idêntica com o mesmo brilho alinhado.

### Passo 5: Unificação da Estrutura

- **a.** Com a Seta Preta (V), clique e arraste pegando o círculo principal da cabeça e as duas orelhas de trás.

- **b.** Ative o Construtor de Formas (Atalho: Shift + M).

- **c.** Clique na cabeça e passe o mouse cruzando por cima das orelhas. Ao soltar, a cabeça e as orelhas se fundem em uma peça única e contínua de vetor!', 5, 'Introdutório', '', '[{"title":"Psicologia das Formas","description":"Círculos transmitem simpatia e fofura; quadrados passam força e estabilidade; triângulos geram alerta, velocidade e perigo."},{"title":"Construção por Blocos","description":"Nunca tente desenhar o contorno final de primeira; estruture personagens empilhando formas geométricas básicas."},{"title":"Organizar (Enviar para Trás)","description":"Permite mudar a ordem de empilhamento das formas, jogando partes como orelhas e asas para trás da base."},{"title":"Atalho Ctrl + G","description":"Agrupa dois ou mais objetos para que eles se movam e sejam editados como uma única peça."},{"title":"Duplicação Rápida (Alt + Arrastar)","description":"Segurar a tecla Alt enquanto move um elemento cria uma cópia instantânea sem precisar de Ctrl+C e Ctrl+V."}]'::jsonb, '[{"keys":"Ctrl + G","label":"Agrupar objetos"},{"keys":"Ctrl + C","label":"Copiar objeto"},{"keys":"Ctrl + V","label":"Colar objeto"},{"keys":"Shift + M","label":"Construtor de Formas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-1', 'percepcao-de-silhueta-e-decalque-de-acessorios', 'Percepção de Silhueta e Decalque de Acessórios', 2, 'O Cérebro Preguiçoso, os Símbolos e o Espaço Negativo', ARRAY['percepção', 'silhueta', 'decalque', 'acessórios', 'illustrator', 'arte digital', 'design visual']::text[], 'Já reparou que quando alguém pede para você desenhar um olho rápido sem olhar para nada, você quase sempre faz uma forma de amêndoa com uma bolinha no meio? Ou quando pedem uma casa, sai um quadrado com um triângulo em cima? Isso acontece porque o nosso cérebro adora economizar bateria. A pesquisadora de arte Betty Edwards, autora do livro Desenhando com o Lado Direito do Cérebro, explica que a nossa mente cria uma espécie de "pasta de atalhos cheia de símbolos" para reconhecer o mundo sem esforço. O problema é que, para quem cria arte e design no computador, esse símbolo mental não serve: se você tentar ilustrar um carro ou um acessório usando o símbolo que tem guardado na cabeça, ele vai ficar parecendo um desenho infantil. O profissional precisa "hackear" os próprios olhos e desligar o nome do objeto. Você não pensa: "Estou desenhando um óculos maneiro". Você pensa: "Estou acompanhando uma linha reta que desce, faz uma curva aberta e fecha na base". Você foca apenas na Silhueta — na fronteira exata que separa o objeto do resto do universo. E para não deixar o cérebro te enganar, existe o truque do Espaço Negativo: o ar ou o vazio que fica ao redor da peça. Como a nossa mente não tem nenhum "símbolo" salvo para o vazio, quando você se concentra em desenhar as formas do ar em volta do objeto, a proporção real dele aparece na tela perfeitamente.', '## Decalque Estruturado de um Óculos de Sol Retrô

Siga o passo a passo para capturar a silhueta real de um acessório usando imagem de apoio, cliques secos de caneta e ajustes com a ferramenta Curvatura.

### Passo 1: Importando e Bloqueando a Referência

- **a.** No menu superior, vá em Arquivo > Inserir (File > Place).

- **b.** Escolha a foto de um óculos de sol (ou outro acessório, como boné ou fone) no seu computador e dê um clique na prancheta para posicioná-la.

- **c.** Com a foto selecionada pela Seta Preta (V), aperte o atalho Ctrl + 2 (ou vá no menu Objeto > Bloquear > Seleção).

- **d.** A foto ficará travada na prancheta, impedindo que ela se mexa ou seja arrastada por engano enquanto você desenha por cima.

### Passo 2: Configurando as Cores de Trabalho

- **a.** Olhe para a base da barra de ferramentas à esquerda, onde ficam os dois quadrados de cor.

- **b.** Clique na caixa de Preenchimento (Fill) e clique no ícone [Nenhum] (o quadradinho branco com risco vermelho diagonal). O miolo precisa ficar transparente para você conseguir enxergar a foto por baixo.

- **c.** Clique na caixa de Traçado (Stroke) e escolha uma cor vibrante que se destaque bem da imagem (como Verde- Fluorescente ou Magenta).

- **d.** Na barra de controle superior, ajuste a espessura da linha para 2 pt ou 3 pt para que o traço fique bem nítido.

### Passo 3: Decalcando a Borda com Precisão (Apenas Cliques)

- **a.** Selecione a Ferramenta Caneta (Atalho: tecla P).

- **b.** Atenção: não clique e arraste para tentar fazer curvas agora. Faça apenas cliques simples e secos acompanhando os cantos e quebras da armação do óculos.

- **c.** Vá contornando toda a parte de fora da silhueta, conectando linhas retas de um canto para o outro.

- **d.** Para terminar, dê o último clique exatamente em cima do primeiro quadradinho azul onde você começou. O Illustrator fechará o contorno.

### Passo 4: Curvando as Arestas com a Ferramenta Curvatura

- **a.** Na barra de ferramentas, selecione a Ferramenta Curvatura (Curvature Tool - Atalho: Shift + ~), que fica logo ao lado da Caneta.

- **b.** Aproxime o cursor do meio de uma linha reta do seu traçado, clique e puxe suavemente para fora.

- **c.** A reta se transformará em uma curva suave, colando na curvatura da lente e da armação da foto.

- **d.** Repita esse processo de puxar o meio das linhas nos outros lados até que todo o contorno abrace a referência.

### Passo 5: Revelando a Silhueta Final

- **a.** Destrave a imagem de referência usando o atalho Ctrl + Alt + 2.

- **b.** Com a Seta Preta (V), clique na foto de fundo e pressione a tecla Delete no teclado.

- **c.** Clique no contorno vetorial que sobrou na tela e pressione o atalho Shift + X.

- **d.** O Illustrator inverterá as propriedades: o traçado colorido sumirá e o miolo será preenchido com cor sólida preta, revelando a silhueta finalizada com acabamento limpo!', 5, 'Introdutório', '', '[{"title":"O Erro do Símbolo","description":"Desenhar de cabeça ativa atalhos e símbolos infantis da memória; o trabalho profissional exige desenhar a geometria real do que você vê."},{"title":"Espaço Negativo","description":"O vazio e o ar ao redor do objeto; desenhar as formas desse vazio ajuda a acertar as proporções reais da peça."},{"title":"Traçado Ativo e Preenchimento Vazio","description":"Configuração essencial para decalcagem, permitindo ver a imagem de referência sem cobrir os detalhes."},{"title":"Atalhos de Trava (Ctrl + 2 e Ctrl + Alt + 2)","description":"Ctrl + 2 congela a foto na tela para desenhar com segurança; Ctrl + Alt + 2 solta tudo para apagar a referência."},{"title":"Inverter Preenchimento e Traçado (Shift + X)","description":"Transforma a linha de contorno em preenchimento sólido instantaneamente."}]'::jsonb, '[{"keys":"Ctrl + Alt + 2","label":"Desbloquear tudo"},{"keys":"Ctrl + 2","label":"Bloquear seleção"},{"keys":"Shift + X","label":"Inverter preenchimento e traçado"},{"keys":"Shift + ~","label":"Ferramenta Curvatura"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-1', 'simetria-bilateral-e-a-forja-do-escudo-perfeito', 'Simetria Bilateral e a Forja do Escudo Perfeito', 3, 'O Espelho da Mente e a Lei da Metade', ARRAY['simetria', 'bilateral', 'forja', 'escudo', 'perfeito', 'illustrator', 'arte digital', 'design visual']::text[], 'Já parou para pensar por que o design de um carro desportivo, a armadura de um herói ou até as asas de uma borboleta chamam logo a nossa atenção? A resposta está na forma como o nosso cérebro processa o mundo: ele procura padrões constantemente e adora encontrar ordem. Quando o olhar encontra algo perfeitamente equilibrado, a mente relaxa e lê aquela imagem como estável, forte e agradável. No design e na produção de jogos, usamos a Simetria para criar esse equilíbrio visual:

- Simetria Bilateral: Funciona como um espelho perfeito, onde o lado esquerdo é a cópia idêntica do lado direito. Transmite segurança, firmeza, postura e poder. É a base para desenhar capacetes, rostos vistos de frente, espadas, naves espaciais e escudos medievais.

- Simetria Radial: As formas não se dividem em direita e esquerda; elas nascem de um único ponto central e espalham-se em círculos, como rodas de veículos, miras de mira telescópica, runas e círculos mágicos de invocação.

A regra de ouro de qualquer artista vetorial experiente é simples: se um objeto é simétrico, você nunca desenha os dois lados à mão. Se tentar traçar o lado direito e depois o lado esquerdo no olho, uma das metades vai ficar torta ou descompensada. O profissional desenha apenas a metade e deixa o computador calcular a outra parte com exatidão matemática.', '## Desenhando Metade de um Escudo Medieval e Espelhando no Eixo

Abra o Illustrator para construir um escudo simétrico desenhando somente uma das faces e aplicando o espelhamento vetorial com solda.

### Passo 1: Criando o Eixo Guia Central

- **a.** Abra o Illustrator e pressione o atalho Ctrl+ Rpara ativar as réguas na borda superior e na lateral esquerda da prancheta.

- **b.** Posicione o cursor sobre a régua vertical da esquerda, clique, segure o botão do rato e arraste até o centro da tela.

- **c.** Solte o botão do rato: surgirá uma linha vertical ciano (azul-piscina). Essa Linha Guia marca o eixo central exato onde o escudo será espelhado.

### Passo 2: Desenhando Apenas o Lado Esquerdo

- **a.** Selecione a Ferramenta Caneta (Atalho: tecla P).

- **b.** Configure as cores: deixe o preenchimento sem cor ([Nenhum]) e o traçado com uma linha preta fina de 1 pt ou 2 pt.

- **c.** Dê um clique simples exatamente em cima da Linha Guia vertical (este será o ponto do topo do escudo).

- **d.** Mova o rato para a esquerda em linha reta e clique para criar a borda superior.

- **e.** Desça o cursor até a lateral esquerda, clique e arraste suavemente para puxar as alças e curvar o bordo externo do escudo.

- **f.** Mova o rato de volta para a Linha Guia central na parte inferior e dê um clique simples para fixar a ponta da base.

- **g.** Pressione a tecla Enterno teclado para encerrar a linha. Terá na tela apenas a metade esquerda aberta do escudo.

### Passo 3: A Mágica da Ferramenta Refletir

- **a.** Ative a Ferramenta Seleção (Seta Preta -Atalho: tecla V) e clique na metade desenhada para selecioná-la.

- **b.** Na barra de ferramentas, selecione a Ferramenta Refletir (Reflect Tool-Atalho: tecla O).

- **c.** O Ponto de Ancoragem: Mantenha a tecla Alt pressionada no teclado e dê um clique simples exatamente em cima da Linha Guia vertical (no ponto da base do escudo).

- **d.** Uma caixa de diálogo abrirá na tela.

- **e.** Na secção de eixos, marque a opção Vertical.

- **f.** Atenção aos botões: Não clique em OK! Clique no botão Copiar (Copy).

- **g.** O Illustrator criará uma cópia espelhada no lado direito, alinhada ao eixo guia.

### Passo 4: Soldando as Duas Metades

- **a.** Com a Seta Preta (V), clique e arraste uma seleção cobrindo as duas metades do escudo ao mesmo tempo.

- **b.** Ative a ferramenta Construtor de Formas (Shape Builder Tool-Atalho: Shift+ M).

- **c.** Clique na metade esquerda e arraste o traço por cima da linha central até a metade direita.

- **d.** Solte o botão do rato: a costura central desaparece e as duas peças fundem-se num único objeto fechado e perfeitamente simétrico!

- **e.** Na caixa de ferramentas, selecione a cor de preenchimento desejada para colorir o brasão e remova a linha de contorno.', 5, 'Introdutório', '', '[{"title":"Simetria Bilateral","description":"O efeito de espelho em que o lado esquerdo é a réplica do lado direito, passando a sensação de firmeza e proteção."},{"title":"A Regra da Metade","description":"Em objetos simétricos, desenha-se apenas um dos lados para evitar distorções manuais."},{"title":"Réguas e Guias (Ctrl + R)","description":"Puxar uma linha guia da régua define o ponto de apoio central para alinhar a arte com rigor."},{"title":"Ferramenta Refletir (O) + Tecla Alt","description":"Clicar com o Alt pressionado define o pivô do espelho e abre a janela de opções."},{"title":"Botão Copiar (Copy)","description":"Cria a metade espelhada sem apagar a peça original desenhada."},{"title":"União com Construtor de Formas (Shift + M)","description":"Arrastar sobre a emenda solda as duas metades numa peça sólida e fechada."}]'::jsonb, '[{"keys":"Ctrl + R","label":"Ativar réguas"},{"keys":"Shift + M","label":"Construtor de Formas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-1', 'padroes-visuais-e-texturas-infinitas', 'Padrões Visuais e Texturas Infinitas', 4, 'A Batida da Música, M.C. Escher e as Texturas Sem Costura', ARRAY['padrões', 'visuais', 'texturas', 'infinitas', 'illustrator', 'arte digital', 'design visual']::text[], 'Já ouviste uma música com uma batida tão marcante que dá vontade de acompanhar com o pé? Na música, quando um som se repete em intervalos idênticos de tempo, chamamos a isso Ritmo. No design gráfico e na criação de videojogos, o ritmo não entra pelos ouvidos: entra diretamente pelos olhos. Quando pegamos em formas geométricas e as multiplicamos várias vezes com espaçamentos organizados, criamos um Padrão Visual (Pattern). Um dos maiores mestres desta técnica foi o artista holandês M.C. Escher. Ele usava matemática para criar a Tesselação: desenhos de pássaros, peixes e répteis que se encaixavam com tanta precisão que pareciam azulejos infinitos, sem deixar um único milímetro de espaço vazio entre eles. Nos videojogos, esta lógica é indispensável por causa da memória do computador. Num jogo de plataformas 2D (como Terraria, Hollow Knight ou Super Mario), se o cenário tiver uma masmorra ou um castelo gigante, o ilustrador não desenha pedra a pedra ao longo de milhares de píxeis de ecrã. Se fizesse isso, o telemóvel ou o computador ficaria lento e bloqueava com um ficheiro tão pesado! A solução da indústria é criar uma Textura Seamless (sem costura):

- O artista desenha apenas um pequeno bloco com 3 ou 4 tijolos.

- As pedras do lado direito encaixam perfeitamente nas do lado esquerdo, e o topo encaixa na base.

- O jogo repete esse pequeno quadrado milhares de vezes pelo cenário. O jogador vê um castelo colossal, mas o jogo carregou apenas um elemento leve e minúsculo.', '## Criando um Papel de Parede Infinito para Jogos

Abre o Illustrator para criar uma estampa contínua que pode ser usada como papel de parede ou textura de cenário de jogo.

### Passo 1: Desenhando os Elementos Matriz

- **a.** Na tua prancheta de trabalho, localiza uma área livre para desenhar os símbolos de base.

- **b.** Desenha três elementos pequenos próximos uns dos outros: ▪ Um triângulo dourado: ativa a Ferramenta Polígono (no menu escondido do Retângulo), dá um clique simples na tela, digita Lados: 3 e clica em OK.

▪ Um círculo azul-claro: ativa a Ferramenta Elipse (tecla L), mantém a tecla Shift pressionada e arrasta para fazer um círculo perfeito. ▪ Uma pequena estrela: ativa a Ferramenta Estrela no mesmo menu de formas e desenha uma estrela simples.

- **c.** Pinta cada figura com cores vivas e contrastantes.

- **d.** Remove o traçado preto de todas elas (deixa o Traçado em [Nenhum]).

### Passo 2: Entrando na Fábrica de Padrões

- **a.** Com a Ferramenta Seleção (Seta Preta - tecla V), clica e arrasta para selecionar os três elementos em conjunto.

- **b.** Acede ao menu superior: Objeto > Padrão > Criar (Object > Pattern > Make).

- **c.** Uma caixa de aviso surgirá a informar que o novo padrão foi adicionado ao painel de Amostras; clica em OK.

### Passo 3: Ajustando o Ritmo Visual

- **a.** O Illustrator entra no Modo de Edição de Padrão. Vais ver o teu desenho original no centro cercado por vários clones semitransparentes em tempo real.

- **b.** Na janela flutuante Opções de Padrão, procura pelo campo Tipo de Ladrilho (Tile Type) e experimenta as opções: ▪ Grade (Grid): alinha as réplicas em colunas e linhas retas.

▪ Tijolo por Linha (Brick by Row): intercala as linhas como uma parede de tijolos, criando um ritmo mais dinâmico.

- **c.** Clica numa das peças originais do meio com a Seta Preta (V) e move-a ligeiramente: repara como todas as cópias ao redor se movem em simultâneo!

- **d.** Quando a distribuição parecer equilibrada e harmoniosa, olha para a barra cinzenta no topo do ecrã e clica em Concluído (Done).

### Passo 4: Aplicando a Estampa no Cenário

- **a.** Seleciona a Ferramenta Retângulo (tecla M).

- **b.** Clica e arrasta para desenhar um retângulo grande cobrindo uma área ampla da prancheta.

- **c.** Abre o painel Amostras (Swatches) no menu lateral direito (ou vai a Janela > Amostras).

- **d.** Clica no novo quadrado da amostra do teu padrão que foi criado.

- **e.** O retângulo gigante é preenchido de imediato com a textura contínua!

### Passo 5: O Truque Profissional da Tecla Til (~)

- **a.** Se achares que os desenhos do padrão ficaram demasiado grandes dentro do retângulo, não precisas de refazer

- **a.** Se achares que os desenhos do padrão ficaram demasiado grandes dentro do retângulo, não precisas de refazer tudo do zero!

- **b.** Com o retângulo preenchido selecionado, ativa a Ferramenta Escala (tecla S).

- **c.** O Segredo: mantém premida a tecla Til (~) no teclado.

- **d.** Com o ~ pressionado, clica no ecrã e arrasta o rato para dentro.

- **e.** O retângulo exterior permanece imóvel no mesmo tamanho, mas a textura no seu interior diminui, multiplicando o número de repetições!', 5, 'Introdutório', '', '[{"title":"Padrão Visual (Pattern)","description":"A repetição matemática e ritmada de formas geométricas no espaço."},{"title":"M.C. Escher e Tesselação","description":"A técnica de encaixar formas sem deixar espaços vazios entre elas, precursora dos mosaicos digitais."},{"title":"Textura Seamless (Sem Costura)","description":"Módulo em que as bordas opostas se encaixam, permitindo criar cenários infinitos sem sobrecarregar a memória do computador."},{"title":"Menu Objeto > Padrão > Criar","description":"A ferramenta do Illustrator que automatiza a repetição de elementos em grelha com visualização instantânea."},{"title":"Tecla Til (~) com Escala (S)","description":"Comando que permite redimensionar apenas a textura interna, mantendo as dimensões da forma exterior intactas."}]'::jsonb, '[]'::jsonb),
    ('producao-multimidia-i', 'modulo-2', 'a-fisica-da-luz-e-o-sombreamento-em-blocos-cel-shading', 'A Física da Luz e o Sombreamento em Blocos (Cel Shading)', 0, 'A Ilusão do 3D e a Arte do Cel Shading', ARRAY['física', 'luz', 'sombreamento', 'blocos', 'cel', 'shading', 'illustrator', 'arte digital', 'design visual']::text[], 'Já tentaste desenhar uma bola no computador e ela continuou a parecer apenas uma moeda achatada colada no ecrã? Isso acontece porque, no mundo real, o nosso cérebro só percebe que um objeto é redondo pela forma como a luz bate nele. Sem luz, não há volume; sem sombra, tudo parece plano. A primeira regra de ouro da física visual é desmistificar a sombra: a sombra nunca é uma camada de tinta preta atirada por cima do desenho. Ela é simplesmente a ausência de luz onde a própria massa do objeto bloqueia os raios luminosos. Antes de colocares qualquer sombra no teu personagem ou item de jogo, precisas de definir a tua Fonte de Luz (o Sol, uma tocha ou um poste de rua). Se a luz vem do canto superior esquerdo, o lado inferior direito ficará obrigatoriamente no escuro. Na física visual de jogos e animação, dividimos essa superfície iluminada em quatro zonas principais:

- Luz Plena (Highlight): O ponto de impacto frontal onde o raio bate em cheio. É a zona mais clara de todas, chegando quase ao branco puro.

- Meio-Tom (Midtone): A cor real e pura do material. Se a armadura é vermelha, o meio-tom é o vermelho sólido que escolheste na paleta.

- Sombra Própria (Core Shadow): A escuridão no próprio corpo do objeto, situada exatamente no lado oposto à lâmpada.

A luz não faz curvas para alcançar essa área.

- Sombra Projetada (Cast Shadow): A silhueta escura que o objeto "atira" para o chão ou contra as paredes ao lado. É essa sombra que prende o objeto ao piso para ele não parecer que está a flutuar no vazio.

Em jogos estilizados (como The Legend of Zelda: The Wind Waker ou em animes), os ilustradores não usam pincéis esfumados ou borrados. A indústria recorre ao Cel Shading (ou sombreamento em blocos): desenhamos formas geométricas de cores sólidas com arestas duras e recortadas para representar cada zona de luz!', '## Esculpindo uma Pokébola Estilizada com o Construtor de Formas

Abre o Illustrator para transformar um círculo plano num orbe tridimensional através do corte de volumes e sobreposição geométrica.

### Passo 1: Preparando a Prancheta e a Cor Base

- **a.** Abre o Illustrator e cria um documento novo no tamanho padrão de 1920 x 1080 pixels.

- **b.** Na barra de ferramentas à esquerda, ativa a Ferramenta Elipse (Atalho: tecla L).

- **c.** Mantém premida a tecla Shift (para travar as proporções), clica no ecrã e arrasta para criar um círculo central com cerca de 500 px de diâmetro.

- **d.** Na barra superior de propriedades, retira o Traçado (Stroke) deixando-o em [Nenhum].

- **e.** Define o Preenchimento (Fill) com um Vermelho vivo. Este círculo vermelho é o nosso Meio-Tom.

### Passo 2: Construindo a Sombra Própria sem Usar Pincel

- **a.** Ativa a Ferramenta Seleção (Seta Preta - Atalho: tecla V) e clica no círculo vermelho.

- **b.** Pressiona Ctrl + C (copiar) e logo de seguida Ctrl + F (colar exatamente no mesmo sítio, à frente da original).

- **c.** Com a cópia selecionada, arrasta-a ligeiramente para cima e para a esquerda (assumindo que a nossa fonte de luz imaginária vem do canto superior esquerdo).

- **d.** Com a Seta Preta (V), clica e arrasta para selecionar os dois círculos ao mesmo tempo.

- **e.** Ativa a ferramenta Construtor de Formas (Shape Builder Tool - Atalho: Shift + M).

- **f.** Mantém premida a tecla Alt no teclado (o cursor apresentará um pequeno sinal de subtração -) e clica na parte do círculo superior que vazou para fora da área base para a eliminar.

- **g.** Solta o rato: repara na meia-lua que restou encaixada na base inferior direita.

- **h.** Dá um duplo clique na caixinha de cor de preenchimento e escolhe um tom de Vinho ou Vermelho Escuro. A tua Sombra Própria está perfeitamente integrada na curvatura da bola!

### Passo 3: Criando o Brilho Especular (Luz Plena)

- **a.** Seleciona novamente a Ferramenta Elipse (L).

- **b.** Clica e arrasta sem segurar a tecla Shift para desenhar uma elipse pequena, oval e inclinada no canto superior esquerdo da esfera (exatamente onde a luz bate de frente).

- **c.** Pinta essa elipse de Branco Puro e certifica-te de que está sem contorno.

### Passo 4: Projetando a Sombra no Chão (Oclusão Básica)

- **a.** Seleciona mais uma vez a Ferramenta Elipse (L).

- **b.** Desenha uma elipse bem achatada e horizontal logo por baixo da esfera.

- **c.** Pinta-a com um tom de Cinza Escuro ou Preto.

- **d.** Clica com o botão direito do rato em cima dessa elipse escura e vai a: Organizar > Enviar para Trás (Arrange > Send

- **d.** Clica com o botão direito do rato em cima dessa elipse escura e vai a: Organizar > Enviar para Trás (Arrange > Send to Back).

- **e.** A elipse fica escondida por baixo da base da esfera, conferindo peso e estabilidade à peça no chão virtual!', 5, 'Introdutório', '', '[{"title":"A Ilusão do Volume","description":"O 3D no ecrã nasce do estudo de como a luz e a sombra modelam as superfícies."},{"title":"Cel Shading","description":"Técnica de sombreamento que utiliza blocos geométricos sólidos e arestas duras em vez de gradientes desfocados."},{"title":"As Quatro Zonas de Luz","description":"Luz Plena (brilho máximo), Meio-Tom (cor base), Sombra Própria (no corpo do objeto) e Sombra Projetada (no chão)."},{"title":"A Sombra é um Vetor","description":"No Illustrator, a sombra é desenhada e cortada como uma forma geométrica independente usando o Construtor de Formas (Shift + M)."},{"title":"Organizar (Enviar para Trás)","description":"Posiciona a sombra projetada atrás do objeto principal para ancorá-lo no chão com firmeza."}]'::jsonb, '[{"keys":"Ctrl + C","label":"Copiar objeto"},{"keys":"Shift + M","label":"Construtor de Formas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-2', 'transicoes-suaves-e-escala-tonal', 'Transições Suaves e Escala Tonal', 1, 'O Lápis de Mil Tons e a Matemática do Degradê', ARRAY['transições', 'suaves', 'escala', 'tonal', 'illustrator', 'arte digital', 'design visual']::text[], 'Na semana anterior, vimos como o sombreamento em blocos duros (Cel Shading) funciona bem para desenhos com estilo de anime ou quadrinhos. Só que, se você olhar para um cano de metal, para o braço de um personagem ou para uma espada curva, vai reparar que a luz nem sempre para numa linha seca. Ela escorrega e desliza suavemente ao longo da superfície. No desenho tradicional no papel, o artista cria essa suavidade controlando a força da mão: se encostar o grafite de leve, sai um cinza bem clarinho; se apertar com força contra a folha, sai um preto escuro. Essa passagem gradual e contínua do claro para o escuro chama-se Escala Tonal. Como explica o mestre da ilustração James Gurney, a ilusão de volume 3D em superfícies curvas depende totalmente de quão bem você consegue fazer a luz transicionar para a sombra. No computador, o mouse não sente a pressão dos seus dedos. Para resolver isso sem complicação, o Illustrator usa uma calculadora visual de transições: o Degradê (Gradient). Você apenas indica onde fica a luz e onde fica a sombra, e o software calcula todos os tons intermediários para você:

- Degradê Linear: A cor anda em linha reta. É ideal para cilindros, lâminas afiadas, canos e troncos retos.

- Degradê Radial: A luz espalha-se em círculos a partir de um centro. É perfeito para esferas, planetas, orbes mágicos e joias reluzentes.

Guarde esta regra: se a forma tem quinas e ângulos retos, a luz quebra em blocos; se a forma é cilíndrica ou arredondada, a luz escorrega em degradê.', '## Forjando a Lâmina Iluminada de uma Espada Mágica com Degradê Linear

Abra o Illustrator para esculpir a lâmina de uma espada aplicando degradê linear de múltiplos pontos para criar o reflexo cortante do aço.

### Passo 1: Desenhando a Geometria da Lâmina

- **a.** Na barra de ferramentas à esquerda, pegue a Ferramenta Retângulo (Atalho: letra M).

- **b.** Dê um clique simples na prancheta, digite 60 px de largura por 600 px de altura e confirme no OK para criar uma barra vertical longa.

- **c.** Selecione a Ferramenta Caneta (Atalho: letra P).

- **d.** Aproxime o cursor do centro exato da linha superior do retângulo até aparecer um pequeno sinal de mais (+) ao lado da caneta e clique para criar um novo ponto de ancoragem bem no meio.

- **e.** Ative a Ferramenta Seleção Direta (Seta Branca - Atalho: letra A).

- **f.** Dê um clique sobre esse novo ponto central do topo e puxe-o cerca de 80 px para cima em linha reta: você acabou de criar a ponta perfurante da lâmina!

### Passo 2: Aplicando o Degradê Linear

- **a.** Com a Ferramenta Seleção (Seta Preta - Atalho: letra V), selecione a lâmina inteira.

- **b.** Pressione o atalho Ctrl + F9 para abrir o painel Degradê (Gradient).

- **c.** No painel, clique no primeiro ícone: Degradê Linear.

- **d.** A lâmina receberá a transição padrão do Illustrator, indo do branco até o preto.

### Passo 3: Mapeando a Luz de Aço (Múltiplos Pontos)

- **a.** Olhe para a barra horizontal de degradê dentro do painel.

- **b.** Dê um clique duplo na bolinha da extrema esquerda e selecione um tom de Azul Claro.

- **c.** Dê um clique duplo na bolinha da extrema direita e defina um tom de Azul Marinho Escuro.

- **d.** Aproxime o mouse da parte logo abaixo da barra de degradê: o cursor ganhará um sinal de mais (+). Dê um clique simples perto do meio para adicionar uma terceira bolinha de cor.

- **e.** Defina essa bolinha intermediária com a cor Branco Puro.

- **f.** Arraste essa bolinha branca para perto da bolinha do azul escuro: a aproximação brusca do branco contra a sombra cria a quebra reflexiva típica de uma lâmina de metal polido!

### Passo 4: O Controle Direcional (A Ferramenta G)

- **a.** Na barra de ferramentas à esquerda, ative a Ferramenta Degradê (Atalho: letra G).

- **b.** Repare que uma régua interativa vai surgir posicionada diretamente em cima da lâmina.

- **c.** Dê um clique na borda lateral esquerda da lâmina e arraste o mouse em linha reta na horizontal até a borda lateral direita.

- **d.** O degradê agora cruza o aço na horizontal. O retângulo plano ganha curvatura visual, volume cilíndrico e um brilho reflexivo de alt a definição!', 5, 'Introdutório', '', '[{"title":"Escala Tonal","description":"A variação gradual de luminosidade entre a luz mais clara e a sombra mais escura que revela o volume da forma. forma."},{"title":"Degradê Linear vs. Radial","description":"O Linear guia a luz em linha reta (tubos, armas, cilindros); o Radial expande a luz em círculos a partir do meio (esferas, orbes, olhos)."},{"title":"Painel Degradê (Ctrl + F9)","description":"A central onde você define o tipo de gradiente, cria novas paradas de cor e ajusta a escala."},{"title":"Ferramenta Degradê (G)","description":"O \"pincel direcional\" na tela que permite clicar e arrastar para escolher o ângulo e a distância exata da luz."},{"title":"Pontos Intermediários de Cor","description":"Clicar na barra do painel adiciona novos focos de cor, permitindo criar quebras metálicas afiadas de alt o contraste."}]'::jsonb, '[{"keys":"Ctrl + F9","label":"Abrir painel Degradê"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-2', 'iluminacao-geometrica-o-bau-de-tesouro-3d', 'Iluminação Geométrica: O Baú de Tesouro 3D', 2, 'A Regra das Quinas e a Iluminação em Degraus', ARRAY['iluminação', 'geométrica', 'baú', 'tesouro', 'illustrator', 'arte digital', 'design visual']::text[], 'Na semana passada, vimos como a luz escorrega suavemente por superfícies curvas e cilíndricas através do degradê. No entanto, quando olhamos para um bloco de minério no Minecraft, para uma caixa de munições ou para um baú de tesouro medieval, essa suavidade desaparece. Em objetos com quinas duras de 90 graus, a luz não escorrega: ela quebra bruscamente. A regra de ouro da iluminação geométrica dita que o formato da superfície decide como a luz se comporta:

- Superfícies Curvas: Fazem a luz transicionar de forma contínua.

- Superfícies Planas com Quinas: Bloqueiam a passagem de luz repentinamente de uma face para a outra. Cada parede do objeto recebe uma cor sólida e estática.

Para iluminar um cubo ou baú no espaço digital, não precisas de softwares de modelação 3D pesados. Pensamos na luz em degraus de intensidade. Imagina uma tocha posicionada no alt o e à esquerda do ecrã:

- Tampa Superior (Luz Plena): Está virada de frente para a fonte luminosa e recebe o tom mais claro de todos.

- Parede Lateral Esquerda (Meio-Tom): Enxerga a luz num ângulo rasante, mantendo a cor original pura do material.

- Parede Lateral Direita (Sombra Própria): Está totalmente escondida da tocha, recebendo a tonalidade mais escura da paleta.

Basta juntar três polígonos planos com os tons corretos para enganar o cérebro humano e gerar uma caixa volumétrica com profundidade instantânea!', '## Montando um Baú Cúbico 3D através de Faces e Degraus de Cor

Abre o Illustrator para construir um baú tridimensional partindo de uma base hexagonal fatiada com a estrutura em "Y" e colorida por degraus de luz.

### Passo 1: A Silhueta Hexagonal Externa

- **a.** Na barra de ferramentas à esquerda, clica e segura sobre a ferramenta de formas para escolher a Ferramenta Polígono.

- **b.** Dá um clique simples no centro da prancheta para abrir a janela de propriedades.

- **c.** Digite Raio: 250 px e Lados: 6 para gerar um Hexágono perfeito e confirma no OK.

- **d.** Ativa a Ferramenta Seleção (Seta Preta - Atalho: tecla V) e certifica-te de que o hexágono está orientado com um vértice pontiagudo virado diretamente para o topo e outro para a base.

### Passo 2: Fatiando o Bloco com a Estrutura em "Y"

- **a.** Seleciona a Ferramenta Caneta (Atalho: tecla P).

- **b.** Retira a cor de preenchimento (deixa em [Nenhum]) e coloca um traçado preto fino de 2 pt.

- **c.** Passa o rato sobre o ponto de ancoragem do centro exato do hexágono e clica.

- **d.** Sobe o cursor em linha reta vertical até ao ponto de ancoragem do topo do hexágono, dá um clique e prime Enter para soltar o traço.

- **e.** Clica novamente no centro do hexágono, puxa uma linha diagonal até ao vértice inferior esquerdo e prime Enter.

- **f.** Clica outra vez no centro e puxa uma última linha diagonal até ao vértice inferior direito.

- **g.** Repara no resultado: desenhaste uma letra "Y" perfeita ligando o centro aos cantos da forma!

### Passo 3: Transformando as Linhas em Paredes com o Construtor de Formas

- **a.** Com a Seta Preta (V), clica e arrasta para selecionar o hexágono e as três linhas internas ao mesmo tempo.

- **b.** Ativa a ferramenta Construtor de Formas (Shape Builder Tool - Atalho: Shift + M).

- **c.** Dá um clique simples no quadrante de cima (a tampa do baú).

- **d.** Dá um clique simples no quadrante lateral esquerdo.

- **e.** Dá um clique simples no quadrante lateral direito.

- **f.** O Illustrator converteu os traços e separou o hexágono em três losangos independentes e perfeitamente fechados!

### Passo 4: Aplicando os Degraus de Cor do Baú

- **a.** Ativa a Seta Preta (V) e clica na face superior (a tampa).

- **b.** No seletor de cores, escolhe um tom de Castanho Madeira Muito Claro (cor de areia ou caramelo claro) para simular a Luz Plena.

- **c.** Clica na face esquerda e pinta com um Castanho Médio quente (o Meio-Tom base).

- **d.** Clica na face direita e pinta com um Castanho Chocolate Escuro (a Sombra Própria).

- **e.** Seleciona todas as peças e desativa completamente os traçados pretos de contorno.

- **f.** Em apenas três cliques de cor sólida, o desenho plano transforma-se num baú cúbico com peso, massa e tridimensionalidade convincentes!', 5, 'Introdutório', '', '[{"title":"A Regra da Superfície","description":"Formas curvas fazem a luz escorregar suavemente; superfícies planas com quinas quebram a luz"},{"title":"A Regra da Superfície","description":"Formas curvas fazem a luz escorregar suavemente; superfícies planas com quinas quebram a luz em blocos duros."},{"title":"Degraus de Cor no Cubo","description":"O volume nasce da diferenciação das três faces expostas: face superior clara (Luz Plena), face em ângulo média (Meio-Tom) e face oposta escura (Sombra Própria)."},{"title":"Base Hexagonal + Letra \"Y\"","description":"A técnica geométrica mais rápida para projetar uma caixa cúbica 3D sem depender de softwares tridimensionais."},{"title":"Construtor de Formas (Shift + M) com Cliques Simples","description":"Em vez de fundir formas arrastando, clicar dentro de áreas delimitadas por linhas transforma cada espaço fechado numa nova forma isolada."},{"title":"Sem Contornos Pesados","description":"Remover os traçados escuros das arestas valoriza a quebra de cor entre as faces, tornando a ilusão volumétrica mais limpa e realista."}]'::jsonb, '[{"keys":"Shift + M","label":"Construtor de Formas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-2', 'cores-atmosfera-e-iluminacao-estilizada', 'Cores, Atmosfera e Iluminação Estilizada', 3, 'A Psicologia da Atmosfera e a Luz que Faz Ricochete', ARRAY['cores', 'atmosfera', 'iluminação', 'estilizada', 'illustrator', 'arte digital', 'design visual']::text[], 'Nas semanas anteriores, aprendeste a iluminar uma esfera e a construir um baú cúbico tridimensional. No entanto, num videojogo a sério, uma espada, uma poção ou um baú nunca flutuam num ecrã em branco. Eles fazem parte de um mundo, apoiados no chão de uma masmorra húmida ou na relva de uma floresta ensolarada. A luz não serve apenas para revelar formas; ela comanda as emoções do jogador e constrói a atmosfera da cena:

- Luz Solar Quente (Dia): Apresenta tons amarelos e dourados na luz, com sombras ligeiramente azuladas que refletem o céu aberto. Transmite clareza, segurança e espírito de aventura.

- Luz Noturna Fria (Noite): A cena é invadida por azuis-escuros, cianos e sombras densas quase negras. Transmite sigilo, tensão e perigo.

Além disso, no mundo real, a luz comporta-se como uma bola de borracha: quando o raio de luz atinge o chão brilhante, ele não desaparece ali; faz ricochete e sobe, atingindo a base do objeto. Chamamos a isto Luz Rebatida (Bounce Light). Ao bater no solo, a luz "rouba" a cor do chão e tinge a base da sombra. Se um baú repousa sobre relva verde-musgo, a parte de baixo da sombra deixa de ser cinzenta e ganha um reflexo esverdeado. E exatamente no ponto onde o objeto toca fisicamente no chão, a luz é completamente bloqueada, gerando a Oclusão Ambiental (Ambient Occlusion): aquela sombra de contacto preta e justa que dá peso e impede o objeto de parecer um autocolante solto a flutuar no ecrã!', '## Integrando o Baú Cúbico na Atmosfera Noturna com Luz Rebatida

Abre o Illustrator para construir um cenário noturno minimalista, ajustar a paleta do baú cúbico e aplicar luz rebatida com sombra de contacto realista.

### Passo 1: Construindo o Cenário Minimalista

- **a.** Abre o teu documento de trabalho ou cria uma prancheta no tamanho padrão de 1920 x 1080 px.

- **b.** Ativa a Ferramenta Retângulo (Atalho: tecla M).

- **c.** Clica e arrasta para desenhar um bloco largo cobrindo a metade superior da prancheta (a parede ou o céu da cena).

- **d.** Pinta este retângulo com um tom de Azul Noturno Profundo e retira o contorno.

- **e.** Com a mesma ferramenta (M), desenha outro retângulo cobrindo toda a metade inferior da tela para representar o chão.

- **f.** Pinta o chão com uma tonalidade escura de Roxo Escuro ou Verde-Musgo.

- **g.** Copia o baú tridimensional construído na Semana 9 (Ctrl + C), cola-o na cena (Ctrl + V) e pousa a sua base diretamente sobre a linha que divide o chão da parede.

### Passo 2: Integrando as Faces à Atmosfera Noturna

- **a.** Como o cenário agora se passa durante a noite, a tampa superior do baú não pode manter a cor de madeira iluminada pelo sol.

- **b.** Com a Ferramenta Seleção (Seta Preta - Atalho: tecla V), clica na tampa superior do baú.

- **c.** Alt era a cor de preenchimento para um tom de Azul Claro Lavado (simulando a luz fria do luar).

- **d.** Clica na parede lateral esquerda do baú e aplica um tom de Azul Petróleo intermediário.

- **e.** Clica na parede lateral direita (a face da sombra própria) e escurece-a para um tom de Azul Marinho quase preto.

- **f.** O baú absorveu a temperatura de cor fria do ambiente ao redor!

### Passo 3: A Luz Rebatida do Chão (Bounce Light)

- **a.** Com a Seta Preta (V), seleciona a face lateral direita do baú (a parede que está na sombra).

- **b.** Abre o painel Degradê através do atalho Ctrl + F9.

- **c.** Aplica um Degradê Linear e ajusta a direção para que ele corra na vertical, de baixo para cima.

- **d.** No marcador de cor do topo do degradê, mantém o tom de Azul Marinho da sombra.

- **e.** No marcador de cor da base do degradê (a área que encosta ao chão), escolhe exatamente a mesma cor utilizada no solo (o Verde-Musgo).

- **f.** O solo reflete a sua tonalidade verde para dentro da sombra do baú, unindo o objeto ao cenário de forma natural!

### Passo 4: Sombra de Contacto com Modo de Mesclagem (Multiply)

- **a.** Na barra de ferramentas, ativa a Ferramenta Elipse (Atalho: tecla L).

- **b.** Desenha uma elipse bem fina, achatada e horizontal pousada logo abaixo da base do baú.

- **c.** Pinta essa elipse de Preto Puro sólido e retira o traçado.

- **d.** Acede ao menu superior: Janela > Transparência (Window > Transparency) para abrir o painel.

- **e.** No menu suspenso onde diz Normal, alt era o modo para Multiplicação (Multiply).

- **f.** Reduz a Opacidade para 70% (ou 60%).

- **g.** A sombra preta funde-se perfeitamente com a cor do piso verde por baixo, criando a oclusão ambiental que fixa o baú no chão com peso e gravidade reais!', 5, 'Introdutório', '', '[{"title":"Temperatura de Cor e Emoção","description":"Ambientes diurnos e quentes transmitem aventura e segurança; iluminações frias e azuladas transmitem sigilo, tensão ou perigo."},{"title":"Luz Rebatida (Bounce Light)","description":"A luz que bate no chão, faz ricochete e colore a base sombreada do objeto com o tom do piso."},{"title":"Integração de Cores","description":"Pintar a sombra de um objeto com reflexos do solo impede o efeito de \"autocolante solto\", unificando o asset ao cenário."},{"title":"Oclusão Ambiental (Ambient Occlusion)","description":"A sombra de contacto mais escura existente no ponto exato onde as superfícies se tocam, conferindo sensação de peso e gravidade."},{"title":"Modo Multiplicação (Multiply)","description":"Opção do painel Transparência que funde e escurece a cor da sombra sobre as texturas e cores do chão que estão por baixo."}]'::jsonb, '[{"keys":"Ctrl + F9","label":"Abrir painel Degradê"},{"keys":"Ctrl + C","label":"Copiar objeto"},{"keys":"Ctrl + V","label":"Colar objeto"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-2', 'texturas-estilizadas-a-madeira-e-o-metal', 'Texturas Estilizadas: A Madeira e o Metal', 4, 'O Toque pelos Olhos, o Espelho de Metal e o Caos da Madeira', ARRAY['texturas', 'estilizadas', 'madeira', 'metal', 'illustrator', 'arte digital', 'design visual']::text[], 'Quando estás a jogar e encontras um baú antigo, um martelo de guerra ou um escudo viking, como sabes imediatamente se aquele item é feito de ferro maciço ou de carvalho envelhecido? Tu não podes esticar a mão e tocar no monitor! O teu cérebro descobre a matéria do objeto apenas através da visão, num fenómeno chamado Sinestesia Visual. O segredo para fazer um material parecer áspero ou polido está na forma como a luz é refletida pela superfície:

- Superfícies Duras e Polidas (Metal): O metal limpo comporta-se como um espelho. A luz atinge o material e reflete diretamente para os olhos do jogador. Em vez de transições lentas de cor, o metal exige Alt o Contraste: brilhos em branco puro colados imediatamente a sombras pretas ou reflexos do ambiente, sem meios-tons demorados. É esse corte brusco de luminosidade que dá a sensação de aço frio, afiado e reluzente.

- Superfícies Rústicas e Orgânicas (Madeira): A madeira é um material que cresceu na natureza de forma caótica e sofreu com o tempo, a chuva e os cortes. Não tem linhas retas nem reflexos espelhados. A sua textura é composta por Veios (linhas onduladas de crescimento) e Nós (as marcas ovais deixadas pelos ramos cortados).

No Illustrator, não precisamos de fotografias pesadas para fazer arte de jogos. Para dar a sensação de que uma racha na madeira tem profundidade real, usamos um truque de iluminação simples: desenhamos a fenda com uma linha escura (a sombra do buraco) e colocamos uma linha clara colada logo abaixo (a quina da madeira a apanhar luz). O cérebro interpreta essa dupla como relevo tridimensional imediato!', '## Forjando um Escudo Viking com Madeira Rústica e Aro de Metal

Abre o Illustrator para construir um elemento de equipamento combinando a textura orgânica da madeira entalhada com o aro de metal em degradê cromado de alt o contraste.

### Passo 1: A Prancha de Madeira Rústica

- **a.** Na barra de ferramentas à esquerda, ativa a Ferramenta Retângulo (Atalho: tecla M).

- **b.** Clica no ecrã e arrasta para desenhar uma barra vertical larga.

- **c.** Define a cor de preenchimento com um tom de Castanho Quente (cor sólida de caramelo) e retira a linha de contorno.

- **d.** Localiza a Ferramenta Lápis (Atalho: tecla N) na barra de ferramentas e dá um duplo clique sobre o seu ícone.

- **e.** Na janela de opções que se abre, arrasta o cursor deslizante de Fidelidade / Suavidade (Smoothness) totalmente para a direita (no máximo) e clica em OK. Isso faz com que o Illustrator corrija tremores do rato e arredonde as tuas linhas automaticamente!

### Passo 2: Entalhando os Veios e Nós da Madeira

- **a.** Mantém a Ferramenta Lápis (N) ativa, deixa o preenchimento sem cor ([Nenhum]) e escolhe um traçado Castanho Escuro com 2 pt de espessura.

- **b.** No centro da tábua de madeira, desenha uma pequena elipse torta e irregular para representar o nó da árvore.

- **c.** Agora, desenha linhas verticais onduladas de cima a baixo na tábua, fazendo com que o traço se afaste e contorne o nó central que desenhaste.

- **d.** O Truque do Relevo: Alt era a cor do traçado do Lápis para um tom de Bege Muito Claro (quase amarelo).

- **e.** Desenha linhas curtas coladas exatamente debaixo das linhas castanhas escuras que acabaste de traçar. A linha clara simula a aresta da madeira a receber luz e a escura simula a fenda, criando relevo tátil instantâneo!

### Passo 3: A Borda Refletiva de Metal (Aro de Proteção)

- **a.** Seleciona a Ferramenta Retângulo (M).

- **b.** Desenha uma faixa retangular horizontal cruzando a base da tábua de madeira para criar a cinta metálica do escudo.

- **c.** Abre o painel Degradê pressionando o atalho Ctrl + F9 e escolhe o modo Degradê Linear.

- **d.** Cria a sequência de múltiplos pontos de cor para gerar o metal espelhado: ▪ Ponto 1 (extrema esquerda): Cinzento Escuro.

▪ Ponto 2 (muito perto do primeiro): Branco Puro. ▪ Ponto 3 (ao centro): Cinzento Médio. ▪ Ponto 4 (mais à direita): Preto. ▪ Ponto 5 (extrema direita): Cinzento Claro.

- **e.** O choque direto entre o branco incandescente e as sombras vizinhas faz a chapa reluzir como aço polido!

### Passo 4: Os Rebites de Aço (Parafusos)

- **a.** Ativa a Ferramenta Elipse (Atalho: tecla L).

- **b.** Mantém premida a tecla Shift e desenha um círculo minúsculo posicionado sobre a faixa metálica.

- **c.** No painel Degradê (Ctrl + F9), muda para o modo Degradê Radial com o centro em Branco Puro e a borda externa em Cinzento Escuro.

- **d.** Com a Ferramenta Seleção (Seta Preta - tecla V), mantém premida a tecla Alt no teclado, clica no rebite e arrasta

- **d.** Com a Ferramenta Seleção (Seta Preta - tecla V), mantém premida a tecla Alt no teclado, clica no rebite e arrasta para duplicar três parafusos espaçados ao longo da cinta de proteção.', 5, 'Introdutório', '', '[{"title":"Sinestesia Visual","description":"A capacidade do cérebro em \"sentir\" as características físicas de um material (liso, áspero, duro) apenas através da iluminação no ecrã."},{"title":"Alt o Contraste no Metal","description":"Superfícies metálicas espelhadas exigem brilhos brancos puros colados a sombras escuras sem transições suaves prolongadas."},{"title":"Veios e Nós","description":"A estrutura orgânica da madeira; as linhas de crescimento acompanham e contornam os nós redondos do tronco."},{"title":"Ilusão de Relevo em Fendas","description":"Uma linha escura combinada com uma linha clara colada logo abaixo engana o olhar e cria profundidade tátil."},{"title":"Ferramenta Lápis (N) e Suavidade","description":"Ideal para desenhar traçados naturais e imperfeitos; puxar a suavidade para o máximo corrige tremores manuais indesejados."},{"title":"Degradê de Múltiplos Pontos","description":"Permite alt ernar faixas de luz e sombra na mesma forma para simular superfícies cromadas e rebites tridimensionais."}]'::jsonb, '[{"keys":"Ctrl + F9","label":"Abrir painel Degradê"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-3', 'matematica-do-espaco-1-ponto-o-quarto-do-jogador', 'Matemática do Espaço (1 Ponto): O Quarto do Jogador', 0, 'A Ilusão da Terceira Dimensão, a Linha do Olhar e o Íman Central', ARRAY['matemática', 'espaço', 'ponto', 'quarto', 'jogador', 'illustrator', 'arte digital', 'design visual']::text[], 'Já reparaste como num jogo em 2D ou com perspetiva clássica um quarto parece ter profundidade real, dando a sensação de que podes andar até ao fundo do corredor? Isso não acontece por magia nem por tentativa e erro: acontece através da Perspetiva Linear, uma fórmula geométrica e matemática desenvolvida durante o Renascimento para enganar o cérebro humano e criar a ilusão de espaço 3D num ecrã totalmente plano. Todo o cenário estruturado assenta em dois elementos fundamentais:

- Linha do Horizonte (LH): Não representa apenas a linha onde a terra toca no céu; ela marca a altura exata dos olhos do observador ou a lente da câmara do jogo. Se a desenhares no fundo do ecrã, o jogador sente-se rebaixado a olhar para cima (visão de formiga); se a colocares no topo, ele sente-se a pairar a olhar para o chão (visão aérea).

- Ponto de Fuga (PF): Fica cravado sobre a Linha do Horizonte e funciona como um íman magnético invisível que atrai e suga todas as linhas de profundidade do cenário.

Na Perspetiva de 1 Ponto de Fuga, o jogador observa a arquitetura diretamente de frente. Por isso, o espaço segue duas regras inquebráveis: 1. Regra Frontal: Tudo o que está virado de frente para os teus olhos não entorta nem inclina; desenha-se com linhas 100% horizontais e 100% verticais (largura e altura puras). 2. Regra da Profundidade: Todas as quinas, rodapés e cantos que se afastam da câmara e entram pelo cenário adentro apontam obrigatoriamente para o Ponto de Fuga central.', '## Construção da Estrutura Base de um Quarto com Piso em Profundidade

Abre o Illustrator para erguer a caixa arquitetónica de um quarto com chão quadriculado convergente em 1 Ponto de Fuga.

### Passo 1: Preparando a Prancheta e as Réguas

- **a.** Abre o Adobe Illustrator e cria um documento novo no formato padrão de 1920 x 1080 pixels.

- **b.** Pressiona o atalho Ctrl + R para ativar as réguas na parte superior e lateral da tela.

- **c.** Clica na régua horizontal superior, segura e arrasta a linha guia para baixo até à metade exata da altura do ecrã (Y: 540 px). Acabaste de posicionar a Linha do Horizonte (LH).

- **d.** Clica na régua vertical esquerda e arrasta outra guia até ao meio horizontal da prancheta (X: 960 px).

- **e.** O cruzamento exato destas duas linhas guias marca o teu Ponto de Fuga (PF).

### Passo 2: A Parede do Fundo (Regra Frontal)

- **a.** Na barra de ferramentas à esquerda, ativa a Ferramenta Retângulo (Atalho: tecla M).

- **b.** Configura as cores: deixa o preenchimento sem cor ([Nenhum]) e escolhe um traçado preto com 2 pt de espessura.

- **c.** Desenha um retângulo centralizado ao redor do Ponto de Fuga (com cerca de 800 px de largura por 500 px de altura).

- **d.** Observa a Regra Frontal: as quatro arestas desta parede do fundo são retas puras — teto e rodapé são 100% horizontais, e as laterais são 100% verticais.

### Passo 3: Esculpindo Chão, Teto e Paredes Laterais

- **a.** Seleciona a Ferramenta Caneta (Atalho: tecla P).

- **b.** Dá um clique simples exatamente no Ponto de Fuga (PF) no centro da tela.

- **c.** Puxa a linha reta fazendo-a passar pelo vértice superior esquerdo do retângulo e estica o traçado até ao canto extremo superior da prancheta.

- **d.** Repete este mesmo procedimento a partir do Ponto de Fuga passando pelos outros três cantos do retângulo: superior direito, inferior esquerdo e inferior direito.

- **e.** O feixe em formato de "X" divide a tela em quatro planos imediatos: o teto no topo, o piso na base e as duas paredes laterais a recuar em profundidade!

### Passo 4: O Piso em Perspectiva (Linhas de Convergência)

- **a.** Na borda inferior da prancheta (o chão mais próximo da câmara), marca pequenos pontos de apoio com a Caneta ou com a Ferramenta Linha a cada 150 px de distância.

- **b.** Conecta cada uma dessas marcações da base diretamente ao Ponto de Fuga central, criando um feixe em formato de leque.

- **c.** Agora, traça linhas horizontais paralelas a cortar essas retas diagonais de um lado ao outro: ▪ A primeira linha horizontal, próxima da câmara, deve ter um espaçamento largo em relação à base.

▪ As linhas seguintes devem ficar progressivamente mais juntas e achatadas à medida que sobem e se aproximam da parede do fundo.

- **d.** Essa compressão gradual engana a visão humana, gerando um piso quadriculado que recua no espaço com distância tridimensional realista!', 5, 'Introdutório', '', '[{"title":"Perspetiva Linear","description":"O método geométrico que projeta a tridimensionalidade numa superfície plana com proporção visual exata."},{"title":"Linha do Horizonte (LH)","description":"Linha imaginária que estabelece a altura exata da câmara ou dos olhos do jogador na cena."},{"title":"Ponto de Fuga (PF)","description":"O ponto cravado na Linha do Horizonte que atrai todas as arestas que recuam para o fundo do espaço."},{"title":"Regra Frontal (1 Ponto)","description":"Paredes viradas de frente utilizam apenas linhas perfeitamente horizontais e verticais, sem distorção angular."},{"title":"Encolhimento Espacial","description":"Linhas de piso e objetos repetidos ficam progressivamente mais comprimidos e menores conforme se aproximam do Ponto de Fuga."}]'::jsonb, '[{"keys":"Ctrl + R","label":"Ativar réguas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-3', 'volume-interno-mobiliando-o-quarto', 'Volume Interno: Mobiliando o Quarto', 1, 'A Caixa Invisível (Bounding Box) e a Espessura das Coisas', ARRAY['volume', 'interno', 'mobiliando', 'quarto', 'illustrator', 'arte digital', 'design visual']::text[], 'Na semana anterior, construíste a estrutura de paredes e o piso quadriculado de um quarto em perspetiva de 1 Ponto de Fuga. No entanto, um quarto vazio parece apenas uma maquete desabitada. Para transformar esse espaço no quarto de um jogador ou num cenário de jogo real, precisamos de inserir mobília: cama, secretária, baús e portas. No desenvolvimento de videojogos e na arte conceptual, nenhum artista tenta desenhar os lençóis de uma cama ou as gavetas de um armário logo à primeira. Tudo começa com o conceito de Bounding Box (Caixa Delimitadora): um prisma ou bloco geométrico simples que envolve o objeto para definir o espaço físico e o volume que ele ocupa no mundo 3D. Para mobilar um quarto em perspetiva frontal sem quebrar a ilusão espacial, seguimos três princípios fundamentais:

- A Face Frontal Mantém-se Reta: A parte da cama, do armário ou da mesa que está virada de frente para o jogador obedece à Regra Frontal, utilizando apenas linhas 100% horizontais e 100% verticais (largura e altura puras).

- Profundidade Rumo ao Íman: Todas as arestas do tampo e das laterais do móvel que recuam em direção ao fundo do quarto são desenhadas a apontar diretamente para o mesmo Ponto de Fuga (PF) das paredes.

- A Espessura Real das Paredes: Uma porta ou janela aberta numa parede lateral não é um autocolante plano. Para cavar passagens e gavetas na alvenaria, quebramos a diagonal da parede puxando pequenas linhas horizontais puras para dentro do cenário, revelando a grossura da parede ou da madeira.', '## Inserindo uma Cama e uma Porta com Espessura no Quarto

Abre o ficheiro do quarto estruturado na semana anterior para mobilar o ambiente com blocos volumétricos e abrir uma passagem com profundidade na parede.

### Passo 1: Desenhando a Frente da Cama (Bloco Inicial)

- **a.** No ficheiro do teu quarto construído na Semana 13, localiza o canto inferior esquerdo do chão.

- **b.** Na barra de ferramentas, ativa a Ferramenta Retângulo (Atalho: tecla M).

- **c.** Desenha um retângulo baixo e largo encostado à grelha do piso.

- **d.** Esta forma geométrica representa a "peseira" da cama virada de frente para a câmara do jogador.

### Passo 2: Puxando a Profundidade para o Ponto de Fuga

- **a.** Ativa a Ferramenta Caneta (Atalho: tecla P) ou a Ferramenta Segmento de Linha (\).

- **b.** Clica no canto superior esquerdo da peseira da cama e traça uma linha reta contínua até ao Ponto de Fuga (PF) no centro da parede do fundo.

- **c.** Clica no canto superior direito da peseira e puxa outra reta guia até ao Ponto de Fuga (PF).

- **d.** Repete o mesmo traçado no canto inferior direito da base da cama, ligando-o também ao Ponto de Fuga.

### Passo 3: Cortando o Comprimento do Colchão

- **a.** Define visualmente até onde a cabeceira da cama vai recuar ao longo do chão.

- **b.** Com a Caneta (P), desenha uma linha perfeitamente horizontal a unir as duas retas guias superiores que estão a convergir para o centro.

- **c.** A partir do ponto final dessa horizontal à direita, desce uma linha perfeitamente vertical até encontrar a linha guia da base do colchão no chão.

- **d.** Utiliza a Ferramenta Tesoura (Atalho: tecla C) para cortar e apagar os excessos das linhas guias que continuavam em direção ao Ponto de Fuga.

- **e.** O colchão ganha massa sólida e repousa de forma tridimensional no quarto!

### Passo 4: Escavando uma Porta com Espessura na Parede Direita

- **a.** Na parede lateral direita do quarto, traça duas linhas verticais paralelas com a Caneta (P) para marcar a largura da porta.

- **b.** Clica no topo da primeira linha vertical e traça uma diagonal até ao Ponto de Fuga (PF) para definir a inclinação superior do batente da porta.

- **c.** A Revelação da Espessura: A partir do vértice superior frontal da porta, puxa uma pequena linha reta perfeitamente horizontal para a direita (entrando na parede).

- **d.** A partir dessa ponta, desce uma linha vertical interna para fechar o batente.

- **e.** A parede deixa de parecer uma folha fina de papel e ganha a grossura da alvenaria real!', 5, 'Introdutório', '', '[{"title":"Bounding Box","description":"O prisma ou bloco geométrico simples desenhado em perspetiva antes de se esculpirem os detalhes finais de qualquer mobília ou equipamento."},{"title":"Regra Frontal no Mobiliário","description":"As faces dos móveis viradas de frente para a câmara utilizam unicamente linhas horizontais e verticais puras. verticais puras."},{"title":"Profundidade Partilhada","description":"Todas as arestas de recuo de tampos, camas e mesas convergem obrigatoriamente para o mesmo Ponto de Fuga das paredes."},{"title":"Fecho de Caixas 3D","description":"O comprimento de um móvel é delimitado cruzando retas perfeitamente horizontais e verticais entre as linhas de fuga."},{"title":"Espessura Estrutural","description":"Portas, janelas e nichos ganham volume arquitetónico quando quebramos a diagonal da parede com linhas horizontais puras a entrar no espaço."}]'::jsonb, '[]'::jsonb),
    ('producao-multimidia-i', 'modulo-3', 'proporcao-estilizada-o-estilo-chibi-cartoon', 'Proporção Estilizada: Personagem Chibi (Cartoon)', 2, 'A Fofura Matemática e o Poder da Cabeça Gigante', ARRAY['proporção', 'estilizada', 'estilo', 'chibi', 'cartoon', 'illustrator', 'arte digital', 'design visual']::text[], 'Já reparaste como em jogos como Animal Crossing, Pokémon ou The Legend of Zelda: Link''s Awakening, os personagens têm um visual extremamente carismático, simpático e marcante? Isso não acontece por acaso; acontece graças a uma técnica visual chamada Estilização por Proporção. Na arte tradicional e nas bandas desenhadas clássicas de super-heróis, o corpo humano obedece ao Cânone das 8 Cabeças: a altura total da figura equivale a oito vezes o tamanho do seu próprio crânio. Essa proporção realista cria deuses imponentes e guerreiros musculados com membros compridos e cabeça pequena. No entanto, para quem está a criar o seu primeiro jogo ou animação, desenhar dezenas de músculos complexos pode prender o fluxo de criação. É aqui que entra o estilo Cartoon / Chibi (2 a 3 Cabeças):

- Proporção Realista (7 a 8 Cabeças): Foco em anatomia rigorosa, tronco pesado e membros longos.

- Proporção Cartoon / Chibi (2 a 3 Cabeças): A cabeça gigante ocupa metade ou um terço da altura total do personagem.

Ao comprimirmos o corpo para 2 ou 3 cabeças, eliminamos a necessidade de decorar nomes de músculos ou desenhar clavículas. O foco visual é direcionado inteiramente para aquilo que realmente importa num herói carismático: a expressividade dos olhos, a silhueta das roupas e o apelo visual (appeal). Se os olhos ocuparem a metade inferior de um rosto volumoso, o cérebro do jogador regista o personagem de imediato como fofo, jovem e digno de proteção.', '## Construção da Estrutura de um Herói Chibi de 2 Cabeças e Meia

Abre o Illustrator para construir um gabarito modular de altura e estruturar o corpo de um herói estilizado do zero.

### Passo 1: O Gabarito de Alt ura (Empilhando Cabeças)

- **a.** Abre o Illustrator na tua prancheta de trabalho de 1920 x 1080 px.

- **b.** Na barra de ferramentas à esquerda, ativa a Ferramenta Elipse (Atalho: tecla L).

- **c.** Mantém premida a tecla Shift, clica no ecrã e arrasta para criar um círculo perfeito de 150 px de diâmetro. Este círculo é o nosso módulo de medida: representa 1 Cabeça.

- **d.** Ativa a Ferramenta Seleção (Seta Preta - Atalho: tecla V) e seleciona o círculo.

- **e.** Mantém premidas as teclas Alt + Shift no teclado, clica no círculo e arrasta para baixo duas vezes seguidas para formar uma coluna vertical de 3 círculos alinhados.

- **f.** Com a Seta Preta (V), seleciona os três círculos e pressiona o atalho Ctrl + 2 para bloqueá-los. Eles servirão como a nossa régua de proporção.

### Passo 2: O Crânio e o Rosto (Cabeça 1)

- **a.** Seleciona a Ferramenta Elipse (L).

- **b.** Desenha uma forma oval larga preenchendo quase todo o primeiro círculo-guia do topo.

- **c.** Ativa a Ferramenta Seleção Direta (Seta Branca - Atalho: tecla A).

- **d.** Clica no ponto de ancoragem da base inferior da elipse e puxa-o suavemente para baixo e para os lados para criar bochechas volumosas e macias.

- **e.** Volta à Ferramenta Elipse (L) e desenha dois círculos ou ovais pretos grandes na metade inferior do rosto. Posicionar os olhos abaixo da linha média do crânio é a regra de ouro para dar o aspeto infantil e simpático ao desenho.

### Passo 3: Tronco e Bacia (A Cabeça 2)

- **a.** No espaço delimitado pelo segundo círculo-guia, ativa a Ferramenta Retângulo Arredondado (ou a Ferramenta Elipse).

- **b.** Desenha um tronco pequeno e simples em formato de feijão, gota virada para baixo ou coxinha.

- **c.** Lembra-te: o corpo Chibi não tem peitoral dividido ou cintura rígida; é uma massa compacta e contínua.

- **d.** Garante que a virilha e a linha dos pulsos do personagem terminam exatamente na transição para o terceiro círculo.

### Passo 4: Membros Simples e Tubulares (Cabeça 3)

- **a.** Desenha as pernas no terceiro círculo como pequenos cilindros curtos, grossos e tubulares.

- **b.** Para os pés, não tentes desenhar dedos individuais: cria pequenas formas ovais horizontais simples que funcionem como sapatos estilizados de desenho animado.

- **c.** Conecta os braços ao tronco usando cilindros simples que partem dos ombros e descem até à linha da cintura/bacia.

- **d.** Pressiona o atalho Ctrl + Alt + 2 para desbloquear todos os objetos da prancheta.

- **e.** Com a Seta Preta (V), seleciona os três círculos de gabarito iniciais e carrega em Delete.

- **f.** O teu herói Chibi fica com proporções anatómicas equilibradas, limpas e pronto para receber roupas e acessórios!', 5, 'Introdutório', '', '[{"title":"Cânone de 8 Cabeças vs. Chibi","description":"O cânone realista de 8 cabeças serve para figuras imponentes e heroicas; a proporção de 2 a 3 cabeças prioriza o carisma, o apelo visual e a fofura."},{"title":"A Cabeça como Unidade","description":"Toda a altura do personagem é medida e dividida usando o tamanho do seu próprio crânio como"},{"title":"A Cabeça como Unidade","description":"Toda a altura do personagem é medida e dividida usando o tamanho do seu próprio crânio como gabarito."},{"title":"Olhos na Metade Inferior","description":"Posicionar os olhos grandes na parte de baixo da cabeça acentua a expressividade e a sensação de juventude do herói."},{"title":"Tronco Simplificado","description":"Corpos no estilo Cartoon não dividem músculos; são desenhados como massas orgânicas únicas em forma de gota ou feijão."},{"title":"Membros Tubulares","description":"Braços e pernas são construídos com cilindros curtos e sapatos ovais sem necessidade de dedos detalhados."},{"title":"Gabarito com Ctrl + 2","description":"Bloquear círculos de apoio permite utilizá-los como régua visual sem correr o risco de os arrastar por engano durante a construção."}]'::jsonb, '[{"keys":"Ctrl + Alt + 2","label":"Desbloquear tudo"},{"keys":"Ctrl + 2","label":"Bloquear seleção"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-3', 'a-alma-do-movimento-poses-de-acao', 'A Alma do Movimento: Poses de Ação', 3, 'A Alma do Gesto, o "Verbo" e a Linha de Ação', ARRAY['alma', 'movimento', 'poses', 'ação', 'illustrator', 'arte digital', 'design visual']::text[], 'Nas semanas anteriores, construímos o corpo humano com réguas, cabeças empilhadas e volumes geométricos como verdadeiros engenheiros. A geometria dá solidez e peso, mas se ficarmos presos apenas a caixas e cilindros retos, o personagem parecerá um manequim duro travado na vitrine de uma loja. A precisão matemática traz firmeza, mas a vida exige dinamismo. Nos estúdios profissionais de jogos e animação, os artistas utilizam o Desenho Gestual (Gesture Drawing) para destravar o traço e dar atitude às cenas. No desenho de ação, o seu objetivo imediato não é desenhar olhos, dedos, fivelas de cinto ou dobras de roupa. O foco do gesto é desenhar o "verbo" da cena: o que o herói está fazendo fisicamente? Ele está saltando, desferindo um golpe, caindo ou fugindo a toda velocidade? Para capturar essa energia antes que o movimento se perca, seguimos dois princípios visuais fundamentais:

- A Linha de Ação (Line of Action): É uma curva mestra invisível e fluida que atravessa o corpo inteiro, nascendo no topo da cabeça, descendo pela coluna e terminando na ponta do pé de apoio. Linhas 100% retas transmitem imobilidade e rigidez.

O movimento real é construído com curvas abertas em formato de "C" ou "S", projetando o peso do corpo na direção do impacto.

- Oposição de Ombros e Bacia: Quando um ser humano corre ou ataca, o corpo dele nunca fica com as articulações perfeitamente paralelas. Se a linha dos ombros se inclina para a direita, a linha da bacia compensa inclinando-se na direção oposta para distribuir o peso e manter o equilíbrio cinético da pose.', '## Capturando a Linha de Ação e Estruturando uma Pose de Ataque no Illustrator

Abra o Illustrator para extrair a força do movimento de uma referência real e construir uma pose dinâmica sobreposta.

### Passo 1: Encontrando a Linha de Ação (A Curva Mestra)

- **a.** Crie uma prancheta de 1920 x 1080 px e insira uma imagem de referência de um atleta ou herói a saltar ou a correr via menu: Arquivo > Inserir (File > Place).

- **b.** Bloqueie a foto de referência pressionando Ctrl + 2 para trabalhar com segurança.

- **c.** Ative a Ferramenta Caneta (Atalho: tecla P) ou a Ferramenta Pincel (Atalho: tecla B).

- **d.** Configure as propriedades de cor: deixe o preenchimento sem cor ([Nenhum]) e utilize um traçado suave em tom Vermelho com 2 pt de espessura.

- **e.** Trace um único arco longo e contínuo (uma curva em "C" ou "S") que corte a pose desde a cabeça até ao pé que sustenta o impacto no chão.

- **f.** Observe como essa linha mestra define a intenção da pose: se o herói ataca, a curva projeta o peito para a frente sustentando a inércia do golpe.

### Passo 2: Marcando as Linhas de Inclinação (Ombros e Pélvis)

- **a.** Mantenha a Caneta (P) ativa com o traçado vermelho.

- **b.** Cruze a Linha de Ação na altura do peito desenhando uma reta diagonal curta para marcar a inclinação do eixo dos ombros.

- **c.** Mais abaixo, trace outra diagonal reta para o eixo da cintura/bacia, inclinada no sentido oposto ao dos ombros.

- **d.** Essa oposição angular quebra de imediato a rigidez estática e introduz o equilíbrio vivo do movimento natural.

### Passo 3: Manequim Gestual com Formas Soltas

- **a.** Desenhe uma esfera simples inclinada no topo para representar a cabeça, acompanhando a direção do olhar do personagem.

- **b.** Esboce a caixa torácica e a bacia como duas massas ovais simplificadas, conectadas pela coluna flexível que acompanha a Linha de Ação.

- **c.** Puxe arcos rápidos e abertos para marcar a trajetória dos membros: a linha do braço que empunha a arma e as linhas das pernas em impulsão.

- **d.** Não feche contornos nem desenhe detalhes individuais nesta etapa; mantenha os traços longos e fluidos.

### Passo 4: Finalização Rápida de Silhueta

- **a.** Ative a Ferramenta Seleção (Seta Preta - Atalho: tecla V), selecione todas as linhas do esqueleto gestual vermelho e abra o painel Transparência (Shift + Ctrl + F10).

- **b.** Reduza a Opacidade desse esqueleto para 30% e bloqueie a camada ou as linhas com Ctrl + 2.

- **c.** Crie uma nova camada por cima (ou selecione a Caneta com um traçado preto de 3 pt).

- **d.** Desenhe os volumes musculares externos e a silhueta das roupas por cima da estrutura transparente.

- **e.** Como a base segue uma curva dinâmica forte, a silhueta final preservará toda a energia e velocidade do golpe original!', 5, 'Introdutório', '', '[{"title":"Desenho Gestual (Gesture Drawing)","description":"Esboços rápidos focados em capturar a força, o ritmo e o \"verbo\" da ação, ignorando"},{"title":"Desenho Gestual (Gesture Drawing)","description":"Esboços rápidos focados em capturar a força, o ritmo e o \"verbo\" da ação, ignorando detalhes anatômicos secundários."},{"title":"Linha de Ação (Line of Action)","description":"A curva mestra contínua (em \"C\" ou \"S\") que atravessa o corpo da cabeça ao pé de apoio, ditando a direção do movimento."},{"title":"Evite Retas Rígidas","description":"Linhas 100% retas transmitem paragem e rigidez; curvas dinâmicas comunicam velocidade, tensão e impacto."},{"title":"Oposição de Eixos","description":"Ombros e pélvis inclinados em sentidos contrários quebram o aspeto robótico e distribuem o peso realisticamente."},{"title":"Traço Amplo com o Braço","description":"O desenho de movimento deve ser feito com traçados longos e seguros, evitando riscos curtos e picotados na tela."},{"title":"Construção por Camadas","description":"O manequim gestual serve como guia de apoio em opacidade reduzida (30%) para receber a silhueta finalizada por cima."}]'::jsonb, '[{"keys":"Ctrl + 2","label":"Bloquear seleção"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-3', 'ancoragem-simples-o-personagem-no-espaco', 'Ancoragem Simples: O Personagem no Espaço', 4, 'A Ilusão do Autocolante e a Lei do Horizonte Humano', ARRAY['ancoragem', 'simples', 'personagem', 'espaço', 'illustrator', 'arte digital', 'design visual']::text[], 'Já tentaste desenhar um cenário detalhado e depois colocaste lá dentro um personagem que parecia estar a levitar ou que parecia um gigante comparado com a porta? Isso acontece porque não basta desenhar um ambiente e um herói de forma isolada; eles precisam de estar matematicamente integrados. Sem essa amarração geométrica, a figura não parece habitar o mundo do jogo, parecendo antes um autocolante solto colado no vidro do monitor. No design de videojogos e na arte concetual, o processo de fixar um personagem ao chão de um espaço tridimensional chama-se Ancoragem. A ancoragem respeita duas leis físicas fundamentais da perspetiva linear:

- Linha do Horizonte = Nível dos Olhos: Se a câmara do jogo e o personagem estiverem apoiados no mesmo plano de chão horizontal, a Linha do Horizonte cortará exatamente a altura dos olhos da figura. Se a linha cortar o peito, a câmara está mais alt a; se estiver acima da cabeça, a câmara vê a cena de cima.

- A Escala de Chão e o Deslizamento de Fuga: Quando o personagem caminha para o fundo do cenário, ele não diminui no "olhómetro" ou por palpite. Traçam-se duas retas convergentes a partir do Ponto de Fuga: uma toca no topo da cabeça e a outra na sola dos pés da figura original. Qualquer réplica colocada entre esses dois carris terá a escala humana rigorosamente preservada pela matemática da perspetiva.

Por fim, a sombra projetada na base dos sapatos atua como a cola física que confirma o peso, a gravidade e o contacto do modelo com o solo.', '## Ancorando e Multiplicando a Escala do Personagem em Profundidade

Abre o Illustrator para posicionar o teu herói na grelha de piso e calcular matematicamente o seu encolhimento em profundidade.

### Passo 1: O Ponto de Contacto e a Linha de Alt ura

- **a.** Abre no Illustrator o ficheiro do quarto com piso quadriculado construído na Semana 13.

- **b.** Escolhe um quadrado específico da grelha de piso no primeiro plano onde o personagem irá assentar os pés.

- **c.** Ativa a Ferramenta Caneta (Atalho: tecla P) e traça uma linha vertical perfeitamente reta que suba desse ponto de apoio no chão até encontrar a Linha do Horizonte (LH).

- **d.** Esta reta vertical define a tua altura padrão no primeiro plano: o topo da cabeça alinha com a LH e a base toca no quadrado do chão.

### Passo 2: Inserindo o Manequim no Primeiro Plano

- **a.** Posiciona o teu herói Chibi (construído na Semana 15) ou manequim sobre essa linha vertical guia.

- **b.** Confirma que a linha dos olhos do personagem fica cravada na Linha do Horizonte.

- **c.** Garante que os dois pés assentam com firmeza na mesma linha horizontal da grelha do piso.

### Passo 3: A Mágica do Deslizamento de Escala para o Fundo

- **a.** Imagina que precisas de colocar um segundo personagem a caminhar mais longe, junto à parede do fundo da sala.

- **b.** Seleciona a Ferramenta Caneta (P) com uma linha de traçado fina.

- **c.** Clica no Ponto de Fuga (PF) central e traça uma linha guia que passe a raspar no topo exato da cabeça do primeiro personagem.

- **d.** Clica novamente no Ponto de Fuga (PF) e traça outra linha guia que passe a raspar na sola dos pés do mesmo herói.

- **e.** Escolhe a nova posição no chão ao fundo da sala e traça uma linha vertical delimitada rigorosamente entre essas duas retas convergentes.

- **f.** Duplica o personagem (Ctrl + C e Ctrl + V), move-o para essa nova marca e reduz o seu tamanho proporcionalmente (mantendo premida a tecla Shift) até que ele encaixe perfeitamente entre as duas guias: a proporção de recuo 3D está calculada com precisão absoluta!

### Passo 4: A Sombra de Ancoragem (A Cola do Chão)

- **a.** Na barra de ferramentas, ativa a Ferramenta Elipse (Atalho: tecla L).

- **b.** Desenha uma elipse achatada e horizontal posicionada exatamente por baixo da sola dos pés do herói.

- **c.** Pinta a elipse de Preto Puro sólido e retira o contorno.

- **d.** Abre o painel Transparência (Shift + Ctrl + F10), alt era o menu suspenso de Normal para Multiplicação (Multiply) e define a opacidade para 60%.

- **e.** A sombra funde-se com as cores do piso, criando a ilusão física de massa e peso que fixa o herói ao chão!', 5, 'Introdutório', '', '[{"title":"Ancoragem","description":"O processo de alinhar o personagem ao chão e ao horizonte para que ele pareça habitar o espaço tridimensional em vez de flutuar."},{"title":"LH = Linha dos Olhos","description":"Em solo horizontal plano com a câmara à altura padrão, a Linha do Horizonte passa obrigatoriamente na altura dos olhos da figura humana."},{"title":"Grelha de Chão (Ground Plane)","description":"A malha de perspetiva quadriculada desenhada no piso que serve de régua de"},{"title":"Grelha de Chão (Ground Plane)","description":"A malha de perspetiva quadriculada desenhada no piso que serve de régua de posicionamento e suporte para os pés."},{"title":"Deslizamento por Fuga","description":"O método de puxar retas convergentes a partir do Ponto de Fuga (passando pela cabeça e pelos pés) para calcular a altura exata de elementos distantes."},{"title":"Sombra de Contacto em Multiplicação","description":"A elipse escura sob os pés configurada em modo Multiply no painel Transparência, responsável por ancorar a gravidade do personagem ao piso do cenário."}]'::jsonb, '[{"keys":"Ctrl + C","label":"Copiar objeto"},{"keys":"Ctrl + V","label":"Colar objeto"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-3', 'narrativa-visual-detalhes-que-contam-historias', 'Narrativa Visual: Detalhes que Contam Histórias', 5, 'A Alma do Cenário e a Narrativa Ambiental', ARRAY['narrativa', 'visual', 'detalhes', 'que', 'contam', 'histórias', 'illustrator', 'arte digital', 'design visual']::text[], 'Num videojogo ou numa ilustração concetual, um quarto ou masmorra não pode ser apenas uma caixa cinzenta vazia e funcional. O trabalho de um artista de cenários vai muito além de colocar paredes retas e chão quadriculado; ele utiliza a Narrativa Ambiental (Environmental Storytelling), que é a arte de contar quem vive naquele local, o que aconteceu ali e qual é o clima da história sem recorrer a uma única linha de texto ou diálogo no ecrã. A identidade de um espaço nasce dos detalhes deixados por quem o habita:

- Quem vive aqui? Se o quarto pertencer a um jovem aprendiz de feitiçaria, o ambiente terá pergaminhos enrolados pelos cantos, velas a derreter e frascos de poção brilhantes. Se for a oficina de um mecânico de naves espaciais, o chão terá parafusos espalhados, ferramentas penduradas na parede e ecrãs com cabos soltos.

- Interação com a Arquitetura: O teu personagem torna-se credível quando reage fisicamente aos objetos ao seu redor. Um herói que está simplesmente em pé como uma estátua parece artificial; mas se ele estiver sentado na cama, encostado à parede com uma perna dobrada no rodapé ou a puxar um livro de uma prateleira, o cérebro do jogador acredita de imediato na solidez do mundo.

- Respiro Visual vs. Pontos de Interesse: Nem todas as paredes precisam de estar cheias de tralha. O contraste entre áreas lisas e cantos com acumulação intencional de objetos guia a visão do jogador para o que é narrativamente importante.', '## Transformando a Sala numa Oficina Temática com Interação e Desgaste

Abre o ficheiro do quarto com o herói ancorado para quebrar a rigidez da pose, construir prateleiras em perspetiva, espalhar pequenos adereços e unificar a iluminação da cena.

### Passo 1: Quebrando a Rigidez da Pose (Interação Física)

- **a.** No teu cenário, seleciona o personagem que está posicionado junto à parede lateral.

- **b.** Ativa a Ferramenta Seleção Direta (Seta Branca - Atalho: tecla A).

- **c.** Seleciona os pontos de ancoragem da perna do herói que está mais encostada à parede.

- **d.** Dobra o joelho dessa perna, erguendo o pé e assentando a sola do sapato diretamente sobre o rodapé da parede lateral.

- **e.** Ao apoiar o membro contra a alvenaria, a figura humana deixa de parecer rígida e passa a habitar o espaço físico da sala com naturalidade.

### Passo 2: Adicionando Detalhes Primários nas Paredes

### Passo 2: Adicionando Detalhes Primários nas Paredes

- **a.** Na parede lateral esquerda, ativa a Ferramenta Caneta (Atalho: tecla P).

- **b.** Traça linhas que partem do Ponto de Fuga (PF) para desenhar prateleiras de madeira fixadas na parede em declive.

- **c.** Puxa pequenas linhas horizontais para dentro da sala para dar espessura às tábuas.

- **d.** Na parede do fundo (que obedece à Regra Frontal), ativa a Ferramenta Retângulo (tecla M) e desenha um quadro de aviso ou mapa tático.

- **e.** Com a Seta Preta (V), aproxima o cursor de uma das quinas e inclina o retângulo do quadro ligeiramente para o lado. Elementos tortos ou desalinhados comunicam descuido, ação e passagem do tempo.

### Passo 3: Pequenos Props e Desgaste (A Camada de Vida)

- **a.** Para detalhar a secretária, seleciona a Ferramenta Retângulo Arredondado e a Ferramenta Elipse (L) para desenhar pequenos frascos e garrafas sobre o tampo.

- **b.** Une ou corta os excessos dos frascos com o Construtor de Formas (Shift + M).

- **c.** Na grelha do piso de pedra, ativa a Ferramenta Caneta (P) com um traçado preto fino de 1 pt e desenha pequenas linhas quebradas em zigue-zague para criar rachaduras nas lajes.

- **d.** Desenha folhas de papel caídas no chão utilizando retângulos com os lados a afunilar em direção ao Ponto de Fuga para assentarem na perspetiva do chão.

### Passo 4: Ajuste de Luz e Sombra Integradas

- **a.** Define a fonte de iluminação principal do compartimento (como a janela aberta na parede lateral).

- **b.** Verifica todos os novos objetos: a lateral oposta à janela em cada frasco, caixa, prateleira e no corpo do herói deve receber um tom mais escuro de sombra própria.

- **c.** Esta iluminação unificada amarra todos os microdetalhes numa única atmosfera coerente, crível e sólida.', 5, 'Introdutório', '', '[{"title":"Narrativa Ambiental (Environmental Storytelling)","description":"A técnica de contar quem vive no local e qual a sua história através da disposição visual de objetos e pistas no cenário."},{"title":"Interação Física","description":"Fazer o personagem encostar-se, sentar-se ou dobrar membros sobre elementos da arquitetura elimina o aspeto de estátua rígida."},{"title":"Desalinhamento Narrativo","description":"Quadros tortos, papéis caídos e rachaduras no chão comunicam vida, ação e passagem do tempo na cena."},{"title":"Props em Perspetiva","description":"Prateleiras nas paredes laterais e folhas no chão devem ter as suas bordas de recuo alinhadas rigorosamente com o Ponto de Fuga."},{"title":"Luz Consistente","description":"Todos os pequenos objetos adicionados ao quarto devem partilhar a mesma direção de luz e sombra para manter a cena unificada."}]'::jsonb, '[{"keys":"Shift + M","label":"Construtor de Formas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-3', 'expressoes-e-emocoes-cartoon-as-reacoes-do-heroi', 'Expressões e Emoções Cartoon: As Reações do Herói', 6, 'A Máscara dos Sentimentos e a Geometria do Rosto', ARRAY['expressões', 'emoções', 'cartoon', 'reações', 'herói', 'illustrator', 'arte digital', 'design visual']::text[], 'Já reparaste no motivo pelo qual nos afeiçoamos tão rápido a um personagem de anime ou de jogo? Não é apenas pelo visual da armadura ou pelo golpe especial; é porque conseguimos ler com clareza o que ele está a sentir no rosto! Um personagem com um olhar estático e sem reação parece apenas um manequim sem vida. São as microexpressões que criam empatia e ligam o jogador à história. No design estilizado e em jogos 2D, não precisamos de desenhar dezenas de músculos anatómicos complexos. O rosto do herói é simplificado em módulos independentes que funcionam como autênticos interruptores de emoção:

- O Eixo das Sobrancelhas: É o leme emocional principal do rosto humano. Se inclinares as pontas para baixo em direção ao nariz (formando um "V" tenso), comunicas foco extremo, fúria ou agressividade; se as curvares para cima no centro da testa, comunicas choque, pavor, dúvida ou tristeza; se estiverem suaves e relaxadas, transmitem calma e alegria.

- A Abertura dos Olhos: Olhos bem esbugalhados com a pupila encolhida até virar um ponto minúsculo comunicam choque, susto ou terror imediato.

Olhos semicerrados em fendas transmitem desconfiança, concentração ou cansaço.

- A Geometria da Boca: Funciona como o complemento perfeito dos olhos: arcos curvados para cima indicam satisfação e simpatia; arcos virados para baixo expressam descontentamento e nojo; aberturas amplas em forma de "O" ou "D" comunicam gritos de batalha ou gargalhadas abertas.

Ao manteres a mesma cabeça e mexeres apenas nas linhas dos olhos, sobrancelhas e boca, geras múltiplos estados de espírito em poucos segundos!', '## Montando uma Matriz de Expressões sobre a Cabeça do Mascote

Abre o Illustrator para criar uma folha de reações com três estados emocionais distintos (Determinado, Assustado e Confiante) sobre o molde do teu herói.

### Passo 1: A Base da Cabeça Duplicada

- **a.** No Illustrator, seleciona a cabeça do herói Chibi que desenvolveste na Semana 15.

- **b.** Remove os olhos, sobrancelhas e boca antigos, mantendo apenas a silhueta limpa do crânio com o cabelo e as orelhas.

- **c.** Ativa a Ferramenta Seleção (Seta Preta - Atalho: tecla V) e clica na cabeça vazia.

- **d.** Mantém premidas as teclas Alt + Shift no teclado, clica e arrasta para o lado direito duas vezes seguidas para gerar três bases perfeitamente alinhadas na prancheta.

### Passo 2: Expressão 1 – Determinado / Bravo

- **a.** Na primeira cabeça, ativa a Ferramenta Elipse (Atalho: tecla L) e, com a

- **a.** Na primeira cabeça, ativa a Ferramenta Elipse (Atalho: tecla L) e, com a tecla Shift pressionada, desenha dois círculos pretos médios para marcar os olhos.

- **b.** Seleciona a Ferramenta Caneta (Atalho: tecla P), desativa a cor de preenchimento ([Nenhum]) e escolhe um traçado preto com 3 pt de espessura.

- **c.** Desenha duas linhas diagonais retas inclinadas para baixo, apontando para o centro do nariz e formando um "V" aberto: as sobrancelhas franzidas de foco e raiva.

- **d.** Para a boca, desenha uma linha reta horizontal tensa ou um trapézio fechado simulando dentes cerrados prontos para o combate.

### Passo 3: Expressão 2 – Assustado / Chocado

- **a.** Na segunda cabeça, usa a Ferramenta Elipse (L) sem a tecla Shift para desenhar dois olhos ovais enormes e arregalados.

- **b.** No centro de cada olho, desenha uma pupila circular preta minúscula: esse contraste entre a órbita gigante e a pupila encolhida transmite pânico imediato.

- **c.** Com a Caneta (P), desenha as sobrancelhas como dois arcos curvados para cima, posicionados bem longe dos olhos.

- **d.** Para a boca, desenha uma elipse vertical aberta (formato de "O"), simulando um grito de surpresa ou pavor.

### Passo 4: Expressão 3 – Confiante / Sorridente

- **a.** Na terceira cabeça, substitui os círculos dos olhos: ativa a Caneta (P) e desenha dois arcos curvados para cima (como dois pequenos sorrisos), simulando olhos semicerrados de pura satisfação.

- **b.** Desenha uma das sobrancelhas numa linha relaxada e curva a outra suavemente para cima, criando um ar irónico e seguro.

- **c.** Desenha uma boca ampla em meia-lua aberta com a base arredondada, preenchida com um sorriso luminoso.

- **d.** Com a Seta Preta (V), seleciona os elementos de cada cabeça individualmente e prime Ctrl + G para agrupar cada expressão no seu próprio bloco.', 5, 'Introdutório', '', '[{"title":"O Eixo das Sobrancelhas","description":"O maior indicador emocional do desenho; inclinadas para baixo em \"V\" comunicam agressividade e foco, e curvadas para cima transmitem medo e espanto."},{"title":"Pupilas Encolhidas","description":"Reduzir o tamanho da pupila dentro de um olho esbugalhado vende a ilusão instantânea de choque ou susto."},{"title":"Olhos Semicerrados","description":"Linhas curvas voltadas para cima no lugar dos olhos passam a sensação de tranquilidade, confiança e alegria genuína."},{"title":"Matriz com Alt + Shift","description":"O método mais ágil para duplicar a estrutura do personagem e manter a coerência de escala entre diferentes reações."},{"title":"Agrupamento (Ctrl + G)","description":"Consolida os traços faciais com a cabeça, facilitando a troca de expressões em cenas narrativas e animações."}]'::jsonb, '[{"keys":"Ctrl + G","label":"Agrupar objetos"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-4', 'psicologia-visual-gestalt-e-o-design-subtrativo', 'Psicologia Visual (Gestalt) e o Design Subtrativo', 0, 'A Mente Preguiçosa do Jogador e as Leis da Gestalt', ARRAY['psicologia', 'visual', 'gestalt', 'design', 'subtrativo', 'illustrator', 'arte digital', 'design visual']::text[], 'Quando estás a jogar e abres o teu inventário ou a árvore de habilidades, o teu cérebro não fica a analisar cada pixel individualmente no ecrã. Ele quer poupar energia mental e toma decisões em frações de segundo. Para fazer isso, a nossa visão procura automaticamente padrões e grupos organizados no meio do caos. No início do século XX, psicólogos alemães criaram a Teoria da Gestalt (que significa "forma" ou "configuração"). A regra de ouro da Gestalt é direta: o todo é percebido antes das partes e é maior do que a simples soma delas. Nas interfaces de jogos (UI Design), quatro leis comandam essa leitura imediata da mente:

- Lei da Proximidade: Elementos colocados perto uns dos outros são lidos como pertencendo ao mesmo grupo funcional.

Se colocares três ícones de armas no canto esquerdo e três poções no canto direito, o cérebro divide-os de imediato em "Ataque" e "Cura" sem precisares de desenhar caixas ou molduras à volta! O espaço vazio (espaço negativo) encarrega- se da separação.

- Lei da Semelhança: Coisas com a mesma cor, forma ou tamanho parecem parentes. Num campo de batalha caótico, como sabes quem é aliado e quem é inimigo? Pela cor do escudo: todos os escudos azuis são lidos como uma única equipa e os vermelhos como outra.

- Lei do Fechamento: Se uma forma estiver incompleta ou tiver cortes, o teu cérebro preenche as falhas invisíveis e enxerga o desenho fechado e completo. É o truque usado no logótipo do panda da WWF e em ícones minimalistas de jogos.

- Lei da Continuidade: O olhar percorre caminhos e curvas suaves com muito mais facilidade do que curvas travadas.

Pensa nas moedas ou nos anéis do Sonic: eles formam uma linha contínua que diz ao jogador por onde correr e saltar sem ser preciso nenhum tutorial escrito! Para criar ícones modernos e velozes para ecrãs pequenos de telemóvel ou inventários de jogos, aplicamos o Design Subtrativo: desenhamos a peça inteira e depois apagamos pedaços desnecessários. Ao usarmos o Espaço Negativo (deixar o fundo aparecer através de recortes vazados), o ícone fica muito mais limpo, marcante e fácil de ler mesmo no meio de uma batalha intensa!', '## Ícone de Habilidade – A Espada Cortada e o Frasco de Poção com Espaço Negativo

Abre o Illustrator para esculpir dois ícones de habilidade aplicando a Lei do Fechamento e o recorte por espaço negativo.

### Passo 1: A Prancheta de Interface

- **a.** Cria um documento novo no Illustrator: predefinição de 1920 x 1080 pixels, orientação em Paisagem (horizontal).

- **b.** Seleciona a Ferramenta Retângulo (Atalho: tecla M) e desenha um retângulo grande cobrindo toda a prancheta (1920 x 1080 px).

- **c.** Pinta este fundo com um tom de Cinzento Escuro Neutro (#222222) e retira a linha de contorno.

- **d.** Pressiona o atalho Ctrl + 2 para bloquear o fundo e não o moveres por engano.

### Passo 2: A Silhueta Sólida da Espada

- **a.** Ativa a Ferramenta Retângulo (M) e clica na prancheta para criar uma lâmina vertical estreita: digita 40 px de largura por 400 px de altura e clica em OK.

- **b.** Pinta a lâmina de Branco Puro (#FFFFFF) e retira o traçado.

- **c.** No menu escondido de formas, ativa a Ferramenta Polígono, dá um clique simples na tela, escolhe Lados: 3 e gera um triângulo branco para ser a ponta perfurante da lâmina. Posiciona-o no topo.

- **d.** Desenha um retângulo horizontal curto cruzando a base da lâmina para fazer a guarda da espada.

- **e.** Desenha outro retângulo fino vertical descendo para formar o cabo e a empunhadura.

- **f.** Com a Ferramenta Seleção (Seta Preta - Atalho: tecla V), clica e arrasta para selecionar todas as peças da espada.

- **g.** Ativa o Construtor de Formas (Atalho: Shift + M), clica e passa o traço por cima de todas as partes da espada para fundir tudo numa única silhueta branca sólida!

### Passo 3: O Corte de Gestalt (Lei do Fechamento)

- **a.** Seleciona a Ferramenta Caneta (Atalho: tecla P) ou a Ferramenta Linha (\).

- **b.** Configura a linha com uma cor visível e uma espessura larga de 12 pt.

- **c.** Traça uma linha diagonal cruzando o meio da lâmina da espada de fora a fora.

- **d.** Com a Seta Preta (V), seleciona a espada branca e a linha diagonal juntas.

- **e.** Vai ao menu superior: Janela > Pathfinder (Window > Pathfinder).

- **f.** No painel do Pathfinder, clica no botão Dividir (Divide).

- **g.** Clica com o botão direito do rato em cima da espada fatiada e escolhe Desagrupar (Ungroup).

- **h.** Com a Seta Preta (V), clica na tira cortada que ficou no meio da lâmina e carrega na tecla Delete.

- **i.** Repara no resultado: a lâmina está fisicamente dividida em dois pedaços a flutuar no ecrã, mas o cérebro humano

- **i.** Repara no resultado: a lâmina está fisicamente dividida em dois pedaços a flutuar no ecrã, mas o cérebro humano conecta a linha invisível e continua a ler a espada inteira com um brilho diagonal cortante!

### Passo 4: Esculpindo com Espaço Negativo

- **a.** Ao lado da espada, desenha a silhueta sólida de um escudo heróico utilizando as formas básicas e a união com o Construtor de Formas. Pinta o escudo de Branco Puro.

- **b.** Seleciona a Ferramenta Retângulo (M) e desenha dois retângulos brancos sobrepostos em forma de sinal de mais para formar uma cruz médica no centro do escudo. Pinta a cruz de uma cor contrastante provisória (como preto) para a veres.

- **c.** Com a Seta Preta (V), seleciona o escudo e a cruz juntos.

- **d.** Ativa o Construtor de Formas (Shift + M).

- **e.** Mantém premida a tecla Alt no teclado (o cursor ganhará um sinal de menos ).

- **f.** Com o Alt pressionado, clica no centro da cruz.

- **g.** O miolo da cruz é eliminado e o escudo fica perfurado: a cor cinzenta do fundo da tela aparece no meio da forma.

Criaste um símbolo poderoso desenhando com o próprio vazio!', 6, 'Introdutório', '', '[{"title":"Teoria da Gestalt","description":"A ciência que estuda a forma como o cérebro organiza estímulos visuais, provando que o todo é lido antes das partes individuais."},{"title":"Lei da Proximidade e Semelhança","description":"Agrupamos elementos pela distância física e pela partilha de cores ou formas (essencial para organizar inventários sem poluição)."},{"title":"Lei do Fechamento","description":"A mente humana une lacunas e completa contornos quebrados, permitindo criar logótipos e ícones vazados."},{"title":"Design Subtrativo","description":"A arte de desenhar uma forma sólida e retirar excessos até restar apenas o essencial com impacto direto."},{"title":"Espaço Negativo","description":"A utilização ativa do fundo transparente para esculpir símbolos e detalhes sem adicionar novas linhas."},{"title":"Squint Test","description":"Semicerrar os olhos para desfocar a visão; se o ícone continuar a ser reconhecível mesmo sem detalhes finos, o contraste e a silhueta funcionam."}]'::jsonb, '[{"keys":"Ctrl + 2","label":"Bloquear seleção"},{"keys":"Shift + M","label":"Construtor de Formas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-4', 'equilibrio-visual-contraste-e-a-regra-dos-tercos', 'Equilíbrio Visual, Contraste e a Regra dos Terços', 1, 'A Balança Invisível, a Regra dos Terços e o Espaço para Respirar', ARRAY['equilíbrio', 'visual', 'contraste', 'regra', 'terços', 'illustrator', 'arte digital', 'design visual']::text[], 'Já olhaste para uma ilustração ou ecrã de início de um jogo em que os desenhos estavam impecáveis, mas a imagem parecia estranha, desconfortável ou a "cair para o lado"? Isso acontece por causa de uma força invisível chamada Gravidade Visual. Toda a composição funciona como uma balança de pratos. Cada elemento que colocas no ecrã tem um determinado peso visual:

- Equilíbrio Simétrico: Funciona em modo espelho: se há um elemento de um lado, há outro idêntico do lado oposto. Transmite ordem, solenidade e rigidez, como nos portões de um templo antigo.

- Equilíbrio Assimétrico: É dinâmico, moderno e natural. Em vez de espelhares coisas iguais, equilibras um objeto grande (mas de cor clara ou distante) num lado, com um elemento pequeno (mas escuro, pontiagudo ou muito contrastante) no outro. A balança equilibra-se sem parecer uma cópia mecânica.

O maior erro dos iniciantes é colocar o herói sempre cravado no meio exato do ecrã, criando uma cena estática e aborrecida. Para fugir do centro morto, usamos a Regra dos Terços. Dividimos o ecrã numa grelha 3x3 (como o jogo do galo) usando duas linhas verticais e duas horizontais. Os quatro pontos de cruzamento dessas linhas são Pontos Magnéticos de atração visual instantânea. E há um detalhe que não podes esquecer: o Lead Room (Espaço de Respiração). Se o teu herói estiver encostado no terço esquerdo e a olhar para a direita, deves deixar os restantes dois terços do ecrã livres à frente dele. Este espaço vazio indica para onde o olhar ou o movimento da personagem avançam, deixando a cena respirar e guiando os olhos do jogador pela paisagem!', '## Montagem da Tela de Título com a Regra dos Terços e Balanço Assimétrico

Abre o Illustrator para construir uma grelha matemática 3x3 e compor a tela inicial (Title Screen) de um jogo com equilíbrio dinâmico e espaço de respiração.

### Passo 1: Construindo a Grade 3x3 Guia

- **a.** Cria um novo documento no Illustrator com 1920 x 1080 pixels e orientação em Paisagem.

- **b.** Pressiona o atalho Ctrl + R para ligar as réguas na lateral e no topo da área de trabalho.

- **c.** Vamos dividir a largura de 1920 px em três partes iguais (640 px cada): ▪ Clica na régua vertical esquerda e arrasta uma linha guia até X: 640 px.

▪ Puxa outra guia vertical da mesma régua até X: 1280 px.

- **d.** Agora divide a altura de 1080 px em três partes iguais (360 px cada): ▪ Clica na régua horizontal superior e arrasta uma guia até Y: 360 px.

▪ Puxa uma segunda guia horizontal até Y: 720 px.

- **e.** Clica com o botão direito do rato numa área vazia da tela e seleciona Bloquear Guias (Lock Guides) para não as moveres sem querer.

### Passo 2: Posicionando o Horizonte sem Dividir a Tela ao Meio

- **a.** Ativa a Ferramenta Retângulo (Atalho: tecla M).

- **b.** Atenção à regra de composição: Nunca dividas a tela a 50% no meio exato! Desenha o chão fazendo a linha do horizonte repousar diretamente sobre a linha guia horizontal inferior (Y: 720 px), descendo até à base da prancheta.

- **c.** Pinta o chão de Cinzento Escuro e retira a linha de contorno.

- **d.** O céu ocupa agora dois terços inteiros da imagem, transmitindo vastidão, escala e grandiosidade ao mundo do jogo.

### Passo 3: Posicionando o Ponto Focal no Ponto Magnético

- **a.** Copia e cola o teu herói Chibi (ou uma silhueta de personagem) na tela.

- **b.** Com a Ferramenta Seleção (Seta Preta - Atalho: tecla V), arrasta a figura até que a cabeça e os

- **b.** Com a Ferramenta Seleção (Seta Preta - Atalho: tecla V), arrasta a figura até que a cabeça e os ombros fiquem cravados exatamente na interseção inferior esquerda da grelha (no cruzamento de X: 640 px com Y: 720 px).

- **c.** Garante que o herói está orientado a olhar para o lado direito da tela.

- **d.** Observa o impacto: sobram dois terços amplos de ecrã à frente dos olhos da figura (o teu Lead Room), permitindo que o jogador respire e sinta a direção do percurso.

### Passo 4: Contrabalançando com Peso Assimétrico

- **a.** Com o herói posicionado no canto inferior esquerdo, o lado esquerdo da tela ficou visualmente pesado.

- **b.** Para equilibrar a balança sem espelhares uma figura repetida, desloca o cursor até à interseção superior direita (X: 1280 px com Y: 360 px).

- **c.** Desenha a silhueta de uma lua cheia luminosa com a Ferramenta Elipse (L), ou uma torre de castelo distante com tons claros e suaves.

- **d.** A balança visual equilibra-se com perfeição orgânica: a proximidade e o peso escuro do herói em primeiro plano contrabalançam a claridade e o recuo do castelo no horizonte distante!', 5, 'Introdutório', '', '[{"title":"Gravidade Visual e Balança","description":"Toda a imagem possui pesos visuais que precisam de distribuição consciente para não tombarem a composição."},{"title":"Equilíbrio Assimétrico","description":"A técnica de compensar um elemento grande e claro com um elemento menor, mas escuro ou pontiagudo, gerando dinamismo natural."},{"title":"A Grelha 3x3 (Regra dos Terços)","description":"Divisão do enquadramento em três faixas horizontais e três verticais para encontrar os quatro pontos de maior interesse visual."},{"title":"Fuga do Centro Morto","description":"Posicionar os elementos focais nas interseções laterais em vez do meio exato da tela torna o design mais enérgico e cinematográfico."},{"title":"Lead Room (Espaço de Respiração)","description":"Deixar a maior porção vazia da tela posicionada à frente do olhar ou do movimento da personagem para indicar o seu rumo de ação."},{"title":"Linha do Horizonte nos Terços","description":"O horizonte deve assentar na guia do terço superior ou inferior, evitando cortar a tela a metade de forma monótona."}]'::jsonb, '[{"keys":"Ctrl + R","label":"Ativar réguas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-4', 'hierarquia-visual-e-notan-o-limite-preto-e-branco', 'Hierarquia Visual e Notan (O Limite Preto e Branco)', 2, 'A Ordem do Olhar, o Segredo Japonês do Notan e o Fim do Cinzento', ARRAY['hierarquia', 'visual', 'notan', 'limite', 'preto', 'branco', 'illustrator', 'arte digital', 'design visual']::text[], 'Já te aconteceu passar horas a desenhar detalhes minúsculos — os botões da camisa, os fios de cabelo, as folhas da árvore — e, quando te afastas do ecrã, o desenho parece uma confusão borrada onde ninguém percebe para onde deve olhar? Isto acontece quando a imagem falha no seu alicerce mais básico: a Hierarquia Visual. A hierarquia visual é a ordem matemática e psicológica em que o teu cérebro processa os elementos na fração de segundo de uma batalha de jogo: 1. Primeiro, bate o olho no elemento mais importante (o grande boss ou o perigo iminente). 2. Segundo, repara na ação secundária (a arma que o inimigo empunha ou o portal de saída). 3. Por fim, absorve o contexto do ambiente (o chão onde pisar e as ruínas ao fundo). Se tudo no ecrã tiver o mesmo nível de detalhe e a mesma força de cor, o olho cansa-se e perde-se. Para testar se uma cena é realmente poderosa antes de perder tempo a desenhar texturas, a indústria de videojogos utiliza o conceito tradicional japonês do Notan (que significa "a harmonia do claro e do escuro"). O Notan elimina todas as cores, texturas e degradês suaves. A cena é reduzida a uma escolha binária absoluta:

- 100% Branco Puro (#FFFFFF): Representa tudo o que recebe luz direta.

- 100% Preto Puro (#000000): Representa todas as sombras e áreas escuras.

Além disso, aplicamos o Agrupamento de Valores (Value Grouping): pequenas sombras soltas são fundidas numa grande massa negra sólida, e pequenas luzes conectam-se em blocos brancos limpos. O ponto de maior atração visual da cena será sempre aquele onde a forma mais escura corta diretamente contra a forma mais clara!', '## Montagem de Miniaturas (Thumbnails) em Notan Puro no Illustrator

Abre o Illustrator para criar pequenos esboços de teste (thumbnails) e validar a força do contraste e da hierarquia visual sem meios-tons.

### Passo 1: A Matriz de Thumbnails

- **a.** Cria um novo documento no Illustrator no tamanho padrão de 1920 x 1080 pixels em orientação horizontal.

- **b.** Seleciona a Ferramenta Retângulo (Atalho: tecla M).

- **c.** Desenha três retângulos menores horizontais alinhados lado a lado no centro da prancheta: clica na tela e digita 500 px de largura por 300 px de altura para cada um.

- **d.** Configura as molduras com preenchimento em Branco Puro e um traçado preto fino de 1 pt. Estes pequenos quadros serão os teus ecrãs de teste rápido.

### Passo 2: Thumbnail 1 – Céu Noturno e Silhueta Branca

- **a.** No primeiro retângulo, ativa a Ferramenta Caneta (Atalho: tecla P) ou a Ferramenta Retângulo (M).

- **b.** Preenche toda a área superior do céu com Preto Puro sólido (#000000).

- **c.** Desenha uma cordilheira de montanhas na frente, mantendo o seu interior em Branco Puro sólido (sem traçado).

- **d.** Sobre a área branca da montanha, desenha a silhueta do herói totalmente preenchida a Preto Puro.

- **e.** Observa o resultado: o contraste extremo do boneco preto contra o recorte branco da montanha puxa o olhar do observador para o herói no mesmo segundo!

### Passo 3: Thumbnail 2 – Inversão de Valores (Luz de Holofote)

- **a.** No segundo retângulo, preenche toda a base do chão e as paredes com Preto Puro sólido.

- **b.** Com a Caneta (P), desenha um cone ou triângulo de luz aberto a descer do teto até ao chão, preenchendo-o com Branco Puro (simulando um holofote de vigia ou uma janela aberta).

- **c.** Posiciona a silhueta de uma criatura ou monstro como uma massa preta que invade a coluna de luz branca.

- **d.** Repara na aplicação do Value Grouping: as áreas de sombra fundem-se num bloco negro contínuo e a área iluminada age como um palco branco recortado, destacando o monstro de imediato.

### Passo 4: Validação por Inversão e Agrupamento

- **a.** Com a Ferramenta Seleção (Seta Preta - Atalho: tecla V), seleciona os teus desenhos de teste.

- **b.** Verifica o painel de cores: certifica-te de que não há nenhum tom de cinzento ou degradê esquecido na

- **b.** Verifica o painel de cores: certifica-te de que não há nenhum tom de cinzento ou degradê esquecido na prancheta; o exercício opera apenas com preto absoluto (#000000) e branco absoluto (#FFFFFF).

- **c.** Se existirem pequenas manchinhas pretas isoladas a criar ruído visual, seleciona tudo e ativa o Construtor de Formas (Shift + M).

- **d.** Passa o traçado por cima dessas manchas para as fundir com as massas pretas vizinhas.

- **e.** Realiza o Squint Test (afasta-te do monitor e semicerra os olhos): mesmo com a imagem desfocada, a leitura de quem é o herói e de onde está a ação mantém-se nítida e direta!', 5, 'Introdutório', '', '[{"title":"Hierarquia Visual","description":"O planeamento intencional da ordem pela qual o cérebro nota cada elemento da cena, evitando que os detalhes compitam entre si."},{"title":"Notan","description":"Conceito japonês que testa a harmonia estrutural da cena através da redução binária estrita a Preto Absoluto e Branco Absoluto."},{"title":"Eliminação de Meios-Tons","description":"Deixar de fora cinzentos e texturas garante que a composição se apoia na solidez da silhueta e não em truques de acabamento."},{"title":"Agrupamento de Valores (Value Grouping)","description":"O método de soldar pequenas sombras e luzes em grandes blocos contínuos para limpar o ruído visual da tela."},{"title":"Ponto de Tensão Máxima","description":"A área focal mais intensa da imagem forma-se onde a massa preta mais densa toca diretamente na massa branca mais brilhante."},{"title":"Thumbnails de Teste","description":"Miniaturas rápidas feitas em Notan para validar o impacto da composição antes de perder tempo com renderizações complexas."}]'::jsonb, '[{"keys":"Shift + M","label":"Construtor de Formas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-4', 'apresentacao-de-portfolio-e-montagem-de-mockups', 'Apresentação de Portfólio e Montagem de Mockups', 3, 'A Linguagem da Lente, os Três Planos e as Três Camadas', ARRAY['apresentação', 'portfólio', 'montagem', 'mockups', 'illustrator', 'arte digital', 'design visual']::text[], 'A câmara de um videojogo ou de uma animação nunca é um mero espectador passivo; a posição e a distância da lente determinam a emoção dramática de cada momento. O modo como cortamos a imagem dita a reação psicológica de quem está a jogar: se posicionares a câmara no sítio errado, um combate frenético pode parecer aborrecido ou um instante de pânico pode passar totalmente despercebido. Ao construir um storyboard (o guião visual de um jogo) ou planear cutscenes, o artista recorre a três planos cinematográficos fundamentais:

- Plano Geral (Wide Shot / Long Shot): A figura humana é desenhada em tamanho reduzido e o ambiente domina a maior parte do ecrã. Não serve para mostrar detalhes ou expressões faciais; serve para situar a geografia, estabelecer a atmosfera e transmitir a vulnerabilidade ou solidão da personagem perante um mundo monumental.

- Plano Médio (Medium Shot): Corta a personagem aproximadamente pela cintura. É o enquadramento padrão para interações físicas, gesticulação, preparação de itens e diálogos, equilibrando a linguagem corporal com o cenário ao redor.

- Primeiro Plano (Close-Up): O cenário é eliminado quase na totalidade para focar com exclusividade no rosto ou num objeto específico (como uma mão a tremer ao segurar uma arma). Ao revelar os olhos e as microexpressões, cria empatia imediata e uma carga extrema de tensão dramática.

Para além de escolher o plano, uma composição profissional precisa de escapar ao aspeto de desenho plano. Para isso, dividimos o espaço em Três Camadas de profundidade de campo:

- Primeiro Plano (Foreground): Elementos posicionados muito perto da lente, frequentemente escuros ou recortados em silhueta, que servem de moldura natural à cena.

- Segundo Plano (Middle Ground): O palco central onde a ação principal decorre e a personagem atua.

- Plano de Fundo (Background): Elementos distantes (montanhas, céu, arquitetura remota) desenhados com menor contraste para dar contexto sem roubar o foco da jogabilidade.', '## Storyboard de 3 Quadros para a Cena "O Encontro com a Criatura"

Abre o Illustrator para construir uma tira narrativa de três quadros em proporção panorâmica, aplicando a progressão dramática de planos e a sobreposição de camadas espaciais.

### Passo 1: Criando a Tira de Storyboard

- **a.** Cria um novo documento no Illustrator com as medidas padrão de 1920

- **a.** Cria um novo documento no Illustrator com as medidas padrão de 1920 x 1080 pixels em orientação horizontal.

- **b.** Seleciona a Ferramenta Retângulo (Atalho: tecla M).

- **c.** Desenha três retângulos alinhados lado a lado, configurando cada um com 550 px de largura por 310 px de altura (respeitando a proporção cinematográfica de 16: 9).

- **d.** Alinha os três retângulos ao centro da prancheta e define um traçado fino neutro com o preenchimento em branco para servir de moldura aos teus quadros.

### Passo 2: Quadro 1 – Plano Geral (A Chegada)

- **a.** No primeiro retângulo da esquerda, ativa a Ferramenta Caneta (Atalho: tecla P) ou formas básicas.

- **b.** Desenha a boca de uma caverna colossal e escura ocupando cerca de 80% de todo o enquadramento.

- **c.** Na base da caverna, desenha a silhueta do herói minúscula, com apenas cerca de 40 px de altura.

- **d.** A diferença de escala entre a imensidão da rocha e o herói reduzido estabelece de imediato a fragilidade do explorador perante o desconhecido.

### Passo 3: Quadro 2 – Plano Médio com Camadas (A Decisão)

- **a.** No segundo retângulo central, estrutura as três camadas espaciais: ▪ Primeiro Plano (Foreground): Com a Caneta (P), desenha silhuetas de galhos secos e retorcidos a preto sólido encostados à borda lateral do quadro, emoldurando a imagem.

▪ Segundo Plano (Middle Ground): Desenha o herói cortado na altura da cintura, empunhando uma tocha acesa à frente do corpo num gesto de prontidão e combate. ▪ Plano de Fundo (Background): Desenha a parede de pedra ao fundo da caverna preenchida com um tom de cinzento médio com baixo contraste.

- **b.** O enquadramento direciona a atenção diretamente para a linguagem corporal e para a determinação da personagem.

### Passo 4: Quadro 3 – Close-Up (O Terror)

- **a.** No terceiro retângulo da direita, elimina totalmente os elementos de cenário.

- **b.** Preenche a moldura quase por inteiro desenhando a cabeça do herói de perto com a Ferramenta Elipse (Atalho: tecla L) e a Caneta (P).

- **c.** Desenha os olhos arregalados em pânico e reduz as pupilas a pequenos pontos negros cravados num ponto fora da moldura do ecrã.

- **d.** O espectador não precisa de ver o monstro: o corte fechado focado na expressão transmite a sensação de perigo e horror psicológico com total impacto cinematográfico!', 5, 'Introdutório', '', '[{"title":"Enquadramento Narrativo","description":"A escolha intencional do que entra e do que fica fora do ecrã para conduzir a emoção e o foco do jogador."},{"title":"Plano Geral (Wide Shot)","description":"Focado na geografia e na atmosfera; estabelece a"},{"title":"Plano Geral (Wide Shot)","description":"Focado na geografia e na atmosfera; estabelece a grandiosidade do cenário e a pequenez da personagem."},{"title":"Plano Médio (Medium Shot)","description":"Corta a figura pela cintura; ideal para leitura de linguagem corporal, preparação de combate e diálogos."},{"title":"Primeiro Plano (Close-Up)","description":"Enquadramento fechado no rosto ou em objetos de foco; maximiza a tensão dramática e a empatia através da expressão facial."},{"title":"As Três Camadas de Profundidade","description":"Organização do ecrã em Primeiro Plano (moldura próxima), Segundo Plano (ação principal) e Plano de Fundo (contexto distante)."},{"title":"Tensão Fora de Campo","description":"Ocultar a ameaça fora da moldura e mostrar apenas o reflexo do terror no rosto do herói amplifica o medo através da imaginação de quem joga."}]'::jsonb, '[]'::jsonb),
    ('producao-multimidia-i', 'modulo-4', 'a-arte-de-omitir-informacao-cortes-e-tensao', 'A Arte de Omitir Informação (Cortes e Tensão)', 4, 'A Faca do Realizador, a Omissão Narrativa e a Claustrofobia Visual', ARRAY['arte', 'omitir', 'informação', 'cortes', 'tensão', 'illustrator', 'arte digital', 'design visual']::text[], 'A ferramenta mais rápida e poderosa no arsenal de um realizador ou Diretor de Arte não é passar dias a desenhar novos monstros e detalhes: é o simples ato de cortar o que já foi desenhado. O ato de redefinir as margens e os limites de um enquadramento chama-se Reenquadramento (Crop). Quando um ilustrador principiante cria uma cena épica, o seu instinto inicial é querer mostrar tudo ao mesmo tempo: o guerreiro completo, a criatura inteira, a floresta, o castelo e até os pássaros no céu. O resultado é uma imagem dispersa, onde o olho do jogador divaga sem encontrar um ponto de tensão dramática. O segredo do suspense reside na Omissão Narrativa: a verdadeira tensão nasce daquilo que o público não consegue ver. Ao esconder a ameaça fora do ecrã, obrigas a mente do jogador a preencher o vazio com a sua própria imaginação, gerando níveis muito mais elevados de ansiedade e mistério do que qualquer monstro totalmente exposto conseguiria provocar. Esta manipulação apoia-se no controlo do Espaço de Respiração (Lead Room):

- Sensação de Segurança: Se uma personagem está a fugir e deixamos um espaço amplo e aberto à sua frente, o cérebro do jogador compreende que ela ainda tem caminho e rota de fuga livre.

- Claustrofobia Visual: Se cortarmos o enquadramento rente ao nariz da personagem (eliminando todo o espaço para onde ela avança) e encostarmos a ameaça diretamente às suas costas na borda da imagem, a perceção muda radicalmente. O cérebro sente que o espaço acabou e que o herói está encurralado, disparando o pânico sem ser necessário recorrer a violência gráfica ou sangue!', '## Reenquadrando uma Cena com a Ferramenta Máscara de Recorte (Clipping Mask)

Abre o Illustrator para desenhar um palco narrativo aberto e aplicar um visor de corte (viewfinder) para transformar um plano geral descritivo num momento tenso de perigo iminente através da Máscara de Recorte.

### Passo 1: Desenhando a Cena Aberta de Teste

- **a.** Cria uma prancheta de 1920 x 1080 pixels em orientação horizontal.

- **b.** Desenha um cenário amplo e descritivo utilizando formas simples e silhuetas: ○ No canto inferior esquerdo, esboça a silhueta de um cavaleiro exausto de joelhos no chão.

○ No canto direito, a cerca de vinte metros de distância, desenha um dragão colossal pousado no chão da floresta.

- **c.** Com a Ferramenta Seleção (Seta Preta - Atalho: tecla V), seleciona todos os elementos desenhados e pressiona **Ctrl + G** para

todos os elementos desenhados e pressiona **Ctrl + G** para agrupar a cena num único bloco.

- **d.** Este conjunto representa um Plano Geral comum e aberto, onde a informação está demasiado dispersa.

### Passo 2: Construindo o Visor de Recorte (Viewfinder)

- **a.** Ativa a Ferramenta Retângulo (Atalho: tecla M).

- **b.** Dá um clique simples na tela para abrir a janela de propriedades e digita 400 px de largura por 400 px de altura. Clica em OK.

- **c.** Configura a moldura com preenchimento em [Nenhum] (transparente) e define um traçado fino e visível para que consigas ver o desenho por dentro da caixa.

- **d.** Este quadrado atuará como a tua lente de reenquadramento (Crop).

### Passo 3: Posicionando o Corte da Emoção e da Ação

- **a.** Com a Seta Preta (V), move esse quadrado de 400 x 400 px sobre a cena agrupada.

- **b.** Em vez de tentares enquadrar o guerreiro todo ou a cabeça do dragão, posiciona a moldura focada exclusivamente na mão trémula do guerreiro caída na relva, a tentar desesperadamente alcançar o punho da espada.

- **c.** Ajusta o enquadramento de modo a que a borda do retângulo apanhe apenas a silhueta escura de uma garra colossal projetada no solo logo ao lado da mão.

- **d.** Todo o corpo do guerreiro e o resto do dragão ficam de fora da moldura.

### Passo 4: Executando a Máscara de Recorte (Clipping Mask)

- **a.** Certifica-te de que o teu retângulo de 400 x 400 px está posicionado no topo da pilha de camadas (se necessário, clica nele com o botão direito e escolhe: Organizar > Trazer para a Frente ou pressiona Shift + Ctrl + ]).

- **b.** Com a Seta Preta (V), seleciona em simultâneo o retângulo de recorte e o grupo da cena de fundo.

- **c.** Pressiona o atalho mestre: **Ctrl + 7** (ou acede ao menu superior: Objeto > Máscara de Recorte > Criar).

- **d.** O Illustrator oculta instantaneamente toda a floresta e o dragão gigante: no ecrã resta unicamente a mão estendida na relva e a sombra da garra ameaçadora!

- **e.** Ao ocultares os rostos e o monstro, a imagem deixa de ser uma paisagem passiva e converte-se num momento cinematográfico de urgência máxima.', 5, 'Introdutório', '', '[{"title":"A Arte do Crop (Corte)","description":"O processo de redefinir as margens de uma ilustração existente para focar os olhos do jogador unicamente no elemento de maior carga narrativa."},{"title":"Omissão Narrativa","description":"A técnica de esconder a ameaça fora do ecrã; a imaginação do espectador preenche o vazio e gera mais medo do que a revelação total do monstro. revelação total do monstro."},{"title":"Claustrofobia Visual","description":"A remoção intencional do Lead Room à frente de uma personagem, transmitindo a sensação psicológica de encurralamento imediato."},{"title":"A Regra da Simplicidade","description":"Um bom enquadramento deve responder a uma única questão visual por ecrã, eliminando centros de atenção concorrentes."},{"title":"Máscara de Recorte (Ctrl + 7)","description":"O comando vetorial supremo que utiliza a forma superior como janela para ocultar tudo o que está fora dos seus limites sem apagar o desenho original."},{"title":"Ordem de Camadas na Máscara","description":"A forma geométrica que define o recorte deve estar obrigatoriamente no topo da hierarquia sobre os objetos a mascarar."}]'::jsonb, '[{"keys":"Ctrl + 7","label":"Criar máscara de recorte"},{"keys":"Ctrl + G","label":"Agrupar objetos"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-4', 'linhas-guias-leading-lines-setas-invisiveis', 'Linhas Guias (Leading Lines): Setas Invisíveis', 5, 'A Arte de Guiar o Olhar com Setas Invisíveis', ARRAY['linhas', 'guias', 'leading', 'lines', 'setas', 'invisíveis', 'illustrator', 'arte digital', 'design visual']::text[], 'Num cenário de jogo vasto, épico e rico em detalhes, o olhar do jogador pode facilmente dispersar-se sem saber exatamente para onde deve olhar primeiro. Para resolver este problema de comunicação e controlar a atenção visual, a direção de arte recorre às Leading Lines (Linhas Guias): elementos construídos e camuflados dentro do próprio cenário que atuam como autênticas setas invisíveis apontadas diretamente para o teu Ponto Focal. O cérebro humano é biologicamente condicionado a seguir caminhos visuais contínuos: quando os nossos olhos encontram uma linha, percorrem-na de forma quase automática de uma ponta à outra. Estas linhas não precisam de ser setas literais no ecrã; elas disfarçam-se sob quatro formas principais no Worldbuilding:

- Linhas Arquitetónicas (Explícitas): São as mais diretas de implementar, aproveitando o alinhamento do espaço. Uma estrada de terra batida, os carris de um comboio, cercas, rodapés de masmorras ou uma fileira de postes de iluminação que afunilam em perspetiva.

- Linhas Orgânicas: Elementos da natureza manipulados intencionalmente pelo artista. A curva em "S" do leito de um rio, o arco de uma árvore retorcida cujos ramos se esticam numa direção, ou nuvens desenhadas em formato de cunha pontiaguda no céu.

- Linhas de Luz e Sombra: Feixes de luz a vazar por frestas de janelas ou longas sombras projetadas no chão ao entardecer, desenhadas a apontar diretamente para a personagem ou para o tesouro.

- Linhas de Ação e Olhares (Implícitas): Criadas pela postura das personagens. A lâmina de uma espada empunhada a apontar para o inimigo, o cano de uma arma ou a direção para onde uma multidão de figurantes (NPCs) está a olhar: se todos olharem para o topo de uma torre, o jogador olhará para lá no mesmo instante!', '## Construindo um Cenário onde o Chão, as Nuvens e a Árvore Apontam para o Castelo

Abre o Illustrator para compor uma cena de exploração onde três tipos distintos de linhas guias direcionam o olhar do observador para uma torre misteriosa.

### Passo 1: Posicionando o Ponto Focal nos Terços

- **a.** Cria um documento novo no Illustrator com 1920 x 1080 pixels em orientação horizontal.

- **b.** Pressiona **Ctrl + R** para ativar as réguas e puxa as linhas guias da Regra dos Terços para mapear o ecrã (X: 640 px e 1280 px; Y: 360 px e 720 px).

- **c.** Na interseção superior direita (X: 1280 px / Y: 360 px), utiliza formas primitivas (retângulos e triângulos) para desenhar a silhueta de uma torre

primitivas (retângulos e triângulos) para desenhar a silhueta de uma torre de castelo misteriosa. Este é o destino final da jornada e o teu Ponto Focal primário.

### Passo 2: A Estrada de Chão como Seta Explícita

- **a.** Seleciona a Ferramenta Caneta (Atalho: tecla P), deixa o contorno sem cor ([Nenhum]) e escolhe um preenchimento com tom de cinzento-terra.

- **b.** Inicia o traço no canto inferior esquerdo da tela (a zona onde o olhar ocidental entra habitualmente na imagem), desenhando a base de uma estrada bastante larga.

- **c.** Conduz o caminho numa curva suave em direção ao lado direito, afunilando progressivamente a sua largura até que ela termine exatamente na porta de entrada da torre do castelo.

- **d.** O afunilamento não serve apenas para criar perspetiva: funciona como um funil magnético que puxa o olhar da base do ecrã diretamente para o castelo!

### Passo 3: As Nuvens em Cunha (Vetores Direcionais)

- **a.** No céu, acima e à esquerda da torre, ativa a Ferramenta Caneta (P) ou a Ferramenta Elipse (L).

- **b.** Não desenhes nuvens arredondadas ou faixas horizontais genéricas.

- **c.** Desenha nuvens compridas e pontiagudas, inclinando as suas formas na diagonal de modo a que as extremidades apontem diretamente para o telhado da torre do castelo.

- **d.** A inclinação diagonal das nuvens empurra visualmente a atenção para baixo, impedindo o olho do jogador de escapar pela borda superior da tela.

### Passo 4: A Árvore Retorcida em Arco (Moldura e Direção)

- **a.** No canto inferior esquerdo da composição (em Primeiro Plano), ativa a Caneta (P) para desenhar o tronco de uma árvore seca.

- **b.** Em vez de ergueres um tronco perfeitamente vertical, desenha-o com uma curvatura acentuada em direção ao lado direito da imagem.

- **c.** Faz com que os galhos superiores se estiquem e afunilem como dedos abertos a apontar para o castelo.

- **d.** Realiza o Squint Test (afasta-te do ecrã e semicerra os olhos ligeiramente): nota como a estrada na base, as nuvens no céu e os galhos laterais formam um circuito visual fechado que força a leitura imediata da torre!', 5, 'Introdutório', '', '[{"title":"Leading Lines (Linhas Guias)","description":"Elementos intencionais do cenário que criam trilhos visuais que forçam o olho do jogador a deslocar-se até ao Ponto Focal."},{"title":"Camuflagem Visual","description":"As linhas direcionais não devem parecer forçadas; devem surgir naturalmente disfarçadas como estradas, rios, nuvens ou galhos de árvores."},{"title":"Linhas de Ação e Olhares","description":"Armas estendidas e a direção do olhar das personagens no ecrã funcionam como setas implícitas de atenção imediata."},{"title":"Estrada em Funil","description":"Caminhos que nascem largos na base da imagem e afunilam na aproximação do objetivo aceleram a condução do olhar pela profundidade do cenário."},{"title":"Sinergia com a Perspetiva","description":"O Ponto de Fuga natural da arquitetura é o local ideal para posicionar elementos narrativos cruciais, pois todas as linhas de fuga ideal para posicionar elementos narrativos cruciais, pois todas as linhas de fuga já convergem para ele."},{"title":"Combate ao Caos","description":"Redesenhar elementos de fundo para que sigam um fluxo ordenado elimina ruído visual e unifica a composição ao redor da ação principal."}]'::jsonb, '[{"keys":"Ctrl + R","label":"Ativar réguas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-5', 'bitmap-vs-vetor-e-a-filosofia-da-pixel-art', 'Bitmap vs. Vetor e a Filosofia da Pixel Art', 0, 'O Mosaico de Azulejos, a Fórmula Infinita e a Precisão Cirúrgica', ARRAY['bitmap', 'vetor', 'filosofia', 'pixel', 'art', 'illustrator', 'arte digital', 'design visual']::text[], 'No universo da computação gráfica, existem apenas duas formas de um computador processar e exibir uma imagem no ecrã: através de Bitmap (Raster) ou através de Vetor.

- O Bitmap (Mosaico de Pixéis): Quando tiras uma fotografia com o telemóvel ou descarregas uma imagem da internet, estás a olhar para uma grelha gigante composta por pequenos azulejos quadrados chamados pixéis. O computador memoriza a cor e a posição exata de cada quadradinho. O grande problema surge quando tentas aumentar essa imagem: o computador não sabe o que existe no espaço vazio e é forçado a "adivinhar" dados, resultando numa imagem desfocada, baça e cheia de serrilhados.

- O Vetor (A Matemática Infinita): O vetor não guarda quadradinhos coloridos; guarda fórmulas matemáticas puras compostas por coordenadas nos eixos X e Y, pontos de ancoragem e curvas de raio. Quando aumentas um vetor, o processador simplesmente recalcula a fórmula matemática. Podes pegar num ícone desenhado no tamanho de uma moeda e esticá-lo para a lona de um camião ou para um outdoor de um edifício de dez andares que a linha permanecerá perfeitamente nítida, cortante e sem desfoque.

Nas décadas de 1980 e 1990, as consolas de videojogos de 8 e 16 bits tinham limitações brutais de memória e processamento, sendo incapazes de gerar imagens curvas perfeitas. Foi dessa escassez técnica que nasceu a Pixel Art. No entanto, na produção contemporânea de jogos independentes (como Celeste, Stardew Valley ou Undertale), o grafismo pixelizado já não é uma imposição de hardware, mas sim uma escolha estética intencional e nostálgica. A regra de ouro da Pixel Art é a Intencionalidade. Quando desenhas uma personagem numa matriz minúscula de apenas 16x16 pixéis, a margem de erro é zero. Um único pixel colocado no local errado pode transformar um sorriso num bigode, ou quebrar a leitura da lâmina de uma adaga. Além disso, como desenhar diagonais com quadrados gera degraus, temos de evitar os jaggies (degraus irregulares e desordenados), recorrendo a uma progressão matemática limpa (a "escada rítmica"). Ao utilizarmos o motor do Adobe Illustrator para construir Pixel Art, unimos o melhor dos dois mundos: capturamos o charme visual retrô clássico dos videojogos antigos com a escalabilidade matemática infinita dos vetores, garantindo ficheiros leves e prontos para qualquer interface sem perder resolução!', '## Montagem da Matriz Estrutural e Criação de um Ícone Retrô de 16x16 Pixels

Abre o Illustrator para construir um tabuleiro de xadrez digital através da ferramenta Grelha Retangular, convertê-lo numa matriz interativa de Pintura em Tempo Real e traçar a silhueta em escada de um item de inventário.

### Passo 1: Preparando a Prancheta Vetorial

- **a.** Abre o Adobe Illustrator e seleciona o botão Criar Novo (Create New).

- **b.** Configura a prancheta de trabalho com 1000 px de largura por 1000 px de altura, em formato quadrado.

- **c.** No modo de cores, confirma que está selecionado o perfil RGB (o modelo aditivo de emissão de luz de ecrãs).

- **d.** Define a resolução de efeitos rasterizados para 72 ppi (resolução padrão para web e ecrãs) e clica em Criar.

- **e.** Pressiona o atalho Ctrl + R para ativar as Réguas nas margens da área de trabalho.

### Passo 2: Construindo a Matriz com a Grelha Retangular

- **a.** Na barra de ferramentas à esquerda, clica e segura sobre a Ferramenta Linha (\) até abrires o menu expansível com as ferramentas ocultas.

- **b.** Seleciona a Ferramenta Grelha Retangular (Rectangular Grid Tool).

- **c.** Dá um clique simples exatamente no centro da prancheta branca (atenção: não arrastes o rato).

- **d.** Na janela de configurações da grelha que se abre, define os parâmetros exatos: ○ Largura: 640 px ○ Alt ura: 640 px ○ Divisores Horizontais (Horizontal Dividers): digita 15 ○ Divisores Verticais (Vertical Dividers): digita 15 (Nota Matemática: Para obteres um tabuleiro de 16 células, precisas de exatamente 15 linhas divisórias internas).

- **e.** Clica em OK para gerar a matriz de 16×16 células quadradas perfeitamente simétricas.

### Passo 3: Alinhando a Matriz com Precisão Absoluta

- **a.** Com a grelha selecionada através da Ferramenta Seleção (Seta Preta - Atalho: tecla V), acede ao menu superior em Janela > Alinhar (Window > Align).

superior em Janela > Alinhar (Window > Align).

- **b.** No canto inferior do painel Alinhar, clica no ícone de opções e certifica-te de que a opção Alinhar à Prancheta (Align to Artboard) está ativa.

- **c.** Clica no botão Alinhar Centro Horizontal e no botão Alinhar Centro Vertical para cravar a grelha no centro exato da tela.

- **d.** Na barra de propriedades superior, certifica-te de que o Preenchimento (Fill) está definido em [Nenhum] e o Traçado (Stroke) configurado com uma linha preta fina de 1 pt.

### Passo 4: Convertendo a Grelha em Objeto de Pintura

- **a.** Com a matriz selecionada pela Seta Preta (V), vai ao menu superior: Objeto > Pintura em Tempo Real > Criar (Object > Live Paint > Make).

- **b.** Em alt ernativa, podes usar o atalho de teclado: Alt + Ctrl + X.

- **c.** A grelha converte-se num agrupamento inteligente, onde cada quadrado passa a ser reconhecido como uma célula interativa de coloração digital.

### Passo 5: Desenhando a Silhueta Primária com Traçado de Escada

- **a.** Ativa a ferramenta Balde de Pintura em Tempo Real (Live Paint Bucket - Atalho: tecla K).

- **b.** No painel de Amostras (Swatches), seleciona a cor Preta sólida para o preenchimento.

- **c.** Ao moveres o cursor sobre o tabuleiro, repara como cada casa se ilumina com um contorno vermelho, aguardando o clique.

- **d.** Clica e arrasta suavemente o rato para preencher os pixéis que formam a silhueta externa de um item de inventário (como um frasco de poção, adaga ou chave).

- **e.** A Regra da Escada: Evita criar "jaggies" (degraus quebrados); organiza os pixéis numa progressão ritmada nas diagonais (por exemplo: 2 pixéis na vertical, 1 pixel na quina diagonal, 2 pixéis na horizontal).

- **f.** Se pintares uma casa errada por engano, seleciona a amostra [Nenhum] (quadrado com risco vermelho diagonal) e clica sobre o erro para repor a transparência da célula.

3. Hora de Memorizar!

- Bitmap vs. Vetor: Bitmaps são formados por grelhas fixas de pixéis que perdem resolução ao serem ampliados; vetores são fórmulas matemáticas que se mantêm infinitamente nítidos em qualquer escala.

- Intencionalidade da Pixel Art: Em baixas resoluções (16×16), cada pixel isolado é crucial para definir a silhueta, o peso e a leitura anatómica da peça.

- A Regra dos Divisores: Na ferramenta Grelha Retangular, o número de divisórias inserido é sempre igual ao total de células pretendidas menos uma (15 divisórias geram 16 pixéis).

- Pintura em Tempo Real (Alt + Ctrl + X): O comando que converte o cruzamento de linhas geométricas num "livro de colorir" modular sem necessidade de desenhar novos retângulos.

- Balde de Pintura em Tempo Real (K): Ferramenta dinâmica que permite clicar e arrastar tinta diretamente sobre as células da matriz para traçar contornos de forma ágil.

- Jaggies e a Escada Matemática: Defeito visual provocado por saltos desordenados de pixéis nas diagonais; deve ser evitado através de uma progressão numérica consistente (ex.: 3-2-1).', 8, 'Introdutório', '', '[]'::jsonb, '[{"keys":"Ctrl + R","label":"Ativar réguas"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-5', 'camadas-sistema-rgb-e-o-coracao-8-bit', 'Camadas, Sistema RGB e o Coração 8-Bit', 1, 'A Lanterna dos Ecrãs, a Empilhadora de Camadas e o Preenchimento sem Bordas', ARRAY['camadas', 'sistema', 'rgb', 'coração', 'bit', 'illustrator', 'arte digital', 'design visual']::text[], 'Ao contrário da pintura tradicional em papel ou tela, onde misturamos tintas e pigmentos físicos para absorver a luz ambiente, os monitores dos computadores e os ecrãs dos telemóveis funcionam como lanternas ativas: eles emitem luz direta aos nossos olhos. O padrão universal utilizado na arte digital para ecrãs é o Sistema RGB (Red, Green, Blue). Trata-se de um modelo aditivo onde a imagem nasce do cruzamento de três canais luminosos fundamentais:

- Intensidade Máxima (255, 255, 255): A soma das três luzes no topo gera o Branco Puro.

- Ausência Total (0, 0, 0): O desligamento completo dos canais luminosos gera o Preto Absoluto.

Para trabalhar com rigor profissional e não deixar o ficheiro transformar-se num labirinto onde nada se encontra, o designer organiza o projeto no painel Camadas (Layers). O Illustrator opera como um empilhador de folhas translúcidas de acetato: qualquer objeto desenhado por último é colocado automaticamente por cima de tudo o que foi feito antes. Separar o fundo do ecrã numa camada inferior e bloqueá-la com o ícone do Cadeado impede que o cenário seja arrastado ou selecionado por engano enquanto estás a trabalhar nos detalhes do herói ou do item. No design retrô de 8 bits, é indispensável dominar a fronteira entre Preenchimento (Fill) e Contorno (Stroke):

- O Preenchimento injeta a cor sólida no interior fechado de cada célula ou forma.

- O Contorno desenha a linha perimetral ao redor da forma.

Nos ícones de videojogos clássicos, o contorno da grelha de apoio é sempre desativado na entrega final, preservando exclusivamente os blocos de cor pura que dão a leitura nítida e marcante da Pixel Art!', '## Colorindo um Coração de Vida 8-Bit e Otimizando a Estrutura de Camadas

Abre o Illustrator para organizar a estrutura do teu projeto em camadas independentes, desenhar um coração clássico de vida em matriz de 16×16 e converter a grelha em blocos vetoriais finais através da expansão.

### Passo 1: Estruturando as Pastas de Trabalho (Painel Camadas)

- **a.** Abre o painel Camadas (Layers) através do atalho F7 ou acede ao menu superior em Janela > Camadas (Window > Layers).

- **b.** Dá um duplo clique sobre o texto da camada padrão Camada 1 e renomeia-a para 01_FUNDO.

- **c.** Ativa a Ferramenta Retângulo (Atalho: tecla M), desenha um bloco cobrindo a totalidade da prancheta e preenche-o com um tom de Cinzento Médio (#333333), retirando o contorno.

- **d.** No painel Camadas, clica no pequeno quadrado vazio situado imediatamente ao lado do ícone do olho da camada 01_FUNDO: surgirá o ícone de um Cadeado, travando o fundo para que ele não se mova.

- **e.** Clica no botão Criar Nova Camada (o ícone de quadrado com um sinal + no rodapé do painel) e renomeia esta nova camada superior para 02_SPRITE_CORACAO.

### Passo 2: Construindo a Matriz de 16x16 na Nova Camada

- **a.** Certifica-te de que a camada 02_SPRITE_CORACAO está selecionada (marcada com destaque azul no painel).

- **b.** Na barra de ferramentas, ativa a Ferramenta Grelha Retangular (escondida sob a Ferramenta Linha).

- **c.** Dá um clique simples na prancheta e define: Largura: 400 px, Alt ura: 400 px, Divisores Horizontais: 15 e Divisores Verticais: 15. Confirma no OK para gerar a matriz de 16×16 células.

- **d.** Com a Seta Preta (V), seleciona a grelha e converte-a de imediato através do menu: Objeto > Pintura em Tempo Real > Criar (Object > Live Paint > Make) ou pressiona o atalho Alt + Ctrl + X.

### Passo 3: Desenhando a Silhueta Externa do Coração

- **a.** Seleciona o Balde de Pintura em Tempo Real (Atalho: tecla K).

- **b.** No painel de Amostras (Swatches), escolhe a cor Preta para o preenchimento.

- **c.** Clica e arrasta suavemente pelas células da grelha para traçar o contorno fechado do coração retrô: ▪ Desenha dois topos curvos simétricos (os dois lobos superiores).

▪ Desce as laterais em linhas diagonais regulares a 45 graus (progressão de escada limpa de 1 em 1 pixel) até convergirem numa única ponta afiada na base inferior.

pixel) até convergirem numa única ponta afiada na base inferior.

- **d.** Correção de Falhas: Se preencheres uma casa errada, utiliza as setas do teclado para alt ernar rapidamente entre amostras até à cor [Nenhum] (o quadrado branco atravessado por um risco diagonal vermelho) e clica sobre o pixel incorreto para o apagar.

### Passo 4: Aplicando Preenchimento Interno e Ponto de Brilho

- **a.** Com o Balde (K) ativo, seleciona uma amostra de cor Vermelho Escarlate puro (#FF0000).

- **b.** Clica e arrasta pelo interior do coração para preencher todo o miolo sólido, garantindo que não ficam células vazias no centro da peça.

- **c.** No painel de Amostras, muda a cor ativa do Balde para Branco Puro (#FFFFFF).

- **d.** Clica sobre 2 a 3 pixéis situados no topo curvado superior esquerdo do coração.

- **e.** Este pequeno ponto de luz (highlight) cria a ilusão ótica de volume esférico e reflexo lustroso, simulando um ícone clássico de barra de vida!

### Passo 5: Limpeza do Traçado e Conversão do Vetor

- **a.** Ativa a Ferramenta Seleção (Seta Preta - tecla V) e seleciona o coração completo.

- **b.** Na barra de controlo superior, clica na caixinha de Traçado (Stroke) e alt era para [Nenhum]: as linhas pretas da malha estrutural desaparecem, revelando a Pixel Art nítida.

- **c.** Com o objeto ainda selecionado, vai ao menu superior: Objeto > Expandir (Object > Expand).

- **d.** Na janela flutuante, certifica-te de que as caixas Objeto e Preenchimento estão assinaladas e clica em OK.

- **e.** O Illustrator funde automaticamente os pixéis vizinhos da mesma cor em polígonos vetoriais sólidos e definitivos, libertando o asset das amarras da grelha e deixando o ficheiro leve e otimizado!', 6, 'Introdutório', '', '[{"title":"Sistema RGB","description":"Modelo de cor aditivo baseado na emissão de feixes de luz (Vermelho, Verde e Azul); o valor 255, 255, 255 gera o branco puro e 0, 0, 0 gera a ausência total de luz (preto)."},{"title":"Painel Camadas (F7)","description":"Ferramenta essencial de arrumação técnica; empilha elementos verticalmente e permite travar planos com o Cadeado para impedir alt erações acidentais."},{"title":"Preenchimento (Fill) vs. Contorno (Stroke)","description":"O preenchimento define a cor interna do bloco; o contorno delimita a linha exterior. Na Pixel Art, o traçado da malha é removido para manter os blocos puros."},{"title":"Amostra [Nenhum] como Borracha","description":"No Balde de Pintura em Tempo Real (K), selecionar a cor transparente permite repor a célula original sem ter de desfazer o desenho."},{"title":"Brilho Especular (Highlight)","description":"A aplicação cirúrgica de 2 a 3 pixéis brancos no topo oposto às sombras simula o reflexo luminoso imediato da peça."},{"title":"Expandir (Object > Expand)","description":"Comando técnico obrigatório que elimina a grelha interativa e funde os pixéis da mesma cor em formas vetoriais limpas, sólidas e finalizadas para motores de jogo."}]'::jsonb, '[]'::jsonb),
    ('producao-multimidia-i', 'modulo-5', 'hue-shifting-basico-a-moeda-reluzente', 'Hue Shifting Básico: A Moeda Reluzente', 2, 'A Armadilha da "Sombra Suja" e a Rotação de Matiz', ARRAY['hue', 'shifting', 'básico', 'moeda', 'reluzente', 'illustrator', 'arte digital', 'design visual']::text[], 'O erro mais frequente de quem está a começar a colorir e a sombrear elementos em Pixel Art é pegar na cor base do desenho (como um amarelo puro) e misturar pigmento preto para tentar criar a sombra. O resultado dessa mistura é uma cor desbotada, acinzentada e sem vida, conhecida na indústria de videojogos como Sombra Suja (ou "lama visual"). Um amarelo escurecido com preto não parece ouro na sombra; parece plástico velho ou mostarda estragada. Para criar materiais vibrantes que transmitam volume tridimensional real aos olhos do jogador, os ilustradores recorrem à técnica do Hue Shift ing (Desvio de Matiz). A física da luz dita que a luz solar direta é quente, enquanto as sombras refletem a luz fria do céu e do ambiente ao redor. Por essa razão, ao sombrear um objeto, não mexemos apenas na claridade; alt eramos intencionalmente a posição da cor ao longo do círculo cromático:

- Para a Luz (Highlights): Deslocamos o matiz no círculo cromático em direção aos tons quentes. Para iluminar o amarelo, move-se o indicador na direção do amarelo-esverdeado ou limão e aproxima-se do branco puro.

- Para as Sombras: Deslocamos o matiz no círculo cromático em direção aos tons frios. Para sombrear o amarelo, não se usa preto: desliza-se a cor primeiro para o laranja, depois para o vermelho-terroso e, em sombras extremas, para o violeta profundo.

Na Pixel Art, não há espaço para degradês longos ou esfumados. É exatamente este salto cromático inteligente entre luzes quentes e sombras frias que faz o cérebro de quem joga perceber de imediato se aquele objeto é feito de metal polido, gema de cristal ou rocha rústica!', '## Esculpindo uma Moeda de Ouro com Rotação de Matiz no Illustrator

Abre o Illustrator para construir uma paleta de iluminação precisa através do modelo HSB, desenhar a circunferência de uma moeda em escada limpa e aplicar o volume metálico com desvio de matiz.

### Passo 1: Preparando a Paleta com Desvio de Matiz no Painel HSB

- **a.** Cria ou abre uma prancheta de 1000 x 1000 px com a tua grelha de 16x16 células convertida em Pintura em Tempo Real (Alt + Ctrl + X).

- **b.** Acede ao menu superior em Janela > Cor (Window > Color) para abrir o painel de cor e, no menu do canto superior direito do painel, muda a visualização para Controles Deslizantes HSB (Hue, Saturation, Brightness).

- **c.** Cria os quatro passos de cor da moeda e guarda cada um no painel de Amostras (Swatches): ▪ Sombra Profunda: Matiz (H) em 30° (Laranja avermelhado), Saturação (S) em 90% e Brilho (B) em 45%.

Saturação (S) em 90% e Brilho (B) em 45%. ▪ Tom Base (Midtone): Matiz (H) em 45° (Amarelo Ouro), Saturação (S) em 85% e Brilho (B) em 80%. ▪ Luz Alt a: Matiz (H) em 55° (Amarelo Limão), Saturação (S) em 60% e Brilho (B) em 95%. ▪ Brilho Especular: Branco Puro (#FFFFFF).

### Passo 2: Construindo o Perímetro Circular da Moeda

- **a.** Seleciona o Balde de Pintura em Tempo Real (Atalho: tecla K).

- **b.** Escolhe a amostra de Sombra Profunda (Laranja avermelhado) para traçar o contorno da moeda.

- **c.** Desenha uma circunferência perfeitamente redonda ocupando uma área de 14x14 pixels no centro da grelha.

- **d.** Segue a regra da escada regular para evitar degraus quebrados (jaggies): pinta 4 pixels horizontais no topo, 2 pixels na diagonal, 4 pixels verticais na lateral, 2 pixels na diagonal e fecha a base inferior com a mesma simetria.

### Passo 3: Preenchendo o Miolo com o Tom Base

- **a.** Com o Balde (K) ativo, escolhe a amostra do Tom Base (Amarelo Ouro).

- **b.** Clica e arrasta no interior da moeda para preencher todo o miolo sólido com esta cor.

### Passo 4: Esculpindo a Sombra com Desvio de Matiz

- **a.** Assume que a fonte de luz imaginária da cena vem do canto superior esquerdo do ecrã.

- **b.** No painel de Amostras, seleciona a cor de Sombra Profunda (Laranja avermelhado).

- **c.** Pinta uma faixa em formato de meia-lua cobrindo a margem interna inferior e direita da moeda (a área oposta à entrada da luz).

- **d.** Repara como a transição do amarelo para o laranja confere densidade, peso e espessura ao ouro sem sujar a arte.

### Passo 5: Aplicando a Luz Plena, o Ponto Especular e a Expansão

- **a.** Muda a cor do Balde (K) para a amostra de Luz Alt a (Amarelo Limão).

- **b.** Pinta uma curva fina acompanhando a borda interna superior esquerda da moeda.

- **c.** Escolhe a amostra de Branco Puro e pinta apenas 2 pixels na extremidade mais alt a da curvatura iluminada: este brilho pontual especular funciona como o reflexo de metal polido para o cérebro do jogador!

- **d.** Com a Seta Preta (V), seleciona a moeda, vai à barra de propriedades e desativa a cor do Traçado (Stroke = [Nenhum]) para remover as linhas da malha.

- **e.** Vai ao menu superior em Objeto > Expandir (Object > Expand), confirma com OK e funde os pixels em vetores definitivos.', 5, 'Introdutório', '', '[{"title":"Sombra Suja","description":"O erro comum de escurecer cores com tinta preta pura, gerando um aspeto desbotado e sujo na pintura digital."},{"title":"Hue Shift ing (Desvio de Matiz)","description":"A técnica de rodar o matiz no círculo"},{"title":"Hue Shift ing (Desvio de Matiz)","description":"A técnica de rodar o matiz no círculo cromático ao construir sombras e luzes (tons quentes para a luz e tons frios para as sombras)."},{"title":"Controles Deslizantes HSB","description":"Modo do painel de cores que separa Matiz (Hue), Saturação (Saturation) e Brilho (Brightness), ideal para calibrar transições cromáticas precisas."},{"title":"Brilho Especular (Highlight)","description":"O impacto frontal de 1 a 3 pixels quase brancos que comunica instantaneamente ao jogador se a superfície é polida como ouro ou vidro."},{"title":"Escada Rítmica da Moeda","description":"O desenho da curva circular através de proporções simétricas (4-2-4-2) para evitar o defeito dos jaggies."},{"title":"Desativar Traçado e Expandir","description":"Elimina a estrutura visual da grelha e agrupa as cores sólidas em polígonos vetoriais prontos a usar."}]'::jsonb, '[]'::jsonb),
    ('producao-multimidia-i', 'modulo-5', 'desenhando-itens-classicos-de-inventario', 'Desenhando Itens Clássicos de Inventário', 3, 'A Silhueta Inconfundível, o Código dos Materiais e a Economia Visual', ARRAY['desenhando', 'itens', 'clássicos', 'inventário', 'illustrator', 'arte digital', 'design visual']::text[], 'Num jogo de RPG ou numa aventura de ação, o ecrã do inventário é uma das áreas mais visitadas pelo jogador durante toda a partida. Quer estejas a trocar de arma no calor de uma batalha de chefão ou a escolher uma poção de vida enquanto foges de uma armadilha, a experiência de jogo precisa de ser instantânea. O jogador não tem tempo para parar e ler descrições compridas de texto; ele precisa de bater o olho num ícone de apenas 32 ou 64 pixels no telemóvel e saber exatamente o que tem na mão. Para desenhar itens de inventário com legibilidade imediata, o artista apoia-se em três pilares fundamentais:

- A Silhueta Dominante: Antes de pensares em cores ou detalhes, a forma preta do objeto no teste de Notan precisa de ser inconfundível. Uma chave nunca pode parecer um pedaço de pau reto: ela precisa do anel de apoio e dos dentes característicos na ponta. Um frasco de poção precisa de exibir claramente o gargalo estreito e a base arredondada.

- O Código de Materiais: Como não usamos texturas fotográficas em Pixel Art, a matéria de que o item é feito é comunicada pela forma como a luz reage à superfície. Superfícies de vidro e poções líquidas recebem reflexos de luz branca pontuais e nítidos que contornam a curvatura do bojo; já ferramentas de pedra ou ferro usam áreas de transição opacas e foscas, sem reflexos espelhados exagerados.

- Economia Visual: Menos informação significa maior rapidez de leitura. Numa matriz minúscula de 16×16 células, tentar desenhar rótulos com texto, rachaduras minúsculas ou teias de aranha gera apenas ruído visual e "lama digital". O segredo dos grandes clássicos é eliminar o supérfluo e valorizar as linhas mestras da forma.', '## Construindo um Frasco de Poção Mágica e a Chave do Chefe

Abre o Illustrator para desenhar um consumível líquido translúcido e uma ferramenta dourada com dentes de engrenagem na matriz de 16×16, aplicando economia de traço e expansão vetorial.

### Passo 1: Desenhando o Frasco de Vidro da Poção

- **a.** Numa matriz de 16x16 células configurada com Pintura em Tempo Real (Alt + Ctrl + X), ativa o Balde de Pintura em Tempo Real (Atalho: tecla K).

- **b.** No painel de Amostras, escolhe um tom de Cinzento Escuro (#2A2A2A) para a linha de contorno externo.

- **c.** No topo central da grelha, desenha o bocal de vidro pintando 4 pixels horizontais alinhados.

- **d.** Desce 2 pixels verticais em cada lado para esculpir o gargalo estreito da garrafa.

garrafa.

- **e.** Abre os ombros do frasco para os lados e desce as paredes num bojo arredondado até à base, fechando a silhueta da garrafa.

- **f.** No topo do bocal aberto, escolhe a cor Castanho Médio e pinta 2 pixels para representar a rolha de cortiça que veda o recipiente.

### Passo 2: Preenchendo o Nível do Líquido Mágico

- **a.** No painel de Amostras, escolhe um tom de Vermelho Carmesim saturado para ser o corpo do fluido vital.

- **b.** Preenche a metade inferior do bojo da garrafa, mantendo uma linha de pixels vazios logo abaixo do gargalo para indicar visualmente que o frasco não está cheio até ao topo.

- **c.** Muda a cor do Balde para Vermelho Claro e pinta uma linha horizontal sobre o topo do líquido para marcar a linha de superfície e a tensão da água.

### Passo 3: A Translucidez e o Brilho do Vidro

- **a.** Seleciona a amostra de Branco Puro (#FFFFFF) no Balde (K).

- **b.** Pinta 1 pixel isolado na curva do ombro superior esquerdo do vidro.

- **c.** Pinta mais 2 pixels na curva da base arredondada inferior esquerda.

- **d.** O alinhamento curvo deste reflexo branco brilhante comunica de imediato ao cérebro do jogador que o frasco é cilíndrico, oco e feito de vidro transparente!

### Passo 4: Desenhando a Chave do Chefe (Dourada)

- **a.** Numa segunda matriz de 16×16 ao lado da poção, seleciona uma cor de Castanho Escuro no Balde (K) para traçar a carcaça da chave.

- **b.** No topo da grelha, desenha o anel de manuseio: constrói um quadrado oco de 6x6 pixels com o centro vazio.

- **c.** A partir da base do anel, puxa uma haste vertical reta descendo pelo centro com 6 pixels de comprimento.

- **d.** Na extremidade inferior da haste, puxa 2 pixels para a direita e 1 pixel para cima, esculpindo o relevo dos dentes da engrenagem da fechadura.

- **e.** Aplica a técnica de Hue Shift ing: preenche o miolo da haste com Amarelo Ouro, sombreia as laterais opostas com Laranja e aplica Branco Puro nas quinas superiores do anel para dar o reflexo metálico.

- **f.** Com a Seta Preta (V), seleciona os dois itens, retira a cor do Traçado (Stroke = [Nenhum]) e vai ao menu: Objeto > Expandir (Object > Expand) para fixar os vetores finais.', 5, 'Introdutório', '', '[{"title":"Silhueta Dominante","description":"O item precisa de ser reconhecível apenas pelo contorno preto sólido antes de receber qualquer cor ou textura interna."},{"title":"Código de Materiais","description":"Vidros e líquidos recebem brilhos especulares pontuais e nítidos; metais e pedras utilizam quebras angulares ou superfícies foscas."},{"title":"Economia Visual","description":"Evitar detalhes miúdos que viram ruído gráfico em ícones de inventário pequenos, priorizando clareza e síntese formal."},{"title":"Translucidez por Reflexo","description":"Pixéis brancos posicionados ao longo da curvatura"},{"title":"Translucidez por Reflexo","description":"Pixéis brancos posicionados ao longo da curvatura externa simulam a refração da luz num frasco transparente de vidro."},{"title":"Dentes Estruturais da Chave","description":"A saliência geométrica na ponta da haste é o traço anatómico indispensável para que o jogador diferencie uma chave de uma simples barra de metal."},{"title":"Expansão Vetorial","description":"O comando Objeto > Expandir finaliza o trabalho, fundindo as células de tinta em caminhos vetoriais limpos e prontos para exportação."}]'::jsonb, '[]'::jsonb),
    ('producao-multimidia-i', 'modulo-5', 'otimizacao-e-eficiencia-o-truque-do-palette-swap', 'Otimização e Eficiência: O Truque do Palette Swap', 4, 'A Fábrica de Clones dos RPGs e a Preservação de Valores', ARRAY['otimização', 'eficiência', 'truque', 'palette', 'swap', 'illustrator', 'arte digital', 'design visual']::text[], 'Quando jogas um RPG clássico de aventura (como Final Fantasy, Castlevania ou Pokémon), encontras centenas de armas no inventário e dezenas de variantes do mesmo inimigo ao longo do mapa. Achas mesmo que a equipa de arte desenhou cada uma daquelas peças do zero? De certeza que não! A indústria utilizou um dos maiores segredos de produção de videojogos: o Palette Swap (Troca de Paleta). Na era dos cartuchos de 8 e 16 bits, o espaço de memória era microscópico. Para guardar novos monstros nos níveis avançados sem esgotar o armazenamento do jogo, os programadores mantinham a mesma matriz de desenho e alt eravam unicamente a tabela de cores atribuída a essa forma:

- O mesmo sprite de slime verde básico do início do jogo transformava-se num slime vermelho venenoso nas masmorras perigosas.

- A espada inicial cinzenta de ferro convertia-se numa lâmina dourada rara ou numa espada de fogo elemental nos níveis de topo.

Hoje em dia, os computadores têm gigabytes de memória sobrando, mas o Palette Swap continua a ser utilizado pela sua Eficiência de Produção: desenhas uma matriz vetorial perfeita uma única vez e multiplicas o catálogo de itens do teu jogo em poucos minutos! A cor atua como uma linguagem visual imediata de valor e raridade para o jogador:

- Nível 1 (Básico / Comum): Materiais como Ferro ou Cobre, com cinzentos neutros e castanhos baços, comunicando equipamento inicial sem poderes especiais.

- Nível 2 (Raro / Mágico): Materiais como Ouro ou Fogo, com amarelos quentes e laranjas vivos, transmitindo evolução de poder e valor elevado.

- Nível 3 (Lendário / Épico): Materiais como Diamante ou Cristal de Gelo, com ciano fluorescente, azul-marinho e branco puro, sinalizando raridade máxima e magia ancestral.

A regra de ouro inquebrável da troca de paleta é a Preservação de Valores: se a sombra da lâmina de ferro era o ponto mais escuro do desenho original, a nova cor de sombra da espada de ouro terá de ser obrigatoriamente a mais escura da nova paleta. Se trocares um tom de sombra por um tom demasiado claro, quebras o contraste e a ilusão de volume 3D desaba por completo!', '## Forjando a Tríade Elemental (Ferro, Ouro e Gelo) com Seleção Inteligente

Abre o Illustrator para criar a matriz de uma adaga de ferro em 16×16 células, duplicá-la em linha de montagem e aplicar recoloração automática em segundos através da seleção por atributos.

segundos através da seleção por atributos.

### Passo 1: A Matriz Base (Adaga de Ferro – Nível 1)

- **a.** Numa matriz de 16x16 células configurada em Pintura em Tempo Real (Alt + Ctrl + X), ativa o Balde de Pintura em Tempo Real (Atalho: tecla K).

- **b.** Desenha a silhueta de uma espada ou adaga posicionada na diagonal da grelha.

- **c.** Pinta a lâmina com a paleta clássica de Ferro: ▪ Contorno: Cinzento-chumbo quase preto (#1A1A1A).

▪ Sombra da Lâmina: Cinzento Médio escuro (#555555). ▪ Luz da Lâmina: Cinzento Claro brilhante (#CCCCCC). ▪ Cabo: Castanho Madeira escuro (#4A2E18).

- **d.** Com a Seta Preta (V), seleciona a adaga, retira a cor do Traçado (Stroke = [Nenhum]) e vai ao menu: Objeto > Expandir (Object > Expand), clicando em OK para fixar a geometria vetorial.

### Passo 2: Duplicando a Matriz em Linha de Montagem

- **a.** Com a Ferramenta Seleção (Seta Preta - Atalho: tecla V), clica sobre a adaga de ferro finalizada.

- **b.** Mantém premidas as teclas Alt + Shift no teclado, clica no objeto e arrasta para o lado direito para criar uma cópia alinhada na horizontal.

- **c.** Sem clicar em mais nada, pressiona o atalho Ctrl + D (Transformar Novamente).

- **d.** O Illustrator repete o deslocamento e gera uma terceira cópia idêntica à mesma distância. Agora tens três armas com a mesma estrutura prontas para receber os novos materiais!

### Passo 3: A Segunda Forja – Versão de Ouro (Nível 2)

- **a.** Aproxima o zoom da segunda espada.

- **b.** Ativa a Ferramenta Seleção Direta (Seta Branca - Atalho: tecla A).

- **c.** Clica sobre um dos pixels preenchidos com o Cinzento Médio (a sombra da lâmina de ferro).

- **d.** Acede ao menu superior: Selecionar > Mesmo > Cor do Preenchimento (Select > Same > Fill Color). O Illustrator seleciona automaticamente todos os pixels de sombra da lâmina de uma só vez!

- **e.** Dá um duplo clique na caixinha de cor de preenchimento e substitui essa cor por um tom de Laranja Escuro Quente (#D45800).

- **f.** Com a Seta Branca (A), clica num dos pixels de Cinzento Claro (a área iluminada da lâmina).

- **g.** Repete o comando: Selecionar > Mesmo > Cor do Preenchimento e substitui a cor por um Amarelo Ouro Vivo (#FFD700).

- **h.** A arma converte-se em ouro maciço num piscar de olhos, preservando todo o volume e recorte original!

### Passo 4: A Terceira Forja – Versão de Cristal / Gelo (Nível 3)

- **a.** Desloca a visão para a terceira espada e seleciona a Seta Branca (A).

- **b.** Clica sobre os pixels de sombra da lâmina e vai a: Selecionar > Mesmo > Cor do Preenchimento.

- **c.** Substitui as sombras por um tom de Azul Marinho Profundo (# 0A2540).

0A2540).

- **d.** Clica sobre os pixels claros da lâmina, repete a seleção por preenchimento idêntico e troca por um tom de Ciano Fluorescente (# 00F0FF).

- **e.** Para o toque de mestre, clica nos pixels mais alt os da ponta de corte e pinta com Branco Puro (#FFFFFF) para criar o brilho de diamante lapidado.

- **f.** Em menos de três minutos, o teu inventário ganhou uma linha evolutiva completa de equipamentos com rigor profissional e identidade visual coesa!', 6, 'Introdutório', '', '[{"title":"Palette Swap (Troca de Paleta)","description":"A técnica de reaproveitar a mesma matriz gráfica alt erando unicamente a tabela de cores para gerar novos itens ou inimigos com rapidez."},{"title":"Eficiência na Indústria","description":"Poupa horas de modelação e desenho, permitindo multiplicar o volume de elementos visuais do jogo com consistência de estilo."},{"title":"Preservação de Valores","description":"Regra indispensável que exige manter a mesma relação de claro e escuro da matriz base para que a nova cor não achate o volume 3D."},{"title":"Hierarquia por Cor","description":"O uso de códigos cromáticos culturais (Ferro = Básico; Ouro = Raro; Diamante/Ciano = Lendário) para comunicar o nível de raridade do item sem texto."},{"title":"Duplicação com Alt + Shift e Ctrl + D","description":"Atalhos industriais para clonar matrizes em série mantendo espaçamentos rigorosamente alinhados."},{"title":"Comando Selecionar > Mesmo > Cor do Preenchimento","description":"O atalho mestre do Illustrator para capturar e trocar dezenas de pixels da mesma cor instantaneamente."}]'::jsonb, '[{"keys":"Ctrl + D","label":"Repetir transformação"}]'::jsonb),
    ('producao-multimidia-i', 'modulo-5', 'fechando-o-inventario-organizacao-e-exportacao', 'Fechando o Inventário: Organização e Exportação', 5, 'A Entrega Técnica, o Motor de Jogo e o Canal Alfa', ARRAY['fechando', 'inventário', 'organização', 'exportação', 'illustrator', 'arte digital', 'design visual']::text[], 'Desenhar ilustrações e sprites incríveis é apenas metade do trabalho de um artista de videojogos; a outra metade, igualmente decisiva, é saber entregar esses ficheiros organizados e otimizados para a equipa de programação e integração técnica no motor de jogo (como Unity, Unreal Engine ou Godot). Num estúdio profissional, ninguém aprova pastas com nomes desorganizados, camadas sem rótulo ou ficheiros soltos com dimensões aleatórias. No desenvolvimento de interfaces de utilizador (UI Assets), a indústria segue três padrões técnicos rigorosos:

- Folha de Sprites (Spritesheet): Em vez de enviar dezenas de ficheiros soltos e perdidos, os ícones são organizados numa única grelha uniforme com espaçamentos regulares. Isso permite que o motor de jogo fatie as imagens automaticamente através de coordenadas matemáticas.

- A Regra das Potências de Dois: As dimensões das pranchetas e caixas de exportação de cada ícone devem seguir a escala de potências de dois (como 32×32, 64×64, 128×128 ou 256×256 pixels).

Os processadores e as placas gráficas dos computadores e consolas foram construídos com arquitetura binária, processando texturas nessas proporções com velocidade máxima sem desperdício de memória.

- Canal Alfa (Transparência no PNG-24): O formato padrão para exportação de assets 2D em jogos é o PNG com suporte a canal alfa. Ao contrário do formato JPEG (que cola obrigatoriamente um fundo branco ou preto por trás do desenho), o PNG preserva o vazio transparente ao redor do item sem serrilhar as bordas do vetor, permitindo que a espada ou a poção repouse perfeitamente sobre qualquer cenário ou caixa de menu.', '## Montagem de uma Folha de Inventário e Exportação Otimizada em PNG Transparente

Abre o Illustrator para construir uma vitrine de inventário com molduras quadradas, posicionar os quatro assets criados ao longo do módulo e executar a exportação automática em pranchetas individuais limpas.

### Passo 1: Organizando a Grade do Inventário na Prancheta

- **a.** Cria um novo documento no Illustrator com as medidas padrão de 1920 x 1080 pixels em orientação horizontal.

- **b.** Pressiona Ctrl + R para ativar as réguas e certifica-te de que as Guias Inteligentes estão ativas através do atalho Ctrl + U.

- **c.** Seleciona a Ferramenta Retângulo (Atalho: tecla M).

- **d.** Clica na tela e define um quadrado com 200 px de largura por 200 px de altura para servir como o primeiro slot do inventário.

- **e.** Pinta o interior do slot com um tom de Cinzento Escuro (#1E1E1E) e define o traçado com uma linha fina de 2 pt em Cinzento Claro (#

define o traçado com uma linha fina de 2 pt em Cinzento Claro (# 555555).

- **f.** Com a Seta Preta (V), duplica esse quadrado três vezes para o lado direito mantendo Alt + Shift pressionados, alinhando quatro molduras horizontais idênticas no centro do ecrã.

### Passo 2: Encaixando os Assets Produzidos

- **a.** Copia e cola na tua tela os quatro itens desenvolvidos ao longo do módulo: o Coração de Vida, a Moeda de Ouro, o Frasco de Poção e a Espada Elemental.

- **b.** Posiciona um item dentro de cada um dos quatro slots de inventário.

- **c.** Seleciona o primeiro item e o seu respetivo quadrado com a Seta Preta (V), abre o painel Alinhar (Window > Align) e clica em Alinhar Centro Horizontal e Alinhar Centro Vertical para cravar o asset no meio exato da moldura.

- **d.** Repete o alinhamento nos outros três slots.

- **e.** Observa a harmonia do conjunto: ajusta suavemente o tamanho dos itens para que nenhum pareça desproporcionalmente minúsculo ou gigante em relação aos restantes.

### Passo 3: Criando Pranchetas Individuais para Exportação

- **a.** Na barra de ferramentas à esquerda, ativa a Ferramenta Prancheta (Artboard Tool - Atalho: Shift + O).

- **b.** Dá um clique simples exatamente em cima do quadrado do primeiro slot de inventário: o Illustrator gera automaticamente a Prancheta 2, ajustada com precisão matemática às bordas daquela moldura.

- **c.** Clica sobre os outros três quadrados para criar as respetivas pranchetas de corte de cada um dos itens.

- **d.** Abre o painel Pranchetas (Window > Artboards) e dá um duplo clique no nome de cada uma para renomeá-las com rigor profissional: UI_Item_Coracao, UI_Item_Moeda, UI_Item_Pocao e UI_Item_Espada.

### Passo 4: O Fluxo de Exportação Profissional para Telas

- **a.** Acede ao menu superior: Arquivo > Exportar > Exportar para Telas (File > Export > Export for Screens).

- **b.** Na janela de diálogo, marca apenas as pranchetas correspondentes aos quatro slots de inventário que acabaste de nomear.

- **c.** Na secção de formatos à direita, certifica-te de que o tipo de ficheiro está definido como PNG (para assegurar o fundo transparente nativo via canal alfa).

- **d.** No campo Prefixo (Prefix), escreve Asset_ ou mantém os nomes definidos nas pranchetas.

- **e.** Clica no ícone de pasta para escolher o diretório de destino no teu computador e clica no botão azul Exportar Pranchetas (Export Artboards).

- **f.** Abre a pasta gerada: cada ícone estará gravado como um ficheiro individual, limpo, perfeitamente recortado e pronto a ser arrastado diretamente para dentro do motor de jogo!', 5, 'Introdutório', '', '[{"title":"Organização Profissional","description":"Entregar assets nomeados, limpos e alinhados é metade da competência técnica exigida pela indústria de jogos."},{"title":"Spritesheet e Grelha Uniforme","description":"A disposição padronizada de ícones que permite aos programadores fatiar texturas no motor de jogo via coordenadas."},{"title":"Potências de Dois","description":"Resoluções baseadas em múltiplos binários ($32×32 $, 64×64, 128×128) que aceleram o processamento gráfico nas placas de vídeo."},{"title":"Canal Alfa (PNG-24)","description":"Formato que armazena a transparência total ao redor do item, eliminando bordas brancas indesejadas sobre o cenário."},{"title":"Ferramenta Prancheta (Shift + O)","description":"Permite converter formas existentes em caixas de corte individuais com apenas um clique sobre o objeto."},{"title":"Exportar para Telas (Export for Screens)","description":"O recurso supremo do Illustrator para processar e gravar dezenas de assets simultâneos em pastas organizadas numa única operação."}]'::jsonb, '[{"keys":"Ctrl + R","label":"Ativar réguas"},{"keys":"Ctrl + U","label":"Alternar guias inteligentes"},{"keys":"Shift + O","label":"Ferramenta Prancheta"}]'::jsonb)
)
insert into public.apostilas (discipline_slug, module_id, module, slug, title, lesson_order, summary, tags, body_markdown, practice_markdown, reading_minutes, difficulty, key_idea, essential_points, shortcuts, published)
select source.discipline_slug, modules.id, modules.name, source.slug, source.title, source.lesson_order, source.summary, source.tags, source.body_markdown, source.practice_markdown, source.reading_minutes, source.difficulty, source.key_idea, source.essential_points, source.shortcuts, true
from source
join public.modules as modules on modules.discipline_slug = source.discipline_slug and modules.slug = source.module_slug
on conflict (discipline_slug, slug) do update set
  module_id = excluded.module_id, module = excluded.module, title = excluded.title, lesson_order = excluded.lesson_order,
  summary = excluded.summary, tags = excluded.tags, body_markdown = excluded.body_markdown,
  practice_markdown = excluded.practice_markdown, reading_minutes = excluded.reading_minutes,
  difficulty = excluded.difficulty, key_idea = excluded.key_idea, essential_points = excluded.essential_points,
  shortcuts = excluded.shortcuts, published = true, updated_at = timezone('utc'::text, now());

commit;
