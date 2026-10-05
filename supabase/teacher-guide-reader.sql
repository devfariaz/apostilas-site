-- Conteúdo dos guias do professor organizado em capítulos para o leitor editorial.
create table if not exists public.teacher_guide_chapters (
  id uuid primary key default gen_random_uuid(),
  guide_id uuid not null references public.teacher_guides(id) on delete cascade,
  slug text not null,
  title text not null,
  chapter_order integer not null check (chapter_order > 0),
  content_markdown text not null default '',
  created_at timestamptz not null default timezone('utc'::text, now()),
  updated_at timestamptz not null default timezone('utc'::text, now()),
  unique (guide_id, slug),
  unique (guide_id, chapter_order)
);
create index if not exists teacher_guide_chapters_order_idx on public.teacher_guide_chapters(guide_id, chapter_order);
alter table public.teacher_guide_chapters enable row level security;
drop policy if exists "Admins manage teacher guide chapters" on public.teacher_guide_chapters;
create policy "Admins manage teacher guide chapters" on public.teacher_guide_chapters for all to authenticated
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.is_active));

with source(discipline_slug,module_title,slug,title,chapter_order,content_markdown) as (values
('producao-multimidia-i', 'Módulo I: O Alfabeto Visual e o Pensamento Vetorial', 'semana-1', 'Semana 1: O Despertar do Traço e a Filosofia das Formas', 1, 'Semana 1: O Despertar do Traço e a Filosofia das
Formas
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
No computador, uma ilustração não nasce de rabiscos aleatórios; ela nasce de
geometria e lógica pura. O pintor russo Wassily Kandinsky, um dos fundadores
da arte abstrata na escola Bauhaus, explicava que toda imagem começa com
dois elementos:
O Ponto: É a semente. Sozinho, é imóvel e marca uma coordenada exata no
espaço.
A Linha: É o ponto que decidiu passear. Quando o ponto se move, ele gera
direção, velocidade e sensação. Linhas retas horizontais transmitem paz e
estabilidade (como o horizonte do mar), enquanto linhas diagonais e
quebradas passam tensão e dinamismo (como um raio).
Mais tarde, o pintor Paul Cézanne provou que a natureza inteira pode ser
simplificada em formas básicas: quadrados, círculos e triângulos. No design
digital, traduzimos isso para a Filosofia Lego: em vez de tentar desenhar um
objeto complexo de uma vez só, nós empilhamos formas geométricas simples.
No Adobe Illustrator, não desenhamos com pixels (que perdem resolução e
embaçam). Trabalhamos com Vetores: cálculos matemáticos perfeitos que
você pode ampliar até o tamanho de um prédio de dez andares sem perder um
único milímetro de nitidez.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Criando o Ícone de um Escudo de Super-Herói com
Formas e Cortes.
Passo 1 — Preparando a Prancheta

- Abra o Adobe Illustrator.

- Clique em Criar Novo  Create New).

- Escolha a predefinição Web e defina o tamanho para 1920 × 1080
pixels.

- Deixe a orientação em Paisagem (horizontal) e clique em Criar.
Passo 2 — Construindo a Base com Formas Perfeitas

- Vá na barra de ferramentas à esquerda e selecione a Ferramenta
Retângulo  M.

- Dê um clique simples na tela, digite 400 px de largura por 500 px de
altura e clique em OK.

- Troque para a Ferramenta Elipse  L. Segure a tecla Shift (a trava
matemática que impede a forma de achatar), clique e arraste para
desenhar um círculo perfeito com cerca de 400 px de diâmetro.

- Posicione o círculo sobreposto à parte inferior do retângulo utilizando a
Ferramenta Seleção  Seta Preta - Atalho V.
Passo 3 — A Mágica do Construtor de Formas

- Com a Seta Preta  V, clique fora das figuras e arraste o mouse
cobrindo as duas formas para selecionar ambas.

- Ative o Construtor de Formas  Shape Builder Tool - Atalho Shift + M.

- Aponte o cursor para o centro das peças: note que uma malha cinza
pontilhada aparece.

- Clique dentro do retângulo e arraste o mouse até o círculo sem soltar o
botão. Ao soltar, o Illustrator solda as duas peças numa silhueta única.
Passo 4 — Esculpindo com a Tecla Alt  Subtração)

- Desenhe uma nova elipse menor com a Ferramenta Elipse  L.

- Posicione-a na lateral do escudo criado.

- Selecione tudo novamente com a Seta Preta  V.

- Pegue o Construtor de Formas  Shift + M.

- Segure a tecla Alt no teclado (o ponteiro do mouse ganhará um sinal de
"menos").

- Clique na área da elipse que você deseja eliminar. Ela funcionará como
um cortador de biscoitos, retirando aquele pedaço instantaneamente.
Passo 5 — Colorindo o Escudo

- Selecione a forma final com a Seta Preta  V.

- Na barra de controle superior (ou na base da barra de ferramentas),
clique duas vezes na caixa de Preenchimento  Fill.

- Escolha uma cor sólida vibrante (como Azul Marinho ou Vermelho) e
clique em OK.

- Clique na caixa de Traçado  Stroke  e selecione o quadrado branco
com um risco diagonal vermelho para desativar a borda.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Forja do Emblema de Herói
Hoje é a sua vez de ser o designer da sua própria liga de heróis. Você vai
construir o emblema de um time utilizando exclusivamente a fusão e o corte de
peças geométricas simples.
Checklist do Desafio:
Criar um documento novo no tamanho 1920 × 1080 pixels.
Desenhar pelo menos 3 formas geométricas usando a trava do Shift para
manter círculos ou quadrados perfeitos.
Sobrepor as formas na tela para criar uma silhueta original.
Usar a Seta Preta  V  para selecionar todas as peças.
Ativar o Construtor de Formas  Shift + M  e unir o núcleo principal do
símbolo clicando e arrastando por cima delas.
Segurar a tecla Alt com o Construtor de Formas para cavar detalhes
vazados no símbolo (como cortes ou estrelas).
Aplicar uma cor sólida de preenchimento e remover a borda preta.
Salvar o arquivo no formato.AI  com o nome SeuNome_Emblema_Semana1.ai.'),
('producao-multimidia-i', 'Módulo I: O Alfabeto Visual e o Pensamento Vetorial', 'semana-2', 'Semana 2: Geometria Primitiva e o Rosto de um Mascote', 2, 'Semana 2: Geometria Primitiva e o Rosto de um
Mascote
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Como as formas transmitem sentimentos? Na comunicação visual, as figuras
geométricas básicas possuem psicologia própria:
O Círculo: Não tem quinas afiadas. Transmite simpatia, infância, proteção e
amizade (pense no Mickey Mouse ou no Kirby).
O Quadrado: Passa ideia de estabilidade, peso, força e equilíbrio.
O Triângulo: Aponta para algum lugar. Gera sensação de alerta, velocidade
ou perigo (vilões e monstros costumam ter formatos pontiagudos).
Para construir o rosto de um mascote no design vetorial, não começamos pelo
queixo ou pelas orelhas à mão livre. Começamos agrupando grandes volumes
redondos e quadrados para criar a estrutura óssea do desenho.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Montando o Rosto de um Urso Mascote.
Passo 1 — A Cabeça  Círculo Base)

- Pegue a Ferramenta Elipse  L.

- Segure Shift, clique na tela e puxe para criar um círculo de tamanho
médio.

- Pinte de Marrom Médio no painel de cores.
Passo 2 — As Orelhas e a Sobreposição

- Desenhe um círculo menor segurando o Shift.

- Pressione Ctrl + C (copiar) e depois Ctrl + V (colar) para duplicar a
orelha.

- Com a Seta Preta  V, arraste uma orelha para a parte superior
esquerda da cabeça e a outra para a superior direita.

- Selecione as duas orelhas, clique com o botão direito e vá em
Organizar > Enviar para Trás  Arrange > Send to Back) para escondê-
las atrás da cabeça.
Passo 3 — O Focinho e o Nariz

- Com a Ferramenta Elipse  L, clique e arraste sem segurar o Shift para
desenhar uma forma oval horizontal (mais larga que alta). Pinte-a de
bege claro.

- Encaixe a forma oval na metade inferior da cabeça usando a Seta Preta
V.

- Pegue a Ferramenta Polígono (no menu escondido debaixo do
Retângulo).

- Dê um clique simples na tela; na janela que surgir, digite Lados: 3 e
clique em OK para gerar um triângulo.

- Com a Seta Preta  V, aproxime o cursor de um dos cantos da caixa de
seleção até a seta virar uma curva. Gire o triângulo de ponta-cabeça (a
ponta apontando para baixo). Pinte de preto e posicione no centro do
focinho para ser o nariz.
Passo 4 — Os Olhos Perfeitos

- Desenhe um círculo pequeno preto para a pupila com a Ferramenta
Elipse  L  + Shift.

- Desenhe um segundo círculo minúsculo branco e coloque dentro do
olho preto para criar o ponto de brilho.

- Selecione as duas peças, aperte Ctrl + G para agrupá-las (elas viram
um objeto só).

- Duplique o olho agrupado segurando a tecla Alt e arrastando-o para o
lado com o mouse.
Passo 5 — Unificação de Estrutura

