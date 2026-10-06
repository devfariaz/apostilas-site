-- Guia privado de Produção Multimídia II: módulos semanais estruturados para leitura no site.
-- Insere somente em teacher_guides e teacher_guide_chapters; não altera apostilas de alunos.
with guide_source(discipline_slug,module_slug,title,source_filename,storage_path,page_count) as (values
('producao-multimidia-ii','modulo-1','Módulo 1: Fundamentos de Arte para Games, Identidade Visual e Art Bible','MD1PRMU2.pdf','producao-multimidia-ii/modulo-1.pdf',20),
('producao-multimidia-ii','modulo-2','Módulo 2: Pintura Digital de Props, Materiais e Texturas Contínuas','MD2PRMU2.pdf','producao-multimidia-ii/modulo-2.pdf',24),
('producao-multimidia-ii','modulo-3','Módulo 3: Storytelling Visual, Storyboard e Animatic','MD3PRMU2.pdf','producao-multimidia-ii/modulo-3.pdf',21),
('producao-multimidia-ii','modulo-4','Módulo 4: UX/UI para Games, Hierarquia e Interface','MD4PRMU2.pdf','producao-multimidia-ii/modulo-4.pdf',18),
('producao-multimidia-ii','modulo-5','Módulo 5: Character Design, Rigging e Animação 2D com Adobe Animate','MD5PRMU2.pdf','producao-multimidia-ii/modulo-5.pdf',25),
('producao-multimidia-ii','modulo-6','Módulo 6: Tilesets e Cenários Modulares','MD6PRMU2.pdf','producao-multimidia-ii/modulo-6.pdf',12)
) insert into public.teacher_guides (discipline_slug,module_id,title,source_filename,storage_path,page_count)
select s.discipline_slug,m.id,s.title,s.source_filename,s.storage_path,s.page_count
from guide_source s join public.modules m on m.discipline_slug=s.discipline_slug and m.slug=s.module_slug
on conflict (discipline_slug,module_id) do update set title=excluded.title,source_filename=excluded.source_filename,storage_path=excluded.storage_path,page_count=excluded.page_count,updated_at=timezone('utc'::text,now());

with chapter_source(discipline_slug,module_slug,slug,title,chapter_order,content_markdown) as (values
('producao-multimidia-ii','modulo-1','semana-1','Semana 1: O Quebra-Cabeça Digital e o Ambiente do Photoshop',1,'## Semana 1: O Quebra-Cabeça Digital e o Ambiente do Photoshop Conteúdos integrados: O que é um Asset Visual, Pipeline de Produção, Nomenclatura e Configuração do Photoshop.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Quando jogamos títulos como The Legend of Zelda ou Hollow Knight, parece que estamos assistindo a uma animação contínua. No entanto, por trás da tela, não existe um filme gravado; existe um quebra-cabeça matemático de milhares de peças independentes chamadas de Assets Visuais. Um Asset (que em inglês significa "ativo" ou "bem de valor") é cada arquivo visual isolado do jogo: a árvore do cenário, o botão de "Play", a espada mágica, a moeda de ouro ou a nuvem no céu. O motor de jogo (a Engine, como Unity ou Unreal) funciona como um tabuleiro de Lego que recebe essas peças soltas e as organiza na tela via programação. Para que 5.000 peças diferentes se encaixem sem travar o jogo, a indústria segue uma linha de montagem chamada Pipeline Conceito > Produção > Exportação > Implementação). Nesta aula, apresentamos aos alunos duas regras que separam o amador do profissional:

- A Nomenclatura Padrão (Naming Convention): Computadores não têm

olhos. Se um arquivo for salvo com o nome desenho_final2_ontem.png, o

programador não saberá como chamá-lo no código. Usamos sempre letras minúsculas, sem acentos nem espaços, separadas por sublinhado (underline): categoria_objeto_estado.extensao (por exemplo: prop_espada_madeira.png ou ui_botao_jogar.png ).

- Resolução de Tela vs. Impressão Pixels e DPI No ano anterior,

exploramos vetores escaláveis. No Photoshop, pintamos sobre um mosaico de Pixels (quadradinhos que guardam cor). Se vamos imprimir um livro ou embalagem física, usamos 300 DPI (Dots Per Inch / Pontos por Polegada). Em games, nossa arte vive exclusivamente em monitores e celulares; por isso, trabalhamos na resolução padrão de telas de 72 DPI, medindo o tamanho do nosso palco (Canvas) diretamente em pixels (como 1920 1080 px para Full HD.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Criação do primeiro Canvas profissional de game art, configurando réguas e desenhando um asset de ícone de moeda mágica com fundo transparente (.PNG).

#### Passo 1 — Criando o Palco de Trabalho

- Abra o Adobe Photoshop.

- Clique no botão Criar Novo (Create New) no canto superior esquerdo.

- No painel de predefinições à direita:

Altere a unidade de medida de "Centímetros" para Pixels. Defina a Largura para 1920 e a Altura para 1080. Defina a Resolução para 72 Pixels/Polegada. O Modo de Cores deve ficar em Cores RGB / 8 bits. Em Conteúdo do Plano de Fundo, selecione Transparente (fundo xadrez cinza e branco).

- Clique em Criar (Create).

#### Passo 2 — Reconhecendo o Cockpit e Atalhos Sagrados

- Aponte no projetor as três áreas fundamentais: Barra de Ferramentas à

esquerda, Área de Pintura Canvas ao centro e Painel de Camadas (Layers) à direita.

- Demonstre o atalho Ctrl + R para ativar as Réguas (Rulers). Puxe uma

linha guia a partir da régua superior e outra da régua lateral para marcar o centro do documento.

- Explique os atalhos vitais:

Tecla B: Pincel (Brush). Tecla V: Mover (Move Tool). Tecla E: Borracha (Eraser). Segurar a Barra de Espaço: Mãozinha (Hand Tool) para arrastar a tela em zoom alto. Ctrl + Z: O botão de desfazer.

#### Passo 3 — Desenhando um Asset Simples com o Canal Alpha

- No painel de Camadas, clique no ícone de folha dobrada (ou símbolo

+ ) na base do painel para criar uma nova camada. Dê dois cliques no nome dela e mude para moeda_dourada.

- Pressione a tecla B Pincel . Clique com o botão direito na tela e ajuste

a Dureza (Hardness) para 100% e o tamanho para 150 px.

- Na caixa de cores, escolha um tom amarelo brilhante. Dê um clique

simples no centro da tela para carimbar um círculo amarelo sólido.

- Mude a cor do pincel para um tom alaranjado e diminua o tamanho para

100 px. Dê outro clique no centro da moeda para criar uma borda decorativa.

#### Passo 4 — A Mágica do Salvamento Transparente (.PNG)

- Vá até o menu superior: Arquivo > Exportar > Exportação Rápida como

PNG (File > Export > Quick Export as PNG).

- Explique que o formato PNG carrega o Canal Alpha (a informação

invisível que elimina o fundo branco).

- Salve o arquivo na pasta de demonstração com a nomenclatura

profissional correta: prop_item_moeda_ouro.png. Mostre aos alunos como o arquivo não tem nenhuma caixa branca ao redor.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** Setup do Game Artist e O Primeiro Asset Pack

Hoje você assume oficialmente a cadeira de artista técnico de um estúdio. Sua missão é configurar o seu ambiente de trabalho no Photoshop e produzir seus três primeiros assets decorativos com nomenclatura profissional e fundo transparente. Checklist do Desafio: Criar uma pasta no computador chamada PRMU2_SeuNome e uma subpasta chamada Assets_S1. Abrir o Photoshop e criar um novo Canvas de 1920 x 1080 pixels, resolução de 72 DPI e fundo transparente. Ativar as réguas com o atalho Ctrl + R e puxar duas guias para marcar o centro do palco. Criar 3 camadas separadas no painel de camadas para cada um dos seguintes itens: Camada 1 Uma poção de vida (formato simples de frasco). Camada 2 Uma moeda de ouro ou gema mágica. Camada 3 Uma chave de masmorra. Pintar cada item em sua respectiva camada usando o Pincel Duro (B ). Exportar cada elemento separadamente como arquivo.PNG com canal alpha (fundo transparente). Respeitar rigorosamente a nomenclatura padrão da indústria: prop_pocao_vida.png prop_moeda_ouro.png prop_chave_ferro.png'),
('producao-multimidia-ii','modulo-1','semana-2','Semana 2: O Repertório Visual e a Bússola do Moodboard',2,'## Semana 2: O Repertório Visual e a Bússola do Moodboard Conteúdos integrados: Classificação de Assets UI, Props, Sprites, Tilesets) e Construção de Moodboard com a Regra do Frankenstein.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Existe um mito prejudicial na arte: a ideia de que o profissional competente senta na frente do monitor e desenha universos inteiros "de cabeça". Na realidade, desenhar puramente de memória gera desenhos infantis, clichês e anatomicamente incorretos. O repertório humano depende da construção de uma Biblioteca Visual sólida. Na indústria profissional, não copiamos um único desenho (o que seria plágio criminoso); nós aplicamos a Regra do Frankenstein. Coletamos 20 referências reais: buscamos a carapaça de um besouro para entender a textura da armadura, a roda de um trator para o design do pneu e um templo grego antigo para o pedestal da estátua. Juntamos a textura de um, a cor do outro e a forma de um terceiro para criar um asset inédito. Antes de abrir o Photoshop para pintar, todo projeto de games começa com um Moodboard Painel Semântico ou Painel de Atmosfera). Ele funciona como a bússola visual da equipe. Se um estúdio possui dez artistas trabalhando no mesmo jogo, o Moodboard garante que todos usem as mesmas tonalidades, os mesmos materiais e o mesmo clima de iluminação, evitando desvios estilísticos. Além disso, o artista precisa saber qual categoria de asset está concebendo: UI Interface): Barras de vida, botões, minimapas — elementos que ficam fixados na lente da câmera para orientar o jogador. Props: Objetos manipuláveis ou decorativos do ambiente (barris, tochas, baús). Sprites: Entidades vivas e dinâmicas que realizam ações ou sofrem animações (heróis, monstros, explosões). Tilesets: Blocos modulares geométricos que se repetem em grade para montar o solo e paredes do mundo.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Montagem de um Moodboard temático profissional ("Posto de Controle Cyberpunk Subterrâneo") com paleta de cores integrada.

#### Passo 1 — O Garimpo nas Minas de Referência

- Abra o navegador e demonstre brevemente as plataformas de

referência profissional: ArtStation (padrão ouro para Concept Art e

Games), Behance (design gráfico e interfaces de jogos) e Pinterest (organização rápida de pastas visuais).

- Baixe de 5 a 6 imagens de alto impacto: tubulações industriais

enferrujadas, luzes de neon azul e rosa, painéis de controle futuristas e capacetes de pilotos táticos.

#### Passo 2 — Preparando a Prancheta do Painel

- No Photoshop, crie um novo arquivo: 1920 x 1080 pixels , 72 DPI , Modo

RGB.

- Pinte o fundo com um cinza escuro neutro (#1E1E1E ) para descansar a

visão durante a avaliação das fotos.

#### Passo 3 — A Importação Não Destrutiva Place Embedded)

- Vá ao menu superior: Arquivo > Colocar Incorporado... (File > Place

Embedded).

- Selecione a primeira foto baixada. Ela entrará no Canvas com uma caixa

delimitadora de transformação.

- Pressione a tecla Enter para confirmar a inserção.

- Pressione o atalho Ctrl + T (Transformação Livre): segure os cantos da

caixa com o mouse para redimensionar a imagem proporcionalmente.

- Use a ferramenta Mover (V) para posicioná-la no quadrante superior

esquerdo.

- Repita a operação com mais 4 imagens, agrupando-as harmonicamente

pela tela e mantendo um pequeno respiro entre elas.

#### Passo 4 — Extraindo a Paleta de Cores Oficial

- Selecione a Ferramenta Retângulo (atalho U). Na barra de opções

superior, desative o traçado (Stroke) e defina uma cor qualquer para o preenchimento (Fill).

- Desenhe um quadrado de aproximadamente 80 x 80 px na parte inferior

do documento.

- Com a Ferramenta Conta-Gotas (atalho I), clique em uma luz de neon

azul da fotografia para clonar a cor exata. Pinte o primeiro retângulo.

- Segure a tecla Alt e arraste o retângulo para o lado com a ferramenta

Mover (V) para duplicá-lo rapidamente.

- Repita o processo até obter 5 amostras cromáticas dominantes do seu

painel (ex: Rosa Choque, Ciano Neon, Cinza Asfalto, Amarelo Alerta e Preto Profundo).

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Bússola Visual do Projeto Você e seu time receberam o briefing de um jogo inédito. Sua missão é garimpar referências de qualidade e construir o Moodboard oficial de Direção de Arte do universo do seu jogo, estabelecendo o clima, os materiais do mundo e a paleta cromática inicial. Checklist do Desafio: Definir o tema do seu projeto Exemplos: Masmorra Medieval Amaldiçoada, Estação Espacial Abandonada ou Vila Flutuante Steampunk). Garimpar e salvar em uma pasta local de 8 a 12 imagens de referência no Pinterest, ArtStation ou Behance. Atenção: incluir pelo menos 2 fotos do mundo real para materiais/texturas). Criar um documento no Photoshop no tamanho 1920 x 1080 pixels a 72 DPI. Importar todas as imagens utilizando o comando Arquivo > Colocar Incorporado.... Organizar as fotos no Canvas usando Ctrl + T Transformação Livre) e a ferramenta Mover (V ), mantendo a tela diagramada sem sobreposições confusas. Criar uma faixa com 5 quadrados na base ou lateral utilizando a Ferramenta Retângulo (U ). Coletar 5 cores fundamentais das próprias fotos com o Conta-Gotas (I ), formando a paleta de cores oficial do jogo. Salvar o arquivo mestre como Moodboard_Tema_SeuNome.psd e exportar uma versão em.JPG para apresentação rápida.'),
('producao-multimidia-ii','modulo-1','semana-3','Semana 3: A Psicologia das Formas (Shape Language)',3,'## Semana 3: A Psicologia das Formas (Shape Language) Conteúdos integrados: Shape Language aplicada a arquétipos, Biologia da Visão e Silhuetas Primitivas.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Quando um personagem de jogo entra na tela, o jogador decide em menos de meio segundo se ele é amigável, ágil ou perigoso, antes mesmo de ouvir a voz do personagem ou ler seus atributos. Essa leitura instantânea não acontece por acaso; trata-se da Linguagem das Formas (Shape Language). Nosso cérebro carrega padrões biológicos ancestrais de sobrevivência: O Círculo O Companheiro): Formas arredondadas e curvas não oferecem quinas cortantes. Transmitem maciez, segurança, inocência, carisma e flexibilidade. É a geometria definitiva de mascotes e protagonistas acolhedores (Kirby, Pikachu, Baymax). O Quadrado A Fortaleza): Linhas retas, cantos de 90 graus e bases largas transmitem estabilidade física, teimosia, lentidão e força bruta. Um personagem quadrado parece ter raízes na terra; ele não recua com facilidade. É a base para "Tanques", guerreiros de escudo e protetores inabaláveis (Hulk, Detona Ralph). O Triângulo A Ameaça e a Velocidade): Vértices afiados, espinhos e linhas diagonais lembram presas, garras e pedras pontiagudas. O cérebro associa o triângulo a perigo, tensão, malícia e dinamismo cortante. É a silhueta primária de vilões, magos traiçoeiros ou assassinos ultrarrápidos (Malévola, Sonic). A Alquimia dos Personagens: Os designs mais interessantes combinam essas geometrias. O arquétipo do "Gigante Gentil" (como Sulley de Monstros S.A.) utiliza um tronco quadrado e largo (força), suavizado por barriga, olhos e queixo circulares (doçura e carisma).

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Construção ao vivo de três silhuetas primitivas de personagens O Tanque Protetor, o Curandeiro Inofensivo e o Assassino Tóxico) usando exclusivamente geometria sólida e o Teste da Silhueta.

#### Passo 1 — Setup do Bloco de Silhuetas

- Crie um novo documento no Photoshop: 1920 x 1080 px , 72 DPI , fundo

Branco.

- Crie uma nova camada chamada Silhuetas_Brutas .

- Pressione a tecla B Pincel , selecione o Pincel Redondo Duro (Hard

Round), configure a Opacidade para 100% e a cor de primeiro plano para Preto puro (#000000 ).

#### Passo 2 — Forjando o Tanque A Ditadura dos Quadrados)

- No lado esquerdo do Canvas, pinte um bloco retangular maciço para o

tronco (muito largo horizontalmente).

- Adicione uma cabeça minúscula e quadrada encaixada diretamente

sobre o tronco, sem pescoço aparente (pescoço ausente transmite dureza mecânica).

- Pinte pernas curtas e retangulares, como dois pilares de concreto

fincados no solo.

- Adicione punhos enormes e quadrados na altura do quadril.

#### Passo 3 — Forjando o Curandeiro A Fluidez dos Círculos)

- No centro do Canvas, aumente o raio do pincel duro e carimbe uma

grande esfera para a barriga.

- Desenhe uma cabeça circular proporcionalmente grande sobreposta ao

tronco (cabeças grandes transmitem apelo visual mais jovem/carismático).

- Pinte membros curvos, em forma de salsichas elípticas, sem ângulos

vivos nas articulações.

#### Passo 4 — Forjando o Assassino A Agressividade dos Triângulos)

- No terço direito do Canvas, desenhe um triângulo invertido pontiagudo

para o tronco (ombros largos afinando drasticamente para uma cintura milimétrica).

- Desenhe pernas longas e pontiagudas com ângulos em zigue-zague.

- Adicione um capuz ou cabelo com três pontas afiadas apontando em

diagonal para fora.

#### Passo 5 — O Teste de Leitura

- Afaste o zoom com Ctrl + Menos.

- Mostre para a turma: sem olhos, sem boca, sem cores e sem roupas,

qualquer estudante sabe apontar com clareza quem é o protetor, quem

é o curandeiro e quem é o assassino letal.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Tríade da Geometria Visual Sua tarefa é colocar a psicologia evolutiva à prova. Você criará três silhuetas originais de corpo inteiro em preto sólido, provando que a identidade do personagem nasce na geometria das formas primitivas antes de receber detalhes cosméticos. Checklist do Desafio: Criar um documento novo no Photoshop: 1920 x 1080 px, 72 DPI, fundo Branco. Dividir mentalmente o palco em três áreas e criar uma camada chamada 01_Silhuetas_Primitivas. Construir o Personagem A O Tanque/Guardião): Deve ser desenhado com 80% de predominância de quadrados e retângulos (ombros em bloco, mandíbula quadrada, postura rígida). Construir o Personagem B O Companheiro/Suporte): Deve ser desenhado com 80% de predominância de círculos e ovais (barriga esférica, postura macia, ausência de pontas). Construir o Personagem C O Vilão/Assassino): Deve ser desenhado com 80% de predominância de triângulos e diagonais (extremidades afiadas, postura tensa e ameaçadora). Aplicar a regra inquebrável: trabalhar com tinta preta sólida (#000000 ), sem linhas internas, sem desenhar olhos, roupas ou armas detalhadas. Executar o "Teste com o Colega": vire o monitor para o colega ao lado; ele deve acertar os arquétipos das três formas em menos de 5 segundos. Salvar o arquivo mestre como ShapeLanguage_Trio_SeuNome.psd.'),
('producao-multimidia-ii','modulo-1','semana-4','Semana 4: A Engenharia dos Thumbnails e o Teste da Silhueta',4,'## Semana 4: A Engenharia dos Thumbnails e o Teste da Silhueta Conteúdos integrados: Thumbnails de Concept Art, Esculpir na Massa e o Teste Supremo da Silhueta Negra.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

O erro mais frequente de quem inicia na Concept Art é abrir uma prancheta de alta resolução, aplicar zoom máximo de 500% e passar quatro horas refinando a fivela do cinto e a pupila do olho do personagem. Quando o artista afasta a visão para ver o corpo inteiro, descobre que a anatomia está torta, a pose está travada e o conceito geral é desinteressante. O tempo de produção foi desperdiçado. Na indústria profissional, combatemos esse erro trabalhando com Thumbnails (que em inglês significa literalmente "unha do polegar"). Um thumbnail é um rascunho em miniatura, produzido em velocidade extrema. Desenhamos pequeno de propósito para que o cérebro fique fisicamente impossibilitado de focar em detalhes. O foco do thumbnail é resolver duas coisas fundamentais:

- A Proporção Anatômica: A relação entre o tamanho da cabeça, o tronco e

os membros.

- O Espaço Negativo e a Silhueta: Os vãos vazios de ar que passam entre as

pernas e entre os braços e o tronco. Se um guerreiro segura uma espada gigante colada na frente do próprio peito, ao preenchermos o desenho de preto sólido, a espada se funde ao tronco e a silhueta vira uma mancha disforme. Ao abrir os braços e projetar a espada para fora do contorno do corpo, o espaço negativo revela a ação com clareza. A regra de ouro de um estúdio é o Desapego. Não gaste horas na primeira ideia. Crie 10 thumbnails rápidos em 30 minutos; descarte os 9 óbvios e fique com a única solução verdadeiramente memorável.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Criação de uma folha de exploração com 6 thumbnails rápidos em miniatura de um Chefe de Fase Alienígena, aplicando a técnica de esculpir massa sólida preta.

#### Passo 1 — A Prancheta de Visão Distante

- Crie um Canvas de 1920 x 1080 px no Photoshop, resolução de 72 DPI ,

fundo cinza-claro (#DCDCDC ) para não cansar a vista.

- Crie uma nova camada chamada Thumbnails_Exploracao .

- O Truque do Zoom: Pressione Ctrl + Menos repetidamente até que o

Canvas ocupe cerca de 25% do monitor. Proíba a si mesmo de aproximar a tela durante o processo.

#### Passo 2 — A Técnica de Esculpir a Massa De Dentro para Fora)

- Pressione B Pincel Redondo Duro), cor Preta, tamanho médio (em

torno de 30 px).

- Em vez de desenhar contornos (outline) como num caderno de colorir

infantil, pinte diretamente o "bloco" sólido da silhueta.

- Mancha 1 Pinte um tronco curvado em arco, adicione quatro pernas

finas de inseto e duas mandíbulas pontiagudas projetadas para a esquerda.

- Pressione a tecla E Borracha dura): "escave" o espaço negativo entre

as pernas para garantir que os vãos de fundo fiquem nítidos.

#### Passo 3 — A Variação de Proporções Explorando o Imprevisto)

- Sem apagar a primeira mancha, mova o pincel para o lado.

- Desenhe a mesma criatura, mas agora com proporções invertidas:

tronco minúsculo e pernas colossais.

- Ao lado, desenhe uma terceira variação: corpo longo e serpentino, com

múltiplos braços finos estendidos em diagonal.

- Repita até alinhar 6 variações distintas lado a lado no mesmo arquivo.

#### Passo 4 — O Teste Supremo Blackout Test)

- Pressione a barra de espaço para navegar entre as silhuetas.

- Avalie qual delas possui a silhueta mais reconhecível à distância,

demonstrando aos alunos como o contorno externo comunica o perigo da criatura sem exigir nenhum traço interno.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Forja de Silhuetas Chegou a sua vez de atuar como artista conceitual de produção. Você deve ignorar os detalhes e explorar variações volumétricas extremas, produzindo

uma folha técnica de thumbnails para um vilão ou criatura de jogo. Checklist do Desafio: Criar um documento no Photoshop: 1920 x 1080 px, 72 DPI, com fundo cinza-claro neutro. Afastar o zoom da tela (trabalhar obrigatoriamente sem aproximação, mantendo o Canvas visualmente pequeno). Escolher um arquétipo para o desafio: O Mercenário Cibernético, O Bruxo da Floresta ou A Criatura das Profundezas. Desenhar na mesma camada pelo menos 6 opções de thumbnails em miniatura, pintando a massa sólida em preto (#000000 ). Utilizar a Borracha (E ) para lapidar as bordas e abrir janelas de espaço negativo (garantir que braços e armas não fiquem colados ao corpo como um bloco maciço). Forçar variações claras em cada um dos 6 desenhos: mudar a postura da linha da coluna, inverter pesos (pernas longas vs. pernas curtas, tronco largo vs. tronco esguio). Eleger o melhor thumbnail entre os seis desenhados e desenhar um círculo vermelho ao redor dele para indicar a escolha da Direção de Arte. Salvar o arquivo mestre como Thumbnails_Criatura_SeuNome.psd.'),
('producao-multimidia-ii','modulo-1','semana-5','Semana 5: Cor Digital, Sistema HSB e o Color Script',5,'## Semana 5: Cor Digital, Sistema HSB e o Color Script Conteúdos integrados: Harmonia Cromática, Seletor HSB, Identidade Visual e Criação do Color Script Narrativo.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

A cor no Game Design vai muito além do embelezamento estético: ela é uma ferramenta de navegação funcional e indução psicológica. O cérebro humano reage quimicamente às cores: Vermelho: Alerta biológico imediato, urgência, sangue, fogo, perigo e dano crítico.

Verde: Vitalidade vegetal, regeneração, segurança e cura. Azul: Calma, serenidade, confiabilidade e tecnologia avançada. Amarelo/Dourado: Riqueza, recompensa (loot) e sinalização de caminhos interativos. Para criar contrastes eficientes, utilizamos a matemática da harmonia cromática:

- Cores Complementares: Cores posicionadas em lados diametralmente

opostos no círculo cromático (ex: Laranja e Azul, ou Vermelho e Verde). Geram o maior contraste perceptivo possível. Se o cenário do jogo é um deserto alaranjado, desenhar a roupa do herói em azul ciano faz com que ele se descole do fundo instantaneamente.

- Cores Análogas: Cores vizinhas no círculo cromático (ex: Azul escuro,

Ciano e Verde musgo). Transmitem unidade, atmosfera coesa e imersão relaxante para cenários naturais. O Segredo do Seletor HSB O artista profissional não escolhe cores de forma arbitrária; ele utiliza o sistema HSB: H Hue / Matiz): A família da cor em graus (qual cor é: vermelho, verde, azul). S Saturation / Saturação): A pureza ou força da cor. Saturação alta gera cores vibrantes (estilo arcade/fantasia); saturação baixa aproxima a cor do cinza (estilo realista/pós-apocalíptico). B Brightness / Brilho): A quantidade de luz ou escuridão da tinta. O Color Script Roteiro de Cores): Um jogo é uma jornada emocional. O Color Script é o mapa de pranchetas que planeja a evolução da iluminação ao longo da narrativa: começa com tons solares e quentes na vila de origem do protagonista, transita para tons frios e desbotados na caverna do meio da história e atinge o contraste extremo em vermelho e preto no confronto final contra o vilão.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Criação de um Color Script de três fases narrativas A Partida, A Perdição na Caverna e A Fortaleza Sombria) utilizando o sistema HSB e pincéis de atmosfera.

#### Passo 1 — Desvendando o Painel de Cores HSB

- No Photoshop, dê dois cliques na caixa de cor de primeiro plano para

abrir o Seletor de Cores (Color Picker).

- Aponte no painel as três opções: H, S e B.

- Altere o valor de H para navegar pelas famílias de cores.

- Mantenha o H em 200 Azul e altere o S: mostre como o azul vivo S

100%) perde vida e se torna cinza chumbo S 10%) sem mudar de matiz.

- Altere o B: mostre como o valor controla a luz do ambiente (de claro a

preto breu).

#### Passo 2 — Construindo a Grade do Color Script

- Crie um novo documento horizontal: 1920 x 1080 px , 72 DPI , fundo cinza-

médio.

- Selecione a Ferramenta Retângulo (atalho U).

- Desenhe três retângulos horizontais alinhados lado a lado no centro do

documento (cada um medindo aproximadamente 550 x 320 px ), simulando três telas de cinema de uma jornada.

- Nomeie as camadas como 01_Vila_Inicial , 02_Caverna_Perdida e

03_Castelo_Chefe.

#### Passo 3 — Pintura Atmosférica dos Quadros Bloqueio sem Detalhes)

- Crie uma nova camada sobre o retângulo 01_Vila_Inicial e ative a

Máscara de Recorte (Clipping Mask, atalho Ctrl + Alt + G) para que a tinta não vaze do quadro.

- Pressione B Pincel Redondo Macio, grande, sem textura).

- No quadro 1, bloqueie cores análogas quentes: azul-claro suave para o

céu superior e manchas de amarelo solar e verde-folha na base. Atmosfera acolhedora.

- No quadro 2 (02_Caverna_Perdida ), crie outra Máscara de Recorte: use

matizes frios de azul-marinho e cinza-azulado com saturação reduzida, pintando uma única fresta de ciano no centro. Atmosfera de solidão e mistério.

- No quadro 3 (03_Castelo_Chefe ), use a regra das cores complementares:

fundo vermelho-sangue escuro recortado por uma fresta amarela incandescente de alto brilho no ponto focal. Atmosfera de perigo iminente.

#### Passo 4 — Validação do Fluxo Emocional

- Afaste o zoom com Ctrl + Menos.

- Demonstre como a transição cromática conta a história visual do jogo

antes mesmo de adicionarmos qualquer linha ou personagem aos quadros.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Jornada das Cores Você é o artista de atmosfera responsável por mapear o ritmo emocional de um jogo de aventura. Sua tarefa é produzir um Color Script completo de três atos, aplicando o sistema HSB e harmonias cromáticas intencionais para narrar a evolução de uma história. Checklist do Desafio: Criar um documento horizontal no Photoshop: 1920 x 1080 px a 72 DPI. Desenhar 3 retângulos proporcionais alinhados na tela com a Ferramenta Retângulo (U ). Definir o roteiro das 3 etapas da jornada do seu protagonista: Quadro 1 A Zona Segura Ex: O Refúgio na Floresta). Quadro 2 O Momento de Tensão/Dúvida Ex: O Labirinto Subterrâneo). Quadro 3 O Clímax Dramático Ex: A Cratera do Meteoro). Utilizar o Pincel Macio (B ) de grande escala, trabalhando puramente com manchas de cor e luz, sem desenhar detalhes finos. No Quadro 1, utilizar cores análogas luminosas e acolhedoras para transmitir paz e tranquilidade. No Quadro 2, reduzir a saturação no painel HSB para transmitir isolamento, frio ou desolação.

No Quadro 3, aplicar alto contraste de cores complementares ou luzes saturadas contra fundos escuros para estabelecer o perigo. Salvar o projeto mestre como ColorScript_Jornada_SeuNome.psd.'),
('producao-multimidia-ii','modulo-1','semana-6','Semana 6: A Art Bible (Bíblia de Arte) e a Diagramação Profissional',6,'## Semana 6: A Art Bible (Bíblia de Arte) e a Diagramação Profissional Conteúdos integrados: Estilos Artísticos em Jogos, Coesão Visual, Estrutura da Art Bible e Diagramação no Adobe Illustrator.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Imagine que você está jogando um título com o visual estilizado e carismático de The Legend of Zelda: The Wind Waker. De repente, em meio a uma ilha cartunizada, surge um barril com uma textura de madeira ultrarrealista com fotografias escaneadas em 4K. O impacto no cérebro é instantâneo: a imersão desmorona. Chamamos essa falha de Quebra de Coesão Visual ou Efeito Frankenstein. Na indústria profissional de games, existem três caminhos estilísticos dominantes:

- Realismo: Busca reproduzir as leis da física óptica, anatomia precisa e

texturas com poros e imperfeições reais (The Last of Us, Red Dead Redemption).

- Estilizado / Cartum: Exagera formas geométricas, proporções corporais e

trabalha com cores altamente saturadas e texturas pintadas à mão (Overwatch, Fortnite, Valorant). Possui envelhecimento visual superior ao longo das décadas.

- Pixel Art: A estética construída a partir da limitação técnica das eras 8/16

bits, consolidada como uma escolha visual charmosa e econômica para jogos independentes (Celeste, Blasphemous). A Art Bible O Guia de Estilo): Em estúdios de médio e grande porte, 50 ou 100 artistas trabalham simultaneamente no mesmo projeto. Para garantir que todos desenhem no mesmo estilo, o Diretor de Arte cria a Art Bible Bíblia de Arte). Ela é o manual de regras estéticas do estúdio, contendo a paleta de cores hexadecimais permitidas, a espessura oficial das linhas de contorno (Lineart),

as proporções dos personagens e a seção mais valiosa de todas: a página de Do''s and Don''ts O que fazer e o que NÃO fazer). Essa seção apresenta lado a lado um objeto desenhado de forma aprovada ao lado de um modelo incorreto, explicando tecnicamente a falha estética para poupar retrabalho da equipe. Como ensina a teórica do design Ellen Lupton, a diagramação estruturada por grades (grids) organiza a informação de forma lógica e clara para o leitor. Por isso, construímos essa documentação no Adobe Illustrator, utilizando pranchetas digitais em 16 9, margens de respiro e hierarquia tipográfica precisa.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Diagramação completa de uma página técnica de "Do''s and Don''ts" O que Fazer vs. O que Evitar) para o Guia de Estilo no Adobe Illustrator.

#### Passo 1 — Preparando o Palco de Diagramação

- Abra o Adobe Illustrator.

- Vá em Criar Novo (Create New). Selecione a categoria Web.

- Configure a largura para 1920 px e altura para 1080 px Paisagem /

Widescreen).

- Resolução de rasterização em 72 PPI , Modo de Cores RGB .

- Clique em Criar.

#### Passo 2 — Margens de Segurança com Réguas e Grades

- Pressione o atalho Ctrl + R para exibir as Réguas (Rulers).

- Clique sobre a régua superior e arraste uma linha-guia até a marca de

100 px. Repita puxando uma guia da base até 980 px.

- Puxe guias verticais das réguas laterais a 100 px da esquerda e da

direita. Explique aos alunos o conceito de Espaço Negativo e Respiro Visual: nunca colamos elementos nas bordas da tela.

#### Passo 3 — Hierarquia Tipográfica A Regra das Duas Fontes)

- Selecione a Ferramenta Texto (atalho T).

- No topo da página (respeitando a margem), crie o título: PROPS &

MATERIAIS: DIRETRIZES VISUAIS.

- Escolha uma fonte de Título de impacto (Display ou sem serifa robusta,

como Montserrat Bold) em corpo 36 pt.

- Explique que títulos utilizam fontes estilizadas, enquanto textos longos

de leitura exigem fontes limpas e neutras em corpos menores (14 a 16 pt ) para garantir conforto visual.

#### Passo 4 — Diagramando a Vitrine Comparativa Do''s and Don''ts)

- Pegue a Ferramenta Retângulo (atalho M).

- Desenhe dois quadrados perfeitamente simétricos no centro da tela

(500 x 500 px ), segurando a tecla Shift. Posicione um à esquerda e outro à direita.

- Pinte o quadrado da esquerda com preenchimento cinza-claro e uma