- Selecione a cabeça e as duas orelhas com a Seta Preta  V.

- Pegue o Construtor de Formas  Shift + M  e passe uma linha contínua
unindo as orelhas ao crânio. O rosto agora é uma peça única e limpa.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Fábrica de Mascotes Geométricos
Aplique a psicologia das formas para criar a cabeça de um personagem: um
gato amigável, um robô quadradão ou um monstrinho travesso.
Checklist do Desafio:
Criar um documento novo no Illustrator (1920 × 1080 px).
Definir a forma da cabeça utilizando a ferramenta correta (Retângulo para
robôs, Elipse para animais fofos, Polígono de 3 lados para monstrinhos).
Utilizar o comando Organizar > Enviar para Trás para posicionar orelhas,
chifres ou antenas no fundo do crânio.
Construir olhos, focinho ou visor utilizando sobreposição ordenada de
círculos e retângulos.
Selecionar a base com a Seta Preta  V  e fundir os contornos externos com
o Construtor de Formas  Shift + M.
Salvar como SeuNome_Mascote_Semana2.ai.'),
('producao-multimidia-i', 'Módulo I: O Alfabeto Visual e o Pensamento Vetorial', 'semana-3', 'Semana 3: Percepção de Forma e Decalque de Silhuetas', 3, 'Semana 3: Percepção de Forma e Decalque de
Silhuetas
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
A pesquisadora de arte Betty Edwards, autora de Desenhando com o Lado
Direito do Cérebro, revelou que o cérebro humano tenta economizar energia
desenhando "símbolos de memória" em vez do que realmente vê. Se pedirmos
para desenhar um olho, a mente desenha uma amêndoa com um círculo no
meio; se for um óculos, dois círculos com uma linha.
Para um artista digital, esse símbolo infantil não serve. O profissional desliga o
nome do objeto e foca apenas nas bordas externas: a Silhueta. O ar vazio ao
redor do objeto chama-se Espaço Negativo. Quando você contorna o espaço
negativo, o objeto real surge na tela com proporção exata.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Decalque Estruturado de um Óculos de Sol Retrô.
Passo 1 — Importando e Bloqueando a Referência

- No menu superior, vá em Arquivo > Inserir  File > Place).

- Selecione a foto de um óculos ou boné e clique na tela para posicioná-
la.

- Com a imagem selecionada, aperte o atalho Ctrl + 2 (ou menu Objeto >
Bloquear > Seleção). A foto está congelada e não sairá do lugar
durante o desenho.
Passo 2 — Configurando as Cores de Trabalho

- Na barra de ferramentas à esquerda, observe os dois quadrados de
cor.

- Clique no quadrado de Preenchimento  Fill  e clique no ícone
Nenhum  (quadrado com o risco vermelho).

- Clique na caixa de Traçado  Stroke  e escolha uma cor visível contra a
foto (como Verde Fluorescente ou Magenta).

- No painel superior, defina a espessura do traçado para 2 pt ou 3 pt.
Passo 3 — Decalcando a Borda com Precisão  Apenas Cliques)

- Selecione a Ferramenta Caneta  Atalho: P.

- Atenção: não tente clicar e arrastar para fazer curvas ainda. Faça
apenas cliques simples ao longo do contorno da armação do óculos.

- Vá clicando nos cantos mais evidentes da silhueta, contornando toda a
borda externa.

- Para finalizar, clique de volta exatamente no primeiro quadradinho onde
começou. O Illustrator fechará o caminho.
Passo 4 — Curvando as Arestas com a Ferramenta Curvatura

- Selecione a Ferramenta Curvatura  Curvature Tool - Atalho Shift + ~)
localizada logo ao lado da Caneta.

- Clique no meio de uma linha reta que você acabou de criar e puxe o
mouse levemente para fora.

- Veja a linha se transformar em uma curva suave acompanhando a
armação da lente. Repita nos pontos necessários.
Passo 5 — Revelando a Silhueta Final

- Desbloqueie a foto de referência apertando Ctrl + Alt + 2.

- Com a Seta Preta  V, clique na foto e aperte Delete no teclado.

- Selecione o traçado que restou, inverta as cores (aperte Shift + X) para
que o traçado vire preenchimento sólido preto. O acessório vetorial
está finalizado.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: Decalcando Itens de Inventário
Traga uma foto de um acessório (um boné, um fone de ouvido, uma bota de
aventura ou um óculos gamer) e capture a sua silhueta vetorial real.
Checklist do Desafio:
Inserir uma foto de referência na prancheta via Arquivo > Inserir.
Bloquear a foto com Ctrl + 2 para trabalhar com segurança.
Desativar o preenchimento e colocar o traçado em cor viva.
Usar a Ferramenta Caneta  P  com cliques secos para marcar o perímetro
do objeto.
Fechar o traçado no ponto inicial.
Usar a Ferramenta Curvatura para curvar os segmentos retos sobre o
formato da foto.
Desbloquear a foto (Ctrl + Alt + 2), deletá-la e preencher o vetor com a cor
desejada.
Salvar como SeuNome_Silhueta_Semana3.ai.'),
('producao-multimidia-i', 'Módulo I: O Alfabeto Visual e o Pensamento Vetorial', 'semana-4', 'Semana 4: Simetria Bilateral e o Escudo Perfeito', 4, 'Semana 4: Simetria Bilateral e o Escudo Perfeito
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Por que a borboleta ou um carro esportivo parecem tão atraentes ao olhar
humano? O cérebro adora encontrar harmonia e ordem. Na arte vetorial, a
principal ferramenta para gerar equilíbrio é a Simetria:
Simetria Bilateral: O lado esquerdo é o reflexo exato do lado direito. Gera
sensação de força, postura, proteção e estabilidade (usada em rostos,
naves e escudos).
Simetria Radial: Elementos que nascem de um núcleo central e giram em
círculos (como mandalas, rodas e miras).
A regra de ouro do profissional de jogos é: se um objeto é simétrico, você só
desenha a metade dele. O computador desenha a outra metade para garantir
que os dois lados não fiquem tortos.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Desenhando Metade de um Escudo Medieval e
Espelhando no Eixo.
Passo 1 — Criando o Eixo Guia Central

- Abra o Illustrator e aperte Ctrl + R para ativar as Réguas no topo e na
esquerda.

- Clique em cima da régua vertical esquerda, segure e arraste o mouse
até o centro da prancheta.

- Solte o mouse: surgiu uma linha guia azul-piscina vertical. Esse é o
nosso eixo central.
Passo 2 — Desenhando Apenas o Lado Esquerdo

- Pegue a Ferramenta Caneta  P. Deixe o traçado preto e o
preenchimento vazio.

- Dê um clique simples exatamente em cima da Linha Guia (ponto do
topo do escudo).

- Mova o mouse para a esquerda e clique para fazer a borda superior.

- Desça até a lateral esquerda do escudo, clique e arraste suavemente
para fazer a curva lateral.

- Desça o mouse de volta até a Linha Guia no fundo e dê um clique
simples.

- Aperte a tecla Enter para parar de desenhar. Você tem apenas a
metade esquerda do escudo na tela.
Passo 3 — A Mágica da Ferramenta Refletir

- Selecione essa metade com a Seta Preta  V.

- Pegue a Ferramenta Refletir  Reflect Tool - Atalho: letra O  na barra de
ferramentas.

- O Segredo: segure a tecla Alt no teclado e clique exatamente em cima
da Linha Guia vertical (na base do escudo).

- Uma janela se abrirá na tela.

- Escolha o eixo Vertical.

- Atenção: Não clique em OK! Clique no botão Copiar  Copy.

- O Illustrator carimba o lado direito perfeitamente alinhado.
Passo 4 — Soldando as Duas Metades

- Pegue a Seta Preta  V  e selecione as duas metades juntas.

- Pegue o Construtor de Formas  Shift + M.

- Clique no lado esquerdo e passe o traço até o lado direito sobre a
emenda central.

- Solte o mouse: as duas metades se fundiram num objeto fechado
único!

- Pinte com a cor do seu clã de fantasia medieval.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: Forjando Equipamentos Espelhados
Crie um item de defesa ou um veículo espacial aplicando a regra de desenhar
metade e refletir o restante com precisão matemática.
Checklist do Desafio:
Ativar réguas (Ctrl + R) e puxar uma Guia central.
Usar a Ferramenta Caneta  P  para construir apenas o lado esquerdo de
um machado, espada, nave ou escudo.
Garantir que o ponto inicial e final toquem a linha do meio guia.
Ativar a Ferramenta Refletir  O.
Segurar Alt e clicar na guia central.
Escolher o eixo Vertical e pressionar Copiar.
Fundir o centro usando o Construtor de Formas  Shift + M.
Salvar como SeuNome_EscudoSimetrico_Semana4.ai.'),
('producao-multimidia-i', 'Módulo I: O Alfabeto Visual e o Pensamento Vetorial', 'semana-5', 'Semana 5: Padrões Visuais e Texturas Infinitas', 5, 'Semana 5: Padrões Visuais e Texturas Infinitas
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Na música, quando um som se repete em intervalos idênticos, temos ritmo. No
design visual, quando multiplicamos formas geométricas em distâncias iguais
no espaço, criamos um Padrão Visual  Pattern).
O artista gráfico holandês M.C. Escher usava matemática para criar ladrilhos
onde pássaros e peixes se encaixavam perfeitamente sem deixar vácuo entre
si (técnica chamada Tesselação). Na indústria dos games, usamos isso para
criar texturas Seamless  Sem Costura).
Se um jogo de plataforma 2D tem uma masmorra de tijolos gigante, o artista
não desenha pedra por pedra ao longo de 10 mil pixels. Ele desenha um
pequeno bloco matriz de 4 tijolos cujos lados se encaixam. O videogame
repete esse bloco infinitamente sem sobrecarregar a memória do computador.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Criando um Papel de Parede Infinito para Jogos.
Passo 1 — Desenhando os Elementos Matriz

- Crie uma área livre na prancheta.

- Desenhe três ícones pequenos próximos uns dos outros:
Um triângulo dourado (Ferramenta Polígono > 3 lados).
Um círculo azul claro (Ferramenta Elipse + Shift).
Uma pequena estrela de 4 pontas (Ferramenta Estrela).

- Pinte cada um com cores contrastantes e retire os traçados pretos.
Passo 2 — Entrando na Fábrica de Padrões

- Com a Seta Preta  V, selecione as três figurinhas juntas.

- Vá no menu superior: Objeto > Padrão > Criar  Object > Pattern >
Make).

- Uma caixa de diálogo surgirá dizendo que o padrão foi adicionado às
Amostras. Clique em OK.
Passo 3 — Ajustando o Ritmo Visual

- A tela mudará para o Modo de Edição de Padrão: o Illustrator replica
seus objetos em clones transparentes ao redor em tempo real.

- No painel Opções de Padrão, clique na caixa Tipo de Ladrilho  Tile
Type):
Grade  Grid
-  Organização reta e militar.
Tijolo por Linha  Brick by Row): Intercala as fileiras, criando um
visual mais dinâmico.

- Mova uma das figuras originais no centro: veja todas as cópias ao redor
se moverem juntas.

- Quando a distribuição estiver equilibrada, olhe para a barra cinza no
topo da tela e clique em Concluído  Done.
Passo 4 — Aplicando a Estampa no Cenário

- Pegue a Ferramenta Retângulo  M  e desenhe um retângulo que ocupe
a tela inteira.

- Abra o painel Amostras  Swatches) no menu lateral direito.

- Clique no novo quadradinho com o seu padrão que acabou de ser
gerado.

- O retângulo gigante é preenchido instantaneamente com a estampa
infinita.
Passo 5 — O Truque Profissional da Tecla Til (~)

- O padrão ficou muito grande dentro do retângulo?

- Selecione a Ferramenta Escala  Atalho: letra S.

- O Segredo: Segure a tecla Til (~) no teclado, clique na tela e arraste o
mouse para dentro.

- O retângulo de fora continua intacto, mas a textura lá dentro diminui de
tamanho, multiplicando os desenhos.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Estampa do Piso da Fase
Desenvolva a textura de chão ou papel de parede temático para uma fase de
jogo 2D (tijolos de castelo, runas espaciais ou doces flutuantes).
Checklist do Desafio:
Desenhar um grupo de 2 a 4 símbolos usando as ferramentas geométricas
aprendidas.
Selecionar tudo com a Seta Preta  V  e criar o padrão via Objeto > Padrão
> Criar.
Testar os modos de repetição (Grade ou Tijolo) até o espaço parecer bem
preenchido.
Concluir a edição no botão Concluído.
Criar um retângulo cobrindo a prancheta e pintá-lo com a amostra de
padrão criada.
Utilizar a Ferramenta Escala  S  segurando a tecla Til (~) para ajustar a
escala da textura internamente.
Salvar como SeuNome_Textura_Semana5.ai.'),
('producao-multimidia-i', 'Módulo I: O Alfabeto Visual e o Pensamento Vetorial', 'semana-6', 'Semana 6: Avaliação de Domínio do Módulo 1', 6, 'Semana 6: Avaliação de Domínio do Módulo 1
Aula 1: Prova Teórica Objetiva (45 min)

- De acordo com a teoria de Wassily Kandinsky na escola Bauhaus, como
são definidos o ponto e a linha?
a) O ponto é a textura e a linha é a cor sólida.
b) O ponto é estático (a semente) e a linha é o ponto em movimento (o
passeio).
c) O ponto é um pixel e a linha é uma curva Bézier.
d) O ponto representa tensão e a linha representa estabilidade absoluta.

- Qual é a principal vantagem dos gráficos vetoriais criados no Illustrator em
relação às imagens comuns em pixels?
a) Ocupam gigabytes de espaço no disco rígido.
b) São compostos por blocos de azulejos que perdem qualidade ao
receberem zoom.
c) São baseados em cálculos matemáticos e podem ser ampliados
infinitamente sem perder nitidez.
d) Só podem ser exibidos em preto e branco.

- Para garantir que um retângulo vire um quadrado perfeito ou uma elipse
vire um círculo sem achatar, qual tecla do teclado deve ser mantida
pressionada durante o clique e arraste?
a) Barra de Espaço
b) Tecla Alt
c) Tecla Shift
d) Tecla Tab

- Ao utilizar a ferramenta Construtor de Formas  Shift + M, como alternamos
a ferramenta do modo de soma para o modo de corte (subtração)?
a) Segurando a tecla Alt enquanto clica na parte desejada.
b) Apertando Delete na prancheta.
c) Dando dois cliques com a Seta Branca.
d) Desligando a placa de vídeo do computador.

- O que define a técnica de texturização conhecida como "Seamless" (sem
costura) usada na produção de jogos?
a) É uma imagem desenhada à mão que ocupa 10 mil pixels inteiros da
fase.
b) É um módulo de desenho pequeno que se repete infinitamente sem
que as bordas de emenda fiquem visíveis.
c) É um filtro que remove as cores da tela do jogador.
d) É um desenho simétrico que só possui o lado esquerdo.
Aula 2: Prova Prática no Laboratório (45 min)
Enunciado do Desafio Prático: A Insígnia do Guardião
O aluno deverá criar um brasão ou logotipo heróico do zero no Illustrator,
demonstrando o domínio dos comandos aprendidos ao longo das 5 semanas.
Requisitos Obrigatórios para Avaliação:

- Construção Vetorial Limpa: O emblema deve conter uma base simétrica
feita com a ferramenta Refletir  O  ou formas primitivas perfeitas com a
tecla Shift.

- Operações do Construtor de Formas: É obrigatório aplicar o Construtor de
Formas  Shift + M  para fundir pelo menos duas formas e cortar pelo
menos uma área usando o Alt.

- Padrão de Fundo Integrado: A insígnia deve estar posicionada sobre um
fundo decorativo preenchido por uma amostra de padrão contínuo (Pattern)
criada pelo próprio aluno.

- Acabamento Profissional: As linhas de traçado desnecessárias devem
estar desativadas, priorizando preenchimentos de cores sólidas
harmônicas.
Entrega: O arquivo deve ser salvo como Prova_M1_NomeDoAluno.ai  e colocado na
pasta de rede da turma antes do toque do sinal.'),
('game-design-i', 'Módulo I: Concepção de Ideias, Gestão de Escopo e Foco no Jogador', 'apresentacao', 'Apresentação do módulo', 1, 'Apresentação do Ciclo
O início da jornada no desenvolvimento de jogos é frequentemente cercado por uma armadilha
comum: a ilusão de que ter uma ideia grandiosa é suficiente para garantir um jogo memorável. É
comum presenciar turmas inteiras cheias de entusiasmo, planejando universos gigantescos,
centenas de armas e tramas mirabolantes, para depois descobrirem que não possuem tempo,
equipe nem recursos técnicos para tirar essas ideias do papel.
Este primeiro ciclo pedagógico foi estruturado para transformar a imaginação em método. O
objetivo não é podar a criatividade dos estudantes, mas ensiná-los a canalizar sua energia de
maneira profissional e sustentável. Ao longo destas aulas, os alunos aprenderão a:

- Encontrar o núcleo emocional e mecânico do seu projeto através da Fantasia do Jogador e da
síntese objetiva em um X-Statement.

- Controlar o escopo do desenvolvimento, abandonando a perigosa mentalidade do "jogo
infinito" para construir um Produto Mínimo Viável funcional e polido utilizando a Metáfora do
Cupcake e a matriz MoSCoW.

- Compreender a psicologia do jogador, superando dados demográficos frios e adotando a
Taxonomia de Bartle para desenhar regras direcionadas a motivações lúdicas reais.

- Construir Player Personas humanizadas, fundamentadas nas ciências de experiência do
usuário, para servir como árbitros racionais nas decisões de design da equipe.

- Realizar engenharia reversa em produções consagradas da indústria independente através
de um estudo de caso prático, consolidando o aprendizado com uma avaliação formativa
transparente.
Sumário

- Aula 01  A Fantasia do Jogo e o Elevator Pitch

- Aula 02  O Escopo do Jogo e o Modelo do "Cupcake"

- Aula 03  Quem Joga o Seu Jogo? Demografia vs. Psicografia

- Aula 04  Criando a Player Persona do Jogo

- Aulas 05 e 06  Estudo de Caso Integrado — Raio-X de um Sucesso Lúdico  Celeste)