borda verde sólida (#00A859 ) com traçado de 6 pt.

- Pinte o quadrado da direita com o mesmo preenchimento e uma borda

vermelha sólida (#ED1C24 ) com traçado de 6 pt.

- Insira um asset aprovado no quadrado verde (ex: um barril estilizado

com cantos chanfrados e contornos limpos).

- Insira um asset reprovado no quadrado vermelho (ex: um barril com

textura fotográfica ruidosa).

#### Passo 5 — A Sinalização Universal e a Justificativa Técnica

- Acima do quadro verde, crie uma caixa de texto escrita [ APROVADO

FAÇA ] em verde.

- Acima do quadro vermelho, escreva [ REPROVADO EVITE ] em

vermelho.

- Abaixo de cada quadrado, abra uma caixa de texto explicativa usando

fonte de leitura limpa em corpo 16 pt: Texto Verde: "Utilize vértices arredondados, paleta saturada com sombras frias e contornos de 3 px." Texto Vermelho: "Proibido utilizar fotos reais com ruído de alta resolução ou degradês automáticos sem volumetria."

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Constituição Visual do Jogo

Chegou o momento culminante do Módulo 1. Você assumirá a postura de Diretor de Arte do seu projeto e montará a página mestra de regras do seu estúdio (a página oficial de "Do''s and Don''ts" da sua Art Bible), impedindo desvios estéticos no pipeline da equipe. Checklist do Desafio: Abrir o Adobe Illustrator e criar um documento no formato 1920 x 1080 px, modo RGB, resolução 72 PPI. Ativar as réguas (Ctrl + R ) e traçar margens de segurança de 100 px nas quatro bordas do documento. Aplicar a Hierarquia Tipográfica: criar um título estilizado no topo da página definindo a categoria analisada (ex: PERSONAGENS REGRAS DE CONTOUR ou CENÁRIOS TRATAMENTO DE TEXTURA). Desenhar dois quadros simétricos lado a lado no centro do documento com a Ferramenta Retângulo (M ). Inserir a sinalização visual inequívoca: usar Verde para o lado aprovado (Do) e Vermelho para o lado reprovado (Don''t). Posicionar um exemplo visual aprovado no lado verde e um exemplo que contenha erros conceituais no lado vermelho. Escrever um parágrafo técnico objetivo abaixo de cada caixa (em fonte legível, corpo 14 a 16 pt), justificando com termos da disciplina (como Shape Language, saturação, espessura de contorno ou ruído visual) a aprovação e a reprovação dos modelos. Adicionar na base do arquivo uma amostra com as 4 cores hexadecimais permitidas para o universo do jogo. Salvar o arquivo mestre do Illustrator como ArtBible_OnePager_SeuNome.ai e exportar a página final em formato PDF de alta compatibilidade para entrega.'),
('producao-multimidia-ii','modulo-2','semana-7','Semana 7: A Fundação da Pintura Digital: Sanduíche de Camadas, Flats e Alpha Lock',1,'## Semana 7: A Fundação da Pintura Digital: Sanduíche de Camadas, Flats e Alpha Lock Conteúdos integrados: Pintura Não-Destrutiva, Sanduíche de Camadas, Bloqueio de Cores Flats, Laço Poligonal e Alpha Lock.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Nos jogos, os adereços e itens interativos ou decorativos do mundo são chamados de Props (espadas, poções, baús e barris). Até agora, trabalhamos com vetores e silhuetas básicas. Para que um prop pareça sólido e pronto para a tela do jogador, precisamos dominar a pintura digital sem cometer o erro clássico dos iniciantes: a pintura destrutiva. Se você pintar com um pincel vermelho diretamente sobre o seu desenho de contorno (Lineart), a linha preta é apagada. Se o Diretor de Arte pedir para trocar a cor do cabo da espada de marrom para cinza, você terá que refazer tudo do zero. Em estúdios profissionais, a regra inquebrável é a Edição Não- Destrutiva. Para organizar o trabalho, utilizamos a técnica do Sanduíche de Camadas: O Pão de Cima (Lineart): A camada mais alta. Contém apenas as linhas pretas do contorno em modo Multiplicação (Multiply), tornando qualquer fundo branco transparente. O Recheio Luzes e Sombras): Camadas intermediárias onde aplicamos volume, reflexos e texturas.

O Pão de Baixo (Flats / Cores Base): A camada estrutural inferior com as cores sólidas e chapadas de cada pedaço do desenho, sem degradês. O Prato (Background): Fundo cinza-neutro escuro para descansar a visão durante a pintura. A Caça aos Pixels Brancos: O aluno iniciante tenta usar a Varinha Mágica (Magic Wand) para preencher o contorno. As linhas digitais possuem bordas suaves (anti-aliasing); por isso, a Varinha Mágica deixa um contorno serrilhado de pixels brancos vazados (o "Efeito Halo"), reprovando o arquivo. Para criar os Flats, usamos o Laço Poligonal L contornando exatamente pelo meio do traço preto, preenchendo com o Balde de Tinta G e travando tudo com o Alpha Lock Bloquear Pixels Transparentes) para não pintar fora das bordas.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Preparação e preenchimento de cores base (Flats) de uma Adaga Curva com ativação do Alpha Lock.

#### Passo 1 — Organizando a Cozinha O Sanduíche de Camadas)

- Abra o arquivo do desenho da adaga no Photoshop (ou baixe um

Lineart limpo de demonstração).

- No painel de Camadas (Layers), renomeie a camada do contorno para

Lineart.

- No menu suspenso de modos de mesclagem (onde está escrito

"Normal"), mude para Multiplicação (Multiply).

- Crie uma nova camada abaixo da Lineart e nomeie-a como Flats .

- Crie outra camada na base de tudo, preencha-a com cinza médio

(#3A3A3A ) e nomeie-a como Background_Neutro. Trave o cadeado dela.

#### Passo 2 — Contornando Cirurgicamente com o Laço Poligonal

- Selecione a camada Flats .

- Pressione a tecla L para ativar a Ferramenta Laço Poligonal (Polygonal

Lasso Tool).

- Aumente o zoom na lâmina com Ctrl + Mais.

- Dê o primeiro clique exatamente no meio-fio da linha preta do contorno.

Vá clicando ponto a ponto contornando toda a extensão da lâmina.

- Feche o circuito clicando no ponto de origem até aparecer um pequeno

círculo ao lado do cursor, gerando a seleção ativa ("formigas marchando").

#### Passo 3 — Inundando a Área com Balde de Tinta

- Pressione a tecla G (se estiver no Gradiente, clique e segure para

selecionar o Balde de Tinta / Paint Bucket Tool).

- No Seletor de Cores, escolha um tom Cinza Metálico Médio (#8C929D ).

- Dê um clique dentro da seleção ativa para preenchê-la.

- Pressione Ctrl + D para cancelar a seleção.

- Repita a técnica do Laço Poligonal para preencher a empunhadura com

Marrom (#5A3218 ) e a guarda com Dourado (#D4A017 ).

#### Passo 4 — A Trava de Segurança Alpha Lock)

- No topo do painel de Camadas, com a camada Flats selecionada,

clique no ícone que se assemelha a um pequeno tabuleiro de xadrez (Bloquear pixels transparentes).

- Pegue um Pincel grande (B ) com qualquer cor berrante e rabisque toda

a tela.

- Demonstre para a turma como a tinta só é aplicada onde já existe cor

base, impedindo que o aluno suje o fundo ou saia das bordas. Desfaça o teste com Ctrl + Z.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Linha de Montagem dos Flats Hoje você trabalhará como assistente técnico de colorização (Flatter) em um estúdio. Sua tarefa é pegar o traço limpo de dois props e construir a base sólida de cores chapadas sem deixar falhas ou vazamentos. Checklist do Desafio: Abrir o Photoshop e configurar um documento de 1920 x 1080 px a 72 DPI com fundo cinza-neutro.

Desenhar rapidamente (ou importar do material de apoio) o contorno de dois props distintos: um frasco de poção mágica e uma adaga ou machado. Estruturar o Sanduíche de Camadas: camada Lineart no topo em modo Multiplicação e camada Flats vazia posicionada logo abaixo. Proibição total do uso da Varinha Mágica para preenchimento de cor base. Utilizar a ferramenta Laço Poligonal (L ), contornando pelo centro exato da linha preta. Preencher cada material (vidro, líquido, aço, madeira) com cores sólidas usando o Balde de Tinta (G ). Usar o atalho Ctrl + D para desselecionar as áreas após cada cor aplicada. Desligar a camada Lineart temporariamente para verificar se não há "furos" ou áreas brancas transparentes na cor base. Ativar o Alpha Lock Bloquear pixels transparentes) na camada Flats finalizada. Salvar o arquivo de produção como Props_Flats_SeuNome.psd.'),
('producao-multimidia-ii','modulo-2','semana-8','Semana 8: Iluminação e Volumetria: Modos de Mesclagem e as 4 Zonas de Luz',2,'## Semana 8: Iluminação e Volumetria: Modos de Mesclagem e as 4 Zonas de Luz Conteúdos integrados: Modos de Mesclagem Multiply, Screen, Linear Dodge), Zonas de Iluminação, Luz Rebatida e Clipping Mask.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Com a cor base pronta e o Alpha Lock ligado, o prop ainda parece um adesivo 2D colado na tela. Para dar a sensação de tridimensionalidade e peso, precisamos esculpir o volume com luz e sombra. O erro mais comum ao sombrear digitalmente é pintar com pincel preto em baixa opacidade sobre a cor base. Isso gera o "Sombreamento Sujo" (Muddy Shading), que desbota a saturação e deixa a imagem acinzentada. Na natureza, as sombras possuem cores ricas e sofrem influências do ambiente ao redor. Para simular isso no computador, usamos os Modos de Mesclagem (Blending Modes) combinados com Máscaras de Recorte (Clipping Masks):

- Multiplicação (Multiply): Focado nas sombras. Ele mescla a tinta com a

camada inferior de forma rica. Ao sombrear com azul ou roxo em Multiply, a sombra ganha profundidade e saturação natural.

- Divisão (Screen): Focado na iluminação difusa. O preto torna-se invisível e

a cor aplicada clareia a base sem estourar o contraste.

- Subexposição Linear / Adicionar (Linear Dodge / Add): Luz extrema,

reflexos especulares fortes, fogo, magia e neons. As 4 Zonas de Luz: Para um objeto curvo parecer 3D, o olho humano exige quatro zonas de luz bem definidas: Luz Plena (Highlight): Ponto de maior incidência direta da luz, próximo ao branco puro. Meio-Tom (Halftone): A cor natural do objeto, visível onde a luz não bate nem de frente nem de raspão (representada pelo nosso Flat). Sombra Própria (Core Shadow): A linha onde a forma se curva para longe da fonte de luz, pintada com tons frios em Multiply. Luz Rebatida (Bounce Light): A luz do chão que "quica" e ilumina sutilmente a parte inferior da sombra própria, integrando o objeto ao ambiente.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Transformação de um círculo 2D em uma Esfera de Cristal volumosa utilizando as 4 zonas de iluminação e modos de mesclagem.

#### Passo 1 — A Bússola de Luz e a Base

- No Photoshop, desenhe um círculo perfeito com a Ferramenta Elipse

(U ) preenchido com Vermelho Puro (#D82828 ). Rasterize a camada ou crie o círculo com seleção e Balde de Tinta. Nomeie como Esfera_Base.

- Defina uma linha-guia imaginária: a luz principal virá do canto superior

esquerdo da tela. Isso é uma regra inquebrável para todo o objeto.

#### Passo 2 — Esculpindo a Sombra Própria Multiply)

- Crie uma nova camada acima da Esfera_Base .

- Pressione o atalho Ctrl + Alt + G para criar uma Máscara de Recorte

(Clipping Mask). Uma setinha apontando para baixo aparecerá; a

pintura não sairá dos limites do círculo).

- Mude o Modo de Mesclagem dessa camada para Multiplicação

(Multiply).

- Pressione B e selecione o Pincel Redondo Macio (Soft Round) com

tamanho grande.

- Escolha uma cor Azul-Púrpura fria (#3C1B54 ). Passe o pincel

suavemente na lateral inferior direita da esfera, acompanhando a curva da forma.

#### Passo 3 — A Luz Difusa Screen

- Crie uma nova camada acima da camada de sombra e ative a Máscara

de Recorte (Ctrl + Alt + G).

- Mude o modo para Divisão (Screen).

- Selecione uma cor Amarelo-Claro quente (#FFECA8 ).

- Com o mesmo pincel macio, aplique duas pinceladas no quadrante

superior esquerdo (onde a luz bate de frente).

#### Passo 4 — Injetando a Luz Rebatida Bounce Light)

- Crie mais uma camada com Máscara de Recorte, em modo Normal ou

Divisão, com opacidade em 40%.

- Imagine que o chão ao redor da esfera é azul-celeste. Escolha um tom

Ciano Claro.

- Dê uma pincelada macia bem rente à beirada inferior direita,

exatamente dentro da zona escura de sombra.

- Mostre aos alunos como a esfera parece respirar instantaneamente,

criando a ilusão de que o chão está refletindo luz para cima.

#### Passo 5 — O Brilho Especular Linear Dodge)

- Crie uma última camada no topo, com Máscara de Recorte, em modo

Subexposição Linear Adicionar).

- Diminua o tamanho do pincel e aumente a Dureza (Hardness) para

80%.

- Com cor branca pura, dê um clique pontual dentro da área mais clara

da esfera. A ilusão de volume e reflexo de cristal está completa.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Forja do Orbe Dimensional Sua missão é dar volume tridimensional a dois objetos geométricos primitivos (uma esfera e um cilindro de poção) aplicando o sistema técnico de 4 zonas de iluminação e modos de mesclagem. Checklist do Desafio: Criar um documento no Photoshop: 1920 x 1080 px a 72 DPI com fundo cinza-neutro. Desenhar a base chapada de um círculo perfeito (orbe de cristal) e de um cilindro (frasco de poção) em camadas separadas. Definir a Bússola de Luz: marcar no canto superior esquerdo uma seta indicando a origem dos raios solares. Criar camadas independentes vinculadas como Máscaras de Recorte (Ctrl + Alt + G ) para luz e sombra. Camada de Sombra: configurada em modo Multiplicação (Multiply) com cor fria (azul ou roxo), sem usar preto puro. Camada de Luz: configurada em modo Divisão (Screen) com cor quente (amarelo ou laranja claro). Aplicar a Luz Rebatida (Bounce Light) na base da sombra, utilizando um tom que simule o reflexo do piso. Finalizar o ponto de impacto com o Pincel Duro em modo Linear Dodge para simular o reflexo especular. Salvar o arquivo de estudo como Volumetria_Zonas_SeuNome.psd.'),
('producao-multimidia-ii','modulo-2','semana-9','Semana 9: Materiais Duros: Aço Polido vs. Madeira e Renderização de Props',3,'## Semana 9: Materiais Duros: Aço Polido vs. Madeira e Renderização de Props Conteúdos integrados: Comportamento de Superfícies Difuso vs. Especular), Render de Metal e Madeira, Edge Highlights e Oclusão Ambiental.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Se usarmos o mesmo pincel macio e as mesmas transições suaves para pintar tudo, todos os objetos do jogo parecerão feitos de borracha ou plástico. Para dar credibilidade aos materiais de um jogo, precisamos entender como a luz física rebate em diferentes superfícies: Materiais Foscos Reflexão Difusa): Madeira, pedra, tijolo e barro possuem microscópicas imperfeições e fendas. Quando a luz atinge essas superfícies, os raios se espalham de forma caótica em todas as direções. O resultado é que não existe um brilho branco brilhante concentrado; o contraste é baixo e a transição é suave. Na madeira, nunca usamos brilho branco puro. Materiais Metálicos Reflexão Especular): O aço polido, o ouro e o cromo são superfícies lisas no nível microscópico. A luz bate e reflete diretamente para o olho do espectador, agindo como um espelho. A Regra de Ouro do Metal: Alto contraste e bordas duras. No aço, colocamos o brilho mais claro encostado quase imediatamente na sombra mais escura, usando pincéis duros e cortes retos. Não há espaço para esfumaçados lentos. Dois Toques de Acabamento:

- Chanfro de Corte (Edge Highlight): Traçar uma linha branca e afiada de 1 a

2 pixels no fio da lâmina para criar a ilusão de metal afiado.

- Oclusão Ambiental (Ambient Occlusion): A sombra escura que se forma

nas frestas onde dois materiais se tocam fisicamente (ex: a base de um prego de metal pregado na madeira).

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Renderização dos materiais de uma Espada Larga Lâmina de Aço com vinco central e Cabo de Madeira envelhecida).

#### Passo 1 — A Quina da Lâmina de Aço Alto Contraste)

- Abra o arquivo da espada com os Flats cinzas já prontos na base.

- Crie uma nova camada em modo Multiplicação (Multiply) com Máscara

de Recorte.

- Com o Laço Poligonal L , selecione com precisão apenas a metade

direita da lâmina (cortando do topo da ponta até o cabo).

- Escolha um Azul-Escuro saturado (#1B2A4A ). Com o Pincel Redondo

Duro, pinte essa metade selecionada. A lâmina ganha uma divisão geométrica imediata de plano.

#### Passo 2 — O Brilho Especular do Aço

- Crie uma nova camada acima, em modo Subexposição Linear /

Adicionar (Linear Dodge), com Máscara de Recorte.

- Diminua o tamanho do Pincel Duro para 4 pixels. Escolha a cor Branca

pura (#FFFFFF ).

- Segure a tecla Shift, clique no topo do vinco central da lâmina e clique

na base para traçar uma linha reta reluzente colada imediatamente na divisão escura.

- Demonstre como a aproximação brusca do branco contra o azul escuro

cria o efeito cromado instantâneo.

#### Passo 3 — Chanfro de Corte Edge Highlight)

- Na mesma camada de brilho, use o pincel de 2 pixels para traçar uma

linha fina e brilhante acompanhando o contorno externo da lâmina.

- A lâmina agora transmite a sensação tátil de corte afiado.

#### Passo 4 — A Madeira do Cabo Caos Orgânico e Baixo Contraste)

- Vá para o Flat do cabo de madeira (marrom). Crie uma camada em

Multiplicação com Máscara de Recorte.

- Use o Pincel Redondo Macio para fazer um leve degradê nas bordas

cilíndricas do cabo.

- Crie uma camada em modo Normal. Pegue um pincel fino 3 px com

marrom bem escuro e desenhe linhas onduladas descendo pelo cabo (veios da madeira).

- O Truque do Relevo: Troque para um marrom claro (areia) e desenhe

linhas claras finas coladas exatamente embaixo de cada linha escura. A ranhura da madeira ganha profundidade.

#### Passo 5 — Oclusão Ambiental de Encaixe

- Crie uma camada em modo Multiply.

- Com um pincel macio bem pequeno e cor marrom-escura/preta, pinte

uma linha de sombra profunda na fenda onde a lâmina de aço entra na

guarda de madeira. As peças parecem fisicamente unidas e com peso realista.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Oficina do Ferreiro Digital Você deve aplicar a física das superfícies e finalizar o render completo de um prop que combine metal e madeira (uma espada de duas mãos, um machado de batalha ou um escudo reforçado com cravos). Checklist do Desafio: Abrir o documento com as camadas de contorno e Flats organizadas da semana anterior. Para a Lâmina/Metal: Dividir a lâmina usando o Laço Poligonal (L ) para separar as faces de corte. Utilizar o Pincel Duro com cor fria em Multiply para criar as áreas de sombra. Aplicar reflexo especular com o Pincel Duro e branco puro em Linear Dodge, criando alto contraste ao lado da sombra. Traçar os Edge Highlights (linhas brancas finas de 1 a 2 px) no fio de corte das bordas. Para o Cabo/Escudo de Madeira: Utilizar transições suaves e pincéis macios para o volume base cilíndrico/arredondado. Não utilizar branco puro para brilhos na madeira (usar tons de amarelo ou bege em modo Screen). Desenhar ranhuras e veios da madeira emparelhando linhas escuras com linhas claras na borda inferior para dar relevo. Pintar a Oclusão Ambiental com sombra densa em Multiply no ponto de contato físico entre o metal e a madeira. Salvar o arquivo de entrega como Prop_Render_AcoMadeira_SeuNome.psd.'),
('producao-multimidia-ii','modulo-2','semana-10','Semana 10: Materiais Orgânicos, Texturização e Weathering (Ação do Tempo)',4,'## Semana 10: Materiais Orgânicos, Texturização e Weathering (Ação do Tempo) Conteúdos integrados: Pincéis Texturizados, Materiais Difusos Couro e Tecido), Weathering Desgaste/Ação do Tempo) e Controle de Ruído Visual.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Se desenharmos a capa de um guerreiro ou o couro de um livro usando os mesmos traços limpos do metal, os materiais parecerão feitos de plástico brilhante ou látex. Materiais orgânicos (tecidos, couros envelhecidos, folhagens e pergaminhos) são caracterizados pela imperfeição, porosidade e absorção de luz. A textura desses materiais não é desenhada fio por fio; ela é sugerida através de milhares de Micro-Sombras projetadas pelos poros e tramas. Para pintar isso no Photoshop sem perder horas de trabalho manual, recorremos aos Pincéis Texturizados (Textured Brushes), baseados em digitalizações de giz, carvão, esponjas e cerdas secas. Weathering A Ação do Tempo): Uma espada perfeita parece um brinquedo saído da embalagem plástica. Para torná-la crível dentro do universo do jogo, aplicamos o Weathering (desgaste, ferrugem, arranhões e manchas). O desgaste é uma ferramenta de Storytelling Ambiental: ele conta a história do herói sem precisar de palavras. O desgaste não é aplicado aleatoriamente: Nas Frestas e Cantos Internos: A sujeira, a umidade e a ferrugem se acumulam onde o pano ou a mão do guerreiro não alcançam para limpar Oclusão Ambiental). Nas Bordas e Quinas Externas (Edge Wear): A tinta descasca e o material quebra nas áreas que sofrem impactos mecânicos constantes ao cair no chão ou bater contra armaduras. A Anatomia do Arranhão Realista: Um risco preto parece apenas uma linha de caneta. Um arranhão volumoso exige relevo: uma linha fina e escura (a fenda cavada) colada imediatamente a uma linha fina clara na borda de baixo (a quina da fenda recebendo luz).

O Perigo do Ruído Visual (Visual Noise): Se você preencher 100% da superfície com ferrugem e arranhões, a imagem se tornará ilegível. Deixe áreas de "respiro" limpas e concentre o desgaste nos pontos de impacto e uso humano.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Aplicação de texturas de couro e marcas de combate (Weathering) na capa de um Tomo Mágico e na lâmina de uma espada veterana.

#### Passo 1 — Acessando a Biblioteca de Pincéis Texturizados

- Pressione a tecla B Pincel e tecle F5 para abrir o painel completo de

configurações de Pincéis.

- Demonstre as pastas nativas do Photoshop: abra a pasta Pincéis de

Mídia Seca (Dry Media Brushes) ou Pincéis Especiais.

- Selecione um pincel de textura de Giz (Chalk) ou Esponja (Sponge).

- Mostre aos alunos como as cerdas deixam "falhas" e fendas que

simulam a porosidade natural dos tecidos.

#### Passo 2 — A Textura de Couro Poroso

- Abra o arquivo do livro mágico com a cor base (marrom escuro) travada

com Máscara de Recorte.

- Crie uma camada em modo Multiplicação (Multiply).

- Escolha uma cor Café/Vinho escura (#2C120A ). Passe o pincel de giz

suavemente nas quinas do livro. Note a formação de uma textura granulada de camurça.

- Crie uma camada em modo Normal. Escolha um tom areia/mostarda

claro. Passe o pincel de giz nas dobras da lombada do livro para simular o couro desbotado pelo atrito das mãos.

#### Passo 3 — Esculpindo os Arranhões de Batalha O Relevo 3D

- Vá até a lâmina de aço que renderizamos na semana anterior.

- Crie uma nova camada em modo Normal. Selecione o Pincel Redondo

Duro com apenas 2 pixels de tamanho e cor azul-escura.

- Desenhe dois riscos diagonais irregulares cruzando o corpo da lâmina

(a vala do corte).

- Crie uma camada em modo Subexposição Linear (Linear Dodge). Com

a cor branca pura e o mesmo pincel de 2 pixels, desenhe uma linha fina colada exatamente na beirada inferior do risco escuro.

- Aproxime a tela para mostrar à turma como a lâmina parece ter sido

riscada por uma ponta de aço.

#### Passo 4 — Ferrugem e Sujeira com Pincéis de Respingo

- Crie uma camada em modo Sobrepor (Overlay) ou Multiplicação.

- Selecione um pincel de manchas ou respingos (Splatter Brush).

- Escolha um Laranja Queimado para ferrugem (#8B3A0D ).

- Dê apenas duas pinceladas pontuais nas fendas onde o metal encosta

na guarda do cabo.

- Reforce a importância do equilíbrio: mantenha o centro da lâmina limpo

para preservar a legibilidade e evitar o ruído visual.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Forja do Veterano de Guerra Você deve transformar um prop limpo e novo em um artefato que sobreviveu a dezenas de combates, aplicando texturas de materiais porosos e marcas de desgaste narrativo intencional. Checklist do Desafio: Abrir o prop finalizado da semana anterior ou iniciar a pintura de um novo item que contenha couro ou tecido (ex: tomo mágico, bainha de espada ou escudo). Abrir a janela de pincéis (F5 ) e selecionar pincéis texturizados de mídia seca, giz ou esponja. Pintar a porosidade do couro ou tecido utilizando pincéis granulados em modo Multiply, evitando transições perfeitamente limpas.

Adicionar áreas de desbotamento nas bordas e dobras do material usando tons claros com textura. Criar pelo menos 2 arranhões profundos no metal ou na madeira, aplicando a regra de emparelhamento: linha fina de sombra + linha fina de luz na borda inferior. Aplicar sujeira, lodo ou ferrugem em áreas de Oclusão Ambiental (cantos, fendas e parafusos). Aplicar Edge Wear (marcas de pancada e descascamento) nas bordas externas do prop. Avaliar o Ruído Visual: certificar-se de que pelo menos 60% da superfície do objeto permaneceu limpa para não prejudicar a leitura durante o jogo. Salvar o arquivo de produção como Prop_Weathering_SeuNome.psd.'),
('producao-multimidia-ii','modulo-2','semana-11','Semana 11: O Segredo dos Mundos Infinitos: Texturas Seamless e o Filtro Offset',5,'## Semana 11: O Segredo dos Mundos Infinitos: Texturas Seamless e o Filtro Offset Conteúdos integrados: Otimização de Memória, Texturas Contínuas Seamless), A Regra da Potência de 2, Efeito Grid e Filtro Deslocamento Offset.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Imagine que o Diretor de Arte encomendou o chão de terra batida para uma fase de exploração de um jogo de mundo aberto. Se você abrir o Photoshop e criar um arquivo de 20.000 20.000 pixels para desenhar cada grão de areia do mapa, o computador travará, o arquivo pesará gigabytes e o motor do jogo fechará por estouro de memória RAM. Na indústria de games, otimização é tudo. Não desenhamos mundos inteiros; nós desenhamos ladrilhos modulares e texturas que se repetem. A solução para pisos e paredes infinitas é a Textura Seamless ("sem costura"). Trata-se de uma imagem quadrada projetada com rigor matemático: a borda direita conecta-se perfeitamente com a borda esquerda, e o topo conecta-se perfeitamente com a base. Quando o motor gráfico clona essa imagem centenas de vezes lado a lado, o jogador vê um terreno contínuo sem divisões.

A Lei da Potência de 2 (Power of 2): Placas de vídeo processam dados em linguagem binária. Por isso, texturas contínuas devem ter dimensões baseadas em potências de 2 256 256, 512 512, 1024 1024 1K ou 2048 2048 2K pixels. Criar um arquivo aleatório como 500 500 pixels prejudica a otimização de memória da GPU. O Inimigo e o Antídoto: O Efeito Grid: Se você pegar uma foto comum, cortá-la em 512 512 px e repeti-la, verá uma malha feia de linhas duras parecendo um piso de azulejos. Isso quebra a imersão do jogador. O Filtro Deslocamento (Offset): Como os olhos humanos não conseguem prever o encaixe das margens enquanto pintam na borda da tela, usamos o filtro Offset com o recurso Wrap Around (efeito Pac-Man). Ele empurra a imagem exatamente pela metade da tela 256 pixels), trazendo as bordas problemáticas para o centro em forma de uma cruz (+). O artista então cura a cicatriz no centro com o Carimbo (Clone Stamp) ou pincel, sem encostar nas bordas externas. Quando a cruz some no meio, a textura torna-se matematicamente infinita!

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Criação de uma textura contínua de Chão de Terra e Pedras utilizando o Filtro de Deslocamento e validação pelo comando Definir Padrão.

#### Passo 1 — O Canvas na Potência de 2

- Abra o Photoshop e crie um novo arquivo.

- Defina a Largura para 512 e Altura para 512 pixels (potência de 2 .

- Resolução em 72 DPI , modo de cores RGB .

- Preencha o fundo com uma cor Marrom-Terra média (#4A2E18 ).

#### Passo 2 — A Pintura Livre da Textura

- Crie uma nova camada. Pegue um pincel texturizado de giz ou cerdas

secas.

- Pinte manchas mais claras de terra, grãos de areia e pequenas

pedrinhas espalhadas pela tela.

- Pinte com liberdade, deixando pedras e manchas tocarem e vazarem

pelas bordas da tela.

#### Passo 3 — A Mágica do Filtro Deslocamento Offset

- Mescle todas as camadas visíveis em uma só com o atalho Ctrl + E (o

filtro exige uma camada achatada para calcular as bordas).

- Vá ao menu superior: Filtro > Outros > Deslocamento... (Filter > Other

> Offset...).

- Na caixa de diálogo que surgir:

No campo Horizontal, digite exatamente a metade da largura: +256 pixels. No campo Vertical, digite a metade da altura: +256 pixels. Na seção "Áreas Indefinidas", selecione obrigatoriamente a opção Dar a Volta (Wrap Around).

- Clique em OK. Uma grande cicatriz em cruz aparecerá cortando o

centro da tela: são as antigas bordas desconectadas!

#### Passo 4 — A Cirurgia da Cicatriz Central

- Selecione a Ferramenta Carimbo (Clone Stamp, atalho S) ou pegue o

seu pincel de textura de terra.

- Pinte cuidadosamente por cima das linhas retas da cruz central,

misturando e borrando os grãos de areia para apagar a emenda.

- A REGRA DE OURO Não encoste o pincel nas bordas externas do

Canvas. Pinte estritamente no miolo. Se você tocar nas bordas externas agora, quebrará a matemática que o Photoshop calculou.

#### Passo 5 — O Teste de Fogo O Chão Infinito)

- Quando a cruz do meio desaparecer, vá ao menu: Editar > Definir

Padrão... (Edit > Define Pattern...). Nomeie como Terra_Seamless_512 e dê OK.

- Crie um novo documento no Photoshop com 2048 x 2048 pixels .

- Vá em Editar > Preencher... (Edit > Fill...), escolha a opção Padrão

(Pattern) e selecione a textura de terra criada.

- Clique em OK. Mostre para a turma o chão preenchendo a tela inteira

sem nenhuma linha divisória ou emenda visível.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** O Tecelão de Superfícies Infinitas Você assumirá o posto de Environment Artist Artista de Cenário). Sua missão técnica é forjar um bloco de textura contínua de solo natural (terra batida, areia ou cascalho) de 512 512 pixels e provar que ele se repete sem costuras. Checklist do Desafio: Criar um documento quadrado no Photoshop de exatos 512 x 512 pixels a 72 DPI (respeitando a Potência de 2. Pintar a camada base com a cor dominante do solo e adicionar variações com pincéis texturizados. Achatar a imagem com o atalho Ctrl + E para garantir uma camada única. Acessar Filtro > Outros > Deslocamento... e configurar os eixos Horizontal e Vertical para +256 px com a opção Dar a Volta ativada. Localizar a cicatriz em forma de cruz no centro do monitor. Utilizar o Carimbo (S ) e pincéis de textura para misturar e eliminar a emenda central. Cumprir a regra de segurança: não encostar o pincel nas margens externas da tela durante a correção. Criar o padrão técnico acessando Editar > Definir Padrão. Criar uma tela grande de teste de 2048 x 2048 pixels e preencher com o padrão via Editar > Preencher. Inspecionar a tela grande: garantir que não há repetições geométricas evidentes Efeito Grid). Salvar o bloco original como Textura_Solo_Seamless_SeuNome.psd.'),
('producao-multimidia-ii','modulo-2','semana-12','Semana 12: Prática de Texturas: Da Grama Orgânica às Fissuras Áridas (Padrão Voronoi)',6,'## Semana 12: Prática de Texturas: Da Grama Orgânica às Fissuras Áridas (Padrão Voronoi) Conteúdos integrados: Pintura de Grama em Tufos, Padrão Voronoi Chão Rachado e Pedras), Offset de Linhas Duras e Relevo de Pisos.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Na semana anterior, aprendemos a técnica do Offset em uma textura de terra. Esconder as emendas na terra é relativamente simples, pois a areia é macia e desordenada. No entanto, a complexidade aumenta quando precisamos pintar superfícies com estruturas geométricas sólidas: pisos de pedras de calçamento (cobblestones) ou terrenos áridos de deserto cheios de fendas. Se a rachadura de uma rocha do lado direito não encontrar exatamente a continuação da rachadura do lado esquerdo, a textura quebra a ilusão de solidez e denuncia a grade. A Matemática da Terra Rachada Padrão Voronoi): Se observarmos uma poça de lama seca ou um casco de tartaruga, notaremos que a natureza não racha em linhas paralelas. Ela segue o Padrão Voronoi: uma teia de polígonos irregulares (com 4, 5 ou 6 lados) que se encaixam como um quebra-cabeça. Para pintar texturas sólidas com sucesso:

- O Trabalho de Encanador: Desenhamos a teia de linhas escuras (as

rachaduras). Ao aplicar o Offset, essas rachaduras serão cortadas no centro. O trabalho do artista aqui não é "borrar" a emenda com o Carimbo, mas sim reconectar os fios: redesenhar a linha da fenda fechando os polígonos que ficaram partidos no meio da tela.

- Relevo 3D de Pisos: Para que a terra seca não pareça um desenho plano,

adicionamos volume: a borda da pedra virada para o sol recebe uma linha fina e brilhante em modo Screen, enquanto a borda inferior que mergulha na fenda recebe uma sombra dura em modo Multiply. A pedra salta da tela.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Pintura de uma textura contínua de Terreno Árido com Rachaduras Padrão Voronoi) e escultura de relevo chanfrado.

#### Passo 1 — A Teia de Rachaduras Padrão Voronoi)

- Crie um Canvas de 512 x 512 pixels a 72 DPI . Preencha o fundo com

Amarelo-Areia queimado (#C29B62 ).

- Crie uma nova camada chamada Rachaduras .

- Pressione B e selecione o Pincel Redondo Duro com tamanho fino

(entre 3 e 4 pixels) e cor Marrom Escuro Profundo (#24150A ).

- Desenhe linhas conectadas formando polígonos irregulares de

tamanhos variados pela tela inteira. Deixe as linhas cruzarem e vazarem pelas beiradas da tela livremente.

#### Passo 2 — O Offset e a Conexão de Fios

- Mescle a camada das rachaduras com a cor do chão com o atalho Ctrl

+ E.

- Acesse Filtro > Outros > Deslocamento... e insira +256 na Horizontal e

+256 na Vertical, com Dar a Volta ativado.

- Aponte no projetor a cruz central: as linhas das rachaduras aparecem

partidas ao meio.

- Pegue o mesmo pincel fino 3 px com a cor marrom escura e

redesenhe as ligações, fechando as pontas soltas das fendas até que nenhum polígono fique cortado. A malha de rachaduras está agora contínua.

#### Passo 3 — Esculpindo o Volume da Seca Chanfros de Luz)

- Crie uma nova camada acima da textura em modo Divisão (Screen)

com opacidade em 70%.

- Selecione uma cor Amarelo Claro/Areia (#FFF1C7 ).

- Diminua o pincel para 2 pixels.

- Desenhe uma linha clara fina colada na borda superior de cada

rachadura escura.

- Demonstre aos alunos o efeito de relevo: a linha clara simula a quina da

terra recebendo a luz do sol antes de o terreno cair na sombra da fenda.

#### Passo 4 — Validação do Padrão em Grande Escala

- Acesse Editar > Definir Padrão, salvando como Chao_Arido_Seamless .

- Abra um documento de 2048 x 2048 pixels e aplique o preenchimento

com o novo padrão.

- Comprove que as fendas se conectam em todas as direções sem

quebras visuais.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** O Arquiteto da Topografia Você deve construir uma textura contínua avançada de superfície geométrica ou sólida: ou um chão árido com o Padrão Voronoi de rachaduras, ou uma parede/piso de pedras de calçamento medieval com relevo tridimensional. Checklist do Desafio: Criar o Canvas quadrado padrão de 512 x 512 pixels a 72 DPI no Photoshop. Preencher a cor de fundo representando a matéria-prima base (areia do deserto ou argamassa cinza). Desenhar a malha de fissuras estruturadas usando o Padrão Voronoi (polígonos fechados) com Pincel Duro fino. Achatar a imagem (Ctrl + E ) e executar o filtro Deslocamento em +256 nos dois eixos. Agir como o "encanador digital": reconectar manualmente as pontas das linhas partidas na cruz central. Adicionar camadas de iluminação em modo Screen e aplicar o chanfro de luz (linha clara fina) nas bordas superiores das rochas para criar relevo físico. Registrar o arquivo como padrão contínuo em Editar > Definir Padrão. Validar a textura preenchendo um documento grande de 2048 x 2048 pixels. Confirmar que não há pedras cortadas ao meio ou emendas em cruz visíveis. Salvar o bloco original como Textura_Pedras_Voronoi_SeuNome.psd.'),
('producao-multimidia-ii','modulo-2','semana-13','Semana 13: Pipeline Técnico de Exportação: Trim, Canal Alpha e Otimização para Engine',7,'## Semana 13: Pipeline Técnico de Exportação: Trim, Canal Alpha e Otimização para Engine Conteúdos integrados: A Ponte Arte-Programação, Canal Alpha, Formato.PNG, Otimização por Trim Aparar, Nomenclatura snake_case e Automação de Assets.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Você pode ter passado semanas pintando o item mais detalhado e esteticamente rico no Photoshop, mas se esse asset não estiver empacotado de acordo com as regras técnicas da programação, ele não poderá ser usado no jogo. Na Produção Multimídia, a Exportação Técnica é a ponte entre o departamento de arte e os desenvolvedores que operam o motor de jogo (engine, como Unity ou Unreal). O motor de jogo não consegue ler um arquivo.PSD pesado com 50 camadas, filtros e modos de mesclagem durante a execução da partida. O jogo precisa de assets leves e achatados. Nesta etapa, três regras técnicas são fundamentais:

- O Canal Alpha e o Formato .PNG Imagens comuns (.JPG) não têm

transparência e chegam ao jogo presas em um bloco branco sólido. O formato.PNG é o padrão definitivo da indústria 2D porque suporta o Canal Alpha (o quarto canal da imagem, que guarda 256 níveis de opacidade), garantindo que apenas o prop apareça na tela.

- Otimização por Trim Aparar Pixels Transparentes): Se você desenhar

uma poção minúscula de 100 pixels no meio de uma tela gigante de 2000 2000 pixels e exportar, o motor do jogo terá que gastar processamento lendo uma área transparente desnecessária. Além disso, a caixa de colisão (hitbox) do item ficará descalibrada. O comando Aparar (Trim) elimina o espaço vazio até o limite exato da pintura.

- Padrão de Nomenclatura e Modo de Cores: Arquivos exportados para telas

devem estar sempre em modo RGB (o modo CMYK é exclusivo para impressão física e gera erros de renderização em motores gráficos). O nome deve seguir rigorosamente a convenção snake_case (ex: prop_espada_aco_veterano.png ), sem letras maiúsculas, espaços ou acentos.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Isolamento, corte cirúrgico com Trim e exportação otimizada de um pacote de 3 assets com automação via Adobe Generator.

#### Passo 1 — Limpeza e Isolamento do Fundo

- Abra o arquivo da espada renderizada com todas as camadas de luz e

sombra.

- No painel de Camadas, desligue a visualização (clicando no ícone do

"olho") da camada Background_Neutro.

- Verifique se o fundo exibe o padrão xadrez cinza e branco (indicativo

universal de transparência / Canal Alpha).

#### Passo 2 — A Cirurgia de Desperdício Comando Trim / Aparar)

- Observe o espaço vazio transparente ao redor da espada.

- Vá ao menu superior: Imagem > Aparar... (Image > Trim...).

- Na janela de opções:

Selecione a opção Com base em: Pixels Transparentes (Based on: Transparent Pixels). Certifique-se de que as 4 caixas Superior, Inferior, Esquerda, Direita) estão marcadas.

- Clique em OK.

- Demonstre como o Photoshop recorta a tela, deixando as margens

encostadas no limite da arte, eliminando o desperdício de memória de textura.

#### Passo 3 — A Exportação Manual Rápida

- Vá em Arquivo > Exportar > Exportação Rápida como PNG (File >

Export > Quick Export as PNG).

- Crie uma pasta chamada Assets_Exportados_Final .

- Salve o arquivo aplicando a nomenclatura técnica:

prop_espada_aco_corte.png.

#### Passo 4 — Automação com Adobe Generator O Truque dos Estúdios)

- Volte ao Photoshop e dê Ctrl + Z para recuperar o arquivo aberto.

- Agrupe as camadas da espada em uma pasta Ctrl + G .

- Renomeie esse grupo de camadas digitando a extensão no final:

prop_arma_espada.png.

- Vá ao menu Arquivo > Gerar > Assets de Imagem (File > Generate >

Image Assets).

- Abra a pasta do seu computador onde o arquivo .PSD está salvo:

mostre aos alunos que o Photoshop gerou uma subpasta

automaticamente e salvou o PNG recortado lá dentro. Qualquer alteração feita no desenho agora é atualizada no arquivo final em tempo real!

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Entrega Final do Asset Pack Você é o artista responsável por preparar o pacote final de arte do Módulo 2 para a equipe de desenvolvimento. Sua missão é limpar, isolar, otimizar com o comando Trim e exportar seu pacote com três assets concluídos, prontos para importação em uma engine de jogos. Checklist do Desafio: Abrir os arquivos mestres (.PSD) criados ao longo do Módulo 2. Selecionar 3 assets finalizados para a entrega técnica: Asset 01 Um prop metálico ou arma (ex: espada ou machado). Asset 02 Um prop de poção mágica ou livro de couro. Asset 03 Uma textura contínua (solo de terra ou pedras Voronoi). Garantir que o modo de cor de todos os arquivos está configurado em RGB (Imagem > Modo > Cores RGB ). Ocultar ou apagar as camadas de plano de fundo cinza, ativando a transparência total Canal Alpha) nos dois props. Aplicar o comando Imagem > Aparar (baseado em Pixels Transparentes) nos props para eliminar bordas vazias. Criar no computador a pasta de entrega: Entrega_Modulo2_SeuNome. Exportar os assets como arquivos.PNG limpos. Aplicar rigorosamente a convenção de nomenclatura da indústria (snake_case ): prop_arma_espada_veterano.png prop_pocao_cura_frasco.png tex_chao_pedras_seamless.png

Inspecionar as imagens salvas na pasta: verificar se os props possuem fundo transparente perfeito e se a textura manteve as dimensões exatas de 512 512 pixels.'),
('producao-multimidia-ii','modulo-3','semana-14','Semana 14: A Arte da Narrativa Visual e o Cenário que Conta Histórias',1,'## Semana 14: A Arte da Narrativa Visual e o Cenário que Conta Histórias Conteúdos integrados: Princípio do "Show, Don''t Tell", Iluminação Narrativa, Storytelling Ambiental, Mise-en-scène e Thumbnail de Cenário com a Regra dos Terços.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Se quiser informar o jogador de que um vilão é perigoso, colocar um balão de texto na tela dizendo "Cuidado, ele é cruel" quebra a imersão da jogabilidade. Na indústria de jogos e no cinema, a regra máxima é "Mostre, não conte" (Show, don''t tell). O Storytelling Visual consiste em utilizar a luz, as cores, os enquadramentos e o estado dos objetos para transmitir o passado, o presente e o futuro da narrativa sem que o jogador precise ler uma única palavra. Nesse ecossistema, o cenário deixa de ser um fundo inerte para atuar como testemunha dos acontecimentos através do Storytelling Ambiental (Environmental Storytelling): Mise-en-scène Colocação em Cena): Cada adereço (prop) inserido no espaço deve possuir uma razão dramática. Um baú quebrado, uma caneca caída e marcas de garras no chão funcionam como pistas de uma cena de crime. Interrupção de Rotina: A forma mais eficiente de criar tensão imediata é mostrar uma atividade comum interrompida de forma abrupta (ex: comida ainda quente sobre a mesa com cadeiras tombadas e uma porta arrombada).

Macro vs. Micro Narrativa: A Macro Narrativa explica o estado global do mundo (uma estátua decapitada na praça revela uma revolução passada), enquanto a Micro Narrativa foca dramas individuais e íntimos (dois esqueletos abraçados sob os escombros humanizam a tragédia). A Iluminação como Guia: A luz atua como um holofote invisível, direcionando o olhar do jogador para itens fundamentais por meio do contraste máximo, enquanto sombras densas (Low Key Lighting) constroem mistério e perigo. Para testar essas ideias de composição antes de gastar horas renderizando texturas, utilizamos o Thumbnail Sketch: rascunhos em miniatura feitos em preto, cinza e branco para validar a iluminação e as massas principais com o apoio da Regra dos Terços.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Rascunho rápido em Thumbnail de um Acampamento Abandonado às Pressas, estruturado na Regra dos Terços e validado pelo Teste do Olhar (Squint Test).

#### Passo 1 — A Prancheta e a Grade de Composição

- Abra o Adobe Photoshop e crie um Canvas no formato 1920 x 1080 px ,

72 DPI, fundo Branco.

- Crie uma nova camada chamada Thumbnail_Cenario .

- Com a Ferramenta Retângulo (U), desenhe uma caixa no centro da tela

medindo cerca de 600 x 340 px (proporção 16 9 em miniatura). Preencha-a com um Cinza Médio (#7A7A7A ) para simular a penumbra noturna.

- Pressione Ctrl + R para ativar as réguas. Puxe duas linhas-guia

horizontais e duas verticais para dividir o retângulo em 9 partes iguais, demarcando a Regra dos Terços.

#### Passo 2 — As Massas e as Silhuetas do Palco Preto Sólido)

- Pressione B Pincel Redondo Duro, 100% de opacidade e cor Preta).

Afaste o zoom com Ctrl + Menos.

- Desenhe as massas estruturais do ambiente: nas laterais, pinte

silhuetas triangulares simulando barracas de acampamento.

- No fundo, trace blocos verticais irregulares representando a barreira

densa da floresta.

#### Passo 3 — O Foco de Luz Narrativo O Holofote Invisível)

- Mude a cor do pincel para Branco Puro (#FFFFFF ).

- Posicione o cursor exatamente sobre a interseção inferior direita da

Regra dos Terços.

- Dê algumas pinceladas rápidas simulando as brasas de uma fogueira e

o chão iluminado por ela. Explique aos alunos que o maior contraste (o ponto mais branco cercado pelo cinza escuro) atua como um ímã visual para o jogador.

#### Passo 4 — A Micro Narrativa da Fuga Interrupção de Rotina)

- Reduza o tamanho do pincel e volte para a cor Preta.

- Ao lado da fogueira, desenhe a silhueta de um tronco de árvore

tombado (o banco onde estavam sentados).

- Desenhe uma mochila aberta com pequenos traços cinzas espalhando-

se em direção à escuridão da floresta.

- A composição conta que alguém estava ali e fugiu em pânico para a

mata ao ser surpreendido.

#### Passo 5 — O Teste do Olhar Squint Test)

- Peça à turma para semicerar os olhos (Squint Test) olhando para a

projeção.

- Mostre que, mesmo com a visão borrada, a fogueira branca permanece

como ponto focal absoluto e as massas escuras delimitam o perigo.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Cena do Crime Visual Você deve assumir o papel de Artista de Cenário e planejar um ambiente que conte uma história de sobrevivência ou mistério sem recorrer a textos, utilizando composição em tons de cinza, a Regra dos Terços e marcas narrativas de ação. Checklist do Desafio:

Criar um documento no Photoshop no tamanho 1920 x 1080 px a 72 DPI. Desenhar um retângulo de Thumbnail de proporção 16 9 no centro da tela preenchido com cinza-médio. Puxar linhas-guia com Ctrl + R para mapear os quatro pontos de interseção da Regra dos Terços. Escolher um dos seguintes roteiros narrativos: Roteiro A O Posto Médico Abandonado durante um ataque de criaturas. Roteiro B A Forja Medieval saqueada por mercenários. Roteiro C A Cabine de Navegação Espacial onde um tripulante sabotou o sistema. Pintar as grandes massas (paredes, saídas, arquitetura) em preto sólido com o Pincel Duro (B ). Posicionar o ponto focal de maior contraste de luz (branco puro) em uma das interseções da Regra dos Terços. Inserir pelo menos dois indícios claros de Interrupção de Rotina (ex: copos quebrados, ferramentas no chão, móveis virados como barricada). Adicionar Marcas de Ação (arranhões, manchas ou impactos) apontando a direção da fuga ou do perigo. Aplicar o Squint Test: semicerar os olhos a 1 metro da tela e certificar-se de que a leitura de iluminação continua imediata. Salvar o arquivo de estudo como Storytelling_Thumbnail_SeuNome.psd.'),
('producao-multimidia-ii','modulo-3','semana-15','Semana 15: Setup de Cutscenes, Formato 16:9 e a Arte da Decupagem',2,'## Semana 15: Setup de Cutscenes, Formato 16:9 e a Arte da Decupagem Conteúdos integrados: Proporção Widescreen 16 9, Pranchetas Artboards) no Photoshop, Leitura de Roteiro e Decupagem Técnica Découpage).

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

A arte de um jogo nunca existe de maneira abstrata; ela vive dentro de limites físicos de monitores, televisores e dispositivos móveis. O padrão universal

adotado pela indústria é a proporção Widescreen 16 9 (para cada 16 unidades de largura, há 9 de altura), traduzida na resolução padrão Full HD 1920 1080 pixels a 72 DPI, aproximando-se do campo de visão humano. Quando o roteirista entrega um roteiro de uma cena cinematográfica de jogo (Cutscene), o artista principiante tenta desenhar tudo o que está escrito em um único quadro. Se o texto diz "O cavaleiro exausto entra na caverna e nota que o monstro acordou", desenhar o cavaleiro inteiro, a caverna inteira e o monstro inteiro gera uma imagem confusa, poluída e desprovida de emoção dramática. O artista profissional utiliza a Decupagem (Découpage): Decupar significa "recortar" o texto em fatias visuais lógicas. Para cada frase, o diretor de arte faz a pergunta-chave: "Qual é a ação ou emoção mais importante deste segundo?". Economia Visual: Em vez de desenhar a cena toda, fracionamos o acontecimento: Cena 1 A Exaustão): Um Close-up na bota rasgada do herói arrastando no chão rochoso. Cena 2 O Choque): A câmera corta para os olhos arregalados do protagonista com a pupila dilatada. Cena 3 A Ameaça): Uma visão por cima do ombro (Over the Shoulder) mostrando o herói pequeno em primeiro plano diante de um olho gigantesco se abrindo na escuridão ao fundo. Para gerenciar essa sequência dentro do mesmo arquivo.PSD sem misturar camadas, utilizamos as Pranchetas (Artboards) do Photoshop, permitindo a comparação visual de continuidade entre as cenas.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Configuração de uma sequência de Cutscene com 3 Artboards em 16 9 e decupagem visual do texto de roteiro.

#### Passo 1 — Criando o Documento Base com Pranchetas

- No Photoshop, clique em Criar Novo (Create New).

- Defina a Largura para 1920 e Altura para 1080 pixels, resolução de 72

DPI, modo de cores RGB.

- O Ponto Crítico: Marque a caixa de seleção Pranchetas (Artboards).

- Clique em Criar. O Canvas surgirá identificado como "Prancheta 1".

#### Passo 2 — Multiplicando o Palco de Cinema

- Pressione a tecla V (ferramenta Mover). Clique e segure para

selecionar a Ferramenta Prancheta (Artboard Tool).

- Observe que ícones de soma (+) surgem nas quatro extremidades da

prancheta.

- Clique no ícone + à direita duas vezes para gerar mais duas pranchetas

perfeitamente alinhadas.

- No painel de Camadas, aplique a Nomenclatura Progressiva: renomeie

os grupos para 01_Cena_Botas, 02_Cena_Olhar e 03_Cena_Monstro.

#### Passo 3 — Decupando o Roteiro Desenho das Cenas)

- Selecione a Prancheta 01_Cena_Botas . Pressione B Pincel Duro preto).

- Desenhe o plano de detalhe (Close-up): a bota de ferro gasta

arrastando no chão rochoso, ignorando o resto do corpo do herói.

- Mude para a Prancheta 02_Cena_Olhar . Desenhe um plano fechado

contendo apenas o contorno do elmo e os olhos arregalados do guerreiro, recebendo um brilho que vem de fora do quadro.

- Mude para a Prancheta 03_Cena_Monstro . Desenhe o herói de costas na

lateral esquerda (plano Over the Shoulder) e uma silhueta monumental de garras se erguendo na penumbra ao fundo.

#### Passo 4 — Avaliação do Fluxo Narrativo

- Afaste o zoom com Ctrl + Menos.

- Mostre para a turma como as três pranchetas operam juntas: a história

agora possui ritmo cinematográfico, guiando os olhos do espectador do detalhe para a ameaça global com economia de traço.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Decupagem do Roteiro de Jogo Você recebeu o roteiro da introdução de uma fase de combate. Sua missão técnica é configurar um ambiente de trabalho com pranchetas em proporção

cinematográfica 16 9 e decupar o parágrafo dramático em uma sequência lógica de três quadros visuais distintos. Checklist do Desafio: Criar um documento novo no Photoshop marcando obrigatoriamente a opção de Pranchetas Artboards). Configurar cada prancheta na resolução Full HD (1920 x 1080 px a 72 DPI ) em orientação horizontal. Utilizar a ferramenta Prancheta (V ) para estruturar 3 pranchetas alinhadas horizontalmente na tela. Renomear os grupos de camadas respeitando a nomenclatura progressiva (01_Apresentacao, 02_Reacao, 03_Climax ). Ler o roteiro da missão: "O piloto espacial cai com a nave em um planeta tóxico, quebra o vidro do capacete e vê criaturas se aproximando pela neblina". Quadro 1 Foco no Impacto): Decupar com plano de detalhe da cabine destruída ou do alarme piscando. Quadro 2 Foco na Emoção): Decupar com plano fechado no rosto em pânico através da rachadura do visor. Quadro 3 Foco na Ameaça): Decupar com plano médio ou aberto revelando as sombras das criaturas na neblina. Trabalhar com desenhos estruturais em preto e branco com foco em clareza de ação, sem detalhar texturas finas. Salvar o arquivo de produção como Decupagem_Cutscene_SeuNome.psd.'),
('producao-multimidia-ii','modulo-3','semana-16','Semana 16: Movimento de Câmera, Setas Técnicas e Continuidade Visual',3,'## Semana 16: Movimento de Câmera, Setas Técnicas e Continuidade Visual Conteúdos integrados: Vocabulário de Câmera Pan, Tilt, Zoom In/Out), Código de Cores de Setas, Linhas de Velocidade e Continuidade de Tela.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Um quadro de Storyboard é um desenho estático, mas a câmera virtual do jogo precisa se mover: ela desce revelando uma torre, persegue o protagonista em fuga ou foca repentinamente na face do oponente. Se o artista desenhar um quadro novo para cada centímetro que a câmera se desloca, precisará de milhares de desenhos para uma cena de cinco segundos. Para evitar isso, a indústria adota o Vocabulário de Câmera e um sistema padronizado de marcações visuais com setas flutuantes. Os três eixos universais de câmera em motores de jogo (Unity e Unreal) são: Pan Panorâmica): Movimento horizontal sobre o eixo (a câmera olha para a esquerda ou direita, como quem diz "não"). Usado para varrer cenários ou acompanhar perseguições laterais. Tilt: Movimento vertical sobre o eixo (a câmera olha para cima ou para baixo, como quem diz "sim"). Usado para enfatizar a imponência e altura de construções ou chefões. Zoom In / Out): O Zoom In aproxima a lente para intensificar reações dramáticas; o Zoom Out afasta para revelar a vastidão e o desamparo do personagem no ambiente. O Código de Cores das Setas: Para que a equipe de programação e animação 3D não confunda a movimentação da câmera com a corrida física do personagem, existe uma convenção obrigatória: Setas Vermelhas (ou com traçado duplo): Indicam exclusivamente o movimento da lente da Câmera. Setas Azuis ou Verdes: Indicam exclusivamente a movimentação dos Atores ou Objetos dentro do cenário. A Regra da Continuidade de Tela: Se no Quadro 1 o herói está correndo da esquerda para a direita, ele deve obrigatoriamente continuar correndo da esquerda para a direita no Quadro 2. Inverter repentinamente a direção da corrida entre dois quadros desorienta o cérebro do jogador, transmitindo a ilusão de que o personagem desistiu e está regressando.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Criação de um Storyboard para a Apresentação de um Chefão (Boss Reveal), aplicando Pan, Zoom In e a diferenciação de setas vermelhas e azuis.

#### Passo 1 — A Prancheta e a Ação do Personagem Seta Azul)

- Abra o arquivo com os Artboards 16 9 no Photoshop.

- No primeiro Artboard, desenhe com pincel preto o portão arrombado da

masmorra e a silhueta em blocos de um Orc monumental avançando.

- Crie uma nova camada chamada Acao_Personagem .

- Selecione uma cor Azul Puro (#0055FF ).

- Desenhe uma seta curva grossa partindo dos pés do monstro e

apontando para frente (em direção ao chão da câmera), sinalizando aos animadores que a criatura está caminhando adiante.

#### Passo 2 — O Zoom In Dramático Setas Vermelhas de Câmera)

- No segundo Artboard, desenhe o tronco e a cabeça rugindo do Orc no

mesmo enquadramento.

- Crie uma nova camada chamada Movimento_Camera .

- Selecione uma cor Vermelha Vibrante (#FF0000 ).

- Desenhe um retângulo vermelho menor contornando apenas a boca

aberta e os olhos do monstro (a área alvo).

- A partir dos quatro cantos da prancheta externa, desenhe quatro setas

vermelhas grossas apontando para dentro desse retângulo menor. Isso documenta tecnicamente uma aproximação veloz de câmera (Fast Zoom In) no momento do rugido.

#### Passo 3 — A Reação e as Linhas de Velocidade Speed Lines)

- No terceiro Artboard, desenhe o herói de corpo inteiro sendo

empurrado pelo deslocamento de ar do rugido.

- Pressione B (pincel preto duro fino de 3 px).

- Trace Linhas de Velocidade (Speed Lines): riscos retos paralelos

partindo das bordas da prancheta em direção ao peito do herói, simulando a força cinética do impacto sonoro.

#### Passo 4 — Validação da Linguagem Técnica

- Revise com os estudantes: quem lê esse storyboard entende

imediatamente o que o ator está fazendo (seta azul) e o que a câmera virtual deve executar no motor gráfico (seta vermelha).

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Coreografia de Câmera Você assumirá o posto de Diretor de Câmera da cinemática de um jogo de ação. Sua missão é estruturar um storyboard de três quadros documentando a fuga de um personagem sobre um abismo, aplicando o vocabulário oficial de movimentos de lente e o código de cores técnico de setas. Checklist do Desafio: Abrir um documento no Photoshop contendo 3 Pranchetas em formato 16 9 (1920 x 1080 px a 72 DPI ). Garantir o princípio da Continuidade Visual: o personagem deve manter a mesma direção de progressão de tela (da esquerda para a direita) ao longo de toda a sequência. Quadro 1 A Corrida): Desenhar o personagem correndo inclinado em direção à beirada de uma plataforma. Inserir uma seta Azul ou Verde indicando a trajetória de corrida do personagem. Quadro 2 O Salto no Vazio): Desenhar o personagem em pleno voo com braços e pernas estendidos sobre o abismo. Inserir Linhas de Velocidade (Speed Lines) atrás do tronco para registrar o movimento no ar. Inserir setas Vermelhas nas margens superior e inferior indicando que a câmera executa um Pan para a Direita acompanhando o salto. Quadro 3 O Pouso com Impacto): Desenhar o personagem aterrissando na borda oposta com os joelhos flexionados e marcas de fumaça de impacto. Inserir marcação com caixa vermelha central e setas apontadas para dentro sinalizando um Zoom In dramático no ponto de aterrissagem.

Manter os desenhos focados em manequins de palito articulados e blocos limpos, priorizando a clareza funcional. Salvar o documento como Camera_Direcao_SeuNome.psd.'),
('producao-multimidia-ii','modulo-3','semana-17','Semana 17: Dinamismo Extremo: A Física do Desequilíbrio, Smear e a Cena de Combate',4,'## Semana 17: Dinamismo Extremo: A Física do Desequilíbrio, Smear e a Cena de Combate Conteúdos integrados: Pushing the Pose, Linhas de Ação e Cinéticas, Efeito Smear Deformação Intencional), Linha Ativa vs. Reativa e Hit Frame.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

O erro fatal ao desenhar cenas de combate em jogos de ação é construir personagens com os pés firmes no solo, coluna ereta e punhos esticados de forma comportada. O resultado é um golpe sem força que parece plástico e encenado. Na animação e na arte de combate, a regra fundamental é: desenhar ação é desenhar o desequilíbrio. Para transmitir velocidade e potência visceral: A Física do Desequilíbrio: Um corpo estático possui seu centro de gravidade perfeitamente equilibrado entre os apoios dos pés. Para correr ou bater, o corpo precisa projetar o centro de gravidade para fora da base, parecendo que cairá no instante seguinte se o movimento for congelado. Pushing the Pose Forçar a Pose): A anatomia realista é insuficiente para a expressividade dos jogos. Exageramos a curvatura da coluna em arcos extremos de "C" ou "S", distorcendo torções corporais para ampliar a tensão. Smear Frame Quadro Borrado): Quando um golpe ocorre a 60 FPS, a lâmina da espada ou o punho cruza a tela em 1 ou 2 quadros. Para evitar que o movimento pareça "teletransportado", o artista deforma o membro desenhando-o esticado como uma lâmina curva ou rastro elástico no ar. O Contraste da Batalha Linha Ativa vs. Linha Reativa): A força de um golpe não é demonstrada por quem bate, mas sim por quem apanha. O atacante deve possuir uma Linha Ativa (coluna inclinada e ofensiva projetando-se para a frente), enquanto o defensor deve exibir uma Linha

Reativa (coluna dobrada violentamente para trás, perdendo o chão), definindo o Hit Frame Quadro de Impacto). O artista deve reservar o Espaço Negativo entre os lutadores: se os corpos se misturarem em uma massa indistinta de membros sobrepostos, a silhueta da cena perde a legibilidade.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Construção de um Hit Frame completo entre o Herói e um Monstro utilizando o efeito Smear, linhas cinéticas e espaço negativo limpo.

#### Passo 1 — A Linha Ativa do Atacante Pushing the Pose)

- No Photoshop, crie um Artboard 16 9 (1920 x 1080 px ) com fundo cinza-

claro.

- No quadrante esquerdo da tela, utilize o Pincel Duro preto para

desenhar o Herói atacando.

- Curve a coluna em um "C" ofensivo agressivo projetado para a frente.

- Desenhe o pé de trás levantado do solo, indicando que todo o peso

corporal foi lançado no golpe.

- Estique o braço direito para a frente, atravessando a prancheta na

horizontal.

#### Passo 2 — O Defensor e a Linha Reativa O Impacto)

- No quadrante direito, desenhe o inimigo recebendo o impacto.

- Regra de Segurança: Não encoste o tronco do defensor no tronco do

herói; mantenha o Espaço Negativo de ar limpo para que a extensão do braço seja vista.

- Desenhe a espinha dorsal do oponente vergada violentamente para trás

em forma de arco inverso.

- Posicione a cabeça do inimigo projetada para trás e os pés sendo

arrancados do piso pela força do soco.

#### Passo 3 — A Mágica do Efeito Smear Borrão Elástico)

- Observe o punho do herói que atinge o queixo do monstro.

- Apague o punho anatômico pequeno com a Borracha (E).

- Redesenhe o punho de forma exagerada, desenhando uma forma

ovalada esticada e borrada que ocupa o dobro do volume anatômico normal, deformando a mandíbula do monstro.

#### Passo 4 — Efeitos Visuais VFX) e Linhas Cinéticas

- Crie uma nova camada chamada VFX_Impacto .

- No ponto exato de colisão (punho e mandíbula), desenhe uma explosão

pontiaguda de linhas brancas e pretas (o Hit Flash gráfico).

- Puxe três Linhas Cinéticas grossas e retas acompanhando o trajeto do

braço do herói, afunilando em direção ao ponto de impacto.

- Adicione riscos de poeira e gotas voando na mesma direção do golpe.

A cena parada ganha força sonora e peso visual.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Forja do Golpe Sísmico Você deve conceber a cena máxima de combate de um jogo de ação, construindo o Hit Frame perfeito através do contraste entre o atacante e o defensor, aplicando deformação de Smear e garantindo espaço negativo para a leitura imediata da silhueta. Checklist do Desafio: Criar um documento com Prancheta 16 9 (1920 x 1080 px a 72 DPI ) no Photoshop. Escolher a natureza do confronto (ex: guerreiro de espada contra cavaleiro negro, ou lutador corpo a corpo contra ciborgue). Desenho do Atacante Linha Ativa): Construir o atacante com o centro de gravidade completamente deslocado à frente (em desequilíbrio dinâmico). Aplicar o Pushing the Pose: exagerar a torção da coluna e a extensão dos membros de ataque. Desenho do Defensor Linha Reativa):

Construir o defensor com a espinha quebrada/curvada na direção oposta ao golpe. Demonstrar a perda de equilíbrio: os pés não devem estar assentados estavelmente no solo. Espaço Negativo: Preservar áreas abertas de fundo entre os personagens, evitando que se fundam em um bloco confuso. Efeito Smear: Deformar ou esticar intencionalmente a arma ou o membro de ataque no ponto de conexão para simular velocidade máxima. VFX de Combate: Adicionar linhas cinéticas direcionais e marcações gráficas de explosão/fumaça no ponto do impacto. Salvar o documento técnico como Cena_Batalha_HitFrame_SeuNome.psd.'),
('producao-multimidia-ii','modulo-3','semana-18','Semana 18: Pacing, Tensão Psicológica e o Ângulo Holandês (Dutch Angle)',5,'## Semana 18: Pacing, Tensão Psicológica e o Ângulo Holandês (Dutch Angle) Conteúdos integrados: Pacing Cadência Visual), Alternância de Planos Wide Shot vs. Close-up), Claustrofobia Visual, A Regra do Oculto e Ângulo Holandês Dutch Tilt).

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Se um jogo apresentar explosões, perseguições e socos ininterruptos do primeiro ao último minuto, o jogador ficará exausto e insensível à ação. O excesso contínuo gera tédio. Para que um momento de impacto funcione, ele deve ser precedido por um período calculado de tensão. Esse controle da velocidade emocional da narrativa é o Pacing Cadência Visual). O diretor de arte controla o batimento cardíaco de quem joga através do ar que deixa dentro do enquadramento: Plano Aberto (Wide Shot): A câmera fica distante e o herói ocupa uma pequena fração da tela. Como o jogador visualiza todo o ambiente, o cérebro entende que nada pode atacá-lo de surpresa; há espaço de fuga. O ritmo desacelera e o jogador relaxa. Plano Fechado (Close-up e Extreme Close-up): A câmera avança agressivamente e enquadra apenas o rosto, os olhos e o suor do

personagem. As bordas da tela cortam a visão do ambiente ao redor, gerando Claustrofobia Visual. O jogador não sabe mais o que está atrás da personagem; o espaço de fuga é eliminado e a frequência cardíaca sobe. A Regra do Oculto: O medo real nasce do desconhecido. Em cenas de suspense (como em Resident Evil ou Silent Hill), nunca desenhamos a ameaça inteira logo no início. Mostramos apenas uma sombra distorcida na parede, uma poça d''água pingando ou um par de olhos na fresta. A imaginação humana preenche as lacunas com seus próprios medos. O Ângulo Holandês (Dutch Angle / Dutch Tilt): Em situações normais, desenhamos a linha do horizonte reta e paralela ao chão, transmitindo estabilidade. Para sinalizar ao subconsciente do jogador que o ambiente perdeu a segurança ou que a sanidade da personagem está em colapso, inclinamos a câmera na diagonal. Essa dissonância visual provoca desconforto imediato.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Decupagem de uma sequência de Suspense em 3 Pranchetas: da calma enganosa no Plano Aberto até o sufocamento no Ângulo Holandês e Extreme Close-up.

#### Passo 1 — A Calma Falsa no Plano Aberto Wide Shot)

- Crie um arquivo com três Pranchetas 16 9 (1920 x 1080 px ) no

Photoshop.

- Na primeira prancheta (01_Plano_Aberto ), desenhe uma sala ampla de

masmorra.

- Mantenha a Linha do Horizonte perfeitamente horizontal e reta.

- Desenhe o herói agachado em tamanho minúsculo atrás de um caixote

no canto inferior. O amplo espaço vazio ao redor passa sensação de controle geográfico.

#### Passo 2 — A Desorientação com o Ângulo Holandês Dutch Tilt)

- Mude para a segunda prancheta (02_Invasao_DutchAngle ).

- Quebre a Estabilidade: Desenhe a linha do chão e as paredes

inclinadas a 30 graus na diagonal.

- Aplique a Regra do Oculto: não desenhe o monstro! Desenhe apenas o

vão da porta aberta e a silhueta de uma bota colossal ou garra pisando na tábua inclinada do piso.

- Explique aos alunos que o horizonte inclinado altera o equilíbrio

perceptual da cena, avisando o jogador de que o perigo invadiu o espaço.

#### Passo 3 — O Sufocamento no Extreme Close-Up

- Vá para a terceira prancheta (03_Claustrofobia_ExtremeCloseUp ).

- Corte todo o cenário exterior: avance a câmera para dentro do

esconderijo.

- Enquadre apenas os olhos arregalados do herói e a mão dele tampando

a própria boca para conter a respiração.

- Desenhe tábuas verticais escuras nas duas margens da prancheta

esmagando o enquadramento (as frestas do armário onde ele se oculta).

- Entre as frestas, pinte a sombra do perseguidor passando bem rente à

lente da câmera.

#### Passo 4 — Análise do Pacing

- Demonstre a progressão aos estudantes: a transição do Plano Aberto

equilibrado para o horizonte torto e o fechamento em um enquadramento sem espaço de fuga conduz a tensão visualmente até o clímax.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Arquitetura do Medo Sua missão é atuar como Diretor de Arte de uma sequência cinematográfica de horror psicológico ou suspense em games. Você deve construir uma progressão de três cenas manipulando a cadência de planos, a desorientação do horizonte inclinado e o confinamento da visão periférica. Checklist do Desafio: Abrir um documento no Photoshop com 3 Pranchetas 16 9 alinhadas.

Escolher um contexto de perigo iminente (ex: sobrevivente escondido de guardas cibernéticos, explorador acuado por uma fera nas ruínas). Prancheta 1 O Respiro - Wide Shot): Desenhar o ambiente completo com a linha do horizonte perfeitamente reta e nivelada. Posicionar o protagonista ocupando uma área reduzida da tela, cercado por espaço negativo de ar. Prancheta 2 A Quebra - Dutch Angle + Oculto): Inclinar a linha do horizonte e paredes diagonalmente (entre 20 e 35 graus). Não desenhar o inimigo completo: ilustrar apenas um indício físico da ameaça (uma sombra projetada, um rastro ou uma extremidade). Prancheta 3 A Claustrofobia - Extreme Close-up): Eliminar o cenário amplo e preencher o quadro com plano fechado no rosto aterrorizado do protagonista. Emoldurar as laterais da tela com obstáculos próximos (barricadas, caixas, tubulações) para suprimir a visão periférica. Salvar o documento técnico como Pacing_Suspense_SeuNome.psd.'),
('producao-multimidia-ii','modulo-3','semana-19','Semana 19: Limpeza Técnica (Clean-up), Escala de Cinza e a Forja do Animatic',6,'## Semana 19: Limpeza Técnica (Clean-up), Escala de Cinza e a Forja do Animatic Conteúdos integrados: Clean-up Lineart refinada), Palco 3D em Escala de Cinza Foreground, Midground, Background), Tangência Tonal e Pop-out, Montagem do Animatic e Scratch Audio.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

O rascunho de miniaturas (Thumbnail) serviu para explorar ideias com agilidade. No entanto, um storyboard precisa ser lido por dezenas de profissionais de diferentes departamentos (iluminação, som, animação e cenários). Se o animador não distinguir onde termina o elmo do herói e onde começa a pedra do cenário, a linha de produção inteira trava.

Para transformar o rascunho em um documento de produção, executamos duas etapas:

- Clean-up Limpeza): Baixamos a opacidade do rascunho bagunçado para