- Instrumentos de Avaliação e Práticas de Sala de Aula: Rubrica Formativa e Fichas de Trabalho'),
('game-design-i', 'Módulo I: Concepção de Ideias, Gestão de Escopo e Foco no Jogador', 'aula-1', 'Aula 01: A Fantasia do Jogo e o Elevator Pitch', 2, 'Aula 01: A Fantasia do Jogo e o Elevator Pitch
Foco da Aula: Definir o núcleo emocional da experiência e sintetizar a proposta de valor.
Competência: Capacidade de traduzir ideias lúdicas abstratas em uma proposição mecânica
clara, concisa e atraente.
1. O Gancho Inicial (00 a 05 min)
Roteiro de Mediação do Professor:
Projete na lousa digital ou apresente duas imagens lado a lado:
Imagem A  Uma fotografia real de um encanador curvado sob uma pia cheia de vazamentos,
segurando uma chave inglesa e trabalhando no esgoto.
Imagem B  A ilustração oficial de Mario saltando alegremente sobre um cano verde reluzente
sob o céu azul do Reino dos Cogumelos.
Faça uma pausa e lance a seguinte pergunta provocativa:
"Ninguém joga Super Mario para sentir que está fazendo manutenção hidráulica ou consertando
encanamentos residenciais. Qual é a verdadeira fantasia que o jogador vivencia quando segura
aquele controle?"
Deixe que dois ou três alunos respondam espontaneamente. É provável que citem "salvar a
princesa", "pular alto", "sentir-se ágil" ou "explorar um mundo mágico". Conduza a discussão
para o fechamento do gancho: a profissão de Mario é apenas um pretexto estético; a verdadeira
fantasia é a sensação de liberdade física, heroísmo e agilidade acrobática em um mundo de pura
fantasia.
2. Aprofundamento Teórico (05 a 20 min)
2.1 A Fantasia do Jogador e a Lente da Experiência
Em sua obra de referência The Art of Game Design: A Book of Lenses  2008, o game designer
Jesse Schell apresenta uma constatação essencial para qualquer criador: o jogo não é a
experiência em si; o jogo é apenas o artefato físico ou digital que possibilita a experiência.
"The game is not the experience. The game enables the experience, but it is not the
experience."  SCHELL, 2008, p. 10.
Tradução: "O jogo não é a experiência. O jogo possibilita a experiência, mas ele não é a
experiência."
A fantasia é o sentimento subjetivo que o jogador vivencia enquanto interage com as regras.
Pode ser a sensação de poder invencível  Doom, a solidão e o desamparo  Shadow of the
Colossus), a tensão e o medo constante  Silent Hill) ou a calma de uma rotina bucólica  Stardew
Valley). Antes de desenhar qualquer tela ou digitar uma única linha de código, o game designer
precisa responder com precisão: "Qual emoção exata eu desejo despertar no meu jogador?"
2.2 A Lente da Unificação e a Dissonância Ludonarrativa
Schell propõe a chamada Lente da Unificação (The Lens of Unification):
"O tema é sobre o que é o seu jogo. É a ideia que amarra tudo junto."  SCHELL, 2008, p. 48.
Todos os elementos do jogo — mecânicas, ritmo, estética visual, interface gráfica, trilha sonora e
narrativa — devem apontar para a mesma promessa. Quando uma parte do jogo caminha em
direção oposta à sua fantasia central, ocorre um fenômeno destrutivo chamado Dissonância
Ludonarrativa (o choque entre a história que está sendo contada e as ações reais que o jogador
executa).
Exemplo de coerência: Em Dead Space, o protagonista é um engenheiro isolado em uma
nave espacial decadente. Os passos pesados, os recursos escassos, a iluminação precária e
a interface projetada no próprio traje do herói reforçam a sensação de vulnerabilidade e
isolamento.
Exemplo de quebra de premissa: Se um jogo afirma tratar da luta desesperada pela
sobrevivência em um mundo devastado pela peste, mas concede ao jogador saltos duplos
espalhafatosos, munição infinita e uma trilha sonora dançante e animada, a credibilidade da
experiência é aniquilada.
2.3 A Fórmula do X-Statement  Elevator Pitch Estruturado)
Na indústria profissional, a capacidade de comunicar o conceito do jogo de forma instantânea é
decisiva. Ninguém tem tempo para ler documentos de cinquenta páginas para entender o básico
de um projeto. Como adverte o veterano Scott Rogers em sua obra Level Up! O Guia para o
Design de Grandes Jogos  2014, p. 25
-
"Se você não consegue explicar seu jogo em uma frase, você não entende o seu jogo."
Para estruturar essa frase-guia de maneira profissional, utilizamos a consagrada fórmula do X-Statement:
Estrutura detalhada da fórmula:

- Título Provisório: Nome do jogo.

- Gênero: O formato mecânico reconhecível pela indústria (ex: plataforma 2D, RPG tático,
quebra-cabeça, survival horror).

- Papel / Protagonista: Quem o jogador personifica no mundo lúdico.

- Ação Central  Verbo de Ação): O verbo mecânico primário que o jogador executará 80% do
tempo (ex: desviar, atirar, construir, empilhar, saltar).

- Obstáculo / Força Opositora: O que ou quem tenta impedir o sucesso do jogador.

- Objetivo Maior: A condição de vitória ou a meta final que encerra o ciclo de jogo.
Aplicações Práticas do X-Statement na Indústria:
[Ttulo]+[Gnero]+[Papel]+[A  o Central (Verbo)]+[Obst culo]+[Objetivo Maior]ıˊ eˆ c¸a˜ aˊ
Pac-Man:"Pac-Man é um jogo de labirinto em duas dimensões onde você controla uma
criatura voraz que precisa devorar todas as pastilhas da tela enquanto desvia de quatro
fantasmas implacáveis para alcançar a maior pontuação possível."
Portal:"Portal é um jogo de quebra-cabeça em primeira pessoa onde você joga como uma
prisioneira que precisa criar portais de teletransporte instantâneo para superar salas de
testes letais arquitetadas por uma inteligência artificial vingativa."
Subnautica:"Subnautica é um jogo de sobrevivência em mundo aberto onde você controla
um astronauta náufrago que precisa mergulhar e coletar recursos em oceanos alienígenas
hostis, enfrentando monstros marinhos colossais para conseguir construir um foguete de
fuga."
3. Dinâmica Ativa de Sala de Aula (20 a 35 min)
Oficina em Duplas: "O Teste da Navalha"

- Organização: Os estudantes formam duplas de trabalho. Cada dupla recebe uma ficha de
cartolina ou papel pautado.

- Comando da Atividade: A dupla escolhe secretamente um jogo clássico ou muito popular de
seu conhecimento prévio (ex: Tetris, Flappy Bird, Hollow Knight, Mario Kart, Minecraft).

- Regra de Ouro  A Navalha): A dupla deve redigir o X-Statement do jogo escolhido em no
máximo duas linhas.
É estritamente proibido resumir a história dramática do jogo.
É obrigatório utilizar a fórmula padronizada.
Não é permitido citar nomes próprios que entreguem a franquia (ex: "Link", "Zelda",
"Master Chief"). O foco deve repousar nos verbos de ação.
4. Fechamento da Aula (35 a 40 min)
Jogo da Adivinhação Mecânica: O professor escolhe duas ou três duplas para lerem o seu
X-Statement em voz alta diante da classe, omitindo o título do jogo.
A turma deve identificar o jogo nos primeiros dez segundos da leitura.
Síntese Conceitual: O professor finaliza destacando que, quando o verbo de ação central é
poderoso e o obstáculo é bem delineado, qualquer pessoa entende imediatamente a
proposta de diversão do projeto. Se a turma não conseguir adivinhar, significa que o texto
incluiu detalhes cosméticos desnecessários em vez de destacar o núcleo do jogo.
Hora de Memorizar!
O jogo é o meio; a experiência emocional é o fim. Projetamos regras para despertar
sentimentos concretos no jogador.
A Lente da Unificação: Se um elemento sonoro, visual ou mecânico contradiz a premissa
central, ele deve ser corrigido ou sumariamente eliminado para evitar a dissonância.
A Navalha do Pitch: Se o seu jogo não cabe em uma frase orientada por verbos de ação
claros, ele ainda está nebuloso na sua cabeça.'),
('game-design-i', 'Módulo I: Concepção de Ideias, Gestão de Escopo e Foco no Jogador', 'aula-2', 'Aula 02: O Escopo do Jogo e o Modelo do "Cupcake"', 3, 'Aula 02: O Escopo do Jogo e o Modelo do "Cupcake"
Foco da Aula: Combater o inchaço de ideias  Feature Creep) e dominar o conceito de
Produto Mínimo Viável  MVP) aplicado ao desenvolvimento de jogos.
Competência: Capacidade de planejar projetos exequíveis dentro de prazos e recursos pré-
estabelecidos, priorizando a qualidade mecânica em detrimento da quantidade superficial.
1. O Gancho Inicial (00 a 05 min)
Roteiro de Mediação do Professor:
Escreva no centro da lousa em letras garrafais a seguinte situação-problema:
"Imagine que vocês foram contratados para preparar o banquete de um grande evento. Vocês
têm apenas 3 dias de trabalho e decidem, por puro entusiasmo, assar um bolo de casamento de
cinco andares, repleto de esculturas de açúcar e recheios complexos. O tempo se esgota. O que
vocês conseguem servir aos convidados na hora da festa?"
Aguarde a reação dos estudantes. A resposta incontornável é: uma massa crua, disforme e
completamente intragável.
Faça o paralelo direto com o desenvolvimento de jogos: turmas iniciantes tentam fazer um
MMORPG de mundo aberto em seis meses. O resultado entregue na data de apresentação é um
boneco flutuando em um cenário vazio, sem animações corretas, sem colisão e repleto de erros
no código.
2. Aprofundamento Teórico (05 a 20 min)
2.1 O Inimigo Silencioso: Feature Creep e a Síndrome da Pia de Cozinha
No vocabulário da engenharia de software e da gestão de produção, o termo Feature Creep
(expansão descontrolada de escopo ou "escopo rastejante") descreve a tendência que as
equipes têm de adicionar novos recursos, mecânicas e firulas ao longo do projeto sem remover
nada em troca.
Como ensina Clinton Keith em Agile Game Development with Scrum  2010, p. 52
-
"Valor não é o que nós produzimos; é o que o cliente compra. Em jogos, os clientes compram
diversão."
Adicionar mais cinquenta tipos de armas ou três mundos extras não torna o jogo
automaticamente divertido; pelo contrário, consome o tempo que deveria ser dedicado ao ajuste
fino da movimentação e da resposta dos controles. Na gíria dos estúdios, isso é conhecido como
a Síndrome da Pia de Cozinha (Kitchen Sink Syndrome), que ocorre quando os designers jogam
tudo o que acham interessante dentro da mesma panela: zumbis, naves espaciais, mecânicas de
pesca, romance e cartas colecionáveis. O resultado é um "jogo Frankenstein": incoerente,
instável e impossível de polir.
O Triângulo de Ferro da Gestão de Projetos: Em qualquer empreendimento, existem três
variáveis conectadas: Tempo, Recursos  Custo  e Escopo. A regra é imutável: você só pode
otimizar dois vértices simultaneamente. Se você quer um jogo gigante  Escopo Alto) feito
rapidamente  Tempo Baixo) com uma equipe pequena  Custo Baixo), o projeto falhará ou sairá
com qualidade terrível. Para alunos, o Tempo é fixo (o ano letivo acaba) e o Custo é fixo (a
equipe é pequena). Portanto, a única variável que vocês controlam é o Escopo. Cortar escopo
não é desistir; é a única maneira matemática de fechar o triângulo com qualidade.
2.2 O Produto Mínimo Viável  MVP) e a Metáfora do Cupcake
O conceito de Produto Mínimo Viável  MVP, popularizado por Eric Ries na obra A Startup
Enxuta  2011, p. 77, propõe construir a versão mais concisa de um projeto capaz de entregar a
experiência central com o menor esforço e tempo possíveis.
Muitos estudantes cometem o erro de achar que um MVP de um jogo é um produto quebrado,
um rascunho sem graça ou um pedaço inacabado. É aqui que entra a Metáfora do Cupcake:
Construção Equivocada do MVP
Etapa 1  Farinha e ovos misturados na mesa  Ninguém pode consumir).
Etapa 2  Massa crua colocada na forma  Continua intragável).
Etapa 3  Bolo de 5 andares pronto  O valor só é entregue no último segundo de prazo).
Construção Correta do MVP  O Modelo do Cupcake):
Etapa 1  Um Cupcake perfeito  Massa, recheio e cobertura; pequeno, mas delicioso e
completo).
Etapa 2  Um bolo caseiro de um andar  Maior, compartilhável, testado).
Etapa 3  O bolo de casamento decorado  Expansão segura com base em aprendizados
reais).
No Game Design: O seu MVP não pode ser dez fases desenhadas com blocos cinzas sem
textura e com pulo defeituoso. O seu MVP deve ser uma única sala perfeitamente acabada, onde
o pulo seja prazeroso, o retorno visual seja responsivo, os efeitos sonoros estejam afinados e a
interface funcione sem falhas. Isso é o que a indústria chama de Vertical Slice  Fatia Vertical).
2.3 Ferramenta Prática: A Matriz de Priorização MoSCoW
Para impedir o inchaço de escopo, as equipes de desenvolvimento utilizam o método de
classificação MoSCoW:
Categoria MoSCoWDescrição de Engenharia Exemplo Prático  Jogo de Corrida)
Must Have
Obrigatório ter)
Funcionalidades indispensáveis. Sem elas, o
jogo não existe conceitualmente ou não roda.
Aceleração, sistema de colisão e
contorno de pista.
Should Have
Deveria ter)
Recursos de alta importância para a
experiência, mas cuja ausência temporária não
impede a demonstração da ideia.
Efeitos sonoros de pneus cantando,
velocímetro funcional na tela e menu
de pausa.
Could Have
Poderia ter)
Elementos desejáveis que enriquecem o
charme e o apelo visual, executados
estritamente se houver folga de tempo.
5 opções de cores de lataria para o
veículo e variação de pista com
chuva fina.
Won''t Have  Não
terá agora)
Ideias intencionalmente descartadas desta
versão inicial para proteger o cronograma e a
saúde da equipe.
Modo multijogador em rede online e
customização mecânica detalhada
do motor.
3. Dinâmica Ativa de Sala de Aula (20 a 35 min)
Oficina de Bancada: "A Tabela do Desapego  Corte de 60% "

- Passo 1 — Ideação Livre - 3 minutos): Individualmente, cada estudante anota em uma folha
todas as funcionalidades, ideias, fases, armas e mecânicas que sonha em incluir no projeto
de jogo do módulo.

- Passo 2 — A Matriz MoSCoW   5 minutos): O aluno desenha uma tabela com 4 colunas no
caderno: Must Have, Should Have, Could Have e Won''t Have.

- Passo 3 — A Regra Impositiva dos 60%
-  O professor dita a regra inegociável de produção: ao
menos 60% de todos os itens anotados no Passo 1 devem ser alocados obrigatoriamente nas
colunas Could Have e Won''t Have.