20% e, em uma nova camada superior, traçamos uma linha vetorial ou pincelada firme e definitiva (Lineart limpa), definindo anatomia, expressões e objetos.

- Escala de Cinza Grayscale): Um storyboard profissional não utiliza cores

completas para não desacelerar o pipeline. Em vez disso, organizamos a profundidade do mundo em Três Planos Tonais: Foreground Primeiro Plano): Elementos colados à lente (ombros de um observador, galhos na frente da tela). Pintados quase sempre em Preto ou Cinza Muito Escuro, servindo como moldura de profundidade. Midground Plano Médio): O palco central onde os atores lutam ou agem. Preenchido com Cinza Médio. Background Plano de Fundo): O horizonte, montanhas e prédios distantes. Pela física da Perspectiva Atmosférica, o ar clareia os objetos afastados; por isso, o fundo é pintado em Cinza Muito Claro ou quase branco. Contraste de Silhueta (Pop-out): Nunca coloque um personagem de cinza-médio encostado em uma parede de cinza-médio. Se o ator é médio, o fundo atrás dele deve ser claro ou escuro para que ele salte da tela. A Quarta Dimensão: O Animatic: O papel não tem tempo. Um desenho estático não informa se o susto dura 0,5 segundos ou 4 segundos. O Animatic é o casamento do Storyboard limpo com um software de vídeo (como Adobe Premiere ou a Linha do Tempo do Photoshop). Exportamos as pranchetas, colocamos os quadros em sequência temporal e adicionamos Scratch Audio (vozes temporárias gravadas com o celular e efeitos sonoros básicos) para validar o Timing antes que o estúdio gaste dinheiro renderizando modelos 3D.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Limpeza de um quadro de storyboard, aplicação dos 3 planos em escala de cinza e montagem de uma sequência no painel Linha do Tempo (Timeline).