- Na coluna Must Have, devem sobrar no máximo 2 ou 3 mecânicas fundamentais (o
"Cupcake").
4. Fechamento da Aula (35 a 40 min)
O professor solicita que dois voluntários leiam o que sobrou na coluna Must Have e quais
foram os cortes dolorosos feitos na coluna Won''t Have.
Síntese Conceitual: O professor arremata demonstrando que cortar ideias não é
mediocridade técnica, mas um ato de maturidade profissional. Um jogo pequeno,
extremamente polido e divertido conquista prêmios e jogadores; um projeto gigantesco,
travado por lentidão e bugs, raramente sobrevive até a linha de chegada.
Hora de Memorizar!
Menos é Mais  Less is More): É preferível entregar uma única mecânica perfeita do que dez
mecânicas malfeitas e frustrantes.
A Lei de Parkinson: O trabalho se expande para preencher todo o tempo disponível. Trabalhe
com limites de tempo curtos  Timeboxing) e metas claras.
O Modelo do Cupcake: Seu protótipo inicial precisa ser funcional, agradável e completo em
escala reduzida antes de qualquer expansão de conteúdo.'),
('game-design-i', 'Módulo I: Concepção de Ideias, Gestão de Escopo e Foco no Jogador', 'aula-3', 'Aula 03: Quem Joga o Seu Jogo? Demografia vs. Psicografia', 4, 'Aula 03: Quem Joga o Seu Jogo? Demografia vs. Psicografia
Foco da Aula: Superar rótulos simplistas de idade, sexo e localização geográfica para
mapear motivações e comportamentos lúdicos reais através da Taxonomia de Bartle.
Competência: Projetar sistemas, mecânicas e desafios afinados com os perfis psicológicos
que compõem o público-alvo prioritário do jogo.
1. O Gancho Inicial (00 a 05 min)
Roteiro de Mediação do Professor:
Exiba na tela a fotografia de dois homens britânicos conhecidos mundialmente:
Figura A  O Rei Charles III do Reino Unido.
Figura B  O lendário astro do heavy metal Ozzy Osbourne.
Apresente a ficha cadastral compartilhada por ambos:
Ano de nascimento: 1948  Mesma idade).
Nacionalidade: Britânicos.
Estado civil: Casados mais de uma vez.
Condição socioeconômica: Homens de alta renda, figuras públicas mundiais, costumam
passar férias de inverno nas montanhas suíças.
Lance a pergunta:
"Estatisticamente, as planilhas tradicionais de marketing diriam que eles são o mesmíssimo
público-alvo. Se vocês criassem um jogo baseado apenas em idade, nacionalidade e classe
social, acham que o Rei Charles e o Ozzy Osbourne jogariam a mesma coisa nas horas vagas?"
A turma reconhecerá de imediato o absurdo da comparação. Esse choque visual desfaz
instantaneamente a crença de que planilhas demográficas tradicionais são suficientes para
definir um público.
2. Aprofundamento Teórico (05 a 20 min)
2.1 A Ilusão Demográfica vs. A Realidade Psicográfica
No desenvolvimento de jogos digitais, confiar puramente em dados demográficos tradicionais é
uma fonte constante de erros de projeto. Como enfatiza Jesse Schell (The Art of Game Design,
2008, p. 98
-
"Não cometa o erro de pensar que a demografia lhe diz do que as pessoas gostam. Ela apenas
lhe diz quem as pessoas são."
Demografia  O "Quem"): Descreve atributos externos (faixa etária, sexo biológico, classe
socioeconômica, país). É útil para definir preços regionais, idiomas de dublagem ou
restrições legais de faixa etária (classificação indicativa), mas é incapaz de ditar se uma
mecânica é divertida ou entediante.
Psicografia  O "Porquê"): Mapeia os valores subjetivos, interesses, traços de estilo de vida
e, principalmente, as necessidades emocionais que levam uma pessoa a ligar o computador
ou celular para jogar. O jogador busca catarse e alívio do estresse? Deseja superar um
quebra-cabeça lógico complexo? Quer sentir a adrenalina de um combate veloz? Ou anseia
por laços comunitários e conversas amigáveis?
DADOS DEMOGRÁFICOS  Apenas Estatística) DADOS PSICOGRÁFICOS  O Design de Experiência)
• Idade: 16 a 24 anos • Motivação: Competição e maestria
• Localização: Região metropolitana • Busca: Superação de limites
• Renda familiar: Média-baixa • Frustração: Sentir que o jogo ajuda
• Dispositivo: Smartphone Android • Recompensa: Subir de elo no ranking
2.2 A Taxonomia dos Tipos de Jogadores de Richard Bartle
Em 1996, o pesquisador e pioneiro dos jogos virtuais compartilhados  MUDs, Richard Bartle,
publicou o artigo clássico Hearts, Clubs, Diamonds, Spades: Players Who Suit MUDs. Sua
pesquisa identificou quatro grandes perfis comportamentais fundamentados no interesse
primordial do usuário no ambiente lúdico:
AÇÃO NO MUNDO (Mundo Lúdico)
ACHIEVERS (Conquistadores)     EXPLORERS (Exploradores)
ATUAR SOBRE OS OUTROS (Competição)                 INTERAGIR COM O SISTEMA (Cooperação)
KILLERS (Competidores)         SOCIALIZERS (Socializadores)
AÇÃO SOBRE JOGADORES (Pessoas)
1. Achievers  Conquistadores):
Motivação Central: Sentimento de progresso, acumulação e finalização total (fazer 100%.
O que valorizam: Troféus virtuais, insígnias de platina, barras de nível subindo, itens
lendários e rankings públicos de pontuação.
Diretriz de Design: Forneça objetivos explícitos, métricas de eficiência mensuráveis e
recompensas imediatas pelo esforço empreendido.
2. Explorers  Exploradores):
Motivação Central: Curiosidade intelectual, descoberta de novidades e compreensão dos
segredos do universo do jogo.
O que valorizam: Mapas labirínticos, paredes falsas quebráveis, Easter Eggs escondidos pela
equipe e detalhes da história em documentos perdidos (lore).
Diretriz de Design: Não entregue todas as respostas de bandeja. Recompense a dedicação
de quem decide sair da rota principal para investigar os cantos escuros do cenário.
3. Socializers  Socializadores):
Motivação Central: Construção de laços humanos e trocas emocionais com outras pessoas.
O que valorizam: O jogo funciona apenas como uma sala de estar virtual. Amam canais de
bate-papo, clãs organizados, gestos sociais (emotes) e itens cosméticos de customização
para expressar sua individualidade.
Diretriz de Design: Construa ferramentas intuitivas de comunicação e dinâmicas
cooperativas onde um jogador ajude o outro sem atrito.
4. Killers  Competidores / Predadores):
Motivação Central: Demonstrar dominância incontestável, sobrepujar oponentes reais e
causar impacto na experiência alheia.
O que valorizam: Arenas de combate direto  Player versus Player), tabelas de classificação
que destacam vitórias contundentes e desafios onde o erro alheio decreta a própria glória.
Diretriz de Design: Garanta equilíbrio cirúrgico nas regras de confronto mecânico para que a
vitória dependa exclusivamente da habilidade do competidor.
Como resume Richard Bartle:
"Os jogadores não são todos iguais. Você não pode projetar um jogo que agrade a todos,
porque pessoas diferentes querem coisas diferentes."  BARTLE, 1996.
3. Dinâmica Ativa de Sala de Aula (20 a 35 min)
Oficina em Grupos: "O Desafio das Quatro Tribos"

- Definição da Base: O professor define um gênero mecânico simples e universal para a turma:
um jogo de plataforma 2D de saltar e desviar de obstáculos.

- Distribuição das Mesas: A sala é dividida em quartetos. Cada quarteto recebe uma carta de
arquétipo sorteada: Achievers, Explorers, Socializers ou Killers.

- Desafio Criativo: Cada mesa tem 15 minutos para inventar uma mecânica exclusiva
obrigatória que faça apenas o seu perfil de jogador amar o jogo, adaptando a base de
plataforma 2D.
Exemplo para Achievers: Medalhas de ouro concedidas apenas a quem completar a fase
sem encostar no chão mais de cinco vezes.
Exemplo para Explorers: Passagens invisíveis escondidas atrás de cachoeiras que
revelam mapas subterrâneos alternativos.
Exemplo para Socializers: Mecânica de "carona de pulo", na qual dois avatares precisam
bater palmas juntos para ativar pontes para o colega de time.
Exemplo para Killers: Plataformas que desabam sob os pés do primeiro corredor para
derrubar o adversário que vem logo atrás.
4. Fechamento da Aula (35 a 40 min)
Cada quarteto apresenta sua mecânica em 45 segundos.
Síntese Conceitual: O professor ressalta o erro fatal de tentar empilhar as quatro mecânicas
juntas sem planejamento. Criar para o "jogador genérico" torna o jogo desinteressante para
todos os públicos. Saber com precisão a quem o jogo se destina é o filtro mais poderoso para
decidir quais ideias entram e quais vão para o lixo.
Hora de Memorizar!
A demografia diz a idade do seu público; a psicografia diz a alma dele.
A Pergunta de Ouro: Diante de qualquer mecânica cogitada, pergunte-se sempre: "Para qual
perfil de Bartle essa mecânica foi desenhada?" Se a equipe não souber responder, a
mecânica deve ser descartada.
Não construa no vazio: Um jogo focado em agradar a todos torna-se uma experiência
esquecível e confusa.'),
('game-design-i', 'Módulo I: Concepção de Ideias, Gestão de Escopo e Foco no Jogador', 'aula-4', 'Aula 04: Criando a Player Persona do Jogo', 5, 'Aula 04: Criando a Player Persona do Jogo
Foco da Aula: Personificar os dados psicográficos e comportamentais em um personagem
humano representativo para balizar decisões de design da equipe.
Competência: Empregar técnicas consagradas de Design Centrado no Usuário  UCD) para
fundamentar escolhas mecânicas com empatia, eliminando disputas vazias de ego entre os
desenvolvedores.
1. O Gancho Inicial (00 a 05 min)
Roteiro de Mediação do Professor:
Apresente uma encenação dramática de um conflito clássico de desenvolvimento:
"Imaginem a seguinte reunião de equipe: o programador principal insiste que o jogo precisa ter
um sistema de inventário ultracomplexo, onde cada poção tem peso em gramas, espaço em
centímetros cúbicos e se deteriora com o calor. Por outro lado, o artista visual da equipe afirma
que o jogo não deveria ter texto nenhum na tela, apenas ícones minimalistas e limpos. Os dois
começam a discutir, elevar o tom de voz e o projeto trava. Como decidir quem tem razão de
forma profissional, sem recorrer a sorteios ou brigas de ego?"
Ouça as sugestões dos estudantes (votação da equipe, decisão do líder, etc.). O professor
intervém: nenhuma dessas saídas resolve o problema de maneira técnica. A resposta correta é:
perguntar o que a Persona do jogo precisa.
2. Aprofundamento Teórico (05 a 20 min)
2.1 A Filosofia da Persona: O Fim do Ego do Designer
O conceito de Personas foi introduzido no campo do design pelo pioneiro da computação Alan
Cooper, em sua célebre obra The Inmates Are Running the Asylum  1999. Cooper demonstrou
que criar para um "público amplo" dilui as qualidades do produto final:
"Quanto mais específicas tornamos nossas personas, mais eficazes elas são como
ferramentas de design. [...] Você não pode projetar um produto que agrade a todos, mas pode
projetar um produto que agrade a alguém específico com perfeição."  COOPER, 1999.
No desenvolvimento de jogos, a Player Persona é um arquétipo fictício, construído a partir de
observações reais de comportamento, que personifica as necessidades, limitações e ambições
do seu jogador ideal.
2.2 A Máxima Fundamental de Donald Norman
O renomado cientista cognitivo Donald Norman, autor de O Design do Dia a Dia (The Design of
Everyday Things, 2013, estabeleceu o princípio de ouro de qualquer projeto interativo:
"Você não é o usuário. Você sabe demais. Você se importa demais."
Os estudantes precisam compreender que o desenvolvedor possui intimidade absoluta com as
regras do jogo. Ele sabe onde estão as armadilhas, o ritmo dos saltos e os atalhos do teclado. O
jogador novo, por outro lado, chega com dúvidas, cansaço do trabalho ou telas com reflexo de
luz. Projetar com empatia significa enxergar o jogo pelos olhos vulneráveis de quem nunca tocou
no projeto.
2.3 Os Componentes de uma Player Persona Eficaz
Uma Persona de qualidade profissional não é uma biografia literária aleatória; ela reúne variáveis
práticas que influenciam as decisões de código, interface e controles:
Identidade: Nome, idade, profissão/estudo e uma foto (fictícia).
Hábitos de Jogo: Plataforma preferida  PC, Console, Mobile), tempo disponível para jogar
(ex: "só nos fins de semana" ou "2 horas por dia").
Jogos Favoritos: Cite 3 jogos que ela ama. Isso define a expectativa de qualidade e gênero.
Frustrações  Pain Points): O que a irrita em jogos? (ex: "Textos muito longos",
"Microtransações abusivas", "Loading demorado").
Motivações  Goals
-  O que ela busca? (ex: "Relaxar após o trabalho", "Competir com
amigos").
Estudo de Caso Comparativo: O Mesmo Gênero, Duas Personas Diferentes
Considere uma equipe decidindo a mecânica de combate de um jogo de ação e aventura:
Opção de Persona 1  Carlos, 17 anos  O Competidor Hardcore)
Rotina: Joga 5 horas diárias no computador com fones de ouvido fechados.
Jogos de Referência: Dark Souls, Sekiro, Valorant.
Frustração Extrema: Jogos fáceis demais, tutoriais lentos que não podem ser pulados e
diálogos excessivos.
Impacto Direto no Design: O combate deve exigir reflexos motores precisos, tolerância
mínima a erros e recompensar esquivas perfeitas no último milissegundo.
Opção de Persona 2  Mariana, 26 anos  A Profissional em Busca de Catarse)
Rotina: Trabalha 9 horas por dia; joga 30 minutos à noite no sofá usando console portátil.
Jogos de Referência: Stardew Valley, Animal Crossing, Journey.
Frustração Extrema: Perder progresso após a morte, controles complexos com excesso
de combinações e punições arbitrárias.
Impacto Direto no Design: O combate deve focar em ritmo harmônico, salvamento
automático constante e opções acessíveis de navegação.
Se a equipe tentar misturar as preferências de Carlos e Mariana em um mesmo sistema de
combate sem modular a experiência, o resultado será um desastre: Carlos achará o ritmo lento e
desinteressante, enquanto Mariana sentirá estresse e abandonará o jogo nos primeiros minutos.
2.4 A Importância Estratégica da Antipersona
Uma equipe madura também define a sua Antipersona: a descrição explícita do perfil de usuário
para o qual aquele jogo não foi feito. Saber para quem você não quer vender o projeto confere
liberdade para a tomada de decisões ousadas, blindando o time contra críticas vazias de pessoas
fora do seu nicho lúdico.
3. Dinâmica Ativa de Sala de Aula (20 a 35 min)
Oficina Prática: "A Ficha de Identidade: O RG do Jogador"