#### Passo 1 — A Linha Limpa Clean-up da Lineart)

- Abra um Thumbnail rascunhado na semana anterior.

- No painel de Camadas, selecione a camada de rascunho e reduza a

Opacidade para 20%.

- Crie uma nova camada acima chamada Lineart_Limpa .

- Pressione B Pincel Redondo Duro, 100% de dureza e cor Preta,

tamanho 3 px).

- Trace o contorno firme e polido do personagem e das estruturas,

definindo arestas precisas e eliminando rabiscos soltos.

#### Passo 2 — O Palco 3D em Escala de Cinza

- Crie uma camada abaixo da Lineart_Limpa chamada Tons_Grayscale .

- Mude o modo de mesclagem da camada Lineart_Limpa para

Multiplicação (Multiply).

- Foreground: Na borda esquerda, pinte o tronco de uma árvore colada

na lente da câmera com Cinza Escuro quase preto (#1A1A1A ).

- Midground: No centro, pinte o herói com Cinza Médio (#7A7A7A ).

- Background: Atrás do herói, pinte a parede distante da caverna com

Cinza Muito Claro (#D4D4D4 ).

- Mostre o efeito Pop-out: a figura cinza-média recorta com nitidez sobre

a parede clara e ganha profundidade contra a moldura escura frontal.

#### Passo 3 — Exportação em Lote das Pranchetas

- Vá ao menu superior: Arquivo > Exportar > Pranchetas para

Arquivos... (File > Export > Artboards to Files...).

- Selecione o formato PNG e resolução 1920 x 1080 .

- Clique em Executar. O Photoshop exportará cada tela numerada

automaticamente (01_Cena.png, 02_Cena.png, 03_Cena.png ).

#### Passo 4 — Sincronização e Áudio na Linha do Tempo Animatic)

- Vá ao menu superior: Janela > Linha do Tempo (Window > Timeline)

para abrir o painel de edição.

- Clique no botão central Criar Linha do Tempo de Vídeo (Create Video

Timeline).

- Importe os quadros exportados em sequência e posicione-os na trilha

horizontal.

- Ajuste a duração de cada prancheta arrastando as bordas: a cena do

choque dura 0.8 segundos, e o plano de suspense segura por 2.5 segundos.

- Adicione uma faixa de áudio provisório (Scratch Track) com efeito de

passos pesados sincronizados no exato segundo do susto. Pressione Play na barra de espaço para demonstrar a imagem estática ganhando vida pelo tempo.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Forja do Animatic Profissional Chegou o fecho do Módulo 3. Você deve pegar a sequência de três cenas desenvolvida ao longo das últimas semanas, executar o Clean-up com separação de planos de profundidade em escala de cinza e montar o seu primeiro Animatic com sincronização de tempo e áudio. Checklist do Desafio: Abrir o arquivo de pranchetas de Storyboard das semanas anteriores. Reduzir a opacidade da camada de rascunhos para 20%. Criar a camada Lineart_Limpa e redesenhar os três quadros com linhas firmes e contornos limpos usando Pincel Duro (B ). Aplicar a divisão de planos em Escala de Cinza Grayscale): Foreground: Elementos imediatos à câmera em preto ou cinza quase preto. Midground: Personagens e ações primárias em cinza-médio. Background: Cenário distante em cinza-claro (simulando perspectiva atmosférica). Evitar Tangências Tonais: garantir que personagens em cinza-médio não fiquem sobrepostos a fundos da mesma tonalidade. Realizar a exportação em lote das pranchetas em formato.PNG Full HD (1920 x 1080 px ).

Abrir o painel Linha do Tempo (Janela > Linha do Tempo ) ou um editor de vídeo de apoio Premiere). Ajustar a cadência temporal (Timing) de cada cena, atribuindo durações distintas para refletir o ritmo dramático (cenas rápidas vs. lentas). Inserir pelo menos um efeito sonoro de impacto (Foley) ou áudio gravado sincronizado no momento crítico da cena. Renderizar e exportar o Animatic finalizado em vídeo.MP4 com o nome Animatic_Cutscene_SeuNome.mp4.'),
('producao-multimidia-ii','modulo-4','semana-20','Semana 20: Fundamentos de UX/UI, Contraste de Gameplay e Acessibilidade Visual',1,'## Semana 20: Fundamentos de UX/UI, Contraste de Gameplay e Acessibilidade Visual Conteúdos integrados: UX vs. UI, Imersão Dinâmica, Interfaces Diegéticas, Camuflagem Acidental vs. Contraste Notan, Cor e Saturação), Codificação Dupla e Testes de Acessibilidade.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Existe uma regra implacável na indústria de videojogos: arte bonita atrai olhares nas redes sociais, mas arte legível e jogável conquista os prémios de Jogo do Ano. No calor de um combate contra um chefe de fase, o jogador não tem tempo para contemplar o reflexo do aço de uma lâmina; ele precisa de identificar instantaneamente quanta vida lhe resta e para onde deve fugir. É neste ponto que a ilustração pura se curva às leis do Design de Interface. O artista digital precisa de distinguir dois conceitos que caminham juntos: UX (User Experience / Experiência do Utilizador): É a engenharia invisível. Foca-se em como o jogo se sente, na facilidade de navegação e na ausência de atrito cognitivo e frustração. UI (User Interface / Interface do Utilizador): É a camada visual e gráfica. São os botões, barras de vida, minimapas e ícones que servem de canal de comunicação entre o motor de jogo e o cérebro humano. A Regra de Ouro da Interface:Invisível na paz, escandalosamente óbvia no perigo. Em momentos de exploração calma, a interface recolhe-se para garantir a imersão (como em The Last of Us); quando o perigo surge, alertas de alta intensidade entram em ação. Quando os dados são projetados dentro do

próprio mundo físico ficcional (como a barra de vida luminosa na espinha dorsal do fato em Dead Space), chamamos-lhe Interface Diegética. Contraste de Gameplay vs. Camuflagem Acidental: Na vida real, a camuflagem protege; nos videojogos, a camuflagem acidental é um erro de design grave. Se o herói se fundir com as cores do cenário, o jogador perde o controlo da ação. Para garantir a separação de planos, manipulamos três pilares:

- Contraste de Valor Notan Elemento claro contra fundo escuro, ou

elemento escuro contra fundo claro.

- Contraste de Saturação: O cenário é pintado com tons acinzentados e

opacos (baixa saturação), enquanto heróis, inimigos e itens interativos recebem cores puras e vibrantes.

- Contraste de Cor: Uso estratégico de matizes complementares.

Acessibilidade e Codificação Dupla: Cerca de 8% dos homens sofrem de daltonismo (sobretudo deuteranopia e protanopia, a dificuldade em distinguir vermelho e verde). A regra inquebrável das diretrizes internacionais (Game Accessibility Guidelines) é a Codificação Dupla: nunca transmitir uma mecânica apenas pela cor. Se o aliado tem marcador verde e o inimigo tem marcador vermelho, altere também a forma geométrica — um círculo verde para o aliado e um triângulo pontiagudo vermelho para o perigo. Mesmo em preto e branco, a leitura é inequívoca.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Auditoria de contraste visual num ecrã de combate, aplicação de simulação de daltonismo no Photoshop e construção de marcadores acessíveis com codificação dupla.

#### Passo 1 — Preparação do Cenário de Teste

- No Adobe Photoshop, abra uma captura de ecrã ou ilustração de

floresta densa (tons de verde e castanho).

- Crie uma nova camada chamada Heroi_Camuflado . Pinte a silhueta de um

personagem em verde-oliva sobre a relva verde.

- Aponte no projetor a falha imediata: o personagem desaparece contra o

fundo.

#### Passo 2 — O Teste de Cinzento Grayscale) e Squint Test

- Crie uma camada no topo de toda a pilha e preencha-a com Preto puro

(#000000 ).

- Mude o Modo de Mesclagem dessa camada preta para Cor (Color) ou

Saturação (Saturation).

- A imagem ficará instantaneamente a preto e branco. Mostre aos alunos

como a silhueta do herói se dissolve completamente nas árvores por falta de Contraste de Valor Notan.

- Apague a camada preta e demonstre a correção: selecione a camada

do herói e ajuste o brilho ou aplique uma paleta de alta saturação quente Laranja/Amarelo) com contorno escuro (Stroke), fazendo-o saltar do fundo.

#### Passo 3 — Construção dos Marcadores com Codificação Dupla

- Crie uma nova camada chamada UI_Marcador_Aliado .

- Com a Ferramenta Elipse (U), desenhe um círculo perfeito segurando a

tecla Shift. Preencha-o com Verde Esmeralda (#00D053 ).

- Dê dois cliques na camada para abrir os Estilos de Camada (Layer

Styles). Ative um Traçado (Stroke) exterior preto de 3 px e uma leve Sombra Projetada (Drop Shadow). Esse backdrop impede que o marcador desapareça se o fundo for branco.

- Crie outra camada chamada UI_Marcador_Inimigo .

- Com a Ferramenta Polígono (U), configure 3 lados para desenhar um

Triângulo afiado. Preencha-o com Vermelho Alerta (#FF2200 ) e aplique o mesmo traçado escuro.

#### Passo 4 — A Prova dos Nove Simulação de Daltonismo no Software)

- Vá ao menu superior: Visualizar > Configuração de Prova >

Daltonismo Protanopia) (View > Proof Setup > Color Blindness - Protanopia).

- Pressione o atalho Ctrl + Y para ligar e desligar a prova de cores em

tempo real.

- Mostre à turma que, sob o filtro de daltonismo, ambas as cores se

tornam castanhos indistintos, mas o círculo e o triângulo com traçado preto continuam imediatamente decodificáveis.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Auditoria de Acessibilidade e Contraste Assuma a função de Designer de UI/UX num estúdio. Terá de pegar numa imagem de jogo caótica, corrigir os problemas de camuflagem acidental através do contraste de saturação/valor e criar um sistema de ícones de status acessível para daltónicos. Checklist do Desafio: Criar um documento no Photoshop no tamanho 1920 x 1080 px a 72 DPI e importar uma imagem de cenário natural complexo para o fundo. Posicionar duas silhuetas de personagens em jogo: um herói e um oponente. Executar o Teste de Cinzento: criar a camada preta em modo Color no topo e confirmar se as silhuetas mantêm leitura através da separação clara de Notan. Aplicar o Contraste de Saturação: reduzir a saturação do cenário de fundo (Imagem > Ajustes > Matiz/Saturação ) em cerca de 25% a 40%, mantendo os atores com cores vibrantes. Criar um pacote de 3 marcadores de mira ou status de personagem acima das cabeças: Marcador 1 Aliado / Recuperação Círculo + Verde). Marcador 2 Ameaça Crítica / Inimigo Triângulo pontiagudo + Vermelho). Marcador 3 Neutro / Ponto de Interesse Losango ou Quadrado + Azul/Amarelo). Aplicar traçado preto de contorno (Stroke) ou caixa de contraste (Backdrop) em todos os elementos tipográficos ou ícones. Testar a interface no menu Visualizar > Configuração de Prova > Daltonismo e confirmar que a distinção geométrica funciona perfeitamente sem o apoio da cor. Salvar o ficheiro de entrega como Auditoria_Acessibilidade_SeuNome.psd.'),
('producao-multimidia-ii','modulo-4','semana-21','Semana 21: Arquitetura de HUD e Wireframing de Baixa Fidelidade (Low-Fi)',2,'## Semana 21: Arquitetura de HUD e Wireframing de Baixa Fidelidade (Low-Fi) Conteúdos integrados: O Centro Sagrado da Tela, Convenções de Gênero, Níveis de Informação Crítica, Tática e Contextual), O que é um Wireframe e Montagem Estrutural.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

O ecrã fixo que se sobrepõe à câmara de um jogo chama-se HUD (Heads-Up Display). A sua disposição não resulta de gosto pessoal aleatório; obedece a uma ciência rígida de rastreio ocular (eye-tracking) e memória muscular. A regra suprema da arquitetura de ecrã é: o centro da tela é sagrado. Cerca de 90% da atenção do jogador está concentrada no ponto central, onde a mira aponta, onde as plataformas se movem e onde os ataques acontecem. Todos os elementos de interface devem ser empurrados estrategicamente para as bordas periféricas. Poluir o centro com painéis opacos gera claustrofobia visual e compromete o desempenho da jogabilidade. Convenções de Gênero O Vício dos Olhos): Os jogadores trazem décadas de reflexos condicionados: Jogos de Tiro (Shooters): A mira domina o centro. O contador de munições fica tradicionalmente ancorado no canto inferior direito porque o modelo 3D da arma da personagem ocupa o lado direito do ecrã, guiando a linha de visão até ao contador. RPGs e Aventura: A leitura ocidental conduz o olhar a iniciar no topo esquerdo. Historicamente, a barra de vida HP) e o retrato do herói ficam no canto superior esquerdo. MOBAs e Estratégia: O minimapa é o elemento tático mais consultado em frações de segundo, posicionado nos cantos inferiores. Hierarquia da Informação:

- Nível 1 Crítico): Vida, munição restante e alertas de morte iminente. Maior

escala, alto contraste e visibilidade prioritária.

- Nível 2 Tático Minimapa, bússola e tempos de recarga de feitiços

(Cooldowns).

- Nível 3 Contextual): Nome da região descoberta, pop-ups de itens

apanhados. Devem ser discretos e desaparecer após alguns segundos. A Regra da Baixa Fidelidade Low-Fi Wireframe): O maior erro de um artista júnior é começar a desenhar barras de vida cheias de ornamentos dourados, pedras preciosas e texturas metálicas complexas no primeiro dia. Se a proporção estiver errada e o ecrã sufocar a visão do jogador, todo esse trabalho vai para o lixo. O profissional constrói primeiro um Wireframe Esqueleto Estrutural) de Baixa Fidelidade (Low-Fi). Ele utiliza exclusivamente caixas cinzentas e formas geométricas simples, sem cor ou textura. Isso desvia o foco das discussões estéticas secundárias ("gostei ou não deste tom de vermelho") para o que realmente interessa: Posição, Escala e Legibilidade.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Construção de um Wireframe Low-Fi completo de HUD para um RPG de Ação sobre um mockup de cenário em 1920 1080 px.

#### Passo 1 — O Mockup de Fundo A Proporção Real)

- No Photoshop, crie um Canvas no formato 1920 x 1080 px a 72 DPI .

- Importe uma captura de ecrã real de um ambiente de ação 3D para a

camada base e trave-a com o cadeado.

- Explique que construir o Wireframe sobre um fundo branco liso distorce

a noção de escala; precisamos de avaliar as caixas cinzentas contra a complexidade do jogo real.

#### Passo 2 — O Canto Superior Esquerdo Informação Crítica - Nível 1

- Crie uma pasta de camadas chamada Wireframe_HUD .

- Selecione a Ferramenta Elipse (U). Segurando a tecla Shift, desenhe um