- Os alunos trabalham nas equipes dos seus respectivos projetos de jogo.

- Cada grupo preenche a ficha oficial de Player Persona em folha sulfite, contemplando:
Nome e Desenho: Atribuição de uma identidade humana tangível.
Contexto de Jogo: Plataforma oficial do projeto e tempo médio por sessão.
Repertório: 3 jogos que essa pessoa ama.
As Duas Linhas Vermelhas  Pain Points): As duas maiores frustrações que o projeto da
equipe está terminantemente proibido de causar a esse jogador.
A Antipersona Oficial: O perfil que a equipe aceita descontentar conscientemente.
4. Fechamento da Aula (35 a 40 min)
O professor convoca os alunos a fixarem as folhas no mural de avisos da sala ou no canal de
comunicação do grupo  Discord/Drive).
Consolidação Formativa: O professor determina que, a partir desse momento, a folha da
Persona se torna o advogado silencioso do jogador. Sempre que houver uma divergência
interna sobre a complexidade de uma regra ou o tamanho de um menu, a pergunta de corte
não será "o que você prefere?", mas sim: "a nossa Persona conseguiria se divertir com
isso?".
Hora de Memorizar!
Você não é o usuário: O seu gosto pessoal como programador ou artista não representa o
gosto do seu público.
Personas eliminam guerras de ego: A discussão técnica substitui o achismo pessoal pela
necessidade validada do jogador.
Tenha orgulho da sua Antipersona: Não tenha medo de desagradar quem busca uma
proposta diametralmente oposta à do seu projeto.'),
('game-design-i', 'Módulo I: Concepção de Ideias, Gestão de Escopo e Foco no Jogador', 'estudo-de-caso', 'Aulas 05 e 06: Estudo de caso integrado', 6, 'Aulas 05 e 06: Estudo de Caso Integrado — Raio-X de umSucesso Lúdico
Foco Integrado: Aplicar as quatro ferramentas do Ciclo 1  X-Statement, Modelo do Cupcake,
Taxonomia de Bartle e Player Persona) dissecando um clássico contemporâneo do
desenvolvimento independente: Celeste  Maddy Makes Games).
Carga Horária: 80 minutos corridos (bloco de 2 aulas integradas).
1. Roteiro Metodológico e Condução Pedagógica
[00-10 min] Bloco 1: O Briefing Analítico (Exibição e Desafio)
[10-35 min] Bloco 2: Desconstrução do Elevator Pitch e do Escopo (O Cupcake)
[35-65 min] Bloco 3: Engenharia Reversa da Persona e Arquétipos de Bartle
[65-80 min] Bloco 4: Síntese Formativa e Apresentações Relâmpago (Pitches de 60s)
00 a 10 min] Bloco 1  O Briefing Analítico

- O professor inicia a sessão projetando um trecho limpo de 2 minutos de jogabilidade direta de
Celeste.

- Contextualização Histórica: O professor pontua que Celeste nasceu originalmente como um
protótipo construído em apenas quatro dias para a plataforma de fantasia retrô PICO 8,
durante uma maratona de desenvolvimento  Game Jam). Anos depois, essa mesma essência
mecânica foi expandida para se tornar uma das obras mais aclamadas da história dos jogos
independentes, vendendo milhões de cópias e colecionando prêmios globais.

- Lançamento do Desafio:"Como um projeto construído em quatro dias em torno de apenas
três ações básicas conseguiu atingir tamanha excelência? Hoje nós vamos fazer a
engenharia reversa deste sucesso."
10 a 35 min] Bloco 2  Desconstrução do Pitch e do Escopo
Os alunos reúnem-se em grupos de 3 a 4 integrantes. Cada mesa recebe uma folha técnica de
trabalho dividida em quadrantes.
Exercício 1  O X-Statement): O grupo deve redigir a síntese de Celeste em uma única frase
impecável de acordo com a fórmula ensinada na Aula 01.
Exercício 2  O Cupcake e a Faca do Escopo): Os alunos mapeiam as três ações motoras
indispensáveis do jogo que compõem o seu "Cupcake" mecânico (o Must Have indiscutível)
e listam três sistemas complexos comumente vistos em outros jogos que os criadores de
Celeste decidiram cortar deliberadamente  Won''t Have) para focar no polimento do controle.
O professor circula pelas mesas atuando como mediador do desapego: qualquer sugestão de
"colocar combate com espada" ou "fazer mundo aberto" é apontada como quebra de
escopo.
35 a 65 min] Bloco 3  Engenharia Reversa da Persona
Exercício 3  Análise Psicográfica via Bartle): Os grupos avaliam a experiência do jogo e
identificam os perfis primário e secundário de Bartle atendidos com primazia pela
jogabilidade de Celeste.
Exercício 4  A Player Persona e a Antipersona): A equipe monta o perfil do jogador que se
apaixona pelo jogo (equilibrando a exigência motora cirúrgica com a delicadeza temática da
superação da ansiedade) e desenha a sua Antipersona explícita (o perfil que detestaria a
experiência de Celeste e os motivos técnicos para esse descontentamento).
65 a 80 min] Bloco 4  Síntese Formativa e Apresentações Relâmpago

- O professor aciona um cronômetro na tela. O representante de duas equipes distintas sobe
ao tablado para apresentar a dissecação do seu grupo em exatos 60 segundos
cronometrados.

- Fechamento do Professor: Consolidação pedagógica do ciclo. Demonstrar que grandes
sucessos da indústria moderna não dependem de orçamentos industriais milionários ou de
escopos infinitos; eles dependem de clareza de conceito, respeito aos limites de tempo e
foco inabalável na empatia com o jogador.
2. Gabarito Didático de Apoio ao Professor (Chave de Respostas)
Síntese de Conceito  X-Statement de Celeste):
"Celeste é um jogo de plataforma de precisão onde você joga como Madeline, uma jovem
determinada que precisa saltar, agarrar paredes e dar impulsos no ar para superar os perigosos
abismos de uma montanha mística, com o objetivo de alcançar o topo e vencer suas crises de
ansiedade."
Desconstrução de Escopo e o Modelo do Cupcake:
O Cupcake Real  Must Have de 4 Dias no PICO 8
-

- Pular (com respostas físicas ajustadas quadro a quadro e margem de tolerância generosa
para o jogador, como o salto de borda ou Coyote Time).

- Agarrar paredes (com limite estrito de resistência de estamina para forçar o planejamento
do trajeto).