círculo cinzento-escuro (#2A2A2A ) com 120 x 120 px a 50 px de distância das margens do canto superior esquerdo (o esqueleto do retrato do personagem).

- Selecione a Ferramenta Retângulo (U). Desenhe uma barra horizontal

cinzenta-escura colada ao círculo (380 x 30 px ) representando o fundo da barra de HP.

- Desenhe um retângulo menor cinzento-claro (#C0C0C0 ) sobreposto a

ocupar 80% do espaço (a barra de vida preenchida).

- Logo abaixo, desenhe uma barra mais fina cinzenta-média (300 x 15 px )

para a estamina/mana.

#### Passo 3 — O Canto Superior Direito Navegação Tática - Nível 2

- Desenhe um círculo cinzento com 200 x 200 px ancorado no canto

superior direito para o minimapa.

- Com a Ferramenta Linha ou Retângulo fino, desenhe uma cruz no

centro do minimapa marcando os eixos da bússola.

#### Passo 4 — O Canto Inferior Direito Habilidades e Ações)

- Com a Ferramenta Retângulo, desenhe um bloco quadrado de 64 x 64

px com preenchimento cinzento e traçado claro.

- Segurando Alt + Shift, arraste para o lado para duplicar o quadrado três

vezes, criando um conjunto de 4 botões de habilidades com espaçamento regular de 12 px entre eles.

#### Passo 5 — A Tipografia Estrutural Placeholder)

- Selecione a Ferramenta Texto (T) com uma fonte neutra sem serifa

(como Roboto ou Arial) na cor branca.

- Escreva textos de marcação objetivos:

Sobre a barra de vida: HP 850 / 1000 em corpo 14 pt. Sobre o minimapa: NOME DO LOCAL em corpo 16 pt. Nos botões de habilidade: as teclas de atalho [Q], [E], [R], [F].

#### Passo 6 — A Avaliação do Centro Sagrado

- Afaste o zoom com Ctrl + Menos.

- Aponte no ecrã: o centro permanece 100% desobstruído para a batalha.

As informações vitais encontram-se arrumadas na visão periférica imediata.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Planta Baixa do HUD

Você é o arquiteto de informação da interface de um projeto. A sua missão é criar um Wireframe de Baixa Fidelidade Low-Fi rigorosamente proporcional para um gênero de jogo à sua escolha, preservando o centro do ecrã e estruturando a hierarquia em três níveis. Checklist do Desafio: Abrir um documento no Photoshop no padrão Full HD (1920 x 1080 px a 72 DPI ). Inserir uma captura de ecrã real de gameplay no fundo (proibido trabalhar sobre fundo branco liso). Escolher o gênero do HUD Shooter de Primeira Pessoa, RPG de Ação em Terceira Pessoa ou MOBA/Estratégia. Respeitar a regra da Baixa Fidelidade: utilizar estritamente formas geométricas limpas (retângulos, círculos) em tons de cinzento, sem pintar ilustrações ou ornamentos artísticos. Informação Crítica Nível 1 Barras de saúde, escudos ou munições posicionadas de acordo com as convenções de gênero consagradas. Informação Tática Nível 2 Minimapa, bússola e caixas de habilidades em recarga arrumadas nos cantos opostos. Informação Contextual Nível 3 Caixa de texto discreta para registro de itens apanhados ou legendas. Inserir tipografia neutra de marcação (Placeholder) demonstrando valores numéricos vitais e atalhos de teclado. Confirmar o Centro Sagrado: verificar se a área central de combate está desobstruída. Salvar o ficheiro como Wireframe_HUD_SeuNome.psd.'),
('producao-multimidia-ii','modulo-4','semana-22','Semana 22: O Design do Ícone Perfeito: Síntese e a Tirania da Escala',3,'## Semana 22: O Design do Ícone Perfeito: Síntese e a Tirania da Escala Conteúdos integrados: A Tirania da Escala 50 50 px), A Arte da Síntese Visual, Silhuetas Exageradas no Notan, Contraste Extremo de Valor e o Teste do Encolhimento Zoom Out).

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Com a planta baixa cinzenta do Wireframe estruturada, precisamos de preencher as pequenas caixas de inventário e habilidades nos cantos do ecrã. O erro sistemático do artista iniciante é abrir uma tela de 2000 2000 píxeis e desenhar uma cena inteira: um feiticeiro a segurar um cajado brilhante disparando chamas contra um dragão. A realidade implacável do Game Design é a Tirania da Escala. Um ícone de feitiço tem de ser lido com nitidez cirúrgica quando for reduzido para 50 50 píxeis num ecrã de telemóvel ou numa televisão vista a três metros de distância do sofá da sala. Se colocarmos uma ilustração narrativa complexa dentro desse espaço minúsculo, ela transformar-se-á num borrão sujo e ilegível de píxeis sem forma. O design do ícone perfeito obedece a quatro mandamentos:

- A Arte da Síntese Menos é Mais): Um ícone não é uma pintura; funciona

como um sinal de trânsito digital. Se a magia é uma "Bola de Fogo", esqueça o feiticeiro e o dragão: desenhe apenas a chama pura isolada.

- Silhuetas Exageradas: Proporções realistas são inimigas da escala

reduzida. Se desenhar uma espada com proporções históricas reais, a lâmina ficará tão fina que desaparecerá ao ser encolhida. Engrosse a lâmina, alargue a guarda e estilize arestas afiadas.

- Contraste Extremo de Notan: O centro da forma precisa de gritar para fora

do ecrã. A base deve carregar sombras profundas encostadas em brilhos quase brancos incandescentes.

- Contorno Técnico (Stroke / Outer Glow): Um traçado escuro exterior sólido

ou brilho nítido em torno do contorno externo é obrigatório para que a silhueta descole perfeitamente de qualquer cenário de fundo caótico. O hábito vital do desenhador de interfaces é o Teste do Encolhimento (Zoom Out Test): pintar a trabalhar com o zoom afastado para conferir se o asset funciona no tamanho de uma moeda pequena.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Criação de um Ícone de Habilidade de Combate ("Estilhaço de Gelo Perfurante") em tela de 256 256 px, com contraste extremo e validação em 50 50 px.

#### Passo 1 — Preparação da Prancheta Otimizada

- No Photoshop, crie um novo documento: Largura 256 px , Altura 256 px ,

resolução 72 DPI e fundo transparente.

- Crie uma camada na base com um quadrado cinzento-escuro (#1A1A1A )

com traçado de 2 px representando a moldura do botão do HUD.

- Crie uma nova camada chamada Icone_Silhueta .

#### Passo 2 — Construção da Silhueta Exagerada Diagonal Dinâmica)

- Selecione a Ferramenta Laço Poligonal (L).

- Trace a silhueta de um cristal de gelo em ângulo diagonal de 45 graus

(a diagonal transmite agressividade cinética e ataque).

- Aplique o Exagero: Faça a ponta principal desproporcionalmente

pontiaguda e a base lascada com dentes geométricos largos.

- Preencha a seleção com um Azul Marinho profundo (#0A1D3A ) usando o

Balde de Tinta (G).

#### Passo 3 — Aplicação de Contraste Extremo de Valor

- Ative o Alpha Lock Bloquear pixels transparentes) na camada da

silhueta.

- Pressione B e selecione o Pincel Redondo Duro com cor Ciano Vibrante

(#00E5FF ).

- Pinte o terço médio do cristal, deixando a base quase preta.

- Mude a cor do pincel para Branco Puro (#FFFFFF ).

- Trace uma linha de corte afiada bem na aresta superior da ponta do

cristal. Mostre aos alunos como o encontro do branco contra o azul escuro projeta a sensação cristalina imediata.

#### Passo 4 — O Contorno de Destaque Stroke

- Dê dois cliques na camada do ícone para abrir os Estilos de Camada.

- Ative a opção Traçado (Stroke): defina o tamanho para 2 px , posição

Externa (Outside) e cor Preto Puro (#000000 ).

- Ative um leve Brilho Externo (Outer Glow) na cor ciano com opacidade

em 40%.

#### Passo 5 — O Teste do Encolhimento Zoom Out)

- Afaste o zoom com Ctrl + Menos até o ícone ficar com cerca de 2

centímetros no monitor físico (o equivalente a 50 50 px).

- Comprove diante da turma: a ponta diagonal e o brilho branco

continuam perfeitamente reconhecíveis mesmo em tamanho minúsculo.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Forja do Ícone de Ação Você é o artista responsável pelo pacote de ícones de habilidades de um jogo de fantasia ou ficção científica. Terá de conceber dois ícones funcionais em pranchetas de 256 256 px, aplicando a regra da síntese visual e garantindo a sobrevivência estética no Teste do Encolhimento. Checklist do Desafio: Criar dois ficheiros no Photoshop com dimensões de 256 x 256 px a 72 DPI. Escolher duas habilidades distintas (ex: Bola de Fogo Vulcânica, Veneno Ácido, Escudo de Luz ou Disparo Laser). Aplicar o princípio da Síntese Visual: desenhar estritamente o símbolo ou objeto central da ação, descartando cenários e personagens no fundo. Exagerar as proporções anatômicas do elemento (espessuras grossas, pontas expressivas). Construir Contraste Extremo de Notan: usar sombras escuras sólidas em oposição a brilhos brancos ou incandescentes nos centros de impacto. Inserir um contorno escuro (Stroke) exterior ou brilho nítido para separar a forma da caixa do HUD. Aplicar o Teste do Encolhimento: reduzir a visualização no ecrã para a escala de 50 50 px e confirmar a legibilidade imediata. Exportar os dois ícones em formato.PNG com canal alpha transparente: ui_icon_habilidade_01.png ui_icon_habilidade_02.png Salvar os arquivos mestres editáveis como Icones_Skill_SeuNome.psd.'),
('producao-multimidia-ii','modulo-4','semana-23','Semana 23: Feedback Visual, Sinais Vitais e Game Feel',4,'## Semana 23: Feedback Visual, Sinais Vitais e Game Feel Conteúdos integrados: O Ecrã Vivo, Damage Vignette Vinheta de Dano), Hit Flash Piscar de Impacto), Visão Periférica e o Conceito de "Game Feel" / Juiciness.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Construímos uma interface com barras e ícones nítidos, mas no calor de uma luta frenética, o jogador raramente tira os olhos do monstro à sua frente para olhar a barra de vida. Se o jogo não responder visualmente, como saberá ele que está prestes a morrer? E quando balança a espada, como tem a certeza física de que atingiu o alvo? A resposta reside no Feedback Visual. O jogo comunica com os instintos biológicos do jogador em milissegundos: Damage Vignette Vinheta de Dano): Quando o herói é atingido, o jogo não se pode limitar a subtrair números matemáticos da barra de HP em silêncio. As bordas do ecrã piscam com um gradiente vermelho-sangue. Como o vermelho invade a visão periférica, o cérebro processa o choque sem desviar os olhos do combate no centro. Se a vida descer abaixo dos 15%, a vinheta permanece a pulsar como um batimento cardíaco tenso. Hit Flash Piscar de Impacto): Se atacar um inimigo e ele não reagir, a espada parecerá feita de cartão. Para validar o golpe, os motores gráficos substituem todas as texturas do monstro por branco puro por 1 a 3 fotogramas (milissegundos) no exato instante do toque. O branco puro destaca-se de qualquer ambiente, gerando uma resposta visual prazerosa de confirmação de acerto. Game Feel Ou Juiciness): Um jogo "seco" limita-se a retirar vida mecanicamente. Um jogo "sumarento" (Juicy) faz a câmara tremer (Screen Shake), emite partículas, ilumina os alvos com Hit Flash e pinta as margens do ecrã com a Damage Vignette. É essa camada visual e táctil que confere impacto e visceralidade ao ato de pressionar um botão.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Pintura técnica de uma Damage Vignette radial em tela Full HD para exportação com Canal Alpha e simulação do Hit Flash num sprite de inimigo.

#### Passo 1 — A Prancheta Transparente Full HD

- Crie um documento novo no Photoshop: 1920 x 1080 px , 72 DPI , com

Conteúdo do Plano de Fundo: Transparente.

- Crie uma nova camada chamada Vignette_Dano_Perigo .

#### Passo 2 — Construção do Gradiente Radial Periférico

- Pressione a tecla G para ativar a Ferramenta Gradiente (Gradient Tool).

- Na barra de opções superior, escolha o estilo Gradiente Radial (o

segundo ícone, circular).

- Abra o Editor de Gradiente:

A ponta esquerda (o centro da tela) deve ser configurada para Vermelho Sangue (#8B0000 ), mas com a Opacidade superior em 0% 100% transparente). A ponta direita (as margens externas) deve ser configurada para o mesmo Vermelho Sangue (#8B0000 ), com a Opacidade superior em 100%.

- Clique no centro exato da tela e arraste o mouse até o canto superior

direito da tela.

- O centro da tela permanece limpo para não tapar o herói, enquanto as

quatro bordas ficam preenchidas com uma névoa vermelha intensa.

#### Passo 3 — Otimização de Fusão Blend Mode Multiply)

- Altere o Modo de Mesclagem da camada da vinheta para Multiplicação

(Multiply) ou Sobrepor (Overlay).

- Importe uma arte de gameplay por baixo da camada e demonstre como

o gradiente vermelho se funde de forma ameaçadora com os elementos do cenário.

#### Passo 4 — Preparação Técnica do Hit Flash

- Pegue num sprite ou silhueta de monstro numa camada separada.

- Duplique essa camada com Ctrl + J e renomeie-a como

Monstro_HitFlash.

- Ative o Alpha Lock Bloquear pixels transparentes) nessa nova camada.

- Pressione Shift + F5 Preencher), escolha a cor Branca Pura (#FFFFFF ) e

confirme a 100%.

- Desligue e ligue o ícone de visibilidade do olho dessa camada branca

no painel: mostre como o "flash" branco relâmpago comunica instantaneamente o impacto da pancada.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Arquitetura do Impacto Você é o especialista em Game Feel encarregado de dar peso e visceralidade aos combates do jogo. Terá de construir a textura técnica da Vinheta de Dano (Damage Vignette) e criar uma folha comparativa demonstrando a reação de impacto (Hit Flash) num elemento inimigo. Checklist do Desafio: Criar um Canvas de 1920 x 1080 px a 72 DPI com fundo transparente no Photoshop. Utilizar a Ferramenta Gradiente (G ) no modo Radial. Configurar as paradas de opacidade: centro 100% transparente e bordas externas com vermelho profundo opaco (#990000 ). Aplicar o gradiente do centro para fora, garantindo que o terço central da tela permaneça desobstruído. Configurar o Modo de Mesclagem em Multiply ou Overlay. Exportar a vinheta finalizada em formato.PNG com Canal Alpha com o nome fx_vignette_damage_critico.png. Num segundo arquivo de trabalho: posicionar um asset de personagem inimigo. Criar a versão de Hit Flash: duplicar a camada do inimigo, aplicar Alpha Lock e preencher a 100% com Branco Puro (#FFFFFF ). Simular um Momento de Dano Crítico combinando o fundo do jogo, o sprite inimigo a piscar com o Hit Flash e a Vinheta de Dano ativada por cima de tudo.

Salvar o ficheiro de teste como Feedback_Impacto_SeuNome.psd.'),
('producao-multimidia-ii','modulo-4','semana-24','Semana 24: O Mockup Completo de Interface e a Metodologia Iterativa de Estúdio',5,'## Semana 24: O Mockup Completo de Interface e a Metodologia Iterativa de Estúdio Conteúdos integrados: Mockup Completo Fake Screenshot), Compositing no Photoshop, O Ciclo D F P Draft > Feedback > Polish), Morte do Ego e Dinâmica de Peer Review com o Método Sanduíche.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Durante o desenvolvimento de um jogo, cenários, personagens e barras de interface são produzidos em ficheiros isolados. Como pode o Diretor de Arte ter a certeza de que essas peças funcionarão harmoniosamente dentro do motor de jogo antes de os programadores escreverem código? A ferramenta padrão da indústria é o Mockup Completo (Fake Screenshot). Trata-se de uma simulação estática de alta fidelidade montada no Photoshop que reproduz com exatidão aquilo que os olhos do jogador verão durante a partida. O Mockup serve para executar o Teste de Colisão Visual: verificar se o minimapa tapa a cabeça de um inimigo, se a barra de vida rouba o foco da ação ou se as cores da interface se misturam com o fundo. Um bom mockup nunca retrata personagens parados em poses descontraídas; ele captura tensão dramática (ataques em execução, vinhetas piscando e inimigos recebendo dano) para validar a legibilidade no caos. A Metodologia Iterativa no Estúdio: A primeira versão de uma arte nunca é a versão final. O artista júnior que se apega emocionalmente ao primeiro traço sofre desnecessariamente na indústria. A produção segue o Ciclo D F P:

- Draft Rascunho Rápido): Exploração estrutural de baixo custo técnico.

- Feedback Crítica Técnica): Apontamento de falhas de usabilidade e

escala pelo Diretor de Arte ou pelos pares.

- Polish Polimento / Arte Final): Aplicação de texturas, luzes e reflexos

apenas após a aprovação da estrutura.

A Arte do Peer Review O Método Sanduíche): Na revisão técnica por colegas de equipa (Peer Review), criticar não é ofender; o objetivo é valorizar o jogo, separando a obra do valor pessoal do criador. Para fornecer feedback construtivo, aplicamos o Método Sanduíche: O Pão de Cima Elogio Sincero): Comece destacando algo que está a funcionar com excelência (ex: "A paleta de cores e o contraste dos ícones ficaram fantásticos!"). O Recheio A Crítica Acionável): Aponte o problema real acompanhado de uma solução prática (ex: "Contudo, a tipografia da munição está pequena demais para ler à distância. Se aumentarmos a escala em 20% e adicionarmos um traçado escuro, a leitura ficará nítida."). O Pão de Baixo O Encorajamento): Encerre reforçando a confiança (ex: "O layout geral está muito dinâmico, excelente trabalho!").

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Montagem e composição (Compositing) de um Mockup Completo de Ação no Photoshop em 1920 1080 px e simulação de uma sessão de Art Review.

#### Passo 1 — A Estrutura de Pastas de Compositing

- Crie um documento no formato 1920 x 1080 px a 72 DPI .

- No painel de Camadas, organize quatro grupos principais de baixo para

cima: Grupo 1 01_Cenario_Fundo Grupo 2 02_Personagens_Atores Grupo 3 03_Interface_HUD Grupo 4 04_Efeitos_Feedback

#### Passo 2 — Montagem do Palco e dos Atores

- Dentro do grupo 01_Cenario_Fundo , insira a arte de cenário finalizada. Se

o fundo estiver excessivamente saturado, diminua a opacidade para 85% para não competir com a ação.

- No grupo 02_Personagens_Atores , posicione o herói em pose de ataque no

lado esquerdo e o monstro recebendo o golpe no lado direito.

#### Passo 3 — Aplicação da Interface HUD

- No grupo 03_Interface_HUD , posicione a barra de vida renderizada no

canto superior esquerdo, o minimapa no topo direito e os ícones de habilidades desenvolvidos no canto inferior direito.

- Mostre que o Centro Sagrado da tela continua perfeitamente limpo

para o combate.

#### Passo 4 — Injetando o "Juice" Efeitos de Tensão)

- No grupo de topo 04_Efeitos_Feedback , importe a textura de Damage

Vignette em modo Multiply, escurecendo as bordas da tela com um gradiente vermelho dramático.

- Adicione o Hit Flash branco sobre a cabeça do monstro no ponto exato

onde a arma atinge o alvo.

- A imagem deixa de ser um conjunto de desenhos soltos e torna-se num

ecrã vivo de jogabilidade real.

#### Passo 5 — Simulação do Peer Review ao Vivo

- Peça a um aluno para apontar um elemento que funcione e uma falha

de legibilidade no ecrã.

- Demonstre a aplicação do Método Sanduíche e ajuste a escala de uma

caixa de texto ao vivo, provando que a metodologia iterativa economiza tempo de produção.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Prova Final do Mockup e Peer Review Chegou o fecho do Módulo 4. Montará o Mockup Completo do seu jogo em alta fidelidade no Photoshop, integrando cenário, personagens, HUD e efeitos de impacto. De seguida, participará numa sessão formal de Peer Review com rotação de postos de trabalho para avaliar e receber críticas estruturadas pelo Método Sanduíche. Checklist do Desafio: Abrir um Canvas Full HD (1920 x 1080 px a 72 DPI ) no Photoshop.

Estruturar a hierarquia de pastas: 01_Cenario, 02_Personagens, 03_Interface e 04_Efeitos. Posicionar o cenário de fundo com o contraste calibrado (reduzir a saturação se necessário). Dispor o herói e o oponente em momento de tensão ou combate. Integrar a camada de UI com os assets produzidos nas semanas anteriores (barra de vida, minimapa, botões e os 2 ícones de habilidade em 256 256 px). Posicionar a textura da Damage Vignette no topo da hierarquia em modo Multiply. Inserir o efeito de Hit Flash branco no inimigo no ponto de contato da lâmina ou projétil. A Dinâmica de Peer Review 15 minutos finais): Trocar de cadeira com o colega ao lado. Avaliar o ecrã do colega e redigir uma avaliação técnica obrigatória no bloco de notas utilizando o Método Sanduíche:

- O Pão de Cima: Elogio sincero sobre a estética ou contraste.

- O Recheio: Identificação de 1 erro funcional de UI (texto

pequeno, colisão visual com o herói, falta de backdrop) acompanhado da sugestão de correção.

- O Pão de Baixo: Encorajamento final focado na qualidade do

projeto. Regressar ao seu posto, ler o feedback com escuta ativa e aplicar o ajuste sugerido no arquivo. Exportar a simulação finalizada em formato.PNG com o nome Mockup_Gameplay_Final_SeuNome.png. Salvar o ficheiro mestre em camadas como Mockup_Compositing_SeuNome.psd.'),
('producao-multimidia-ii','modulo-5','semana-25','Semana 25: Character Design para Jogos: Proporções, Silhuetas e a Linha de Ação',1,'## Semana 25: Character Design para Jogos: Proporções, Silhuetas e a Linha de Ação Conteúdos integrados: A Responsabilidade do Concept Artist, Proporção por Cabeças Realista, Heroica e Chibi), Shape Language Aplicada, O Teste Supremo da Silhueta Negra, Espaço Negativo e a Linha de Ação.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

A conceção do protagonista é a maior responsabilidade de um Concept Artist num estúdio de videojogos: o herói é o veículo emocional do jogador. Se o design do protagonista falhar, o vínculo com o jogo quebra-se. Para construir avatares icónicos e funcionais, dominamos três leis de design de personagens:

- A Proporção por Cabeças: A unidade técnica da indústria para medir a

anatomia. Proporção Realista 7,5 a 8 cabeças): Utilizada em jogos de sobrevivência e terror (The Last of Us), transmitindo fragilidade e peso humano. Proporção Heroica 8,5 a 9 cabeças): Padrão de jogos de ação e combate frenético. O tronco é alongado e as pernas são compridas para que os golpes sejam lidos com clareza mesmo em ecrãs saturados.

Proporção Estilizada / Chibi 3 a 4 cabeças): Cabeça gigante e corpo pequeno. Essencial para jogos móveis, permitindo ler expressões faciais em ecrãs pequenos.

- O Teste Supremo da Silhueta Negra (Blackout Test): Durante a partida,

explosões e magias preenchem o ecrã; o cérebro humano lê primeiro o contorno externo da figura. Se pintar o seu herói inteiramente de preto e ninguém o reconhecer, o design falhou. Ícones como Super Mario ou Sonic são instantaneamente identificáveis apenas pelo contorno.

- Espaço Negativo e Linha de Ação: O erro comum é desenhar braços

colados ao peito. Ao preencher de preto, a arma funde-se com o tronco. Devemos abrir a silhueta utilizando o Espaço Negativo (os vãos de fundo entre os membros). Para que a pose não pareça um manequim estático, curvamos a espinha dorsal seguindo uma Linha de Ação fluida em formato de "C" ou "S", conferindo dinamismo e intenção ao movimento.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Construção do esqueleto dinâmico de um herói de ação em Proporção Heroica 8,5 cabeças) com Linha de Ação e validação via Blackout Test no Adobe Photoshop.

#### Passo 1 — A Régua de Proporção por Cabeças

- No Adobe Photoshop, crie um documento: 1920 x 1080 px , 72 DPI , fundo

Branco.

- Crie uma nova camada chamada Guia_Cabecas .

- Com a Ferramenta Retângulo (U), desenhe uma pequena elipse de 70

px de altura no topo (esta é a nossa cabeça base).

- Segurando Alt + Shift, arraste a elipse para baixo duplicando-a até

obter uma coluna de 8 elipses e meia empilhadas verticalmente.

- Pressione Ctrl + R para puxar linhas-guia horizontais travando: o Topo

da Cabeça 0, a base do Tronco/Bacia (cabeça 4, os Joelhos (cabeça 6) e o Solo (cabeça 8,5.

#### Passo 2 — A Linha de Ação A Espinha Invisível)

- Crie uma camada chamada Linha_de_Acao .

- Pressione B Pincel Macio, cor Vermelha).

- Trace uma curva fluida em forma de "C" amplo, partindo do calcanhar

de apoio, atravessando a pélvis e curvando o tronco para a frente até à cabeça.

- Reduza a opacidade desta camada vermelha para 30%.

#### Passo 3 — A Construção Dinâmica com Espaço Negativo

- Crie uma camada chamada Rascunho_Heroi .

- Pressione B Pincel Redondo Duro preto, tamanho médio).

- Rascunhe o guerreiro seguindo a curva da linha vermelha.

- Abertura de Silhueta: Posicione o braço esquerdo esticado para a

frente e o braço armado recuado para trás, mantendo uma janela visível de ar (espaço negativo) entre a espada e o tronco.

#### Passo 4 — O Teste Supremo Blackout Test com Clipping Mask)

- Crie uma camada vazia diretamente acima do rascunho e chame-lhe

Teste_Silhueta_Preta.

- Pressione D para resetar as cores e Alt + Backspace para preenchê-la

a 100% de preto.

- Clique com o botão direito na camada preta e escolha Criar Máscara de

Corte (Create Clipping Mask) (ou atalho Ctrl + Alt + G).

- O personagem transforma-se instantaneamente numa sombra chinesa

preta.

- Avalie com os alunos: a arma está visível? A classe dele é clara? Ele

transmite energia de combate?

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Criação do Avatar Dinâmico Você assumirá o posto de Concept Artist principal de um estúdio. Terá de definir a proporção anatómica do protagonista, estruturar uma pose de combate em torno de uma Linha de Ação e aprovar o design no Teste Supremo da Silhueta Negra. Checklist do Desafio:

Criar um documento no Photoshop no formato 1920 x 1080 px a 72 DPI. Escolher a métrica anatómica do projeto: Proporção Heroica 8,5 a 9 cabeças) para jogo de ação ou Proporção Chibi 3 a 4 cabeças) para jogo estilizado/mobile. Construir a coluna de marcação com elipses e linhas-guia horizontais para padronizar as alturas. Traçar numa camada separada a Linha de Ação em arco ("C" ou "S") definindo o fluxo dinâmico da pose. Rascunhar o herói integrando a Shape Language estudada (quadrados para armaduras pesadas, triângulos para agilidade ou círculos para simpatia). Preservar o Espaço Negativo: afastar os braços e armas do tronco para evitar blocos maciços sem leitura. Executar o Blackout Test: criar uma camada preta em Clipping Mask (Ctrl + Alt + G ) e avaliar a silhueta sólida. Realizar ajustes na pose com a borracha ou pincel caso alguma parte do corpo tenha ficado ilegível no teste preto. Salvar o ficheiro de desenvolvimento como Heroi_Conceito_Silhueta_SeuNome.psd.'),
('producao-multimidia-ii','modulo-5','semana-26','Semana 26: A Planta Baixa do Herói: O Turnaround Técnico (Model Sheet)',2,'## Semana 26: A Planta Baixa do Herói: O Turnaround Técnico (Model Sheet) Conteúdos integrados: Consistência Volumétrica, Turnaround / Model Sheet em 360°, T Pose vs. A Pose, Alinhamento Ortográfico por Réguas Guidelines) e a Importância do Design Traseiro.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

A pose de ação criada na semana anterior serve para vender o carisma do personagem à equipa criativa. No entanto, quando chega a hora de transformar esse herói num modelo 3D ou numa marionete de animação 2D, perspectivadas dramáticas tornam-se inúteis. Os animadores e modeladores necessitam de um documento técnico rigoroso: o Turnaround (ou Model Sheet).

O Turnaround é a planta baixa ortográfica do personagem, apresentando-o em três vistas retas: Frente, Perfil e Costas. Dois princípios regem este documento:

- A Ditadura das Linhas-Guia (Guidelines): O Turnaround exige

Consistência Volumétrica absoluta. Se o cinto do guerreiro mede 40 píxeis de espessura de frente, terá obrigatoriamente de medir 40 píxeis de lado e de costas. A ponta do nariz de frente tem de bater na mesma linha horizontal da ponta do nariz de perfil.

- A Escolha da Postura: T Pose vs. A Pose:

T Pose: O personagem fica com os braços esticados na horizontal formando uma cruz. Foi o padrão clássico por décadas. A Pose: Uma evolução técnica moderna. Os braços ficam abaixados num ângulo de cerca de 45 graus, formando a letra "A". Esta postura relaxa os músculos trapézios e ombros, facilitando a vida dos modeladores e evitando deformações anatómicas quando o braço se move no jogo.

- O Design Traseiro (Back View): Em jogos de terceira pessoa (Dark Souls,

God of War), o jogador passa cerca de 90% do tempo a olhar para as costas do protagonista. As costas do personagem não podem ser genéricas; o desenho do coldre, da capa, da mochila e dos equipamentos traseiros exige tanta atenção quanto a face.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Construção da malha de Guidelines horizontais e alinhamento ortográfico das vistas de Frente e Perfil em A Pose no Adobe Photoshop.

#### Passo 1 — Configuração do Canvas Panorâmico

- Abra o Photoshop e crie um Canvas largo para abrigar três vistas:

Largura 3000 px, Altura 1200 px, 72 DPI, fundo Branco.

- Nomeie o documento como Turnaround_Heroi_Master .

#### Passo 2 — Construção da Malha de Segurança Guidelines)

- Pressione Ctrl + R para ativar as Réguas (Rulers).

- Clique sobre a régua superior e arraste linhas-guia horizontais para

travar as principais articulações: Linha 1 Topo do Crânio. Linha 2 Linha dos Olhos. Linha 3 Queixo / Base do Pescoço. Linha 4 Ombros. Linha 5 Cintura / Cinto. Linha 6 Linha dos Joelhos. Linha 7 Solo / Base dos Calcanhares.

- Vá em Visualizar > Guias > Bloquear Guias (View > Guides > Lock

Guides) para impedir que se movam por acidente.

#### Passo 3 — A Vista Frontal A Pose

- No lado esquerdo do Canvas, crie uma camada chamada Vista_Frontal .

- Rascunhe o herói olhando diretamente para a câmara.

- Utilize a A Pose: membros inferiores ligeiramente afastados e braços

relaxados a 45 graus do tronco, exibindo palmas abertas.

- Verifique se o topo da cabeça toca a Linha 1 e os calcanhares encostam

exatamente na Linha 7 do solo.

#### Passo 4 — A Vista de Perfil O Desafio do Volume)

- No centro do Canvas, crie uma camada chamada Vista_Perfil .

- Desenhe o mesmo personagem virado 90 graus para a esquerda (visão

lateral).

- Demonstre aos alunos o alinhamento rigoroso: a ponta da bota de perfil

deve assentar na mesma linha do solo; a curvatura do peitoral e o cinto devem encostar milimetricamente nas mesmas linhas horizontais que delimitam a vista frontal.

#### Passo 5 — A Vista Traseira Back View)

- No lado direito, crie a camada Vista_Costas .

- Desenhe o herói de costas, desenhando os fechos da armadura, o

coldre da espada ou mochila utilitária, garantindo a mesma altura dos

ombros e cotovelos.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Planta Baixa 360° do Herói Você deve construir o documento ortográfico oficial Model Sheet) do seu protagonista, estruturando as três vistas técnicas padronizadas Frente, Perfil e Costas) em A Pose, com rigorosa consistência volumétrica controlada por réguas. Checklist do Desafio: Criar um documento largo no Photoshop: 3000 x 1200 px a 72 DPI com fundo neutro claro. Ativar as réguas com Ctrl + R e traçar pelo menos 6 linhas-guia horizontais travando: Topo da Cabeça, Olhos, Ombros, Cintura, Joelhos e Pés. Bloquear as guias no menu para evitar deslocamentos durante o desenho. Desenhar a Vista Frontal à esquerda do Canvas, utilizando obrigatoriamente a A Pose (braços afastados a 45 graus). Desenhar a Vista de Perfil no centro, alinhando a altura do calcanhar, cinto, nariz e topo da cabeça com a vista frontal pelas guias. Desenhar a Vista Traseira Costas à direita, detalhando o design dos equipamentos dorsais (aljavas, capas, fivelas). Confirmar a Consistência Volumétrica: garantir que a espessura de braços, pernas e acessórios não sofre alterações de escala entre as três vistas. Salvar o ficheiro mestre em camadas como Turnaround_ModelSheet_SeuNome.psd.'),
('producao-multimidia-ii','modulo-5','semana-27','Semana 27: Preparação para Cut-out (Rigging 2D) e Boas- Vindas ao Adobe Animate',3,'## Semana 27: Preparação para Cut-out (Rigging 2D) e Boas- Vindas ao Adobe Animate Conteúdos integrados: A Lógica da Animação Cut-out Recortes), Hierarquia Cirúrgica de Camadas, Sobreposição de Juntas Overlap Esférico), Nomenclatura Padrão L/R, O Cockpit do Adobe Animate Stage, Timeline, F5 vs. F6) e a Bouncing Ball.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Até agora, os nossos personagens eram imagens fundidas numa camada única. Se tentar dobrar o cotovelo de uma ilustração achatada, rasgará o peito e o tronco do personagem juntamente com o braço. Na indústria de jogos 2D, redesenhar o personagem quadro a quadro 24 vezes por segundo é extremamente dispendioso. Por isso, o padrão de produção dominante é a animação Cut-out Animação por Recortes). O Cut-out transforma a ilustração numa marionete digital funcional através de duas engenharias:

- Hierarquia e Nomenclatura Cirúrgica: O corpo deve ser fatiado em peças

independentes. Para evitar arquivos com 40 camadas genéricas, usamos a convenção internacional com direção anatómica: Arm_L_Upper Braço Esquerdo Superior), Arm_L_Lower Antebraço), Leg_R_Foot Pé Direito).