- Arrancar no ar / Dash (projeção em oito direções fixas com congelamento de tela de
milissegundos para gerar impacto sensorial).
Cortes Estratégicos  Won''t Have):
Não há combate direto com armas nem barra de vida dos inimigos (evita desviar a
atenção da geometria do cenário).
Não há mapas em mundo aberto ou labirintos sem saída (cada tela é um microenigma
com tela fixa).
Não há sistema complexo de inventário ou equipamentos variáveis.
Psicografia e Perfil de Bartle:
Perfil Primário: Achievers  Conquistadores): Atraídos pelo desafio implacável, pela coleta
dos morangos opcionais de alta dificuldade e pela superação dos lados B e C das fases.
Perfil Secundário: Explorers  Exploradores): Atraídos pela descoberta das salas secretas,
passagens camufladas e fitas cassete escondidas no cenário.
Antipersona: Jogadores impacientes, avessos à repetição mecânica de tentativas e erros
contínuos (die-and-retry), ou jogadores primariamente Socializadores, que buscam apenas
interações comunitárias leves sem qualquer barreira motora de habilidade.'),
('game-design-i', 'Módulo I: Concepção de Ideias, Gestão de Escopo e Foco no Jogador', 'avaliacao', 'Avaliação e fichas de trabalho', 7, 'Instrumentos de Avaliação e Práticas de Sala de Aula
1. Rubrica de Avaliação Formativa do Ciclo 1
Esta rubrica destina-se ao acompanhamento processual e formativo do desempenho dos
estudantes durante as quatro primeiras aulas e a entrega final do Estudo de Caso:
Critério de
Desempenho
Insuficiente  Requer Ajuste
Imediato)
Adequado  Em Construção
Saudável)
Pleno  Padrão de
Excelência Esperado)
Síntese de
Conceito  X-Statement)
O texto parece um longo
roteiro de cinema ou usa
termos genéricos ("jogo
super divertido e incrível"),
sem apontar as regras
reais.
Elabora uma frase correta,
mas mistura a mecânica
central com acessórios
secundários, ultrapassando
os limites de síntese.
Formula um X-Statement
preciso, apoiado em verbos
de ação mecânica claros e
destacando o diferencial do
projeto de imediato.
Gestão de
Escopo e Modelo
do Cupcake
Planeja mundos abertos ou
dezenas de mecânicas
sem relação entre si,
Corta mecânicas apenas
após ordem direta do
professor, mantendo o
Aplica o modelo do
Cupcake de forma
autônoma, isolando as 2 ou
Critério de
Desempenho
Insuficiente  Requer Ajuste
Imediato)
Adequado  Em Construção
Saudável)
Pleno  Padrão de
Excelência Esperado)
resistindo com
agressividade a qualquer
proposta de corte.
escopo no limite do risco
para o prazo letivo.
3 mecânicas essenciais e
priorizando polimento e
consistência.
Empatia com o
Jogador
Psicografia)
Define o público apenas
por dados de idade e
gênero, ou assume o
próprio gosto individual
como regra universal para
o jogo.
Constrói a persona, mas
esquece de ligar as dores
do usuário com as decisões
práticas de controle e
balanceamento da fase.
Mapeia o jogador com
precisão psicográfica e
Bartle, justificando as
regras do projeto a partir
das necessidades
emocionais da Persona.
Engenharia
Reversa  Estudo
de Caso)
Não consegue identificar a
mecânica central do jogo
analisado, focando apenas
no aspecto visual ou na
trilha sonora.
Identifica as mecânicas
principais, mas falha em
apontar quais sistemas
foram conscientemente
cortados pelos criadores.
Disseca com maturidade o
equilíbrio entre premissa,
escopo e psicologia do
jogador, sustentando as
análises com dados
técnicos.
2. Fichas de Aplicação Prática (Modelos para Reprodução)
As fichas a seguir devem ser impressas ou disponibilizadas digitalmente para os estudantes
durante as oficinas práticas:
FICHA DE TRABALHO 01  O X STATEMENT
Identificação da Equipe: ___________________________ Data://202__

- Nome Provisório do Projeto: _________________________________________________

- Gênero Mecânico Primário: _________________________________________________

- Papel / Protagonista: _______________________________________________________

- Verbo de Ação Central  O que o jogador faz 80% do tempo?
-  ______________________

- Força Opositora / Obstáculo Maior: ___________________________________________

- Objetivo de Vitória: ________________________________________________________
A Fórmula Estruturada  Máximo de 2 linhas):
Título  é um jogo de  Gênero  onde você joga como  Protagonista] que precisa  Verbo de Ação]
para superar  Obstáculo] a fim de  Objetivo de Vitória].
Texto Final da Equipe:
FICHA DE TRABALHO 02  A MATRIZ DE ESCOPO MoSCoW
Nome do Jogo: ___________________________ Data de Entrega://202__
+-----------------------------------------------------------------------+
| MUST HAVE (O CUPCAKE)                    | SHOULD HAVE                 |
| (Mecânicas vitais: sem elas o jogo não roda) | (Muito importante,     |
|                                          | mas o MVP roda sem isso)    |
+-----------------------------------------------------------------------+
| 1.                                       | 1.                          |
| 2.                                       | 2.                          |
| 3.                                       | 3.                          |
+-----------------------------------------------------------------------+
| COULD HAVE                               | WON''T HAVE                  |
| (Desejos: só entra se houver folga total)| (Cortado expressamente      |
|                                          | desta primeira versão)      |
+-----------------------------------------------------------------------+
| 1.                                       | 1.                          |
| 2.                                       | 2.                          |
| 3.                                       | 3.                          |
+-----------------------------------------------------------------------+
Conferência de Integridade do Escopo: As colunas Could Have e Won''t Have somadas contêm
pelo menos 60% de todas as funcionalidades planejadas inicialmente?
() SIM, escopo saudável e aprovado.
() NÃO, reduza mais itens antes de iniciar a programação.
FICHA DE TRABALHO 03  O "RG DO JOGADOR"  PLAYER PERSONA
+-----------------------------------------------------------------------+
| NOME FICTÍCIO: _______________________________________________________ |
| IDADE: _________ OCUPAÇÃO: ___________________________________________ |
|                                                                       |
| [ESPAÇO PARA O DESENHO DO ROSTO DO SEU JOGADOR]                       |
|                                                                       |
| PLATAFORMA ONDE JOGA: () PC  () Console  () Mobile                 |
| ROTINA DE JOGO: [ ] 15 a 30 min no transporte                         |
|                 [ ] 1 a 2 horas à noite                               |
|                 [ ] Maratona aos fins de semana                       |
|                                                                       |
| OS TRÊS JOGOS QUE ELE MAIS AMA:                                       |
| 1. ________________________  2. ________________________               |
| 3. ________________________                                           |
+-----------------------------------------------------------------------+
| PERFIL PSICOGRÁFICO DE BARTLE:                                        |
| () Achiever (Conquistador)    () Explorer (Explorador)              |
| () Socializer (Socializador)  () Killer (Competidor)                |
+-----------------------------------------------------------------------+
| DORES CRÍTICAS (O que faz essa pessoa fechar um jogo com ódio?):      |
| 1. ___________________________________________________________________ |
| 2. ___________________________________________________________________ |
+-----------------------------------------------------------------------+
| GATILHO DE PRAZER (O que faz o tempo investido no jogo valer a pena?):|
| → ___________________________________________________________________ |
+-----------------------------------------------------------------------+
| A ANTIPERSONA OFICIAL (A quem este jogo NÃO se destina de forma alguma?):|
| Perfil: ______________________________________________________________ |
| Motivo do corte: _____________________________________________________ |
+-----------------------------------------------------------------------+
3. Bibliografia e Leituras Recomendadas para o Professor
BARTLE, Richard.Hearts, Clubs, Diamonds, Spades: Players Who Suit MUDs. Journal of MUD
Research, 1996.
COOPER, Alan.The Inmates Are Running the Asylum: Why High Tech Products Drive Us
Crazy and How to Restore the Sanity. Indianapolis: Sams Publishing, 1999.
KEITH, Clinton.Agile Game Development with Scrum. Boston: Addison-Wesley, 2010.
NORMAN, Donald A.The Design of Everyday Things: Revised and Expanded Edition. New
York: Basic Books, 2013.
RIES, Eric.A Startup Enxuta: Como os Empreendedores Atuais Utilizam a Inovação Contínua
para Criar Empresas Extremamente Bem-Sucedidas. São Paulo: Leya, 2011.
ROGERS, Scott.Level Up! O Guia para o Design de Grandes Jogos. São Paulo: Blucher, 2014.
SCHELL, Jesse.The Art of Game Design: A Book of Lenses. Burlington: Morgan Kaufmann
Publishers, 2008.')
)
insert into public.teacher_guide_chapters (guide_id, slug, title, chapter_order, content_markdown)
select g.id, s.slug, s.title, s.chapter_order, s.content_markdown
from source s join public.teacher_guides g on g.discipline_slug=s.discipline_slug and g.title=s.module_title
on conflict (guide_id,slug) do update set title=excluded.title, chapter_order=excluded.chapter_order, content_markdown=excluded.content_markdown, updated_at=timezone('utc'::text,now());