> **Atenção:** "L" Left e "R" Right referem-se à esquerda e direita do

personagem, não do ecrã do monitor!

- Sobreposição de Juntas (Overlap Esférico): Se cortar o braço numa linha

reta seca no cotovelo, ao girar a articulação na animação abrir-se-á um buraco vazio feio na carne do personagem. As extremidades das juntas devem terminar numa forma arredondada (esférica), desenhada para se esconder por trás da peça vizinha. Como uma rótula mecânica, a junta pode girar 360 graus sem revelar fendas. O Adobe Animate e a Quarta Dimensão: Para dar vida a essas peças, ingressamos no Adobe Animate. O Animate introduz o Tempo: Palco (Stage): A área central onde a arte é manipulada. Linha do Tempo (Timeline): O painel horizontal dividido em fatias temporais chamadas Quadros (Frames). Quadro Inerte Frame - Atalho F5 Estende o tempo de uma imagem estática na tela. Quadro-Chave Keyframe - Atalho F6 O ponto da timeline onde uma alteração de posição, forma ou rotação acontece.

Taxa de Quadros FPS Projetos em jogos 2D rodam tradicionalmente a 24 FPS ou "animados em dois" 12 poses por segundo com 2 quadros de duração cada), garantindo charme clássico e otimização.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Desmembramento de um braço com Overlap Esférico no Photoshop e introdução ao Adobe Animate com a clássica bola a saltar (Bouncing Ball).

#### Passo 1 — O Fatiamento Cirúrgico e Overlap no Photoshop

- Abra o arquivo do herói no Photoshop.

- Selecione a Ferramenta Laço (L) ou a Caneta (P).

- Contorne o antebraço direito. Corte-o da camada original e cole-o

numa nova camada chamada Arm_R_Lower.

- Observe o buraco que surgiu no cotovelo do braço superior.

- Selecione a camada do antebraço: com o Pincel Duro, desenhe uma

cúpula arredondada (esférica) na ponta do cotovelo que foi cortada.

- Arraste a camada do antebraço para baixo da camada do braço

superior: mostre como a forma esférica esconde a emenda sob o ombro perfeitamente.

#### Passo 2 — Configurando o Palco do Adobe Animate

- Abra o Adobe Animate.

- Clique em Criar Novo (Create New). Escolha a predefinição Full HD

1920 1080.

- No painel de propriedades à direita, confirme a taxa de quadros

(Framerate) para 24 FPS.

- O Palco branco surgirá com uma camada única na Linha do Tempo.

#### Passo 3 — A Bola a Saltar Bouncing Ball em 24 Quadros)

- Selecione a Ferramenta Óvalo (O). Na cor Azul, desenhe um círculo no

topo do Palco.

- Observe a Linha do Tempo: o Frame 1 exibe um pontinho preto sólido,

indicando que já é um Quadro-Chave (Keyframe).

- Clique com o botão esquerdo no Frame 12 na Linha do Tempo.

- Pressione a tecla F6 (o atalho mestre para criar um novo Keyframe).

- Com a ferramenta de Seleção (V), arraste a bola para o fundo do palco,

tocando o piso imaginário.

- Clique com o botão esquerdo no Frame 24 na Linha do Tempo.

- Pressione F6 novamente. Arraste a bola de volta para o topo do palco.

- Pressione a tecla Enter (ou dê Play): a bola move-se entre os três

pontos temporais em exato 1 segundo!

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Dissecação da Marionete e o Primeiro Salto Você irá preparar as partes do corpo do seu protagonista no Photoshop com sobreposição esférica e nomenclatura profissional. De seguida, abrirá o Adobe Animate para dominar a Linha do Tempo através da animação estrutural da bola a saltar. Checklist do Desafio: Etapa Photoshop Preparação Cut-out): Abrir o ficheiro do herói na Vista Frontal. Fatiar o braço e o antebraço em duas camadas distintas com o Laço (L ). Aplicar o Overlap Esférico: pintar um arredondamento curvo na ponta da junta do cotovelo para que não existam cortes retos. Preencher a lateral do tronco que ficou vazia atrás do braço. Aplicar a Nomenclatura Padrão: nomear as camadas com precisão técnica em inglês (Arm_R_Upper, Arm_R_Lower, Torso ). Salvar o ficheiro com as camadas abertas como Heroi_Preparado_Cutout.psd. Etapa Adobe Animate Bouncing Ball): Abrir o Adobe Animate e criar um projeto Full HD a 24 FPS.

Desenhar uma esfera no topo da prancheta no Frame 1. Inserir um Keyframe com F6 no Frame 12 e deslocar a bola para a base da prancheta (o impacto). Inserir um Keyframe com F6 no Frame 24 e retornar a bola ao ponto superior. Pressionar Enter para validar o loop mecânico de 1 segundo. Salvar o arquivo de animação como Exercicio_BouncingBall_SeuNome.fla.'),
('producao-multimidia-ii','modulo-5','semana-28','Semana 28: Rigging 2D no Adobe Animate: Importação de PSD, Símbolos e a Ciência dos Pivôs',4,'## Semana 28: Rigging 2D no Adobe Animate: Importação de PSD, Símbolos e a Ciência dos Pivôs Conteúdos integrados: Importação Direta PSD to FLA, Preservação de Camadas, Símbolo Movie Clip F8, Ferramenta Transformação Livre Q) e Calibração dos Pivôs Articulares.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Com as peças do personagem desmembradas cirurgicamente no Photoshop, precisamos de levá-las para o Adobe Animate e conectar os seus eixos mecânicos. Este processo é chamado de Rigging 2D. O fluxo de trabalho profissional depende de três etapas inquebráveis:

- A Ponte Direta PSD to FLA Não salvamos cada braço ou perna como

imagem.PNG isolada. O ecossistema Adobe conversa nativamente: ao importar o arquivo.PSD diretamente para o palco do Animate, marcamos a opção "Manter camadas do Photoshop" (Maintain Photoshop Layers). O Animate recria instantaneamente toda a estrutura de pastas e camadas com os nomes e posições originais.

- A Conversão Obrigatória em Símbolos F8 O Animate não consegue

interpolar ou girar imagens cruas em pixels (Bitmaps) com fluidez sem sobrecarregar a memória. Cada membro importado deve ser selecionado e convertido num Símbolo de Clipe de Filme (Movie Clip Symbol) através do atalho F8. O Símbolo é um encapsulamento inteligente e leve que o motor do software anima com alto desempenho.

- A Ciência dos Pivôs Ponto de Transformação): Aqui reside o erro mais

crítico de quem inicia no Cut-out. Quando converte um braço em Símbolo, o software posiciona o eixo de rotação (o pequeno círculo branco) no centro matemático geométrico da caixa. Se tentar rodar o braço com o pivô no meio do bíceps, ele girará como uma hélice de helicóptero, descolando- se do ombro e voando pela tela! O corpo humano obedece à anatomia articular: o braço gira a partir da cavidade do ombro; o antebraço gira a partir do cotovelo; a coxa gira a partir da bacia; e o pé gira a partir do calcanhar. Usando a Ferramenta Transformação Livre Atalho Q, devemos reposicionar manualmente esse pequeno círculo branco para o local anatómico exato.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Importação do arquivo PSD fatiado para o Adobe Animate, conversão das peças em Símbolos e calibragem de todos os pivôs articulares do braço e antebraço.

#### Passo 1 — A Importação Avançada do PSD

- No Adobe Animate, abra um projeto Full HD (1920 x 1080 px a 24 FPS ).

- Vá ao menu superior: Arquivo > Importar > Importar para o Palco...

(File > Import > Import to Stage...) e selecione o ficheiro Heroi_Preparado_Cutout.psd.

- Na janela de diálogo que surgir:

Selecione todas as camadas corporais. Na opção de conversão, marque obrigatoriamente: Manter camadas do Photoshop (Maintain Photoshop Layers).

- Clique em Importar. Mostre na Linha do Tempo que cada camada do

Photoshop foi convertida numa camada independente no Animate.

#### Passo 2 — A Conversão em Símbolos F8

- Com a ferramenta de Seleção (V), clique sobre o tronco do herói no

palco.

- Pressione a tecla F8 para abrir a janela "Converter em Símbolo".

- Nomeie como Sym_Torso , defina o Tipo como Clipe de Filme (Movie Clip)

e clique em OK.

- Selecione o braço superior direito e pressione F8; nomeie como

Sym_Arm_R_Upper.

- Selecione o antebraço direito e pressione F8; nomeie como

Sym_Arm_R_Lower.

#### Passo 3 — A Ferramenta Transformação Livre e o Eixo do Pivô

- Selecione o Símbolo do braço superior (Sym_Arm_R_Upper ).

- Pressione a tecla Q para ativar a Ferramenta Transformação Livre

(Free Transform Tool).

- Aponte no projetor a caixa delimitadora com o pequeno círculo branco

repousando no centro geométrico.

- Coloque o cursor sobre as quinas e gire: mostre aos alunos como o

braço voa no espaço de forma antinatural. Dê Ctrl+Z.

#### Passo 4 — Movendo Cirurgicamente o Ponto de Rotação

- Com a ferramenta Transformação Livre (Q), clique diretamente sobre o

pequeno círculo branco central e arraste-o para a extremidade superior do braço, posicionando-o exatamente sobre a junta do ombro.

- Mova o cursor para o canto da caixa e gire o braço: comprove que o

membro agora roda perfeitamente ancorado ao ombro!

- Selecione o antebraço (Sym_Arm_R_Lower ). Pressione Q, pegue no círculo

branco central e arraste-o para o topo da junta esférica do cotovelo.

- Teste a rotação: como desenhou a Sobreposição Esférica (Overlap) no

Photoshop, o antebraço pode dobrar completamente sem que surja uma única falha visual!

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Montagem da Marionete Articular Chegou a hora de estruturar o esqueleto digital Rigging) do seu protagonista. Você importará o arquivo.PSD fatiado para o Adobe Animate, converterá cada parte do corpo em Símbolos individuais e calibrará os eixos de rotação (pivôs) de todas as articulações. Checklist do Desafio:

Abrir um projeto Full HD a 24 FPS no Adobe Animate. Executar o comando Arquivo > Importar > Importar para o Palco selecionando o PSD fatiado do herói. Marcar a opção "Manter camadas do Photoshop" na janela de importação. Organizar as camadas na Linha do Tempo nomeadas em inglês anatómico (Head, Torso, Arm_L_Upper, etc.). Converter cada membro individual num Símbolo de Clipe de Filme com o atalho F8. Ativar a Ferramenta Transformação Livre (Q) para iniciar a calibragem de ancoragem. Reposicionamento dos Pivôs Anatómicos: Cabeça: mover o círculo branco para a base do pescoço. Braços superiores: mover o pivô para a cavidade dos ombros. Antebraços: mover o pivô para o vértice dos cotovelos. Coxas: mover o pivô para as laterais da pélvis/bacia. Pernas inferiores: mover o pivô para o centro dos joelhos. Pés: mover o pivô para os calcanhares. Testar a rotação de cada membro com a ferramenta Q, certificando-se de que nenhuma junta se separa ou quebra a silhueta. Salvar o ficheiro de montagem como Heroi_Rigging_Pronto_SeuNome.fla.'),
('producao-multimidia-ii','modulo-5','semana-29','Semana 29: Princípios Fundamentais e a Animação "Idle" (Estado de Repouso)',5,'## Semana 29: Princípios Fundamentais e a Animação "Idle" (Estado de Repouso) Conteúdos integrados: Timing & Spacing, Squash & Stretch Preservação de Volume), Antecipação Telegraphing), O que é Animação Idle, Mecânica da Respiração, Loop Perfeito e Overlapping Action Atraso.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

A marionete está articulada, mas se o movimento for constante e linear, parecerá feita de plástico oco. Para injetar vida biológica no personagem,

recorremos a três princípios da animação:

- Timing & Spacing A Física do Peso): O Timing é o número de quadros que

uma ação leva para se completar 5 frames = soco rápido; 20 frames = movimento pesado). O Spacing é a distância percorrida entre cada quadro. Pedaços desenhados muito próximos criam desaceleração lenta; pedaços distantes geram sensação de velocidade extrema.

- Squash & Stretch Esmagar e Esticar): Músculos e carne reagem ao

impacto e à gravidade. Ao pular, o corpo estica (Stretch); ao aterrar, comprime-se (Squash). Atenção à Regra de Ouro: O volume total da massa nunca muda; se o corpo esmaga na vertical, tem de alargar na horizontal proporcionalmente!

- Antecipação (Telegraphing): Antes de desferir um soco para a frente, o

corpo puxa o braço e o tronco para trás para acumular energia. No Game Design, a antecipação é uma ferramenta de sobrevivência: é o aviso visual (Telegraphing) que diz ao jogador para desviar. A Animação "Idle" O Batimento Cardíaco do Jogo): O que acontece quando o jogador solta o comando para beber água? Se o avatar congelar no ecrã, parece um jogo avariado. A animação de Idle Estado de Repouso) é um ciclo contínuo em loop que prova que o personagem está vivo, respirando e aguardando ordens. A mecânica base é a respiração: Inspiração: O peito enche-se de ar (estica sutilmente), os ombros sobem e os braços afastam-se ligeiramente. Expiração: O peito murcha (esmaga sutilmente), os ombros caem e os joelhos flexionam suavemente. A Mágica da Ação Sobreposta (Overlapping Action / Atraso): Se o peito, a cabeça e os braços subirem exatamente no mesmo fotograma, o herói parecerá um boneco mecânico de mola. O tronco inicia a subida primeiro; a cabeça, conectada por um pescoço flexível, sofre um atraso intencional de 2 a 3 quadros para atingir o topo. Esse atraso quebra a rigidez e cria a ilusão orgânica de carne e osso. Loop Perfeito: O Frame 1 e o Frame 24 devem ser matematicamente idênticos para que a repetição seja invisível.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Coreografia de um ciclo Idle de respiração orgânica em 24 quadros no Adobe Animate utilizando Overlapping Action na cabeça.

#### Passo 1 — A Pose Base e o Loop Fechado

- Abra o arquivo do herói com o Rigging pronto no Animate.

- No Frame 1, ajuste o personagem numa postura de descanso relaxada

(pernas levemente afastadas, braços ao lado do corpo).

- Selecione todas as camadas no Frame 24 1 segundo completo a 24

FPS.

- Pressione a tecla F6 para criar Keyframes em todas as camadas

idênticos ao Frame 1. O seu loop está matematicamente fechado!

#### Passo 2 — O Ápice da Inspiração Frame 12

- Vá até o Frame 12 (a metade exata da Linha do Tempo).

- Selecione todas as camadas no Frame 12 e pressione F6.

- Selecione a camada do Tronco: com a ferramenta de Transformação

Livre (Q), puxe a caixa delicadamente 2 píxeis para cima.

- Selecione os Símbolos dos ombros e rotacione-os ligeiramente para

trás e para cima.

- Os pulmões do herói estão agora no ponto máximo de expansão de ar.

#### Passo 3 — Injetando a Ação Sobreposta Overlapping Action na Cabeça)

- Mantenha-se no Frame 12: se a cabeça subisse junto com o peito,

estaria no ápice. Mas nós queremos o atraso orgânico!

- Selecione a Cabeça no Frame 12 e rotacione-a levemente para baixo

(como se ainda estivesse "pesada" resistindo à subida).

- Avance dois quadros na Linha do Tempo: vá até ao Frame 14 na

camada da Cabeça.

- Pressione F6 na Cabeça e incline-a para cima, alcançando o topo dois

quadros depois do peito.

#### Passo 4 — Micro-movimentos e Execução

- No Frame 8, rotacione levemente a mão que segura a arma, simulando

um ajuste sutil de empunhadura.

- Pressione a tecla Enter (ou ative o botão de Loop na barra superior da

Timeline).

- Demonstre à turma: a marionete ganha respiração fluida, a cabeça

balança de forma orgânica e o movimento repete-se perpetuamente sem saltos bruscos.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** O Batimento Cardíaco do Personagem Você deve dar fôlego ao seu herói, coreografando o ciclo contínuo de Idle de 24 quadros no Adobe Animate, aplicando a física da respiração, Overlapping Action na cabeça e micro-movimentos secundários em loop perfeito. Checklist do Desafio: Abrir o arquivo de Rigging do herói no Adobe Animate configurado a 24 FPS. Configurar a pose de repouso no Frame 1 em todas as camadas corporais. Criar Keyframes (F6 ) no Frame 24 de todas as camadas copiando a pose inicial para fechar o Loop Perfeito. Inserir Keyframes (F6 ) no Frame 12 (ápice da inspiração): elevar sutilmente o tronco e rotacione os ombros. Aplicar Squash & Stretch sutil: expandir o tórax levemente na inspiração sem distorcer o volume da cabeça. Aplicar a Ação Sobreposta Overlapping Action): atrasar a rotação da cabeça para o Frame 14, fazendo-a responder com atraso à subida do peito. Inserir pelo menos um Micro-movimento secundário (ajustar a arma, balançar a capa ou piscar de olhos) entre os quadros 6 e 18. Ativar a reprodução contínua em loop e verificar se não há "soluços" ou quebras entre o Frame 24 e o Frame 1. Salvar o ficheiro de animação como Heroi_Animacao_Idle_SeuNome.fla.'),
('producao-multimidia-ii','modulo-5','semana-30','Semana 30: A Mecânica da Locomoção: Walk Cycle Completo',6,'## Semana 30: A Mecânica da Locomoção: Walk Cycle Completo Conteúdos integrados: A Física da Queda Controlada, As Quatro Poses Chave Contato, Abaixamento, Passagem e Elevação), A Onda de Altura, Regra da Oposição de Membros, Método da Blocagem Pernas e Bacia Primeiro) e Head Bobbing.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Animar um personagem a caminhar (Walk Cycle) é amplamente reconhecido como o maior teste para um animador. A caminhada humana não é um deslize suave sobre trilhos; é uma queda controlada constante: arremessamos o corpo para a frente perdendo o equilíbrio de propósito e lançamos a perna para nos segurar antes de batermos com o rosto no chão. Para estruturar um Walk Cycle funcional de 24 quadros (dois passos completos em 1 segundo), dominamos as Quatro Poses Chave de Perna:

- Pose de Contato (Contact - Frames 1, 13 e 25 O calcanhar do pé dianteiro

toca o solo e a ponta do pé traseiro deixa a terra. Pernas em abertura máxima (compasso largo). O tronco fica em altura média.

- Pose de Abaixamento (Down / Recoil - Frames 4 e 16 O pé da frente

assenta no chão e recebe todo o peso corporal. O joelho dobra para amortecer o choque (Squash). É a pose mais baixa de todo o ciclo.

- Pose de Passagem (Passing - Frames 7 e 19 A perna de apoio estica-se

sustentando o corpo. A perna de trás levanta e cruza o meio do caminho rente ao solo para avançar. O tronco regressa à altura média.

- Pose de Elevação (Up / High Point - Frames 10 e 22 A perna de apoio

projeta-se na ponta dos pés, empurrando o corpo inteiro para cima (Stretch). É a pose mais alta de todo o ciclo. O personagem quase flutua antes de o calcanhar oposto tocar a próxima pose de contato. A Onda de Altura e a Regra da Oposição: A Onda: Devido à alternância entre o Down (baixo) e o Up (alto), o quadril e a cabeça desenham uma onda senoidal suave subindo e descendo. Sem essa onda, o herói parecerá um fantasma a flutuar. A Regra da Oposição: O corpo compensa o peso. Se a perna direita avança para a frente, o braço direito vai obrigatoriamente para trás e o braço

esquerdo vai para a frente. Animar o braço direito avançando com a perna direita transforma o herói num robô avariado! A Técnica da Blocagem (Blocking): O maior erro do iniciante é tentar mover braços, cabeça e pernas ao mesmo tempo. Na blocagem profissional, ocultamos temporariamente as camadas dos braços e cabeça no software. Construímos e afinamos o ritmo apenas da bacia e das pernas; somente após o peso dos passos estar perfeito é que ligamos os braços e o balanço do pescoço (Head Bobbing).

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Blocagem estrutural das pernas e bacia em 24 frames, seguida da ativação dos braços em oposição e amortecimento da cabeça no Adobe Animate.

#### Passo 1 — O Isolamento das Camadas Blocagem Pura)

- Abra o arquivo do herói no Animate.

- Na Linha do Tempo, clique no ícone do "olho" no topo das camadas

para ocultar a Cabeça, Braços e Acessórios.

- Deixe visíveis apenas o Tronco/Bacia (Torso ) e as duas Pernas (Leg_L ,

Leg_R ).

#### Passo 2 — A Onda Estrutural da Bacia

- No Frame 1 e no Frame 25, marque a altura média da bacia.

- Nos Frames 4 e 16 Pose Down), crie um Keyframe (F6) no tronco e

puxe a caixa para baixo 6 píxeis com as setas do teclado.

- Nos Frames 10 e 22 Pose Up), crie um Keyframe (F6) e empurre o

tronco para cima 6 píxeis acima do nível médio.

- Mostre a Linha do Tempo: o centro de gravidade já desenha a onda de

impacto e impulsão.

#### Passo 3 — Posicionando as 4 Poses Chave de Perna

- Frame 1 Contato): Com a ferramenta Transformação Livre (Q), estique

a perna direita para a frente (calcanhar no chão) e a esquerda para trás (ponta do pé no chão).

- Frame 4 Abaixamento / Down): Dobre o joelho direito para absorver o

impacto; o pé esquerdo descola do solo.

- Frame 7 Passagem): Perna direita reta sustentando o peso; perna

esquerda encolhida cruzando pelo meio.

- Frame 10 Elevação / Up): Pé direito na ponta dos dedos empurrando o

corpo; perna esquerda projetada esticando-se para o ar.

- Frame 13 Segundo Contato): Inverta as pernas: perna esquerda na

frente, perna direita atrás.

- Repita os passos invertidos nos Frames 16, 19 e 22, fechando no Frame

25.

#### Passo 4 — Integrando a Oposição dos Braços e o Head Bobbing

- Torne as camadas dos Braços e da Cabeça visíveis novamente.

- Frame 1 Se a perna direita está na frente, rotacione o braço direito para

trás e o braço esquerdo para a frente Regra da Oposição).

- Frame 13 Inverta o pêndulo dos braços.

- Head Bobbing: No Frame 4 (onde o corpo desceu no Down), não

abaixe a cabeça! Avance para o Frame 6 e, apenas aí, puxe a cabeça para baixo, criando o atraso elástico do amortecedor do pescoço.

- Pressione Play: a marionete caminha com peso, balanço de contrapeso

e atitude natural!

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Engenharia dos Passos Você deve coreografar o ciclo de caminhada (Walk Cycle) completo do seu protagonista em 24 quadros no Adobe Animate, seguindo a metodologia profissional de blocagem: isolar bacia e pernas nas quatro poses fundamentais antes de acoplar os membros superiores. Checklist do Desafio: Abrir o projeto no Adobe Animate com a marionete pronta a 24 FPS.

Ocultar temporariamente as camadas dos braços, acessórios e cabeça na Linha do Tempo. Animar a Onda de Altura da Bacia: marcar a altura média nos Frames 1, 13 e 25; afundar a bacia nos Frames 4 e 16 (Down); elevar a bacia nos Frames 10 e 22 (Up). Construir as Quatro Poses Chave de Perna: Frames 1 e 13 Contato (compasso aberto tocando o solo). Frames 4 e 16 Abaixamento (joelho flexionado absorvendo a carga). Frames 7 e 19 Passagem (perna de apoio esticada, perna livre cruzando o ar). Frames 10 e 22 Elevação (impulso na ponta dos pés, altura máxima). Copiar rigorosamente o Frame 1 no Frame 25 para assegurar o loop contínuo. Tornar visíveis os braços e aplicar a Regra da Oposição: cruzar perna dianteira com braço oposto em amplitude máxima nos contatos. Aplicar o Head Bobbing: atrasar a descida da cabeça em 2 quadros em relação ao impacto do corpo no chão. Flexionar levemente os cotovelos durante a passagem para que os braços não pareçam tábuas retas engessadas. Salvar o arquivo de animação como Heroi_WalkCycle_Completo_SeuNome.fla.'),
('producao-multimidia-ii','modulo-5','semana-31','Semana 31: Polimento (Easing), Animação de Ataque e Exportação para Spritesheet',7,'## Semana 31: Polimento (Easing), Animação de Ataque e Exportação para Spritesheet Conteúdos integrados: Slow In / Slow Out Ease In / Ease Out), Curvas de Interpolação no Animate, Animação de Ação Ataque de Espada), Smear Frames e Exportação de Spritesheet Otimizada PNG Metadados JSON.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

A caminhada está estruturada, mas se o computador mover os membros em velocidade constante, o movimento parecerá rígido e mecânico como um limpador de para-brisas de automóvel. Na natureza, nada atinge a velocidade

máxima no primeiro milissegundo nem para contra uma parede invisível. Entramos na fase de Polimento (Polish). Para quebrar a rigidez matemática, aplicamos o Slow In / Slow Out Ease In e Ease Out): Ease In Aceleração na Saída): O objeto começa devagar, acumulando inércia aos poucos até atingir a velocidade máxima. Ease Out Desaceleração na Chegada): O membro vai perdendo energia de forma suave até parar no ápice do movimento. Controlamos isso no Animate através das propriedades de Easing nas Interpolações Clássicas (Classic Tweens). A Animação de Ataque O Peso da Ação): O combate não é contínuo nem suave; é visceral. O erro do amador é fazer a espada descer linearmente ao longo de 10 quadros, fazendo-a parecer feita de esferovite flutuando na água. Um ataque profissional divide-se em três tempos:

- Antecipação Longa 6 a 10 frames): O herói recua a espada, agacha a

bacia e retém a energia. Cria tensão dramática e telegrafa a ação.

- Explosão do Golpe Apenas 1 a 2 frames): A lâmina cruza todo o ecrã em

um piscar de olhos. Essa disparidade temporal cria o impacto brutal no cérebro do jogador.

- Smear Frame: No quadro do impacto, distorcemos a lâmina desenhando

um rastro curvo elástico que preenche o ar.

- Follow-through e Recuperação 12 a 20 frames): A energia arrasta o herói

para a frente antes de ele recobrar o equilíbrio e voltar ao descanso. A Exportação para Spritesheet A Tira de Cinema do Jogo): Motores como Unity, Godot ou Unreal não rodam o arquivo.FLA. Para manter o jogo a 60 FPS com baixo consumo de memória RAM, empacotamos todos os quadros alinhados lado a lado numa única imagem: a Spritesheet. Essa folha deve respeitar três regras de otimização: Tamanho em Potência de 2 (ex: 2048 2048 px) para leitura eficiente da placa de vídeo. Margem Técnica Padding de 2 a 4 px): Espaço vazio obrigatório entre cada fotograma para evitar o Texture Bleeding (quando píxeis da pose vizinha vazam para o ecrã).

Metadados JSON ou XML O arquivo de texto que informa a engine as coordenadas numéricas exatas de onde cada quadro começa e termina.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Aplicação de Easing no balanço do braço, criação de um ataque com Smear Frame e exportação da Spritesheet final com metadados JSON.

#### Passo 1 — Suavização com Interpolação Clássica e Easing

- No Animate, selecione o braço do personagem entre os Frames 1 e 13

do Walk Cycle.

- Clique com o botão direito entre os Keyframes e selecione Criar

Interpolação Clássica (Create Classic Tween). A linha temporal ficará roxa com uma seta contínua.

- No painel de Propriedades (Properties) à direita, localize a seção

Interpolação (Tweening).

- No campo Efeito (Ease), clique na opção Clássica e insira um valor de

+100 Ease Out).

- Mostre aos alunos como o braço é lançado velozmente e desacelera

organicamente ao atingir a frente.

#### Passo 2 — Coreografando a Explosão do Golpe de Espada

- Crie uma nova cena ou arquivo de ataque a 24 FPS.

- Frames 1 ao 7 Antecipação): Gire o tronco do herói para trás, puxe o

braço armado para o limite extremo nas costas dele e baixe a bacia. Segure a tensão.

- Frame 8 A Explosão Relâmpago): Apenas um quadro depois! Crie um

Keyframe (F6), arremesse o corpo para a frente e estique o braço armado horizontalmente em direção ao alvo.

- O Smear Frame: Desenhe um arco curvo branco/azulado brilhante

conectando a pose do Frame 7 à pose do Frame 8 (o borrão de velocidade da lâmina).

- Frames 9 ao 18 Recuperação): O herói recupera a postura lentamente,

voltando ao estado de repouso.

#### Passo 3 — Exportando a Spritesheet Otimizada

- Selecione toda a sequência da animação finalizada na Linha do Tempo.

- Vá ao menu superior: Arquivo > Exportar > Exportar Folha de Sprite...

(File > Export > Export Sprite Sheet...).

- Na janela técnica de configuração:

Layout: Selecione o formato Grade (Grid). Espaçamento da Borda (Border Padding) e Espaçamento da Forma (Shape Padding): Digite 2 px para eliminar o risco de Texture Bleeding. Tamanho Máximo da Imagem: Ajuste para uma Potência de 2 (2048 x 2048 px ). Formato da Imagem: PNG de 32 bits com Canal Alpha transparente. Formato de Dados (Data Format): Marque JSON Array ou Starling v0.8.

- Clique em Exportar. Mostre a pasta de saída contendo a imagem .PNG

com todos os quadros ordenados e o arquivo.JSON contendo a matemática das coordenadas de corte da engine!

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** O Golpe Mestre e a Entrega para a Engine Você deve aplicar a desaceleração orgânica de Easing na sua marionete, animar um golpe de ataque impactante com Smear Frame e realizar a exportação técnica da Spritesheet pronta para programação em motor de jogo. Checklist do Desafio: Abrir o projeto no Adobe Animate. Selecionar as camadas de membros e aplicar a Interpolação Clássica (Create Classic Tween). Configurar as propriedades de Easing Slow In / Slow Out) no painel de propriedades para quebrar a linearidade mecânica. Coreografar a Animação de Ataque:

Frames 1 a 6 Pose de Antecipação estendida (arma recuada, tensão muscular acumulada). Frame 7 O Golpe Relâmpago disparado em apenas 1 quadro. Desenhar o Smear Frame: criar a mancha gráfica ou arco curvo simulando o rastro de velocidade cortando o ar. Frames 8 a 16 Pose de Follow-through e desaceleração de recuperação. Centralizar o personagem no palco em todos os quadros para evitar deslocamentos indesejados. Executar o comando Arquivo > Exportar > Exportar Folha de Sprite. Configurar a folha em formato Grade, com resolução em Potência de 2 (2048 x 2048 px ) e fundo transparente. Inserir margem de segurança de Padding de 2 a 4 px entre os quadros para prevenir Texture Bleeding. Ativar a exportação de Metadados em formato JSON. Validar a entrega técnica na pasta: confirmar a existência da imagem spritesheet_heroi_ataque.png acompanhada do arquivo de dados spritesheet_heroi_ataque.json.'),
('producao-multimidia-ii','modulo-6','semana-32','Semana 32: A Grade do Mundo, o Grid Map e a Engenharia do 9-Slice',1,'## Semana 32: A Grade do Mundo, o Grid Map e a Engenharia do 9-Slice Conteúdos integrados: Arte Modular, Grid Map Grade de Mapa), Tileset e Tile Mapping, Configuração de Grade e Encaixe Magnético Snap no Photoshop, A Regra das Nove Peças 9 Slice) e a Lógica do Autotiling.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Nos módulos anteriores, focámos a nossa atenção na construção, volumetria e animação da personagem. Agora, é indispensável erguer o palco onde a jogabilidade acontece. Se um artista tentar pintar uma floresta inteira num ficheiro colossal de 20.000 píxeis no Photoshop, o computador sofrerá bloqueios e o motor de jogo não conseguirá carregar a imagem na memória RAM da placa gráfica. Na indústria profissional, nós não desenhamos cenários gigantes contínuos; nós desenhamos blocos de montar. Essa metodologia chama-se Arte Modular: a produção de pequenos módulos visuais repetíveis que podem ser combinados de infinitas maneiras para conceber mundos extensos sem sobrecarregar o hardware. A engenharia modular assenta em três pilares fundamentais:

- O Grid Map Grade de Mapa): Para que as peças se encaixem sem falhas,

o mundo do jogo é estruturado como um tabuleiro de xadrez invisível. Cada quadrado desse tabuleiro segue uma medida matemática fixa em potências de 2 (geralmente $16\times16$, $32\times32$ ou $64\times64$ píxeis). Se o salto do herói percorre a distância exata de dois blocos, toda a arquitetura de plataformas e obstáculos deve respeitar essa métrica.

- O Que é um Tileset? O Tile (ladrilho ou bloco) é a menor unidade visual do

cenário. O Tileset é a folha de imagem única, com fundo transparente, que reúne toda a biblioteca desses blocos desenhados pelo artista (um quadrado de relva, um de terra, um de pedra).

- O Level Designer e o "Carimbo" Tile Mapping): O arquiteto de fases

importa o Tileset para o motor de jogo Unity ou Godot) e utiliza os blocos como almofadas de carimbo digital, pintando centenas de blocos alinhados à grade em segundos. A Regra das Nove Peças 9 Slice) e o Autotiling: Se carimbar apenas um bloco genérico de terra com relva pelo cenário todo, a ilha parecerá recortada com um estilete: as bordas serão secas e sem transição natural para o céu ou água. Para que o terreno pareça orgânico, a indústria recorre ao sistema de 9 Slice Nove Fatias), dividindo a lógica do terreno numa matriz de $3\times3$ blocos: Os 4 Cantos (Corners): Canto Superior Esquerdo, Superior Direito, Inferior Esquerdo e Inferior Direito. As quinas arredondadas da plataforma. As 4 Bordas (Edges): Borda Superior (topo com relva), Inferior (base), Esquerda e Direita (paredes verticais de terra contínua). O 1 Miolo (Center / Filler): O bloco central maciço, 100% terra. Deve ser o mais neutro e limpo possível, pois será o bloco mais repetido para preencher o volume interno do solo. Nos motores modernos, o sistema de Autotiling lê a posição do rato e escolhe sozinho se coloca um canto, uma borda ou o miolo com base no gabarito do 9 Slice desenhado pelo Concept Artist.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Configuração matemática da grade de 32 32 píxeis com encaixe magnético no Photoshop e desenho do gabarito estrutural do 9 Slice de terra e relva.

#### Passo 1 — A Configuração de Preferências da Grade

- Abra o Adobe Photoshop.

- Vá ao menu superior: Editar > Preferências > Guias, Grades e Fatias...

(Edit > Preferences > Guides, Grid & Slices...).

- Na secção "Grade" (Grid):

Defina o campo Linha de Grade a cada (Gridline every) para 32 Pixels. Defina o campo Subdivisões (Subdivisions) para 1.

- Clique em OK.

#### Passo 2 — Ativando a Visão do Tabuleiro e a Trava Magnética

- Crie um novo documento no formato 512 x 512 pixels , 72 DPI , modo de

cores RGB com fundo transparente.

- Vá ao menu Visualizar > Mostrar > Grade (View > Show > Grid) ou use

o atalho Ctrl + ''. O ecrã ficará coberto por uma malha quadriculada onde cada quadrado mede exatamente $32\times32$ píxeis.

- Ative a trava de segurança: aceda a Visualizar > Encaixar Em > Grade

(View > Snap To > Grid). A partir deste momento, qualquer seleção ou desenho será atraído magneticamente pelas linhas da grade, impedindo que a arte vaze para o ladrilho vizinho.

#### Passo 3 — A Demarcação da Matriz 3 3 O Miolo e Bordas)

- Crie uma nova camada chamada Gabarito_9Slice .

- Selecione a Ferramenta Retângulo U .

- No canto superior esquerdo da tela, clique e arraste cobrindo uma área

de exatamente 3 quadrados de largura por 3 quadrados de altura na grade (uma matriz de $3\times3$, totalizando 9 blocos e $96\times96$ píxeis de extensão).

- Preencha essa área sólida com uma cor Castanha Base (#5A381E )

representando a terra bruta.

#### Passo 4 — Esculpindo a Silhueta Externa dos Cantos

- Selecione a Ferramenta Borracha E com ponta dura.

- Aproxime o zoom nos 4 blocos dos cantos extremos Superior

Esquerdo, Superior Direito, Inferior Esquerdo e Inferior Direito).

- Apague os vértices retos de 90 graus dessas quatro quinas externas,

arredondando-as ligeiramente para que a plataforma ganhe uma silhueta orgânica. Mantenha as arestas internas intactas.

#### Passo 5 — A Relva do Topo e Continuidade de Borda

- Crie uma nova camada em modo Normal. Pressione B Pincel Redondo

Duro) com uma cor Verde Vibrante (#389624 ).

- Pinte a relva cobrindo o terço superior dos três blocos da linha superior

Canto Esquerdo, Borda Topo e Canto Direito).

- Faça pequenas irregularidades descendo sobre a terra, assegurando

que o traço da relva no Canto Esquerdo se conecta perfeitamente na mesma altura do bloco da Borda Topo, garantindo a Continuidade de Borda.

- Demonstre aos alunos o quadrado central (o Miolo): ele permanece

puramente castanho, livre de detalhes chamativos, pronto para repetição infinita.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Arquitetura da Grade e a Forja do 9 Slice Hoje atuará como Concept Artist técnico de ambiente. A sua missão é parametrizar o Photoshop para operar com precisão de píxeis na grade de 32 32 com encaixe magnético, e construir a silhueta estrutural de um gabarito de 9 Slice completo para uma plataforma de jogo 2D. Checklist do Desafio: Configurar as Preferências do Photoshop em Editar > Preferências > Guias, Grades e Fatias definindo Linha de Grade a cada 32 pixels e subdivisões em 1. Criar um Canvas de 512 x 512 pixels a 72 DPI com fundo transparente. Ativar a visualização da grade (Visualizar > Mostrar > Grade ). Ativar o encaixe magnético (Visualizar > Encaixar Em > Grade ). Bloquear com a Ferramenta Retângulo uma área de exatamente $3\times3$ ladrilhos $96\times96$ píxeis no total) preenchida com a cor base do terreno (castanho para terra ou cinzento para pedra). Arredondar as quinas externas dos 4 blocos de canto com a Borracha (E ), quebrando a rigidez dos ângulos de 90 graus. Pintar a camada de cobertura superior (relva ou musgo) nos 3 blocos do topo, mantendo a Continuidade de Borda nivelada entre eles.

Preservar o bloco do centro (o Miolo): mantê-lo 100% preenchido com a matéria-prima do solo, sem detalhes chamativos ou fendas isoladas. Salvar o ficheiro de trabalho com as camadas editáveis como Tileset_Gabarito_9Slice_SeuNome.psd.'),
('producao-multimidia-ii','modulo-6','semana-33','Semana 33: Pintura de Terreno Seamless e Iluminação Global do Tileset',2,'## Semana 33: Pintura de Terreno Seamless e Iluminação Global do Tileset Conteúdos integrados: Textura Seamless em Tilesets, Distribuição de Detalhes, Iluminação Global Unificada da Folha, Sobreposição Orgânica Dentes de Relva e Drop Shadow pintada) e o Teste de Clonagem.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Com o gabarito das nove peças bloqueado com cores chapadas, precisamos de pegar nos pincéis digitais e transformar essas formas geométricas num terreno rico, tátil e convidativo. No entanto, pintar um Tileset impõe um desafio rigoroso: a repetição contínua. O bloco central (o Miolo) será carimbado dezenas de vezes lado a lado para formar o chão maciço de cavernas e montanhas. Por essa razão, a sua pintura tem de ser estritamente Seamless Sem Emendas). As duas leis de ouro da pintura de blocos modulares são:

- Distribuição de Detalhes e Preservação de Margens: Se desenhar uma

pedra chamativa ou uma rachadura grossa encostada à borda do seu bloco de $32\times32$ píxeis, no momento em que o ladrilho for clonado no motor de jogo, a pedra surgirá cortada ao meio, criando uma "cicatriz" visual óbvia. Mantenha os detalhes (pequenos grãos de areia, microfissuras) concentrados no centro do bloco, deixando as quatro bordas suaves e neutras.

- A Iluminação Global da Folha: Uma folha de Tileset reúne dezenas de

peças que coexistem na mesma cena. Para que todos os ladrilhos pareçam pertencer ao mesmo universo e não a uma colagem desarticulada, eles devem partilhar a mesma origem de luz. Se o reflexo solar incide no canto superior esquerdo das lâminas de relva, os seixos de terra e as quinas dos blocos vizinhos devem ter os seus brilhos (Highlights) projetados rigorosamente a partir do canto superior esquerdo.

Sobreposição Orgânica e o Teste de Clonagem: A fronteira entre dois materiais (relva e terra) nunca deve ser uma reta perfeita feita com régua. O artista esculpe pequenos "dentes" de relva que invadem o bloco de terra, complementados por uma sombra de oclusão projetada à mão (Drop Shadow) diretamente abaixo da vegetação para criar volume e profundidade. Para validar se o bloco de terra funciona, aplicamos a prova de fogo: o Teste de Clonagem. Copiamos o miolo e colamos cópias acima, abaixo e aos lados; se o olhar detetar uma cruz divisória, a textura falhou e as bordas precisam de ser suavizadas.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Renderização dos volumes de terra e relva do 9 Slice, pintura da sombra projetada sob a vegetação e execução do Teste de Clonagem com a ferramenta Carimbo.

#### Passo 1 — Variação Tonal e Textura no Bloco Central Miolo

- Abra o arquivo do gabarito 9 Slice com a Grade de 32 32 e o Encaixe

magnético ativados.

- Selecione a camada do terreno. Com o Laço Poligonal L , selecione

apenas o quadrado de $32\times32$ píxeis do bloco central (o Miolo).

- Ative o Alpha Lock ou trabalhe dentro da seleção ativa.

- Pressione B e selecione um pincel macio com opacidade em 40%.

- Pinte manchas muito subtis de castanho-escuro e castanho-

avermelhado para simular a umidade da terra seca, sem criar formas geométricas óbvias.

- Com um Pincel Duro fino 2 px , adicione minúsculos pontinhos escuros

simulando grãos de areia concentrados no meio do ladrilho, afastados das bordas de corte.

#### Passo 2 — Esculpindo a Relva Superior e a Sombra Projetada

- Vá até à linha superior de blocos (onde a relva verde repousa sobre a

terra castanha).

- Pressione B Pincel Duro, 2 a 3 px) com cor verde-clara.

- Desenhe pontas irregulares de relva descendo em forma de triângulos

curvos sobre a terra.

- Crie uma camada em modo Multiplicação Multiply) vinculada como

Máscara de Recorte.

- Escolha um Azul-Escuro ou Castanho Profundo. Com o pincel macio

fino, pinte uma linha de sombra projetada (Drop Shadow) contornando exatamente a parte de baixo dos dentes de relva. A relva ganha volume tridimensional e destaca-se da terra.

#### Passo 3 — A Unificação da Iluminação Global

- Defina a regra no quadro: a luz principal incide a partir do canto

superior esquerdo.

- Aplique pequenos reflexos claros (Highlights) na borda superior

esquerda dos tufos de relva e das pequenas pedras do solo.

- Certifique-se de que nenhum bloco possui sombras no topo esquerdo,

assegurando coerência luminosa em toda a folha.

#### Passo 4 — O Teste de Clonagem A Prova de Fogo)

- Selecione a Ferramenta Letreiro Retangular M .

- Enquadre o quadrado de $32\times32$ píxeis do Miolo recém-pintado.

- Copie com Ctrl + C e cole com Ctrl + V.

- Arraste a cópia para uma área vazia da grade ao lado. Cole mais três

cópias, posicionando uma à direita, uma abaixo e uma na diagonal, formando um bloco maior de $64\times64$ píxeis.

- Afaste o zoom com Ctrl + Menos. Aponte no projetor: surge alguma

cicatriz em linha reta dividindo as peças? Se sim, pegue na Ferramenta Carimbo S para atenuar as bordas problemáticas até a emenda desaparecer.

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Pintura do Terreno Orgânico Você deve transformar o gabarito estrutural em blocos de textura rica, renderizando o miolo maciço com encaixe contínuo Seamless), esculpindo a

transição com sombra projetada sob a relva e validando o ladrilho central no Teste de Clonagem. Checklist do Desafio: Abrir o ficheiro Tileset_Gabarito_9Slice com a Grade de 32 32 e o Encaixe magnético ativados. Pintar o bloco do Miolo Center com variações subtis de tom de terra, inserindo pequenas imperfeições com pincéis texturizados. Cumprir a Distribuição de Detalhes: não encostar elementos contrastantes ou pedras nas quatro bordas de corte do quadrado central. Esculpir a Sobreposição Orgânica na linha superior: quebrar a linha reta entre verde e castanho desenhando dentes e tufos de relva. Pintar manualmente a Sombra Projetada (Drop Shadow) numa camada em Multiply logo abaixo das pontas de relva para gerar volume. Aplicar o princípio da Iluminação Global: manter todos os pontos de luz (Highlights) orientados a partir do canto superior esquerdo. Executar o Teste de Clonagem: copiar e empilhar o bloco do Miolo formando uma malha de $2\times2$ blocos adjacentes numa área de teste da tela. Afastar o zoom e inspecionar as junções: confirmar que não há linhas escuras ou falhas denunciando os limites do quadrado. Salvar o ficheiro com as camadas abertas como Tileset_Pintura_Terreno_SeuNome.psd.'),
('producao-multimidia-ii','modulo-6','semana-34','Semana 34: Quebra de Padrão: Tiles de Variação, Decorações (Props) e Exportação',3,'## Semana 34: Quebra de Padrão: Tiles de Variação, Decorações (Props) e Exportação Conteúdos integrados: O Efeito Papel de Parede Grid Repetition), Tiles de Variação Alternate Tiles A, B e C, Preservação de Bordas, Decorações e Props em Canal Alpha, Quebra de Silhueta e Exportação Final do Tileset.

### Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)

#### 1. O Conceito Central (10 Minutos de Teoria)

Pintámos o nosso Tileset respeitando a regra do Seamless. O bloco central agora pode ser clonado dezenas de vezes para erguer o chão sem que linhas de corte denunciem a costura. Contudo, resolvemos um problema técnico e deparamo-nos com uma armadilha visual: o Efeito Papel de Parede (Grid Repetition). O cérebro do jogador é uma máquina programada para reconhecer padrões repetitivos. Se houver uma pedrinha ligeiramente mais clara no seu bloco de terra e esse bloco for carimbado cinquenta vezes para formar uma planície, o jogador verá uma linha diagonal contínua de cinquenta pedrinhas idênticas cruzando o ecrã. A ilusão do mundo quebra-se e o jogo aparenta ser "feito de azulejos plásticos". O segredo do design de cenários profissional não é abandonar a grade, mas sim disfarçá-la. Para devolver naturalidade à paisagem, o Concept Artist produz duas soluções complementares:

- Tiles de Variação (Alternate Tiles): Em vez de entregar apenas um bloco

de solo para o Level Designer, o artista entrega uma família de variações do mesmo bloco: Variação A Neutra/Genérica): A terra padrão já produzida, utilizada em cerca de 70% da área do mapa. Variação B Dano/Fissura): A mesma terra, mas exibindo uma pequena rachadura ou fenda no centro. Variação C Biodiversidade): A mesma terra, com um pequeno tufo de musgo ou seixos escuros incrustados. A Regra Inquebrável da Preservação de Bordas: Ao pintar variações, as quatro margens do quadrado devem permanecer estritamente intocadas e idênticas à Variação A para que o encaixe contínuo Seamless) não seja destruído!

- Decorações e Props A Camada de Vida): Enquanto os blocos de variação

substituem pedaços do piso, os Props (adereços) são elementos desenhados em blocos com fundo 100% transparente (canal Alpha): cogumelos, flores, pedras soltas, caixas de madeira e tufos de relva alta.

- Quebra de Silhueta: Os Props são o recurso visual para quebrar a

linearidade rígida do 9 Slice. Ao carimbar um tufo de relva alta pousado exatamente sobre a borda superior do chão de terra, a relva invade o bloco

de cima (onde está o céu vazio), quebrando a linha reta e trazendo volume e riqueza orgânica à cena.

#### 2. Passo a Passo da Demonstração do Professor 30 Minutos)

**Projeto da demonstração:** Criação de duas variantes do Miolo Fissura e Musgo) com preservação de bordas, desenho de Props de vegetação e montagem de uma ilha de plataforma com quebra de silhueta.

#### Passo 1 — Duplicação e Preservação de Bordas nas Variações

- No Photoshop, selecione o bloco do Miolo original Variação A .

- Copie e cole esse quadrado em dois novos espaços vazios da grade de

32 32 na sua tela, nomeando as camadas como Miolo_Var_B e Miolo_Var_C.

- No Miolo_Var_B : com um pincel fino 1 px preto e castanho, desenhe

uma pequena fissura irregular no centro do bloco. Pinte uma linha clara na borda de baixo da fenda para criar relevo. Aviso: não deixe a fissura tocar nas bordas externas do bloco de 32 píxeis!

- No Miolo_Var_C : desenhe uma mancha de musgo verde no centro da

terra.

#### Passo 2 — Desenhando Props em Blocos com Canal Alpha

- Escolha dois quadrados vazios da grade com fundo 100% transparente.

- No primeiro bloco de $32\times32$ px: com o Pincel Duro, pinte um

pequeno cogumelo vermelho com pintas brancas e base de caule.

- No segundo bloco: desenhe um tufo de relva alta e fina cujas pontas se

projetam para cima.

- Mantenha a mesma origem de iluminação global (luz vinda do canto

superior esquerdo).

#### Passo 3 — A Composição da Cena Quebra de Silhueta em Ação)

- Numa área livre do Canvas, monte uma pequena plataforma suspensa

utilizando o gabarito 9 Slice.

- Substitua dois blocos do miolo neutro pelas Variações B e C salpicadas

de forma assimétrica. A monotonia do chão desaparece.

- Pegue no prop de relva alta e cole-o sobreposto à borda superior da

plataforma.

- Mostre aos alunos como as folhas da relva invadem o ar acima da terra,

mascarando a linha reta matemática da grade e integrando a arte ao ambiente.

#### Passo 4 — Preparação e Exportação do Tileset Final

- Oculte qualquer camada de fundo cinzento ou anotações provisórias,

deixando apenas os ladrilhos e decorações dispostos na grade sobre o fundo xadrez transparente.

- Aceda a Arquivo > Exportar > Exportação Rápida como PNG (File >

Export > Quick Export as PNG).

- Salve com a nomenclatura padrão: tileset_floresta_terra_32px.png . A folha

modular está pronta para ser importada pelo motor de jogo!

### Aula 2: Prática dos Alunos (45 min)

**Missão do aluno:** A Folha Mestra de Cenário Modular Chegou o momento de fechar o Módulo 6 e concluir o ano letivo de PRMU 2. Você deve estruturar uma folha completa de Tileset com resolução padronizada em grade de 32 32 píxeis, composta pelo gabarito de 9 Slice, duas variantes do miolo com preservação de bordas e dois props com canal Alpha para quebra de silhueta. Checklist do Desafio: Abrir o documento do Tileset no Photoshop com a Grade de 32x32 pixels e o Encaixe magnético ativados. Concluir o conjunto base de 9 Slice estruturado 4 Cantos, 4 Bordas e 1 Miolo neutro). Produzir Duas Variações Alternativas do Miolo: Variação B Solo com desgaste, fissura ou pequena pedra central. Variação C Solo com elemento orgânico (mancha de musgo, folhas caídas ou raízes).

Respeitar a Preservação de Bordas: manter as margens externas das variações intocadas para assegurar a textura contínua (Seamless). Criar pelo menos Dois Props de Decoração em células isoladas com fundo 100% transparente (ex: flor silvestre, cogumelo, seixo ou tufo de relva alta). Garantir a Iluminação Global Unificada: todos os blocos e adereços devem partilhar a mesma origem de luz (topo esquerdo). Realizar uma montagem de teste num canto da tela: construir uma plataforma de teste integrando o 9-slice, intercalar as variações de solo e sobrepor um prop na borda superior para demonstrar a Quebra de Silhueta. Limpar a folha: apagar camadas de guias, rasuras ou planos de fundo opacos. Exportar a folha finalizada em formato.PNG com canal Alpha com o nome tileset_bioma_completo_32px_SeuNome.png. Salvar o ficheiro de projeto aberto em camadas como Tileset_Final_SeuNome.psd.')
) insert into public.teacher_guide_chapters (guide_id,slug,title,chapter_order,content_markdown)
select g.id,s.slug,s.title,s.chapter_order,s.content_markdown
from chapter_source s join public.teacher_guides g on g.discipline_slug=s.discipline_slug
join public.modules m on m.id=g.module_id and m.slug=s.module_slug
on conflict (guide_id,slug) do update set title=excluded.title,chapter_order=excluded.chapter_order,content_markdown=excluded.content_markdown,updated_at=timezone('utc'::text,now());
