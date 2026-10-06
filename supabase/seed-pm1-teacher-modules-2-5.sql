-- Cadastro de Módulos II a V de Produção Multimídia I na biblioteca privada do professor.
-- Este conteúdo pertence às tabelas teacher_guides/teacher_guide_chapters, nunca a public.apostilas.
with guide_source(discipline_slug,module_slug,title,source_filename,storage_path,page_count) as (values
('producao-multimidia-i', 'modulo-2', 'Módulo II: Luz, Sombra e a Ilusão do Volume', 'MD2PRMU1.pdf', 'producao-multimidia-i/modulo-2.pdf', 15),
('producao-multimidia-i', 'modulo-3', 'Módulo III: O Espaço Tridimensional e a Figura no Cenário', 'MD3PRMU1.pdf', 'producao-multimidia-i/modulo-3.pdf', 18),
('producao-multimidia-i', 'modulo-4', 'Módulo IV: Composição, Psicologia Visual e Narrativa da Câmera', 'MD4PRMU1.pdf', 'producao-multimidia-i/modulo-4.pdf', 17),
('producao-multimidia-i', 'modulo-5', 'Módulo V: Arte Digital, Teoria da Cor e Pixel Art Vetorial', 'MD5PRMU1.pdf', 'producao-multimidia-i/modulo-5.pdf', 19)
)
insert into public.teacher_guides (discipline_slug,module_id,title,source_filename,storage_path,page_count)
select s.discipline_slug,m.id,s.title,s.source_filename,s.storage_path,s.page_count
from guide_source s join public.modules m on m.discipline_slug=s.discipline_slug and m.slug=s.module_slug
on conflict (discipline_slug,module_id) do update set title=excluded.title, source_filename=excluded.source_filename, storage_path=excluded.storage_path, page_count=excluded.page_count, updated_at=timezone('utc'::text,now());

with chapter_source(discipline_slug,module_slug,slug,title,chapter_order,content_markdown) as (values
('producao-multimidia-i', 'modulo-2', 'semana-7', 'Semana 7: A Física da Luz e o Sombreamento em Blocos (Cel Shading)', 1, 'Semana 7: A Física da Luz e o Sombreamento em
Blocos (Cel Shading)
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Um círculo desenhado na tela não passa de uma moeda achatada até que a luz
revele a sua curvatura. Na arte digital, a sombra nunca é uma camada de tinta
preta jogada por cima da cor; ela é unicamente a ausência de luz onde a massa
do próprio objeto bloqueia a passagem dos raios luminosos.
Para iluminar qualquer elemento de um jogo, o designer precisa definir primeiro
a sua Fonte de Luz (o Sol, uma tocha ou um poste). A física divide a superfície
iluminada em quatro zonas fundamentais:
Luz Plena  Highlight): O ponto exato de impacto frontal da luz,
aproximando-se do branco puro.
Meio-Tom  Midtone): A cor natural da matéria do objeto.
Sombra Própria  Core Shadow): A escuridão no corpo do objeto, no lado
oposto à lâmpada.
Sombra Projetada  Cast Shadow): A silhueta escura que o objeto lança
sobre o chão ou as paredes ao redor.
Em jogos estilizados (como The Legend of Zelda: The Wind Waker ou animes),
não usamos pincéis esfumados; nós desenhamos formas geométricas de cores
sólidas e bordas duras para representar essas zonas. Essa técnica da indústria
chama-se Cel Shading.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Esculpindo uma Esfera Tridimensional  Pokébola
Estilizada) com Construtor de Formas.
Passo 1 — Preparando a Prancheta e a Cor Base

- Abra o Illustrator e crie um novo documento no tamanho padrão 1920 × 1080 pixels.

- Ative a Ferramenta Elipse  L  na barra de ferramentas à esquerda.

- Segure a tecla Shift (para travar as proporções), clique e arraste para
desenhar um círculo central com cerca de 500 px de diâmetro.

- Na barra superior, retire o Traçado  Stroke  deixando-o transparente e
defina o Preenchimento  Fill  com um Vermelho vivo. Esse é o nosso
Meio-Tom.
Passo 2 — Construindo a Sombra Própria sem Usar Pincel

- Com a Seta Preta  V, clique no círculo vermelho, aperte Ctrl + C
(copiar) e depois Ctrl + F (colar exatamente na frente).

- Mantendo a cópia selecionada, arraste-a suavemente para cima e para
a esquerda (assumindo que a lâmpada do cenário está vindo do canto
superior esquerdo).

- Com a Seta Preta  V, selecione os dois círculos juntos.

- Ative o Construtor de Formas  Shift + M.

- Segure a tecla Alt (o cursor exibirá o sinal de subtração) e clique na
parte da esfera copiada que vazou para fora da área original.

- Solte o mouse e selecione a meia-lua que restou na base inferior
direita. Dê dois cliques na cor de preenchimento e escolha um tom de
Vinho ou Vermelho Escuro. A Sombra Própria está perfeitamente
encaixada na curvatura!
Passo 3 — Criando o Brilho Especular  Luz Plena)

- Pegue a Ferramenta Elipse  L.

- Clique e arraste sem segurar o Shift para desenhar uma pequena elipse
oval inclinada no canto superior esquerdo da bola (onde o raio de luz
atinge a carcaça de frente).

- Pinte essa elipse de Branco Puro e retire o traçado.
Passo 4 — Projetando a Sombra no Chão  Oclusão Básica)

- Selecione a Ferramenta Elipse  L  novamente.

- Desenhe uma elipse bem achatada e horizontal logo abaixo da esfera.

- Pinte-a de Cinza Escuro ou Preto.

- Com o botão direito em cima dessa elipse, vá em Organizar > Enviar
para Trás  Arrange > Send to Back) para encaixá-la sob a base da
bola.

- A bola agora possui massa, peso e apoia-se firmemente sobre o chão
virtual.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Fábrica de Orbes Colecionáveis
Crie um item colecionável para um jogo (uma pérola mágica, um ovo de
criatura ou uma bomba esférica) utilizando o método Cel Shading de
sobreposição geométrica pura.
Checklist do Desafio:
Desenhar a esfera base segurando Shift com a cor principal  Meio-Tom).
Duplicar a forma com Ctrl + C e colar no mesmo lugar com Ctrl + F.
Deslocar a cópia na direção oposta à sua luz imaginária.
Usar o Construtor de Formas  Shift + M  segurando o Alt para fatiar e
isolar a meia-lua de sombra.
Pintar a meia-lua com uma tonalidade mais escura da cor base.
Desenhar uma elipse de Luz Plena (brilho branco) no topo iluminado.
Adicionar a Sombra Projetada no solo usando Organizar > Enviar para
Trás.
Salvar o arquivo como SeuNome_Orbe3D_Semana7.ai.'),
('producao-multimidia-i', 'modulo-2', 'semana-8', 'Semana 8: Transições Suaves e Escala Tonal', 2, 'Semana 8: Transições Suaves e Escala Tonal
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
O ilustrador James Gurney, autor de obras clássicas sobre iluminação artística,
explica que a ilusão de tridimensionalidade em superfícies cilíndricas ou curvas
contínuas depende da capacidade de fazer a luz deslizar de forma
imperceptível. No desenho tradicional a lápis, essa transição gradual chama-se
Escala Tonal e é controlada pelo peso do braço no papel.
No computador, o mouse não possui a sensibilidade da mão de um desenhista.
Para gerar transições suaves entre tons claros e escuros, usamos o cálculo
vetorial da ferramenta Degradê  Gradient):
Degradê Linear: A cor caminha em linha reta, perfeito para tubos, armas
afiadas e superfícies cilíndricas.
Degradê Radial: A luz expande-se em círculos a partir de um foco central,
ideal para planetas, joias mágicas e lâmpadas.
A regra de ouro do design digital é: objetos com quinas quebram a luz em
cores chapadas, enquanto objetos cilíndricos e esféricos fazem a luz
escorregar suavemente.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Forjando a Lâmina Iluminada de uma Espada Mágica
com Degradê Linear.
Passo 1 — Desenhando a Geometria da Lâmina

- Pegue a Ferramenta Retângulo  M  e trace uma faixa vertical alta e fina
(ex: 60 px de largura por 600 px de altura).

- Selecione a Ferramenta Caneta  P, aproxime o mouse do centro da
linha do topo superior até surgir um sinal de +  e clique para adicionar
um ponto de ancoragem no meio.

- Troque para a Ferramenta Seleção Direta  Seta Branca - Atalho A,
clique sobre esse novo ponto central e puxe-o cerca de 80 px para
cima, criando a ponta perfurante da lâmina.
Passo 2 — Aplicando o Degradê Linear

- Selecione a lâmina inteira com a Seta Preta  V.

- Pressione o atalho Ctrl + F9 para abrir o painel Degradê  Gradient).

- No painel, clique no primeiro botão: Degradê Linear.

- A lâmina receberá a transição clássica indo do branco para o preto.
Passo 3 — Mapeando a Luz de Aço  Múltiplos Pontos)

- Na barra horizontal de degradê dentro do painel, dê um clique duplo na
bolinha da esquerda e selecione um Azul Claro.

- Dê um clique duplo na bolinha da extrema direita e defina um Azul
Marinho Escuro.

- Clique logo abaixo do meio da barra de degradê para adicionar uma
terceira bolinha de cor (um novo ponto intermediário).

- Defina essa bolinha central como Branco Puro. Arraste-a para perto do
azul escuro para criar a quebra metálica de alto impacto reflexivo.
Passo 4 — O Controle Direcional  A Ferramenta G

- Na barra de ferramentas à esquerda, ative a Ferramenta Degradê
Atalho: letra G.

- Note que uma régua interativa surge desenhada sobre a sua lâmina.

- Clique na borda esquerda da lâmina e arraste o mouse em linha reta na
horizontal até a borda direita.

- O degradê agora cruza o metal lateralmente, transformando a lâmina
retangular em um gume cilíndrico luminoso com reflexo afiado.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Forja do Cristal Energético
Construa um bastão ou cristal reluzente controlando com precisão a direção do
degradê vetorial e os pontos de brilho.
Checklist do Desafio:
Desenhar a silhueta de uma lâmina ou cristal com as ferramentas
geométricas.
Abrir o painel Degradê  Ctrl + F9  e selecionar o modo Linear.
Configurar pelo menos três pontos de cor na barra de degradê  Sombra,
Tom Base e Ponto de Brilho).
Ativar a Ferramenta Degradê  G  na tela e arrastar o cursor para direcionar
a passagem de luz.
Evitar o uso de traçados pretos nas bordas para manter o brilho energético
puro.
Salvar como SeuNome_ArmaMagica_Semana8.ai.'),
('producao-multimidia-i', 'modulo-2', 'semana-9', 'Semana 9: Iluminação Geométrica: O Baú de Tesouro 3D', 3, 'Semana 9: Iluminação Geométrica: O Baú de Tesouro
3D
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
A regra mestra da superfície dita: a geometria do objeto determina como a luz
se comporta. Se uma superfície curva faz a luz deslizar, um objeto composto
por quinas duras de 90 graus quebra a luz bruscamente.
Quando olhamos para um cubo ou baú de suprimentos iluminado por uma
tocha no alto à esquerda, cada parede recebe um degrau de cor
completamente estático:
Tampa Superior  Luz Plena): Apontada diretamente para a lâmpada,
recebe o tom mais claro de todos.
Parede Lateral Esquerda  Meio-Tom): Enxerga a luz em ângulo rasante,
mantendo a cor pura do material.
Parede Lateral Direita  Sombra Própria): Totalmente escondida da fonte de
iluminação, recebe a tonalidade mais escura.
No design volumétrico, não precisamos de modelagem tridimensional pesada.
Três polígonos planos com os tons corretos enganam o olho humano e criam
uma caixa 3D instantânea na tela.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Montando um Baú Cúbico 3D através de Faces e
Degraus de Cor.
Passo 1 — A Silhueta Hexagonal Externa

- Na barra de ferramentas, pegue a Ferramenta Polígono.

- Dê um clique simples no centro da prancheta.

- Digite Raio: 250 px e Lados: 6 para gerar um Hexágono perfeito.

- Com a Seta Preta  V, verifique se o hexágono está orientado com uma
ponta voltada diretamente para cima e uma para baixo.
Passo 2 — Fatiando o Bloco com a Estrutura em "Y"

- Selecione a Ferramenta Caneta  P. Retire o preenchimento e use
traçado preto de 2 pt.

- Clique no ponto de ancoragem do centro exato do hexágono.

- Suba o mouse reto e clique no ponto de ancoragem do topo. Aperte
Enter.

- Clique de novo no centro, puxe uma linha até o vértice inferior
esquerdo e finalize.

- Clique no centro e puxe até o vértice inferior direito. Você desenhou
uma letra "Y" conectando os cantos internos da forma.
Passo 3 — Transformando as Linhas em Paredes com Construtor de
Formas

- Com a Seta Preta  V, selecione o hexágono e as três linhas internas
desenhadas.

- Ative o Construtor de Formas  Shift + M.

- Dê um clique simples no quadrante de cima (a tampa), um no quadrante
esquerdo e um no direito.

- O Illustrator separou o hexágono em três losangos perfeitamente
fechados e independentes!
Passo 4 — Aplicando os Degraus de Cor do Baú

- Com a Seta Preta  V, selecione a face superior (o topo).

- No seletor de cores, escolha um Marrom Madeira Muito Claro (cor de
areia/caramelo).

- Selecione a face esquerda e pinte com um Marrom Médio quente (o
tom original).

- Selecione a face direita e pinte com um Marrom Chocolate Escuro.

- Remova todos os traçados pretos. Em três cliques de cor sólida, o
objeto plano converte-se em um baú cúbico com peso e profundidade
reais!
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Caixa de Suprimentos da Fase
Crie um bloco de suprimentos (caixa de munição, baú espacial ou bloco de
interrogação) aplicando a quebra angular da luz nas três faces expostas.
Checklist do Desafio:
Gerar a base poligonal de 6 lados  Hexágono).
Traçar o "Y" estrutural do centro aos vértices com a Caneta  P.
Converter as áreas em três blocos fechados usando o Construtor de
Formas  Shift + M.
Pintar a face superior com tom alto  Luz Plena).
Pintar a face esquerda com tom médio  Meio-Tom).
Pintar a face direita com tom escuro  Sombra Própria).
Adicionar detalhes nas quinas (como cintas de metal ou travas) respeitando
as cores de cada face.
Salvar como SeuNome_Bau3D_Semana9.ai.'),
('producao-multimidia-i', 'modulo-2', 'semana-10', 'Semana 10: Cores, Atmosfera e Iluminação Estilizada', 4, 'Semana 10: Cores, Atmosfera e Iluminação Estilizada
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
A luz não apenas revela formas; ela dita a emoção psicológica da cena. Em
produções multimídia, o Diretor de Arte usa a atmosfera para avisar o jogador
se um lugar é aconchegante ou assustador:
Luz Solar Quente  Dia
-  Cores amarelas e alaranjadas na luz, com sombras
levemente azuladas (refletindo o céu aberto). Passa sensação de aventura,
segurança e clareza.
Luz Noturna Fria  Noite
-  A cena é dominada por azuis marinhos e cianos,
com sombras quase pretas. Transmite sigilo, tensão ou perigo iminente.
Outro fenômeno físico essencial é a Luz Rebatida  Bounce Light): quando a luz
atinge o solo brilhante, ela quica para cima e mancha a parte de baixo do
objeto com a cor do chão. Se uma caixa de metal repousa sobre a grama
verde, a base da sombra dela deixará de ser preta e ganhará um reflexo
esverdeado sutil.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Mudando o Clima e Integrando o Baú da Semana
Anterior ao Cenário  Dia vs. Noite).
Passo 1 — Construindo o Cenário Minimalista

- Com a Ferramenta Retângulo  M, desenhe um bloco cobrindo a
metade de cima da prancheta (será a parede ou o céu). Pinte de Azul
Noturno Profundo.

- Desenhe outro retângulo cobrindo a metade inferior (o chão). Pinte de
Roxo Escuro ou Verde Musgo.

- Copie o baú tridimensional feito na Semana 9 e cole-o no meio da tela,
pousado sobre a linha do solo.
Passo 2 — Integrando as Faces à Atmosfera Noturna

- Como a cena se passa à noite, o topo do baú não pode continuar com
amarelo solar radiante.

- Selecione a tampa superior: mude a cor para um tom Azul Claro Lavado
(luz do luar).

- Selecione a parede esquerda: aplique um Azul Petróleo intermediário.

- Selecione a parede direita (sombra total): escureça para um Azul
Marinho quase preto. O baú agora absorveu a temperatura de cor do
ambiente.
Passo 3 — A Luz Rebatida do Chão  Bounce Light)

- Selecione a face lateral direita (a parede escura do baú).

- No painel Degradê  Ctrl + F9, aplique um Degradê Linear na vertical
(de baixo para cima).

- Na bolinha do topo do degradê, mantenha o Azul Marinho da sombra.

- Na bolinha da base do degradê, escolha a mesma cor do chão (o Verde
Musgo).

- Veja o solo verde "quicar" a sua luminosidade e tingir sutilmente a quina
inferior do baú. O objeto funde-se visualmente ao chão e deixa de
parecer um adesivo solto na tela!
Passo 4 — Sombra de Contato com Modo de Mesclagem  Multiply)

- Pegue a Ferramenta Elipse  L  e trace uma elipse fina e achatada logo
abaixo da base do baú.

- Pinte essa elipse de preto sólido.

- Vá ao menu superior em Janela > Transparência  Window >
Transparency).

- No menu suspenso onde está escrito Normal, mude para Multiplicação
Multiply) e baixe a Opacidade para 70%.

- O preto funde-se com as cores do piso, criando a Oclusão Ambiental
(sombra de contato realista).
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Troca de Clima  Versão Solar e Versão Mística)
Duplique um objeto cúbico ou esférico e aplique esquemas de cores
contrastantes para representar dois horários completamente diferentes: o
Meio-Dia Desértico e a Noite Mística.
Checklist do Desafio:
Desenhar fundos retangulares dividindo céu e solo.
Ajustar as faces do objeto para harmonizar com as cores da luz ambiente
de cada cenário.
Inserir Luz Rebatida  Bounce Light) na base sombreada com degradê linear
contendo a cor do solo.
Aplicar sombra projetada no piso com modo de transparência em
Multiplicação  Multiply).
Apresentar lado a lado o asset iluminado pelo Sol e pela Lua.
Salvar como SeuNome_Atmosfera_Semana10.ai.'),
('producao-multimidia-i', 'modulo-2', 'semana-11', 'Semana 11: Texturas Estilizadas: A Madeira e o Metal', 5, 'Semana 11: Texturas Estilizadas: A Madeira e o Metal
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Apenas o volume não revela a matéria de que o objeto é feito: aquela esfera
desenhada é uma bola de bilhar lisa ou uma pedra rústica de mina? O olho
humano consegue sentir as características de um material pela forma como a
luz reage contra a superfície (fenômeno conhecido como Sinestesia Visual):
Superfícies Duras e Polidas  Metal
-  O metal atua como um espelho limpo.
A luz bate e reflete quase que imediatamente para o jogador, criando o Alto
Contraste: brilhos brancos puros colados em sombras escuras, sem meio-
termo demorado.
Superfícies Rústicas e Orgânicas  Madeira): A madeira cresceu na
natureza de forma caótica, possuindo veios ondulados e pequenos buracos
(os nós). Cada rachadura cria uma pequena sombra própria de um lado e
uma linha de luz do outro, conferindo a sensação de relevo tátil.
No Illustrator, nós não precisamos de texturas fotográficas pesadas. Usamos
linhas soltas e contrastes pontuais para criar a estética Cartoon perfeita.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Forjando um Escudo Viking Combinando Tábua de
Madeira e Aro de Metal.
Passo 1 — A Prancha de Madeira Rústica

- Selecione a Ferramenta Retângulo  M  e desenhe uma barra vertical
larga.

- Pinte com um Marrom Quente (cor de caramelo sólido).

- Dê dois cliques na Ferramenta Lápis  N  na barra à esquerda. Na janela
de configurações, arraste o controle deslizante de Fidelidade
Smoothness) para o máximo à direita e clique em OK (isso faz o
Illustrator corrigir tremores da mão e arredondar suas linhas
automaticamente).
Passo 2 — Entalhando os Veios e Nós da Madeira

- Mude a cor do seu Lápis para traçado Marrom Escuro com 2 pt de
espessura e preenchimento vazio.

- No centro da tábua, desenhe uma pequena forma oval torta (o nó da
árvore).

- Agora desenhe linhas verticais onduladas de cima a baixo na tábua,
fazendo com que as linhas se curvem e desviem do nó central.

- O Truque do Relevo: Troque a cor do traçado para um Bege Muito Claro
(quase amarelo). Desenhe linhas curtas coladas logo abaixo das linhas
escuras que você acabou de fazer. A linha clara funciona como a quina
da fenda recebendo luz, criando relevo 3D imediato!
Passo 3 — A Borda Refletiva de Metal  Aro de Proteção)

- Pegue a Ferramenta Retângulo  M  e desenhe uma faixa horizontal
cruzando a base da tábua (a cinta de metal).

- Abra o painel Degradê  Ctrl + F9  e escolha o modo Linear.

- Crie a sequência clássica de alto contraste metálico: Cinza Escuro >
Branco Puro > Cinza Médio > Preto > Cinza Claro.

- Note como a aproximação brusca do branco puro com o preto fosco faz
a peça reluzir como prata polida instantaneamente!
Passo 4 — Os Rebites de Aço  Parafusos)

- Pegue a Ferramenta Elipse  L  e, segurando o Shift, faça um círculo
minúsculo sobre a chapa de metal.

- Aplique um Degradê Radial com o centro branco puro e a borda cinza
escura.

- Com a Seta Preta  V, segure a tecla Alt e arraste o círculo para
duplicar três rebites ao longo da faixa de aço.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: O Arsenal dos Dois Materiais
Desenhe um item de cenário ou equipamento (um barril pirata, um baú rústico
reforçado ou um martelo de guerra) combinando a textura orgânica da madeira
com o reflexo de alto contraste do metal.
Checklist do Desafio:
Configurar a suavidade da Ferramenta Lápis  N  no painel de opções.
Desenhar veios ondulados e pelo menos um nó de madeira com traçado
escuro.
Aplicar o traço claro de relevo para conferir profundidade tátil às
rachaduras.
Construir elementos de metal usando degradê linear de múltiplos pontos
contrastantes.
Inserir detalhes metálicos como rebites esféricos com degradê radial.
Salvar como SeuNome_MadeiraMetal_Semana11.ai.'),
('producao-multimidia-i', 'modulo-2', 'semana-12', 'Semana 12: Avaliação de Domínio do Módulo 2', 6, 'Semana 12: Avaliação de Domínio do Módulo 2
Aula 1: Prova Teórica Objetiva (45 min)

- De acordo com os fundamentos da física da iluminação visual, como
definimos a sombra em um objeto 2D ou 3D?
a) Uma tinta preta opaca adicionada por cima da cor original.
b) Uma falha gráfica gerada pelo monitor do computador.
c) A ausência natural de raios de luz provocada pelo bloqueio da massa
do próprio objeto.
d) Um gradiente que só pode ser aplicado em superfícies
transparentes.

- Qual é a principal característica visual da técnica de sombreamento
estilizado conhecida como Cel Shading?
a) Uso exclusivo de texturas fotográficas desfocadas.
b) Sombreamento construído através de blocos geométricos de cores
sólidas e bordas nítidas, sem efeito borrado.
c) Imagens compostas apenas por linhas pretas e folhas em branco.
d) Desenhos feitos exclusivamente com a ferramenta de caneta sem
preenchimento.

- Para criar a ilusão de volume tridimensional em um cubo simples, de que
forma as três faces visíveis devem ser coloridas?
a) Todas com o mesmo degradê radial esfumado no centro.
b) Com cores sólidas diferentes respeitando a luz: tampa clara  Luz,
face em ângulo média  Meio-Tom) e face oposta escura  Sombra.
c) Totalmente pintadas de cinza fosco sem contraste.
d) Com contornos pretos muito grossos e centros vazios.

- O que é a "Luz Rebatida"  Bounce Light) e qual a sua função na pintura
digital de cenários?
a) Um tipo de lâmpada que pisca dentro de jogos de terror.
b) O feixe de luz que bate no chão, reflete de volta e colore a área
sombreada da base do objeto com o tom do piso, integrando-o ao
ambiente.
c) A sombra de contato mais escura existente no ponto em que dois
objetos se encostam.
d) A ferramenta que serve para aumentar o tamanho do desenho na
tela.

- Como o design vetorial representa visualmente o acabamento polido de um
metal reluzente?
a) Aplicando degradê suave composto apenas de tons de cinza muito
próximos.
b) Desenhando veios irregulares e nós circulares na madeira.
c) Utilizando o Alto Contraste: colocando pontos de brilho branco puro
imediatamente colados em sombras escuras na barra de degradê.
d) Diminuindo a opacidade da forma para zero no painel de
transparência.
Aula 2: Prova Prática no Laboratório (45 min)
Enunciado do Desafio Prático: O Baú Relíquia do Explorador
O estudante deverá criar um prop volumétrico completo (um baú mágico, caixa
de munição sci-fi ou santuário) pousado sobre um piso de cenário, aplicando
todas as regras de volume, texturas e integração de iluminação desenvolvidas
ao longo do Módulo 2.
Requisitos Obrigatórios para Avaliação:

- Estrutura Volumétrica Clara: O objeto central deve possuir leitura
tridimensional nítida dividida em faces angulares ou curvaturas anatômicas
Luz Plena, Meio-Tom e Sombra Própria).

- Tratamento de Superfícies: É obrigatório demonstrar o domínio de pelo
menos dois materiais distintos na mesma peça (exemplo: corpo feito em
madeira estilizada com tramas do Lápis e cintas/fechaduras com alto
contraste metálico em Degradê Linear).

- Integração Atmosférica com o Cenário: A peça não pode flutuar no vazio.
Deve estar apoiada sobre um plano de chão e conter:
Sombra projetada no piso configurada em modo Multiplicação
Multiply) no painel de transparência.
Luz Rebatida (Bounce Light) aplicada na base sombreada carregando o
tom do piso.

- Higiene Vetorial: Sem arestas soltas ou excesso de traçados pretos
pesados que prejudiquem a leitura da escala tonal.
Entrega: O arquivo deve ser salvo obrigatoriamente como
Prova_M2_NomeDoAluno.ai  e disponibilizado na pasta compartilhada da turma antes
do término da aula.'),
('producao-multimidia-i', 'modulo-3', 'semana-13', 'Semana 13: Matemática do Espaço (1 Ponto): O Quarto do Jogador', 1, 'Semana 13: Matemática do Espaço (1 Ponto): O
Quarto do Jogador
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Para transformar uma tela bidimensional e plana num espaço profundo onde
um herói possa caminhar, recorremos à Perspectiva Linear, fórmula
matemática redescoberta pelos mestres do Renascimento. O alicerce de
qualquer ambiente nasce de dois elementos essenciais:
Linha do Horizonte  LH
-  Não representa o limite entre o mar e o céu, mas
sim a altura exata dos olhos do observador ou a lente da câmera do jogo.
Se a desenharmos baixa na tela, criamos a sensação de olhar para cima
(visão inferior); se for posicionada no topo, o espectador observa o chão
de cima (visão aérea).
Ponto de Fuga  PF
-  Fica cravado sobre a Linha do Horizonte e atua como
um ímã magnético invisível que suga todas as linhas de profundidade da
cena.
Na Perspectiva de 1 Ponto de Fuga, olhamos para a arquitetura totalmente de
frente. O sistema obedece a duas regras inquebráveis:

- Regra Frontal: Paredes e objetos virados de frente não entortam; utilizam
apenas linhas 100% horizontais e 100% verticais.

- Regra da Profundidade: Todas as quinas que "entram" no cenário (rodapés,
quinas de teto) são traçadas apontando obrigatoriamente para o Ponto de
Fuga central.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Construção da Estrutura Base de um Quarto com
Piso em Profundidade no Illustrator.
Passo 1 — Preparando a Prancheta e as Réguas

- Crie um documento no Illustrator no tamanho padrão 1920 × 1080
pixels.

- Ative as réguas pressionando Ctrl + R.

- Clique na régua horizontal superior, arraste o cursor até a metade da
altura da tela (Y  540 px) e solte: você acabou de posicionar a Linha do
Horizonte  LH.

- Clique na régua vertical esquerda e puxe outra linha guia até o centro
horizontal da tela (X  960 px). O cruzamento exato dessas duas guias
marca o seu Ponto de Fuga  PF.
Passo 2 — A Parede do Fundo  Regra Frontal)

- Selecione a Ferramenta Retângulo  M.

- Com o traçado preto de 2 pt e preenchimento vazio, desenhe um
retângulo centralizado ao redor do Ponto de Fuga (ex: 800 px de
largura por 500 px de altura).

- As quatro arestas desta parede são retas: o teto e o chão do fundo são
horizontais puros, e as paredes laterais são verticais puras.
Passo 3 — Esculpindo Chão, Teto e Paredes Laterais

- Selecione a Ferramenta Caneta  P.

- Dê um clique simples no Ponto de Fuga  PF  no centro.

- Puxe a linha passando exatamente pelo vértice superior esquerdo do
retângulo e estique o traço até o canto extremo superior da prancheta.

- Repita esse procedimento nos outros três vértices: superior direito,
inferior esquerdo e inferior direito.

- O "X" gerado divide a tela em quatro planos imediatos: o teto no topo, o
piso na base e as duas paredes laterais em profundidade.
Passo 4 — O Piso em Perspectiva  Linhas de Convergência)

- Na base inferior da prancheta (borda do chão), marque pequenos
pontos de apoio a cada 150 px com a Caneta ou Segmento de Linha.

- Conecte cada uma dessas marcações ao Ponto de Fuga central.

- Trace linhas horizontais paralelas cortando esse feixe de retas: a
primeira linha perto da câmera deve ter um espaçamento largo; as
próximas devem ficar progressivamente mais juntas e achatadas
conforme se aproximam da parede do fundo. O piso quadriculado recua
com ilusão de distância real.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Caixa de Areia 3D
Estruture o esqueleto arquitetônico de uma masmorra ou quarto utilizando 1
Ponto de Fuga com alinhamento rigoroso.
Checklist do Desafio:
Ativar réguas (Ctrl + R) e posicionar a Linha do Horizonte no centro da
prancheta.
Marcar o Ponto de Fuga com o cruzamento de guias.
Desenhar o retângulo frontal da parede do fundo com linhas estritamente
horizontais e verticais.
Conectar as quatro quinas do retângulo ao Ponto de Fuga para revelar teto,
chão e paredes.
Traçar o piso em leque convergindo para o centro, reduzindo o
espaçamento das linhas horizontais em profundidade.
Salvar o arquivo como SeuNome_Quarto1PF_Semana13.ai.'),
('producao-multimidia-i', 'modulo-3', 'semana-14', 'Semana 14: Volume Interno: Mobiliando o Quarto', 2, 'Semana 14: Volume Interno: Mobiliando o Quarto
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Móveis, baús e equipamentos dentro de um ambiente não são planos; eles
ocupam massa física. Na indústria de desenvolvimento, todo modelo 3D
começa com o conceito de Bounding Box (caixa delimitadora): o prisma
geométrico básico que envelopa o objeto antes de desenharmos os detalhes.
Para mobiliar um espaço em perspectiva frontal:
A face do móvel que está voltada diretamente para o jogador permanece
reta e sem distorção (largura e altura puras).
O tampo e as laterais que recuam em direção ao fundo da sala devem ser
projetados com a régua apontando para o mesmo Ponto de Fuga das
paredes.
Volume e Espessura: Para abrir portas ou gavetas numa parede lateral,
quebramos a diagonal puxando linhas horizontais puras para dentro do
ambiente, revelando a espessura da alvenaria ou da madeira.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Inserindo uma Cama e uma Mesa de Trabalho
Encostadas nas Paredes do Quarto.
Passo 1 — Desenhando a Frente da Cama  Bloco Inicial)

- No arquivo do quarto estruturado na semana anterior, escolha o canto
inferior esquerdo do chão.

- Com a Ferramenta Retângulo  M, desenhe um retângulo baixo e largo
encostado no piso.

- Esta forma representa a "peseira" da cama voltada de frente para o
observador.
Passo 2 — Puxando a Profundidade para o Ponto de Fuga

- Ative a Ferramenta Caneta  P  ou a Ferramenta Segmento de Linha ().

- Clique no canto superior esquerdo da peseira da cama e trace uma reta
até o Ponto de Fuga  PF.

- Clique no canto superior direito da peseira e puxe outra reta até o
Ponto de Fuga  PF.

- Repita o processo no canto inferior direito da base da cama.
Passo 3 — Cortando o Comprimento do Colchão

- Decida onde a cabeceira da cama vai terminar ao encostar na parede
de trás.

- Pegue a Caneta  P  e trace uma linha perfeitamente horizontal unindo
as duas retas guias superiores.

- A partir do ponto final dessa horizontal, desça uma linha perfeitamente
vertical até encontrar a linha guia da base do chão.

- Use a Ferramenta Tesoura  C  ou delete os excessos das linhas que
continuavam até o Ponto de Fuga. A cama ganhou um bloco 3D sólido
de descanso.
Passo 4 — Escavando uma Porta com Espessura na Parede Direita

- Na parede lateral direita, trace duas retas verticais com a Caneta  P
para delimitar a largura da porta.

- Conecte o topo da primeira vertical ao Ponto de Fuga para definir o teto
da porta em declive suave.

- A Espessura: A partir do vértice superior da porta, puxe uma pequena
reta horizontal para a direita (entrando na parede). Desça uma vertical
interna fechando a quina. A alvenaria deixa de ser uma folha fina de
papel e ganha profundidade arquitetônica.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: O Quarto Mobiliado
Insira pelo menos dois móveis volumétricos (cama, estante, mesa ou baú) e
uma abertura estrutural (porta ou janela) no quarto.
Checklist do Desafio:
Desenhar a face frontal do primeiro móvel no chão com linhas horizontais e
verticais.
Projetar as arestas superiores em direção ao Ponto de Fuga.
Fechar a tampa e as laterais do móvel com linhas alinhadas aos eixos
horizontal e vertical.
Apagar linhas de construção estruturais que ficariam invisíveis por trás do
móvel.
Criar uma porta ou janela na parede lateral com linhas de recuo horizontal
para simular espessura.
Salvar como SeuNome_QuartoMobiliado_Semana14.ai.'),
('producao-multimidia-i', 'modulo-3', 'semana-15', 'Semana 15: Proporção Estilizada: O Estilo Chibi / Cartoon', 3, 'Semana 15: Proporção Estilizada: O Estilo Chibi /
Cartoon
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Na arte tradicional clássica, o corpo humano heroico obedece ao cânone das 8
cabeças (o corpo mede a altura de oito vezes o crânio). Embora esse padrão
crie deuses imponentes nos quadrinhos, ele impõe regras rígidas e engessadas
para quem está começando.
No universo dos games e da animação moderna, a linguagem mais acessível e
carismática é a Estilização por Proporção:
Proporção Realista  7 a 8 Cabeças): Membros longos, tronco pesado e
cabeça pequena.
Estilo Cartoon / Chibi  2 a 3 Cabeças): A cabeça gigante ocupa metade ou
um terço da altura total do personagem.
Ao reduzirmos o corpo para 2 ou 3 cabeças, eliminamos a necessidade de
decorar dezenas de músculos complexos. O foco visual é direcionado para a
expressão dos olhos, a silhueta das roupas e a fofura (appeal) da figura,
criando personagens amigáveis semelhantes aos de Animal Crossing ou Zelda:
Link''s Awakening.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Construção da Estrutura de um Herói Chibi de 2
Cabeças e Meia.
Passo 1 — O Gabarito de Altura  Empilhando Cabeças)

- Na prancheta do Illustrator, ative a Ferramenta Elipse  L.

- Segure o Shift, clique e arraste para desenhar um círculo perfeito de
150 px. Este círculo representa a unidade de medida: 1 Cabeça.

- Com a Seta Preta  V, segure Alt + Shift e arraste o círculo para baixo
duas vezes seguidas para formar uma coluna de 3 círculos alinhados.

- Bloqueie esses círculos de guia pressionando Ctrl + 2.
Passo 2 — O Crânio e o Rosto  Cabeça 1

- Pegue a Ferramenta Elipse  L  e desenhe uma forma oval larga
preenchendo o primeiro círculo-guia.

- Com a Ferramenta Seleção Direta  Seta Branca - Atalho A, selecione
o ponto de ancoragem inferior da elipse e puxe-o suavemente para
baixo para formar as bochechas volumosas.

- Desenhe dois olhos ovais grandes na metade inferior do rosto (olhos
baixos conferem aspecto infantil e amigável).
Passo 3 — Tronco e Bacia  A Cabeça 2

- No espaço do segundo círculo-guia, use a Ferramenta Retângulo
Arredondado para fazer um tronco pequeno em formato de feijão ou
trapézio suave.

- O tronco Chibi não tem peitoral dividido: ele se parece com uma
coxinha ou gota arredondada virada para baixo.

- A virilha e a linha dos pulsos encerram-se na transição para a terceira
cabeça.
Passo 4 — Membros Simples e Tubulares  Cabeça 3

- Desenhe as pernas como cilindros curtos e gordinhos.

- Os pés dispensam detalhes anatômicos individuais de dedos: desenhe
pequenas formas ovais horizontais atuando como sapatos de desenho
animado.

- Ligue os braços com cilindros simples que descem do ombro até a
altura da bacia.

- Desbloqueie o gabarito (Ctrl + Alt + 2) e delete as esferas de marcação
iniciais. O herói estilizado está equilibrado e estruturado.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: Criando o Herói Mascote
Construa um personagem original (um aventureiro, mago ou guerreiro espacial)
utilizando o gabarito de proporção reduzida de 2 a 3 cabeças.
Checklist do Desafio:
Desenhar a régua de 2 ou 3 cabeças empilhadas como gabarito de escala.
Bloquear a camada de guia com Ctrl + 2.
Construir a cabeça volumosa ocupando o módulo superior com olhos
baixos e expressivos.
Desenhar o tronco simplificado em bloco único no módulo intermediário.
Estruturar pernas e braços tubulares curtos respeitando a base do gabarito.
Adicionar adereços simples (capa, chapéu ou cinto) sem quebrar a silhueta
principal.
Salvar como SeuNome_HeroiChibi_Semana15.ai.'),
('producao-multimidia-i', 'modulo-3', 'semana-16', 'Semana 16: A Alma do Movimento: Poses de Ação', 4, 'Semana 16: A Alma do Movimento: Poses de Ação
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
A geometria confere solidez a um personagem, mas sem dinamismo ele
parecerá um manequim travado numa vitrine. Para dar vida e movimento aos
personagens, estúdios de arte e animação utilizam o Desenho Gestual
Gesture Drawing).
O objetivo não é desenhar olhos, dedos ou dobras de camisa, mas sim capturar
o "verbo": a força do movimento.
Linha de Ação: Uma curva mestra invisível (em formato de "C" ou "S") que
corta o personagem da cabeça até a ponta do pé de apoio. Linhas 100%
retas representam rigidez e imobilidade; curvas fortes representam tensão,
impacto e velocidade.
Oposição de Ombros e Bacia: Em uma pose natural, a linha dos ombros e a
linha da cintura quase nunca estão paralelas. Se o ombro inclina para a
direita, a bacia compensa inclinando para a esquerda, distribuindo o peso
do corpo dinamicamente.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Capturando a Linha de Ação e Estruturando uma
Pose de Corrida/Ataque.
Passo 1 — Encontrando a Linha de Ação  A Curva Mestra)

- Abra uma fotografia de atleta ou herói saltando como referência.

- Com a Ferramenta Pincel  B  ou a Caneta  P  configurada com traçado
vermelho suave, trace um único arco longo que atravesse todo o
movimento.

- Note como a curva impulsiona a intenção: se o herói desfere um golpe,
a curva projeta o peito para a frente sustentando o impacto.
Passo 2 — Marcando as Linhas de Inclinação  Ombros e Pélvis)

- Sobre a Linha de Ação, trace uma linha reta diagonal curta para definir
o eixo dos ombros.

- Mais abaixo, trace outra diagonal inclinada no sentido oposto para a
linha da cintura.

- Essa torção de eixos rompe o aspecto robótico e transmite equilíbrio
cinético.
Passo 3 — Manequim Gestual com Formas Soltas

- Adicione a esfera da cabeça inclinada acompanhando a direção do
olhar.

- Desenhe a caixa torácica e a bacia como duas massas conectadas por
uma coluna flexível.

- Lance arcos rápidos para indicar a trajetória do braço armado e da
perna esticada.
Passo 4 — Finalização Rápida de Silhueta

- Baixe a opacidade do esqueleto para 30%.

- Crie uma nova camada por cima e engrosse a forma com volumes
musculares ou roupas simplificadas, sem perder a linha mestra que
gerou a pose.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Sessão de Poses Rápidas  Ritmo de 2 Minutos)
A turma participará de uma dinâmica de esboços ágeis: o professor projetará
fotografias dinâmicas com tempo controlado de 2 minutos por pose para
destravar o traço e priorizar a ação sobre o detalhe.
Checklist do Desafio:
Primeiros 20 segundos: Traçar uma única Linha de Ação em curva ("C" ou
"S") representando a força do movimento.
Próximos 30 segundos: Inclinar os eixos de ombros e quadril em direções
contrastantes.
Últimos 70 segundos: Posicionar cabeça e cilindros básicos dos braços e
pernas ao longo das linhas-guia.
Evitar rabiscos curtos e picotados com o pulso; realizar movimentos longos
com o braço.
Executar pelo menos 4 poses gestuais diferentes ao longo da aula.
Salvar como SeuNome_PosesGestuais_Semana16.ai.'),
('producao-multimidia-i', 'modulo-3', 'semana-17', 'Semana 17: Ancoragem Simples: O Personagem no Espaço', 5, 'Semana 17: Ancoragem Simples: O Personagem no
Espaço
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Desenhar um belo cenário e um herói isolado não garante que eles funcionem
juntos. Se a figura não estiver matematicamente "colada" ao piso, ela parecerá
um adesivo flutuando solto na tela. Esse processo de integração chama-se
Ancoragem.
A regra de ouro da ancoragem apoia-se em duas leis físicas da perspectiva:
Linha do Horizonte = Nível dos Olhos: Se o personagem e a câmera
repousam sobre o mesmo plano de chão horizontal, a Linha do Horizonte
passará exatamente na altura dos olhos da figura.
A Escala de Chão: Para fazer o herói andar para o fundo do corredor sem
errar a altura, não usamos estimativas visuais soltas. Puxamos duas linhas
guias que saem do Ponto de Fuga: uma toca o topo da cabeça e a outra
toca os pés do herói base. Qualquer réplica desenhada entre essas duas
retas convergentes terá a escala humana preservada.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Ancorando e Multiplicando a Escala do Personagem
em Diferentes Profundidades da Sala.
Passo 1 — O Ponto de Contato e a Linha de Altura

- Abra o arquivo do quarto com piso quadriculado construído na Semana
13.

- Escolha um quadrado do piso no primeiro plano onde o personagem vai
pisar.

- Com a Caneta  P, suba uma linha vertical reta desse ponto de apoio
até a Linha do Horizonte  LH.

- Esta vertical define a altura padrão: a cabeça toca a LH e a sola dos pés
toca o quadrado do chão.
Passo 2 — Inserindo o Manequim no Primeiro Plano

- Encaixe o seu personagem Chibi ou manequim estruturado sobre essa
linha vertical guia.

- Assegure-se de que os olhos estejam cortados pela Linha do Horizonte.

- Os dois pés devem assentar firmemente na mesma linha horizontal da
grade de piso.
Passo 3 — A Mágica do Deslizamento de Escala para o Fundo

- Imagine um segundo personagem caminhando próximo à parede do
fundo.

- Selecione a Caneta  P  com traçado fino.

- Clique no Ponto de Fuga  PF  e puxe uma linha guia que raspe o topo
da cabeça do primeiro personagem.

- Puxe outra linha guia saindo do PF raspando a sola dos pés dele.

- Escolha a nova posição no fundo da sala e trace uma vertical confinada
exatamente entre essas duas linhas guias.

- Cole a cópia do personagem nessa nova marca e reduza seu tamanho
até ele caber no novo intervalo: a proporção de recuo tridimensional
está calculada com exatidão.
Passo 4 — A Sombra de Ancoragem  A Cola do Chão)

- Pegue a Ferramenta Elipse  L  e desenhe uma elipse achatada preta
sob os pés do herói.

- No painel de Transparência, mude o modo para Multiplicação
Multiply) com 60% de opacidade.

- A sombra projetada no chão "ancora" o peso da figura na gravidade da
sala.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Sala Habitada
Posicione o seu herói no primeiro plano e adicione um segundo elemento
(outro personagem, um rival ou um animal de estimação) recuado no fundo,
respeitando a escala da perspectiva.
Checklist do Desafio:
Alinhar a linha dos olhos do personagem do primeiro plano com a Linha do
Horizonte do cenário.
Posicionar os pés da figura em contato com a grade do solo.
Traçar as linhas de escala convergentes a partir do Ponto de Fuga
passando por topo e base da figura frontal.
Redimensionar e encaixar o segundo personagem no fundo respeitando o
limite dessas retas guias.
Aplicar a sombra de contato no solo para eliminar a sensação de objeto
flutuante.
Salvar como SeuNome_PersonagemAncorado_Semana17.ai.'),
('producao-multimidia-i', 'modulo-3', 'semana-18', 'Semana 18: Narrativa Visual: Detalhes que Contam Histórias', 6, 'Semana 18: Narrativa Visual: Detalhes que Contam
Histórias
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Na produção de jogos e Concept Art, um ambiente não deve ser apenas uma
caixa cinza funcional. O papel do artista de cenários é aplicar a Narrativa
Ambiental  Environmental Storytelling): a arte de contar a história e a
personalidade de quem vive naquele local sem precisar usar diálogos ou textos
na tela.
Para dar identidade ao quarto que construímos:
Quem habita este espaço? Se for um mago, o quarto terá pergaminhos
espalhados, frascos de poção brilhantes e velas derretidas. Se for um
mecânico de naves espaciais, terá parafusos no chão, ferramentas
penduradas e telas de computador piscando.
Interação com a Arquitetura: O personagem ganha credibilidade quando se
apoia fisicamente no mundo — sentado na cama, encostado na parede
com o pé apoiado ou pegando um livro na estante. O contraste entre
paredes limpas e cantos com acúmulo de objetos gera áreas de respiro
visual e pontos de interesse narrativo.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Transformando a Sala em uma Oficina Temática e
Posicionando o Herói Interagindo com o Mobiliário.
Passo 1 — Quebrando a Rigidez da Pose  Interação Física)

- Selecione o personagem que desenhamos encostado na parede.

- Com a Seta Branca  A, selecione a perna mais próxima da parede.

- Dobre o joelho da perna levantando o pé e apoie a sola do sapato
diretamente sobre o rodapé da parede.

- Ao dobrar o membro contra o cenário, o personagem deixa de parecer
uma estátua dura e passa a habitar fisicamente o sólido da arquitetura.
Passo 2 — Adicionando Detalhes Primários nas Paredes

- Na parede lateral esquerda, use a Caneta  P  conectada ao Ponto de
Fuga para desenhar prateleiras de madeira.

- Na parede do fundo (regra frontal), adicione um quadro ou mapa
usando a Ferramenta Retângulo  M.

- Incline o retângulo do quadro levemente para o lado: elementos
desalinhados indicam passagem de tempo e descuido narrativo.
Passo 3 — Pequenos Props e Desgaste  A Camada de Vida)

- Em cima da mesa, desenhe pequenos frascos usando a Ferramenta
Retângulo Arredondado combinada com o Construtor de Formas
Shift + M.

- Adicione rachaduras na pedra do piso traçando pequenas linhas
quebradas em zigue-zague com a Ferramenta Caneta  P.

- Desenhe uma folha de papel caída no chão em perspectiva com
retângulos convergentes.
Passo 4 — Ajuste de Luz e Sombra Integradas

- Defina a fonte de luz do quarto (exemplo: a janela aberta na parede
lateral).

- Garanta que a lateral dos móveis e o lado do corpo do herói opostos à
janela recebam o tom de sombra própria.

- A iluminação unificada conecta todos os microdetalhes em um único
universo crível.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Sala com Identidade
Personalize o quarto arquitetônico estruturado anteriormente para contar a
história de uma classe de jogo  Mago, Hacker, Guerreiro ou Cientista) através
de objetos temáticos.
Checklist do Desafio:
Definir um tema narrativo claro para o aposento.
Fazer o personagem interagir fisicamente com a cena (apoiado, segurando
um objeto ou sentado).
Inserir pelo menos 3 props temáticos nas paredes ou sobre os móveis
(armas, livros, quadros, ferramentas).
Adicionar elementos narrativos de piso (tapete, tábuas soltas, papéis ou
rachaduras) respeitando as linhas de fuga.
Manter a consistência de iluminação em todas as novas peças adicionadas.
Salvar como SeuNome_CenarioNarrativo_Semana18.ai.'),
('producao-multimidia-i', 'modulo-3', 'semana-19', 'Semana 19: Expressões e Emoções Cartoon: As Reações do Herói', 7, 'Semana 19: Expressões e Emoções Cartoon: As
Reações do Herói
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Um personagem estático comunica apenas o seu uniforme; são as expressões
faciais que estabelecem conexão com o jogador. No estilo Cartoon e nos jogos
2D, o rosto do herói é simplificado em peças móveis independentes:
O Eixo das Sobrancelhas: O maior indicador emocional do rosto humano.
Sobrancelhas curvadas para baixo no centro transmitem determinação ou
fúria; sobrancelhas arqueadas para cima no centro comunicam medo,
dúvida ou tristeza; sobrancelhas relaxadas transmitem calma e alegria.
Abertura dos Olhos: Olhos bem abertos com pupilas reduzidas expressam
espanto e choque. Olhos semifechados em fendas expressam
desconfiança ou cansaço.
A Geometria da Boca: A boca funciona como um indicador complementar:
arcos para cima para satisfação, arcos virados para baixo para desgosto, e
formas abertas em "D" para gargalhadas ou gritos de batalha.
Com apenas pequenas alterações no vetor das sobrancelhas e da boca, a
mesma cabeça ganha múltiplos estados de espírito.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Montando uma Matriz de Expressões  Neutro, Bravo
e Assustado) sobre a Cabeça do Mascote.
Passo 1 — A Base da Cabeça Duplicada

- Selecione a cabeça do personagem Chibi desenvolvida na Semana 15.

- Remova os olhos, sobrancelhas e boca, mantendo apenas a silhueta
vazia com as orelhas e o cabelo.

- Com a Seta Preta  V, segure Alt + Shift e arraste a cabeça duas vezes
para o lado, gerando três molduras idênticas alinhadas na tela.
Passo 2 — Expressão 1   Determinado / Bravo

- Na primeira cabeça, desenhe os dois círculos pretos dos olhos.

- Selecione a Ferramenta Caneta  P  com traçado preto grosso de 3 pt.

- Desenhe duas linhas diagonais retas inclinadas para baixo, apontando
em direção ao nariz, formando um "V" aberto: as sobrancelhas
franzidas de raiva.

- Para a boca, trace uma linha reta horizontal tensa ou um trapézio aberto
exibindo os dentes cerrados.
Passo 3 — Expressão 2   Assustado / Chocado

- Na segunda cabeça, use a Ferramenta Elipse  L  para criar olhos
circulares enormes.

- No centro, adicione pupilas minúsculas (o encolhimento da pupila
comunica terror imediato).

- Desenhe as sobrancelhas arqueadas como arcos voltados para cima,
distantes dos olhos.

- Desenhe uma boca em elipse vertical aberta (formato de "O"),
simulando um grito de surpresa.
Passo 4 — Expressão 3   Confiante / Sorridente

- Na terceira cabeça, substitua os círculos dos olhos por dois arcos
curvados para cima (como dois sorrisos fechados), simulando olhos
semicerrados de satisfação.

- Desenhe uma sobrancelha relaxada e a outra levemente levantada em
tom de ironia.

- Desenhe uma boca larga em meia-lua aberta com a base arredondada,
preenchida com um sorriso brilhante.

- Agrupe cada expressão individualmente pressionando Ctrl + G.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Folha de Expressões do Personagem
Desenvolva uma folha de modelo facial contendo pelo menos 3 reações
emocionais distintas para o seu herói (ex: Fúria, Alegria, Espanto ou Confusão).
Checklist do Desafio:
Duplicar a base do crânio do herói em três posições organizadas na
prancheta.
Modular as sobrancelhas para definir a intenção emocional básica em cada
versão.
Ajustar a abertura das pálpebras e o tamanho das pupilas para reforçar o
estado psicológico.
Desenhar bocas estilizadas complementando o sentimento de cada
quadro.
Garantir que o estilo gráfico de traço e espessura mantenha a unidade
visual entre as três reações.
Salvar como SeuNome_FolhaExpressoes_Semana19.ai.'),
('producao-multimidia-i', 'modulo-3', 'semana-20', 'Semana 20: Avaliação de Domínio do Módulo 3', 8, 'Semana 20: Avaliação de Domínio do Módulo 3
Aula 1: Prova Teórica Objetiva (45 min)

- No sistema de perspectiva linear de 1 Ponto de Fuga, qual é o significado
exato da Linha do Horizonte  LH ?
a) O limite físico distante onde a vegetação encosta nas montanhas do
cenário.
b) Uma linha invisível que dita a altura exata dos olhos do observador
ou a posição da câmera.
c) A barra de tarefas localizada na base do monitor do Illustrator.
d) A linha que divide exclusivamente o desenho do corpo humano na
virilha.

- Ao desenhar um corredor ou sala em perspectiva frontal  1 Ponto de Fuga),
como se comportam as paredes viradas de frente para o espectador?
a) Todas convergem obrigatoriamente para o Zênite no alto do teto.
b) Devem ser inclinadas em ângulos diagonais aleatórios para simular
lentes olho de peixe.
c) Obedecem à Regra Frontal: utilizam linhas estritamente horizontais e
verticais, sem sofrer distorção de fuga.
d) Devem ser desenhadas exclusivamente com a ferramenta de lápis à
mão livre.

- Por que a proporção estilizada do tipo Cartoon ou Chibi  2 a 3 cabeças) é
amplamente utilizada no design de jogos e interfaces em vez do cânone
realista de 8 cabeças?
a) Porque torna o arquivo do jogo mais pesado para processar na placa
de vídeo.
b) Porque reduz detalhes anatômicos complexos e concentra o foco
visual nas expressões e no apelo carismático da silhueta.
c) Porque impede que o personagem utilize cores quentes na pintura
digital.
d) Porque dispensa a necessidade de usar o mouse no computador.

- O que é a "Linha de Ação"  Line of Action) no desenho gestual e qual o seu
objetivo principal?
a) Uma reta perfeitamente rígida que mantém o personagem imóvel em
posição de soldado.
b) A linha do chão onde a sombra projetada deve ser pintada de preto
puro.
c) Uma curva mestra fluida que atravessa o corpo, capturando a
energia, a atitude e o ritmo do movimento.
d) O contorno dos músculos do braço finalizado em vetor limpo.

- Quando posicionamos um personagem sobre o mesmo plano de chão
horizontal em que a câmera repousa, qual alinhamento garante a
ancoragem matemática correta?
a) A sola dos sapatos deve tocar o teto do cômodo.
b) A Linha do Horizonte deve passar obrigatoriamente na altura dos
olhos da figura.
c) O personagem deve ser desenhado sempre com o dobro da altura
das portas ao redor.
d) A cabeça do personagem deve ficar invisível fora da prancheta.
Aula 2: Prova Prática no Laboratório (45 min)
Enunciado do Desafio Prático: A Cena de Apresentação do Herói
O estudante deverá criar um ambiente arquitetônico completo em perspectiva
de 1 Ponto de Fuga contendo o seu personagem estilizado ancorado e
interagindo com o espaço.
Requisitos Obrigatórios para Avaliação:

- Estrutura Arquitetônica Precisa: O cenário (sala, masmorra, laboratório ou
templo) deve conter parede frontal, teto, piso e paredes laterais
construídos com guias convergindo ao Ponto de Fuga.

- Mobiliário Volumétrico: É obrigatório desenhar pelo menos um móvel ou
elemento estrutural (baú, mesa, estante ou porta) com profundidade e
espessura calculadas pelo Ponto de Fuga.

- Personagem Estilizado e Ancorado: O herói (proporção Cartoon/Chibi)
deve ter seus olhos alinhados à Linha do Horizonte e conter sombra de
contato no solo para ancorar seu peso no piso.

- Narrativa e Pose: O personagem deve apresentar uma expressão facial
definida e estar posicionado de forma coerente com o ambiente,
interagindo com os elementos ao redor.
Entrega: O arquivo deve ser salvo como Prova_M3_NomeDoAluno.ai  e disponibilizado
na pasta de rede da turma antes do sinal tocar.'),
('producao-multimidia-i', 'modulo-4', 'semana-21', 'Semana 21: Psicologia Visual (Gestalt) e o Design Subtrativo', 1, 'Semana 21: Psicologia Visual (Gestalt) e o Design
Subtrativo
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Quando um jogador abre o menu ou inventário de um jogo, o cérebro dele não
processa pixels isolados; ele procura padrões para economizar energia mental.
Essa tendência biológica é explicada pela Teoria da Gestalt, formulada por
psicólogos no início do século XX, que dita: o todo é percebido antes das
partes e é maior do que a soma delas.
Nas interfaces de jogos  UI Design), quatro leis governam essa leitura rápida:
Proximidade: Elementos posicionados próximos entre si são interpretados
como o mesmo grupo funcional (ex.: três poções agrupadas no canto
separam-se de armas no canto oposto sem precisar de caixas ao redor).
Semelhança: Figuras que compartilham cor ou forma são vistas como
parentes (soldados de escudo azul são aliados; soldados de escudo
vermelho são inimigos).
Fechamento: Se uma forma está incompleta, o cérebro fecha os vazios e
enxerga o desenho inteiro (base de logos como o panda da WWF ou ícones
stencil).
Continuidade: O olhar percorre trilhas suaves (como a fileira de anéis no
Sonic indicando a rota do salto).
No design de ícones modernos, aplicamos o Design Subtrativo: desenha-se a
forma completa e remove-se o excesso. Usando o Espaço Negativo (o vazio
transparente que revela o fundo), menos linhas comunicam com mais impacto
e clareza.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Ícone de Habilidade — A Espada Cortada e o Frasco
de Poção com Espaço Negativo.
Passo 1 — A Prancheta de Interface

- Crie um novo documento no Illustrator: 1920 × 1080 pixels, orientação
Paisagem.

- Desenhe um quadrado de fundo de 1920 × 1080 px com a Ferramenta
Retângulo  M  e pinte de Cinza Escuro Neutro (#222222).

- Bloqueie essa camada de fundo pressionando Ctrl + 2.
Passo 2 — A Silhueta Sólida da Espada

- Pegue a Ferramenta Retângulo  M  e trace uma lâmina vertical estreita
(ex.: 40 px de largura por 400 px de altura).

- Pinte a lâmina de Branco Puro e retire o contorno.

- Com a Ferramenta Polígono  3 lados), gere um triângulo branco no
topo da lâmina para criar a ponta perfurante.

- Adicione um retângulo horizontal curto cruzando a base (a guarda) e
um retângulo fino descendo para ser o cabo.

- Selecione todas as peças com a Seta Preta  V  e use o Construtor de
Formas  Shift + M  arrastando o traço por cima de tudo para fundir a
espada em uma silhueta única sólida.
Passo 3 — O Corte de Gestalt  Lei do Fechamento)

- Selecione a Ferramenta Caneta  P  ou a Ferramenta Linha ().

- Desenhe uma linha diagonal larga (espessura de 12 pt) cortando o meio
da lâmina da espada de fora a fora.

- Selecione a espada e a linha com a Seta Preta  V.

- Vá ao menu superior em Janela > Pathfinder  Window > Pathfinder).

- No painel, clique no botão Dividir  Divide.

- Clique com o botão direito no objeto fatiado e escolha Desagrupar
Ungroup).

- Com a Seta Preta  V, clique na faixa intermediária cortada e aperte
Delete.

- A lâmina agora é formada por dois blocos flutuantes separados, mas o
cérebro fecha a linha invisível e continua lendo a espada completa com
brilho dinâmico.
Passo 4 — Esculpindo com Espaço Negativo

- Ao lado, desenhe a silhueta preta sólida de um escudo com formas
básicas e Construtor de Formas.

- Desenhe uma cruz médica branca por cima do centro do escudo.

- Selecione o escudo e a cruz com a Seta Preta  V.

- Ative o Construtor de Formas  Shift + M, segure a tecla Alt (cursor
com sinal) e clique na cruz branca.

- A cruz é deletada, perfurando o escudo: a cor cinza do fundo da tela
aparece no miolo da forma, criando o ícone através do vazio.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Árvore de Habilidades do Jogo
Crie um conjunto de dois ícones de habilidade (ex.: Ataque Físico, Magia,
Escudo Protetor ou Cura) utilizando corte por fechamento e vazamento por
espaço negativo.
Checklist do Desafio:
Criar documento novo com fundo escuro travado via Ctrl + 2.
Desenhar a silhueta sólida da primeira arma ou item fundindo formas
básicas.
Fatiar a silhueta em diagonal aplicando a Lei do Fechamento com o
comando Dividir ou Construtor de Formas.
Criar um segundo ícone perfurado por Espaço Negativo segurando Alt no
Construtor de Formas.
Realizar o Squint Test (afastar-se e semicerrar os olhos): os dois ícones
devem ser identificáveis mesmo desfocados.
Salvar como SeuNome_IconesGestalt_Semana21.ai.'),
('producao-multimidia-i', 'modulo-4', 'semana-22', 'Semana 22: Equilíbrio Visual, Contraste e a Regra dos Terços', 2, 'Semana 22: Equilíbrio Visual, Contraste e a Regra
dos Terços
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Toda tela de jogo funciona como uma balança de pratos invisível com
gravidade visual própria. Se colocarmos um monstro colossal no canto
esquerdo e deixarmos o lado direito em branco, a imagem tomba e gera
desconforto no jogador. Equilibramos essa balança de duas formas:
Equilíbrio Simétrico: Espelho exato (trilhas cerimoniais, portões de
templos). Passa formalidade e rigidez.
Equilíbrio Assimétrico: Dinâmico e natural. Um elemento volumoso e claro
de um lado é equilibrado por um elemento pequeno, porém escuro e
pontiagudo, do outro lado.
Para fugir da rigidez de posicionar sempre o herói no centro morto da tela, a
indústria utiliza a Regra dos Terços: divide-se a tela em uma grade 3 × 3 com
duas linhas horizontais e duas verticais. As quatro interseções são Pontos
Magnéticos de atração visual imediata.
Ao posicionar o herói em um dos terços laterais, deve-se sempre respeitar o
Lead Room  Espaço de Respiração): deixar a maior área vazia da tela à frente
do olhar ou movimento do personagem, mostrando o espaço para onde ele
avança.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Montagem da Tela de Título de um Jogo com Regra
dos Terços e Equilíbrio Assimétrico.
Passo 1 — Construindo a Grade 3 × 3 Guia

- Crie um documento de 1920 × 1080 pixels.

- Abra o painel de Réguas com Ctrl + R.

- Puxe duas guias verticais da régua esquerda: posicione uma em X  640
px e outra em X  1280 px (dividindo os 1920 px em três partes iguais de
640 px).

- Puxe duas guias horizontais da régua superior: posicione uma em Y
360 px e outra em Y  720 px (dividindo os 1080 px em três partes iguais
de 360 px).

- Bloqueie as guias (clique com botão direito na tela vazia > Bloquear
Guias).
Passo 2 — Posicionando o Horizonte sem Dividir a Tela ao Meio

- Pegue a Ferramenta Retângulo  M.

- Não alinhe o horizonte no centro: desenhe o retângulo do chão
repousando o topo exatamente sobre a linha guia horizontal inferior
Y  720 px).

- Pinte de Cinza Escuro. O céu ocupa agora 2/3 da tela, conferindo
escala épica e vastidão ao mundo aberto.
Passo 3 — Posicionando o Ponto Focal no Ponto Magnético

- Cole a silhueta do herói Chibi na tela.

- Com a Seta Preta  V, arraste o personagem até que a cabeça e os
ombros fiquem cravados exatamente na interseção inferior esquerda
da grade (cruzamento de X  640 px com Y  720 px).

- Faça o herói olhar para o lado direito da tela.

- Observe o resultado: sobraram dois terços inteiros da tela à frente do
rosto dele (o Lead Room), permitindo que a visão respire e caminhe
livremente pela paisagem.
Passo 4 — Contrabalançando com Peso Assimétrico

- O lado esquerdo agora está carregado com o peso visual escuro do
herói.

- Para equilibrar a balança sem espelhar outro personagem, vá até a
interseção superior direita  X  1280 px / Y  360 px).

- Desenhe a silhueta de uma lua cheia ou torre de castelo distante
usando tons claros e dessaturados.

- A cena equilibra-se organicamente: a proximidade e o peso da figura
frontal compensam a distância e a luminosidade do castelo.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Tela Inicial do Jogo  Title Screen)
Construa a composição da tela inicial de um jogo distribuindo o herói, o cenário
de fundo e o espaço para o menu com base na grade 3 × 3.
Checklist do Desafio:
Construir a grade 3 × 3 exata usando réguas e guias nos eixos 1/3 e 2/3.
Alinhar o plano do chão em uma das horizontais guias (evitando dividir a
tela em 50%.
Posicionar o sujeito principal (herói ou veículo) ancorado em um dos quatro
pontos de cruzamento.
Garantir o Lead Room à frente da linha do olhar do herói.
Inserir elemento de contrabalanço no terço oposto para equilibrar a
balança visual de pesos.
Salvar como SeuNome_RegraDosTercos_Semana22.ai.'),
('producao-multimidia-i', 'modulo-4', 'semana-23', 'Semana 23: Hierarquia Visual e Notan (O Limite Preto e Branco)', 3, 'Semana 23: Hierarquia Visual e Notan (O Limite Preto
e Branco)
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
O erro mais comum ao desenhar uma cena complexa é encher o arquivo de
texturas miúdas até a imagem virar uma bagunça sem foco. O jogador precisa
de uma Hierarquia Visual clara: a ordem exata em que o olho nota as coisas na
fração de segundo de uma batalha. Primeiro o chefão, segundo a arma dele,
terceiro o chão onde pisar.
Para testar se uma cena funciona estruturalmente antes de perder horas
detalhando, a indústria usa o método tradicional japonês chamado Notan
(harmonia da luz e da escuridão).
A técnica elimina todas as cores, texturas e degradês.
A imagem é convertida em uma escolha binária absoluta: 100% Branco
Puro para áreas que recebem luz direta, e 100% Preto Puro para áreas em
sombra.
Agrupamento de Valores  Value Grouping): Pequenas sombras soltas são
soldadas em grandes blocos pretos contínuos.
Se a silhueta preta do herói se fundir com o fundo preto do cenário, a
hierarquia falhou. O ponto de maior tensão deve ser onde o preto mais puro
encosta no branco mais puro.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Montagem de Três Miniaturas  Thumbnails) em
Notan Puro para Teste de Composição.
Passo 1 — A Matriz de Thumbnails

- Crie uma prancheta de 1920 × 1080 pixels.

- Com a Ferramenta Retângulo  M, desenhe três molduras retangulares
horizontais menores alinhadas lado a lado (ex.: 500 px de largura por
300 px de altura cada).

- Deixe o preenchimento branco e o traçado preto fino de 1 pt. Estes
pequenos quadros são as telas de teste.
Passo 2 — Thumbnail 1   Céu Noturno e Silhueta Branca

- No primeiro retângulo, pegue a Ferramenta Caneta  P  ou Retângulo
M  e preencha todo o céu com preto sólido.

- Desenhe uma cordilheira de montanhas na frente deixando-as em
branco puro (o papel).

- Sobre a montanha branca, desenhe o herói como uma silhueta
totalmente preta.

- O alto contraste do boneco preto contra o recorte branco da montanha
atrai o olhar imediatamente para o herói.
Passo 3 — Thumbnail 2   Inversão de Valores  Luz de Holofote)

- No segundo retângulo, preencha toda a base do chão e paredes com
preto puro.

- Desenhe um feixe cônico de luz saindo do teto em branco puro (um
holofote ou janela aberta).

- Posicione o monstro como uma massa preta invadindo a coluna de luz
branca.

- Note como as áreas iluminadas conectam-se em uma massa branca
sólida e as sombras em uma massa preta única (Value Grouping).
Passo 4 — Validação por Inversão de Cores

- Selecione as três composições na tela.

- Verifique se existem tons de cinza escondidos: elimine-os. O exercício
opera exclusivamente com os valores #000000  e #FFFFFF.

- Se houver ruído visual excessivo, use o Construtor de Formas  Shift +
M  para fundir as manchinhas pretas isoladas em blocos compactos.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: O Laboratório de Notan  3 Cenários Rápidos)
Desenhe três miniaturas  Thumbnails) de 500 × 300 px explorando ideias
diferentes de iluminação binária extrema  Preto e Branco puro) para encontrar
a cena com a silhueta mais legível.
Checklist do Desafio:
Desenhar três molduras retangulares de teste na prancheta.
Trabalhar exclusivamente com preto 100% e branco 100% (proibido usar
degradês, cinzas ou opacidades).
Aplicar o Agrupamento de Valores (fundir sombras pequenas em massas
sólidas contínuas).
Garantir que o personagem principal destaque-se da parede atrás dele por
contraste inverso (figura escura em fundo claro ou figura clara em fundo
escuro).
Escolher a miniatura mais forte dentre as três e justificar o ponto focal ao
professor.
Salvar como SeuNome_NotanThumbnails_Semana23.ai.'),
('producao-multimidia-i', 'modulo-4', 'semana-24', 'Semana 24: Enquadramento e Planos Cinematográficos', 4, 'Semana 24: Enquadramento e Planos
Cinematográficos
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
A câmera de um jogo ou animação não é um espectador passivo; a posição da
lente determina a emoção dramática da cena. Todo concept artist de
Storyboard e diretor de cenas (cutscenes) utiliza três planos cinematográficos
fundamentais:
Plano Geral  Wide Shot): A figura humana é pequena e o cenário domina a
tela. Serve para situar o espaço geográfico, estabelecer atmosfera e
transmitir isolamento ou pequenez diante do mundo.
Plano Médio  Medium Shot): Corta o personagem pela cintura. Foca na
interação física, gesticulação e diálogos.
Primeiro Plano  Close-Up): Corta o cenário e foca unicamente no rosto ou
em um objeto específico (como a mão segurando uma chave). Gera
empatia, intimidade e tensão dramática máxima ao revelar emoções faciais.
Para que a cena ganhe profundidade tridimensional, dividimos o espaço em
Três Camadas:

- Primeiro Plano  Foreground): Elementos muito próximos da lente, escuros
ou recortados, emoldurando a borda.

- Segundo Plano  Middle Ground): Onde a ação acontece e o herói caminha.

- Plano de Fundo  Background): As montanhas e o céu distantes com pouco
contraste.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Storyboard de 3 Quadros para a Cena "O Encontro
com a Criatura".
Passo 1 — Criando a Tira de Storyboard

- Crie uma prancheta horizontal de 1920 × 1080 pixels.

- Desenhe três retângulos alinhados lado a lado no tamanho 550 × 310
pixels com a Ferramenta Retângulo  M  (proporção 16 × 9.

- Alinhe-os no centro da tela e coloque uma cor de traçado fina de
delimitação.
Passo 2 — Quadro 1   Plano Geral  A Chegada)

- No primeiro quadro, desenhe a entrada monumental de uma caverna
escura que ocupe 80% do espaço.

- Desenhe a silhueta do herói minúscula (com cerca de 40 px de altura)
na base da caverna.

- A escala diminuta estabelece imediatamente a vulnerabilidade do
aventureiro perante o ambiente desconhecido.
Passo 3 — Quadro 2   Plano Médio com Camadas  A Decisão)

- No segundo quadro, estruture as três camadas:
Primeiro Plano: Desenhe galhos secos de árvore pretos encostados
na quina do quadro com a Caneta  P.
Segundo Plano: Desenhe o herói cortado pela cintura segurando
uma tocha à frente do corpo.
Plano de Fundo: Paredes de pedra da caverna preenchidas com
cinza médio.

- O foco concentra-se na atitude física de bravura do herói.
Passo 4 — Quadro 3   Close-Up  O Terror)

- No terceiro quadro, elimine o cenário.

- Preencha a moldura inteira com o rosto do herói desenhado de perto
com a Ferramenta Elipse  L.

- Desenhe olhos arregalados e a pupila encolhida encarando algo fora da
moldura.

- O espectador não precisa ver o monstro: a expressão fatiada em close-
up entrega a tensão psicológica de forma cinematográfica.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: O Mini-Storyboard Narrativo
Desenvolva uma tira de três quadros em vetor contando uma micro-história
com transição obrigatória entre os três planos cinematográficos  Plano Geral,
Plano Médio e Close-Up).
Checklist do Desafio:
Estruturar 3 molduras proporcionais 16 × 9 na horizontal.
Quadro 1  Plano Geral): Foco na geografia, escala ampla e herói reduzido.
Quadro 2  Plano Médio): Foco na linguagem corporal cortada na cintura
com pelo menos duas camadas de profundidade.
Quadro 3  Close-Up): Foco no detalhe dramático ou na expressão facial
isolada da figura.
Manter a consistência de traço entre os três painéis.
Salvar como SeuNome_Storyboard_Semana24.ai.'),
('producao-multimidia-i', 'modulo-4', 'semana-25', 'Semana 25: A Arte de Omitir Informação (Cortes e Tensão)', 5, 'Semana 25: A Arte de Omitir Informação (Cortes e
Tensão)
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
A ferramenta mais rápida no arsenal de um diretor de arte não é desenhar
novos elementos, mas sim recortar o que já foi feito. O ato de redefinir as
margens de uma imagem chama-se Reenquadramento  Crop.
Quando se tenta mostrar todos os detalhes em uma única tela (o monstro
inteiro, as pedras, o castelo e os pássaros), a atenção dispersa-se. A tensão
dramática nasce daquilo que o público não consegue ver:
Abertura e Segurança: Se uma personagem está correndo e deixamos um
espaço amplo vazio à sua frente (Lead Room), o cérebro interpreta que há
fuga e caminho seguro.
Claustrofobia Visual: Se cortamos a imagem colada no nariz da
personagem (eliminando o espaço de respiração) e encostamos a ameaça
nas costas dela, o cérebro sente que a rota acabou e que ela está
encurralada. A ansiedade sobe sem necessidade de adicionar sangue ou
ação gráfica.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Reenquadrando uma Cena com a Ferramenta
Máscara de Recorte  Clipping Mask).
Passo 1 — Desenhando a Cena Aberta de Teste

- Crie uma prancheta de 1920 × 1080 pixels.

- Desenhe uma cena ampla: um guerreiro ajoelhado no chão no canto
esquerdo e um dragão desenhado a 20 metros de distância no canto
direito.

- Agrupe toda a cena pressionando Ctrl + G.

- Esta é a visão descritiva genérica  Plano Geral).
Passo 2 — Construindo o Visor de Recorte  Viewfinder)

- Pegue a Ferramenta Retângulo  M.

- Em vez de pegar a cena toda, desenhe um retângulo pequeno medindo
apenas 400 × 400 pixels.

- Deixe o preenchimento sem cor e traçado fino apenas para enxergar
através dele.
Passo 3 — Posicionando o Corte da Emoção

- Arraste esse pequeno retângulo de 400 × 400 px com a Seta Preta  V  e
coloque-o focado estritamente na mão do guerreiro caída na grama
tentando alcançar a espada.

- Posicione a margem do retângulo cortando a sombra de uma garra
gigante se projetando no chão ao lado da mão.

- O dragão e o corpo do guerreiro ficam de fora da moldura.
Passo 4 — Executando a Máscara de Recorte  Clipping Mask)

- Garanta que o retângulo de 400 × 400 px esteja na frente do desenho
da cena (clique com o botão direito nele > Organizar > Trazer para a
Frente).

- Selecione o retângulo e o grupo do desenho juntos com a Seta Preta
V.

- Pressione o atalho supremo: Ctrl + 7 (ou menu Objeto > Máscara de
Recorte > Criar).

- O Illustrator esconde toda a floresta e o monstro: sobram apenas a mão
trêmula e a sombra da garra na tela. O enquadramento fechado
transformou uma cena comum em um momento de perigo iminente e
urgência.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Lente de Tensão
Pegue a ilustração de uma cena aberta e gere duas versões de
reenquadramento usando Máscaras de Recorte (Ctrl + 7): uma focada na
claustrofobia da fuga e outra em um detalhe tenso de ação oculta.
Checklist do Desafio:
Desenhar ou posicionar os elementos base de um combate ou fuga no
palco.
Agrupar o cenário e personagens com Ctrl + G.
Criar uma moldura retangular de foco e posicionar sobre a área que conte a
história com menos informação.
Garantir que o retângulo esteja no topo da pilha (Shift + Ctrl + ]).
Aplicar a Máscara de Recorte (Ctrl + 7) para ocultar o resto do desenho.
Eliminar o espaço de respiração frontal da figura para criar a sensação de
encurralamento.
Salvar como SeuNome_Reenquadramento_Semana25.ai.'),
('producao-multimidia-i', 'modulo-4', 'semana-26', 'Semana 26: Linhas Guias (Leading Lines): Setas Invisíveis', 6, 'Semana 26: Linhas Guias (Leading Lines): Setas
Invisíveis
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Num cenário de jogo vasto e rico em elementos, o olhar do jogador pode se
perder sem saber para onde ir. Para resolver esse problema, o artista usa as
Leading Lines  Linhas Guias): elementos embutidos na cena que funcionam
como setas invisíveis apontando diretamente para o Ponto Focal.
O olho humano é programado para seguir caminhos de forma contínua. Essas
linhas podem ser disfarçadas sob quatro formas:
Linhas Arquitetônicas: Estradas, trilhos de trem, cercas, rodapés ou postes
de luz em perspectiva.
Linhas Orgânicas: O curso curvo de um rio, galhos de árvores retorcidos,
raízes ou o formato em cunha de nuvens no céu.
Linhas de Luz e Sombra: Feixes de luz vazando por janelas ou a projeção
de sombras compridas no chão apontando para o herói.
Linhas de Ação  Olhares): Armas apontadas, espadas estendidas ou a
direção para onde uma multidão de personagens olha (se todos olham para
o alto de uma torre, o jogador olha para lá instantaneamente).
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Construindo um Cenário onde o Chão, as Nuvens e
uma Árvore Apontam para o Castelo.
Passo 1 — Posicionando o Ponto Focal nos Terços

- Em uma prancheta de 1920 × 1080 pixels, ative as réguas (Ctrl + R).

- Desenhe uma torre de castelo misteriosa encaixada na interseção
superior direita da tela com formas primitivas (este é o destino da
jornada).
Passo 2 — A Estrada de Chão como Seta Explícita

- Pegue a Ferramenta Caneta  P  com preenchimento cinza terra e
traçado vazio.

- Comece no canto inferior esquerdo (onde a visão do jogador costuma
entrar na página) desenhando uma estrada larga.

- Vá afunilando a estrada em uma curva suave que suba e termine
exatamente na porta do castelo.

- A largura que afunila não serve apenas para dar profundidade; ela atua
como um funil magnético puxando o olhar para a torre.
Passo 3 — As Nuvens em Cunha  Vetores Direcionais)

- No céu, acima do castelo, pegue a Ferramenta Caneta  P  ou Elipse
L.

- Não desenhe nuvens horizontais comuns.

- Desenhe nuvens longas e pontiagudas, inclinando a sua diagonal de
modo que as pontas das nuvens no topo esquerdo inclinem para baixo
apontando diretamente para o telhado do castelo.
Passo 4 — A Árvore Retorcida em Arco

- No canto esquerdo da tela (no primeiro plano), desenhe o tronco de
uma árvore seca.

- Em vez de fazer o tronco reto para cima, curve-o em direção ao lado
direito.

- Faça os galhos superiores se esticarem como dedos apontando para o
castelo.

- Faça o Squint Test (semicerre os olhos): note que a estrada, o céu e os
galhos formam um grande circuito fechado forçando a leitura unificada
da torre.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Trilha para o Tesouro
Construa uma cena de exploração (um templo em ruínas, um baú no fim da
caverna ou uma base espacial) utilizando pelo menos três tipos de Linhas
Guias apontando para o objetivo.
Checklist do Desafio:
Posicionar o Ponto Focal em uma das interseções da Regra dos Terços.
Criar uma Linha Guia de chão (estrada, rio, calçada ou rachadura) que
conduza a visão até o objeto.
Criar uma Linha Guia de fundo (nuvens, encostas de montanha ou cabos
de energia) apontando para o foco.
Utilizar um elemento de moldura lateral (árvore, canos ou estátua)
inclinando-se em direção à ação.
Verificar se o olhar do observador é redirecionado para o foco, não importa
onde ele entre na tela.
Salvar como SeuNome_LeadingLines_Semana26.ai.'),
('producao-multimidia-i', 'modulo-4', 'semana-27', 'Semana 27: Avaliação de Domínio do Módulo 4', 7, 'Semana 27: Avaliação de Domínio do Módulo 4
Aula 1: Prova Teórica Objetiva (45 min)

- Qual é o princípio fundamental da Teoria da Gestalt aplicada à percepção
visual e interfaces de jogos?
a) O cérebro analisa cada pixel individualmente antes de entender a
imagem inteira.
b) O todo é percebido antes das partes e é maior do que a simples
soma delas.
c) Imagens de jogos devem ser desenhadas exclusivamente com três
pontos de fuga.
d) A cor preta deve ser sempre evitada em logotipos modernos.

- A Lei do Fechamento da Gestalt é muito usada em ícones e logotipos
porque:
a) Obriga o designer a fechar o arquivo com senha no computador.
b) Permite que formas incompletas ou com cortes tenham suas lacunas
preenchidas automaticamente pela mente do jogador.
c) Força a tela a ficar sem espaço de respiração.
d) Só funciona se o desenho for feito à mão no papel com carvão.

- Ao aplicar a Regra dos Terços em uma cena onde o herói corre para a
direita, por que devemos respeitar o Lead Room  Espaço de Respiração)?
a) Para deixar a tela mais pesada do lado esquerdo sem equilíbrio.
b) Para garantir que a maior parte do espaço vazio fique à frente do
olhar ou movimento, indicando para onde a ação caminha.
c) Para permitir que as quatro quinas da tela recebam o mesmo
degradê radial.
d) Para colocar o personagem exatamente no centro do
enquadramento.

- O método tradicional japonês do Notan utiliza a redução binária absoluta
em Preto e Branco puro com qual finalidade principal?
a) Testar a clareza da Hierarquia Visual e o impacto da silhueta sem a
distração de cores ou texturas.
b) Criar degradês suaves de escala tonal para objetos reflexivos de
metal.
c) Fazer com que o arquivo do jogo ocupe menos memória no celular.
d) Ensinar o aluno a desenhar exclusivamente com a borracha.

- O que são as Leading Lines  Linhas Guias) na composição de um cenário?
a) As réguas azuis do Illustrator que não aparecem no arquivo
exportado.
b) Linhas e formas do próprio cenário (estradas, nuvens, galhos)
organizadas intencionalmente para conduzir o olho do jogador até o
Ponto Focal.
c) O contorno dos músculos do personagem em poses gestuais de
ação.
d) O corte claustrofóbico que encosta no nariz do herói.
Aula 2: Prova Prática no Laboratório (45 min)
Enunciado do Desafio Prático: A Splash Screen do Jogo
O aluno deverá compor a arte final de uma tela de carregamento ou introdução
Splash Screen) integrando todos os princípios composicionais, psicológicos e
narrativos aprendidos no Módulo 4.
Requisitos Obrigatórios para Avaliação:

- Enquadramento e Regra dos Terços: A composição deve ser baseada na
grade 3 × 3, posicionando o Ponto Focal (personagem, monstro ou portal)
sobre uma das quatro interseções mestras, respeitando o Lead Room.

- Profundidade em Três Camadas: A cena deve conter claramente Primeiro
Plano (elementos próximos enquadrando a lente), Segundo Plano (área da
ação) e Plano de Fundo.

- Linhas Guias Integradas: É obrigatório aplicar pelo menos duas Leading
Lines camufladas no cenário (estruturas, fendas no solo, nuvens ou armas)
convergindo em direção ao ponto principal.

- Legibilidade de Notan / Silhueta: O Ponto Focal deve destacar-se do fundo
por contraste tonal direto, garantindo leitura limpa mesmo ao realizar o
Squint Test.
Entrega: O arquivo deve ser salvo como Prova_M4_NomeDoAluno.ai  e colocado na
pasta compartilhada da turma antes do sinal tocar.'),
('producao-multimidia-i', 'modulo-5', 'semana-28', 'Semana 28: Bitmap vs. Vetor e a Filosofia da Pixel Art', 1, 'Semana 28: Bitmap vs. Vetor e a Filosofia da Pixel
Art
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Na computação gráfica, existem duas formas de processar uma imagem:
Bitmap  Raster  e Vetor. Uma imagem em bitmap funciona como um mosaico
de azulejos microscópicos chamados pixels: ao ser ampliada, o computador
precisa inventar dados intermediários, gerando bordas desfocadas e
serrilhadas. O vetor baseia-se em fórmulas matemáticas puras (coordenadas
de eixos, curvaturas e nós), o que permite sua ampliação infinita sem perda de
nitidez visual.
Embora a Pixel Art tenha surgido por limitações extremas de hardware dos
consoles de 8 e 16 bits nas décadas de 1980 e 1990, ela consolidou-se como
uma escolha estilística consciente na produção contemporânea de jogos
independentes (como Celeste e Undertale). A regra de ouro da Pixel Art é a
Intencionalidade: em resoluções minúsculas (como matrizes de 16 × 16 pixels),
nenhum ponto pode ser posicionado por acaso; o erro de um único pixel
deforma a silhueta ou altera a leitura anatômica do desenho.
Ao unir o estilo retrô da Pixel Art ao motor de cálculo do Adobe Illustrator, o
designer produz gráficos de estética nostálgica com a flexibilidade da
escalabilidade matemática, prontos para uso em interfaces sem qualquer
desfoque.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Montagem da Matriz Estrutural e Criação de um
Ícone Retrô de 16 × 16 Pixels.
Passo 1 — Preparando a Prancheta Vetorial

- Abra o Illustrator e selecione Criar Novo  Create New).

- Defina uma prancheta de 1000 × 1000 pixels, orientação em Paisagem,
perfil de cor em RGB e resolução de rastreio em 72 ppi (padrão de tela).

- Pressione Ctrl + R para ativar as Réguas nas margens da tela.
Passo 2 — Construindo a Matriz com a Grelha Retangular

- Na barra de ferramentas à esquerda, clique e segure a Ferramenta
Linha () até abrir o menu expansível.

- Escolha a Ferramenta Grelha Retangular  Rectangular Grid Tool).

- Dê um clique simples no centro da prancheta branca (sem arrastar o
mouse).

- Na janela de configurações da grelha, defina:
Largura:640 px
Altura:640 px
Divisores Horizontais  Horizontal Dividers):15  (a regra
matemática dita: para gerar 16 células, utilizam-se 15 divisórias).
Divisores Verticais  Vertical Dividers):15.

- Clique em OK. O tabuleiro de 16 × 16 casas quadradas surge
centralizado na prancheta.
Passo 3 — Alinhando a Matriz com Precisão Absoluta

- Com a grelha selecionada pela Ferramenta Seleção  Seta Preta -
Atalho V, abra o painel Alinhar  Window > Align).

- Verifique se a opção Alinhar à Prancheta  Align to Artboard) está ativa.

- Clique em Alinhar Centro Horizontal e Alinhar Centro Vertical.

- Na barra superior, confirme se a cor do Traçado  Stroke  está em Preto
com espessura de 1 pt e o Preenchimento  Fill  em  Nenhum.
Passo 4 — Convertendo a Grelha em Objeto de Pintura

- Selecione a grelha com a Seta Preta  V.

- Acesse o menu superior: Objeto > Pintura em Tempo Real > Criar
Object > Live Paint > Make). Atalho: Alt + Ctrl + X.

- A grelha transforma-se em uma matriz especial interativa, cujos
quadrantes são delimitados por interseções matemáticas reconhecíveis
pelo ponteiro de pintura.
Passo 5 — Desenhando a Silhueta Primária com Traçado de Escada

- Ative a ferramenta Balde de Pintura em Tempo Real  Live Paint Bucket
- Atalho: letra K.

- No painel de Amostras  Swatches), selecione o Preto sólido.

- Mova o cursor pela grelha: os quadrantes iluminam-se com um
contorno vermelho.

- Clique e arraste para preencher os pixels da borda de uma poção:
mantenha o ritmo de escada proporcional (ex.: 2 pixels na vertical, 1 na
diagonal, 2 na horizontal) para evitar degraus irregulares (jaggies).
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: O Primeiro Sprite de Inventário
Monte uma matriz de 16 × 16 células usando a Grelha Retangular e trace a
silhueta em preto de um item de inventário (poção, chave de masmorra ou
adaga).
Checklist do Desafio:
Criar documento em modo de cor RGB de 1000 × 1000 px.
Inserir uma Grelha Retangular de 640 × 640 px configurada estritamente
com 15 divisores horizontais e 15 verticais (gerando 16 × 16 células).
Centralizar a grelha nos eixos X e Y da prancheta usando o painel Alinhar.
Converter a malha através de Objeto > Pintura em Tempo Real > Criar.
Utilizar o Balde de Pintura em Tempo Real  K  para delinear a silhueta
fechada em preto.
Aplicar o Squint Test para garantir que o formato do item é compreensível
mesmo sem cores internas.
Salvar o arquivo no formato padrão: SeuNome_Matriz16x16_Semana28.ai.'),
('producao-multimidia-i', 'modulo-5', 'semana-29', 'Semana 29: Camadas, Sistema RGB e o Coração 8- Bit Módulo V : Arte Digital, T eoria da Cor e Pixel Art V etorial 3', 2, 'Semana 29: Camadas, Sistema RGB e o Coração 8-
Bit
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Monitores digitais operam através da emissão direta de luz, e não de
pigmentos reflexivos físicos (como tintas sobre papel). O padrão utilizado nas
telas é o Sistema RGB  Red, Green, Blue), um modelo aditivo onde a
combinação das três luzes em intensidade máxima (valores 255, 255, 255)
resulta no Branco absoluto, e sua ausência completa  0, 0, 0) gera o Preto.
Para produzir de forma profissional sem misturar elementos na tela,
organizamos o projeto no painel de Camadas  Layers:
O Illustrator funciona como um empilhador de papéis translúcidos: formas
criadas por último ficam posicionadas acima de todas as anteriores.
Separar o fundo em uma camada inferior travada com o ícone do Cadeado
impede que o cenário seja selecionado ou arrastado por engano durante a
edição do item principal.
No design retrô, entender a diferença entre Preenchimento  Fill  e Contorno
Stroke  é crucial: o preenchimento aplica cor ao interior do bloco, enquanto o
contorno desenha a borda externa perimetral. Nos assets de 8 bits, o contorno
da grelha é desativado no encerramento para preservar exclusivamente os
blocos de cor sólida.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Colorindo um Coração de Vida 8 Bit e Otimizando a
Estrutura de Camadas.
Passo 1 — Estruturando as Pastas de Trabalho  Painel Camadas)

- Abra o painel Camadas  Layers  no menu superior em Janela >
Camadas  Window > Layers) ou pressione o atalho F7.

- Dê dois cliques no nome da camada padrão Camada 1  e renomeie para
01_FUNDO.

- Com a Ferramenta Retângulo  M, desenhe um fundo cobrindo a tela e
preencha com Cinza Médio (#333333).

- Clique no espaço quadrado vazio ao lado do ícone de olho da camada
01_FUNDO: o ícone do Cadeado surgirá, travando os elementos daquela
pasta.

- Clique no botão Criar Nova Camada (ícone de quadrado com +  na
base do painel) e renomeie para 02_SPRITE_CORACAO.
Passo 2 — Construindo a Matriz de 16 × 16 na Nova Camada

- Certifique-se de que a camada 02_SPRITE_CORACAO  esteja selecionada com
destaque azul no painel.

- Crie uma Grelha Retangular de 400 × 400 px com 15 divisores em
ambos os eixos.

- Converta-a imediatamente via Objeto > Pintura em Tempo Real > Criar
Alt + Ctrl + X.
Passo 3 — Desenhando a Silhueta Externa do Coração

- Selecione o Balde de Pintura em Tempo Real  K.

- Escolha o Preto no painel de Amostras para o preenchimento.

- Preencha os pixels formando a silhueta clássica do coração: duas
curvas no topo descendo em ângulo de 45 graus até convergirem em
uma única ponta inferior.

- Correção de Falhas: Se preencher uma casa incorreta, pressione as
teclas de seta do teclado para navegar pelas amostras até a opção
Nenhum  (quadrado com risco vermelho diagonal) e pinte sobre o erro
para limpá-lo.
Passo 4 — Aplicando Preenchimento Interno e Ponto de Brilho

- Com o Balde  K  ativo, selecione uma amostra de Vermelho Escarlate
puro (#FF0000).

- Clique e arraste por todo o interior da forma para cobrir o miolo com
cor sólida.

- Mude a cor do Balde para Branco Puro (#FFFFFF).

- Pinte de 2 a 3 pixels no topo do lobo superior esquerdo do coração,
criando o reflexo de luz (highlight).
Passo 5 — Limpeza do Traçado e Conversão do Vetor

- Selecione o coração com a Seta Preta  V.

- Na barra de propriedades, clique na caixa de Traçado  Stroke  e mude
para  Nenhum: as linhas pretas da malha estrutural somem, restando
apenas os blocos de cor limpos.

- Acesse o menu: Objeto > Expandir  Object > Expand). Marque as
opções Objeto e Preenchimento e clique em OK.

- A grelha é eliminada e o Illustrator funde os pixels de mesma cor em
planos vetoriais perfeitos, finalizados e leves para uso.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: O Medidor de Vida e Mana
Desenvolva dois ícones clássicos de status de jogos retrô (um Coração de Vida
Vermelho e uma Gota de Mana Azul) aplicando o fluxo completo de camadas
organizadas e expansão vetorial.
Checklist do Desafio:
Criar camada de fundo bloqueada com cadeado e camada independente
para o desenho no painel Camadas  F7.
Configurar a matriz 16 × 16 com Pintura em Tempo Real na camada ativa.
Delinear a borda fechada com o Balde de Pintura em Tempo Real  K.
Preencher o miolo com cor sólida saturada sem deixar vácuos
transparentes internos.
Aplicar o ponto de brilho especular branco no quadrante superior oposto às
sombras.
Desativar a cor do traçado da malha nas opções de Stroke.
Executar o comando Objeto > Expandir para liberar os blocos vetoriais
finais.
Salvar como SeuNome_IconeStatus_Semana29.ai.'),
('producao-multimidia-i', 'modulo-5', 'semana-30', 'Semana 30: Hue Shifting Básico: A Moeda Reluzente', 3, 'Semana 30: Hue Shifting Básico: A Moeda Reluzente
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
O erro mais frequente ao sombrear elementos em Pixel Art é pegar a cor base
(como um amarelo puro) e misturar pigmento preto para criar a sombra. Essa
prática gera uma tonalidade desbotada, acinzentada e sem vida, conhecida na
indústria como Sombra Suja.
Para criar sensações de materiais vibrantes e tridimensionais, os profissionais
utilizam a técnica do Hue Shifting  Desvio de Matiz). A física da atmosfera dita
que a luz direta do Sol é quente e as sombras refletem a cor azul fria do
ambiente ao redor:
Para a Luz  Highlights): Deslocamos a posição da cor no círculo cromático
em direção aos tons quentes (para iluminar um amarelo, move-se o
ponteiro para o amarelo-esverdeado ou limão e adiciona-se branco).
Para as Sombras: Deslocamos o matiz no círculo cromático em direção aos
tons frios (para sombrear o amarelo, não se usa preto; move-se para o
laranja, depois para o vermelho terroso e por fim para o violeta escuro).
Esse contraste cromático faz o cérebro do jogador entender instantaneamente
se o objeto é feito de metal polido, gema translúcida ou plástico fosco, sem
exigir traços complexos.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Esculpindo uma Moeda de Ouro com Rotação de
Matiz no Illustrator.
Passo 1 — Preparando a Paleta com Desvio de Matiz

- Abra uma prancheta de 1000 × 1000 px com a grelha de 16 × 16
convertida em Pintura em Tempo Real.

- Abra o painel Cor  Window > Color) no menu superior e mude o modo
de visualização para Controles Deslizantes HSB  Hue, Saturation,
Brightness).

- Construa os quatro passos tonais da moeda e salve-os no painel de
Amostras:
Sombra Profunda: Matiz  H) em 30°   Laranja avermelhado),
Saturação  S) alta em 90%, Brilho  B) em 45%.
Tom Base  Midtone): Matiz  H) em 45°   Amarelo Ouro), Saturação
S) em 85%, Brilho  B) em 80%.
Luz Alta: Matiz  H) em 55°   Amarelo Limão), Saturação  S) em 60%,
Brilho  B) em 95%.
Brilho Especular: Branco Puro (#FFFFFF).
Passo 2 — Construindo o Perímetro Circular da Moeda

- Selecione o Balde de Pintura em Tempo Real  K.

- Escolha o Tom de Sombra Profunda para fazer a borda externa da
moeda.

- Desenhe uma circunferência ocupando 14 × 14 pixels: use 4 pixels no
topo, 2 na diagonal, 4 na lateral vertical, 2 na diagonal e feche a base
de forma simétrica (escada limpa).
Passo 3 — Preenchendo o Miolo com o Tom Base

- Com o Balde  K, selecione a amostra do Tom Base  Amarelo Ouro).

- Preencha todo o interior do círculo com essa cor sólida.
Passo 4 — Esculpindo a Sombra com Desvio de Matiz

- Assuma que a fonte de luz do jogo vem do canto superior esquerdo.

- Selecione a amostra de Sombra Profunda  Laranja Avermelhado).

- Pinte uma faixa em formato de meia-lua acompanhando a margem
interna inferior e direita da moeda.

- Observe como o tom laranja transmite a densidade pesada do ouro
maciço sem sujar a arte.
Passo 5 — Aplicando a Luz Plena e o Ponto Especular

- Mude o Balde para a amostra de Luz Alta  Amarelo Limão).

- Pinte uma curva fina acompanhando a borda interna superior esquerda
da moeda.

- Finalize escolhendo o Branco Puro e aplicando em apenas 2 pixels na
ponta do arco iluminado.

- Desative a cor do traçado da malha e expanda o objeto (Objeto >
Expandir). A moeda cintila como um metal reflexivo clássico.
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Moeda de Ouro e a Gema Mágica
Construa dois colecionáveis na matriz de 16 × 16: uma moeda circular de ouro e
uma gema de esmeralda lapidada (losango), aplicando obrigatoriamente a
rotação de matiz (Hue Shifting) para luzes e sombras.
Checklist do Desafio:
Configurar as paletas de cor usando o seletor HSB ou círculo cromático
(proibido usar cinza ou preto nas sombras).
Desenhar a circunferência com escada simétrica sem degraus quebrados
(jaggies).
Aplicar a meia-lua de sombra na zona oposta à luz usando tons deslocados
no círculo.
Inserir os pixels de brilho especular branco para definir o acabamento
metálico ou cristalino.
Desativar o traçado das divisórias e expandir o objeto vetorial final.
Salvar como SeuNome_MoedaGema_Semana30.ai.'),
('producao-multimidia-i', 'modulo-5', 'semana-31', 'Semana 31: Desenhando Itens Clássicos de Inventário', 4, 'Semana 31: Desenhando Itens Clássicos de
Inventário
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Na produção de jogos de RPG e aventura, o inventário é uma das telas mais
visitadas pelo jogador. Para que a experiência de jogo seja fluida, cada item
precisa ter uma silhueta inconfundível mesmo quando exibido em ícones
pequenos de 32 ou 64 pixels na tela do celular.
Para desenhar um item com legibilidade instantânea, o artista apoia-se em três
pilares fundamentais:
A Silhueta Dominante: Antes de pintar, a forma preta do objeto deve ser
identificável (uma chave precisa ter os dentes característicos na ponta; um
frasco de poção precisa de gargalo e base arredondada).
O Código de Materiais: A textura é comunicada pela quantidade de brilho:
vidro e líquidos recebem pontos brancos pontuais e nítidos; ferro e pedra
usam áreas de transição foscas sem brilhos excessivos.
Economia Visual: Menos informação significa maior rapidez de leitura. Em
matrizes pequenas, detalhes minúsculos (como texto no rótulo de um
frasco) viram ruído visual e devem ser descartados em favor da clareza da
forma.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Construindo um Frasco de Poção Mágica e a Chave
do Chefe.
Passo 1 — Desenhando o Frasco de Vidro da Poção

- Em uma matriz 16 × 16 em Pintura em Tempo Real, pegue o Balde  K
com a cor Cinza Escuro (#2A2A2A).

- No topo central, desenhe a boca do vidro com 4 pixels horizontais.

- Desça 2 pixels verticais para criar o gargalo estreito.

- Abra os ombros do frasco e desenhe o bojo arredondado até a base,
fechando a silhueta externa.

- No topo do gargalo, use 2 pixels de Marrom para representar a rolha de
cortiça fechando o frasco.
Passo 2 — Preenchendo o Nível do Líquido Mágico

- Escolha uma amostra de Vermelho Carmesim para a base do líquido.

- Preencha a metade inferior da garrafa, deixando uma linha de pixels
vazios no topo para simular que o frasco não está completamente
cheio.

- Na camada superior do líquido, use uma linha de Vermelho Claro para
marcar a superfície do fluido.
Passo 3 — A Translucidez e o Brilho do Vidro

- Com o Branco Puro no Balde  K, posicione 1 pixel no canto do ombro
esquerdo do vidro e 2 pixels na base arredondada esquerda.

- A curvatura do reflexo branco comunica ao cérebro do jogador que o
recipiente é cilíndrico e translúcido.
Passo 4 — Desenhando a Chave do Chefe  Dourada)

- Em uma segunda matriz ao lado, pegue a cor Marrom Escuro no Balde
para a carcaça da chave.

- No topo, faça o anel de apoio da chave (um quadrado oco de 6 × 6
pixels com o miolo vazio).

- Puxe uma haste reta vertical descendo pelo centro com 6 pixels de
comprimento.

- Na ponta da base da haste, puxe 2 pixels para o lado direito e 1 para
cima, esculpindo os dentes da engrenagem da chave.

- Preencha o interior da haste com Amarelo Ouro e a sombra com
Laranja, aplicando o Hue Shifting da aula anterior.

- Desative os traçados pretos e expanda ambos os objetos (Objeto >
Expandir).
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: O Kit Básico de Sobrevivência
Desenhe dois itens fundamentais para o inventário do jogo: um consumível
líquido  Poção de Vida ou Veneno) e uma ferramenta de acesso  Chave,
Pergaminho ou Tocha).
Checklist do Desafio:
Definir silhueta clara e reconhecível para cada item na matriz 16 × 16.
No frasco de poção, representar o vidro externo, a rolha e o nível de líquido
interno.
Inserir reflexos brancos especulares na curvatura para caracterizar a
translucidez do vidro.
Na ferramenta/chave, manter a espessura da haste e dentes nítidos sem
acúmulo de pixels duplos disfuncionais.
Desativar o contorno da grelha estrutural e expandir as formas vetoriais.
Salvar como SeuNome_ItensClassicos_Semana31.ai.'),
('producao-multimidia-i', 'modulo-5', 'semana-32', 'Semana 32: Otimização e Eficiência: O Truque do Palette Swap', 5, 'Semana 32: Otimização e Eficiência: O Truque do
Palette Swap
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Quando analisamos jogos de RPG clássicos (como Final Fantasy, Castlevania
ou Pokémon), notamos inventários com centenas de armas e dezenas de
variações do mesmo monstro. A equipe artística não desenhou cada uma
daquelas peças do zero: utilizou a técnica industrial do Palette Swap  Troca de
Paleta).
Na época dos cartuchos, a memória de dados era limitada. Para economizar
armazenamento, os programadores mantinham a mesma matriz de desenho e
alteravam apenas a tabela de cores atribuída a ela:
O mesmo sprite de slime verde básico tornava-se um slime vermelho
venenoso em níveis avançados.
A espada inicial de ferro convertia-se em uma espada de ouro ou lâmina de
fogo elemental.
Hoje em dia usamos o Palette Swap pela Eficiência de Produção: desenha-se
uma matriz perfeita uma única vez e multiplicam-se os assets do jogo em
minutos.
A regra mestra inquebrável da troca de paleta é a Preservação de Valores: se
o tom da sombra original era o ponto mais escuro do desenho, a nova cor de
sombra deverá ser obrigatoriamente a mais escura da nova paleta, garantindo
que a ilusão de volume 3D continue funcionando.
Nível do Item Material VisualCores Base Valor Transmitido ao
Jogador
Nível 1  Básico  Ferro / Cobre Cinzas neutros,
Castanho escuro
Comum, inicial, sem
poder especial.
Nível 2  Raro  Ouro / Fogo Amarelos quentes,
Laranja vivo
Valioso, mágico,
evolução de status.
Nível 3
Lendário)
Diamante /
Gelo
Ciano brilhante, Azul
Marinho, Branco
Épico, raridade máxima,
poder elemental.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Criando a Matriz de uma Adaga e Gerando as
Versões de Ferro, Ouro e Cristal.
Passo 1 — A Matriz Base  Adaga de Ferro - Nível 1

- Em uma matriz 16 × 16 em Pintura em Tempo Real, desenhe a silhueta de
uma espada ou adaga na diagonal.

- Pinte a lâmina com os tons de Ferro:
Contorno: Cinza Chumbo quase preto (#1A1A1A).
Sombra da Lâmina: Cinza Médio escuro (#555555).
Luz da Lâmina: Cinza Claro (#CCCCCC).
Cabo: Marrom Madeira escuro (#4A2E18).

- Desative o traçado das divisórias e aplique Objeto > Expandir para fixar
o desenho vetorial.
Passo 2 — Duplicando a Matriz em Linha de Montagem

- Com a Seta Preta  V, selecione a adaga de ferro pronta.

- Segure Alt + Shift e arraste para o lado direito para duplicar a espada
mantendo o alinhamento perfeitamente reto.

- Repita o comando pressionando Ctrl + D  Transformar Novamente)
para gerar uma terceira cópia idêntica.

- Agora você possui três espadas com o mesmo desenho estrutural na
tela.
Passo 3 — A Segunda Forja — Versão de Ouro  Nível 2

- Aproxime a visão da segunda espada.

- Selecione a Ferramenta Seleção Direta  Seta Branca - Atalho A.

- Clique em um dos blocos que estavam preenchidos com Cinza Médio
(a sombra da lâmina de ferro).

- Vá ao menu superior: Selecionar > Mesmo > Cor do Preenchimento
Select > Same > Fill Color). O Illustrator seleciona todos os pixels de
sombra da lâmina automaticamente.

- Dê dois cliques na cor de preenchimento e substitua por Laranja Escuro
Quente (#D45B00).

- Repita a operação para os pixels de Cinza Claro (a luz da lâmina): use
Selecionar > Mesmo > Cor do Preenchimento e substitua por Amarelo
Ouro Vivo (#FFD700).

- A lâmina transformou-se em ouro maciço preservando o volume
original.
Passo 4 — A Terceira Forja — Versão de Cristal / Gelo  Nível 3

- Na terceira espada, utilize a Seta Branca  A  para capturar os tons de
sombra.

- Pelo comando Mesmo > Cor do Preenchimento, troque as sombras por
Azul Marinho Profundo (#0A2540).

- Selecione os tons claros da lâmina e substitua por Ciano Fluorescente
(#00F0FF).

- Nos pixels superiores do corte, aplique Branco Puro para gerar o brilho
de diamante lapidado.

- Em menos de três minutos, o portfólio ganhou três armas distintas de
progressão com identidade visual coesa!
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Tríade Elemental de Equipamentos
Desenvolva a matriz de um equipamento de jogo (espada, escudo ou elmo) e
utilize a técnica do Palette Swap para criar a linha evolutiva completa: Comum
Ferro, Mágico  Fogo/Ouro) e Lendário  Gelo/Cristal).
Checklist do Desafio:
Desenhar a matriz do equipamento com volume, sombra e luz bem
definidos na primeira versão de Ferro.
Expandir o objeto e duplicar duas cópias na prancheta com Alt + Shift e
Ctrl + D.
Utilizar a ferramenta Selecionar > Mesmo > Cor do Preenchimento para
substituir as amostras com agilidade técnica.
Respeitar rigorosamente a Preservação de Valores (as cores novas devem
manter a mesma hierarquia de claro e escuro da matriz original).
Apresentar o conjunto alinhado horizontalmente transmitindo sensação
imediata de evolução de poder ao jogador.
Salvar como SeuNome_PaletteSwap_Semana32.ai.'),
('producao-multimidia-i', 'modulo-5', 'semana-33', 'Semana 33: Fechando o Inventário: Organização e Exportação', 6, 'Semana 33: Fechando o Inventário: Organização e
Exportação
Aula 1: Teoria (10 min) + Demonstração do Professor (30 min)
1. O Conceito Central (10 Minutos de Teoria)
Criar uma arte excelente é apenas metade do trabalho de um designer; a outra
metade é entregar os arquivos organizados para a equipe de programação e
integração técnica da engine de jogo (como Unity, Unreal Engine ou Godot).
Ninguém em um estúdio aprova pastas com arquivos soltos, camadas sem
nome ou dimensões aleatórias.
Na entrega de elementos de interface  UI Assets), seguimos padrões rigorosos
de mercado:
Spritesheet  Folha de Sprites): Os ícones não são enviados em dezenas de
arquivos avulsos perdidos; eles são agrupados em uma única grade
organizada com espaçamento uniforme para que o motor gráfico corte as
peças automaticamente por coordenadas.
A Prancheta de Exportação: As margens de cada ícone devem ter
dimensões de potência de dois (ex.: pranchetas de 32 × 32, 64 × 64 ou
128 × 128 pixels), garantindo processamento rápido nas placas gráficas.
Canal Alfa  Transparência PNG
-  O formato final de envio de assets 2D é o
PNG 24, que suporta fundo transparente sem serrilhar as bordas do vetor.
2. Passo a Passo da Demonstração do Professor (30 Minutos)
Projeto da Demonstração: Montagem de uma Folha de Inventário e Exportação
Otimizada em PNG Transparente.
Passo 1 — Organizando a Grade do Inventário na Prancheta

- Abra um documento de 1920 × 1080 pixels.

- Ative as réguas (Ctrl + R) e as Guias Inteligentes (Ctrl + U).

- Com a Ferramenta Retângulo  M, desenhe quatro molduras de slot de
inventário quadradas de 200 × 200 pixels alinhadas horizontalmente.

- Pinte os slots com Cinza Escuro (#1E1E1E) e borda fina de 2 pt em Cinza
Claro (#555555).
Passo 2 — Encaixando os Assets Produzidos

- Importe para a tela os quatro assets criados ao longo do módulo: o
Coração de Vida, a Moeda de Ouro, o Frasco de Poção e a Espada
Elemental.

- Posicione um item no centro exato de cada um dos quatro slots usando
o painel Alinhar  Window > Align).

- Com a Seta Preta  V, verifique se a escala dos quatro objetos está
equilibrada visualmente entre si (nenhum item pode parecer
desproporcionalmente minúsculo ou gigante em relação aos vizinhos).
Passo 3 — Criando Pranchetas Individuais para Exportação

- Na barra de ferramentas, ative a Ferramenta Prancheta  Artboard Tool
- Atalho: Shift + O.

- Na barra de propriedades superior, você pode desenhar novas
pranchetas de recorte.

- Dê um clique simples sobre o quadrado do primeiro slot de inventário: o
Illustrator cria automaticamente a Prancheta 2  ajustada exatamente nas
dimensões daquela moldura.

- Repita o clique sobre os outros três slots para gerar as pranchetas
individuais de corte de cada asset.
Passo 4 — O Fluxo de Exportação Profissional para Telas

- Acesse o menu superior: Arquivo > Exportar > Exportar para Telas
File > Export > Export for Screens).

- Na janela que abrir, selecione as pranchetas correspondentes aos seus
itens.

- No campo de formato à direita, configure:
Formato:PNG  (garante fundo transparente nativo).
Prefixo: Digite UI_Item_.

- Escolha a pasta de destino no seu computador e clique em Exportar
Pranchetas.

- Abra a pasta exportada: cada ícone foi salvo como uma imagem
individual limpa, nomeada e com fundo transparente recortado, pronta
para ser arrastada diretamente para dentro do motor do jogo!
Aula 2: Prática dos Alunos (45 min)
Missão do Aluno: A Entrega Final do Inventário
Reúna os quatro melhores itens criados durante o módulo, monte a tela de
vitrine de inventário e execute a exportação técnica dos arquivos em formato
PNG transparente.
Checklist do Desafio:
Montar uma tela de apresentação com quatro slots de inventário alinhados
no centro da prancheta.
Posicionar e harmonizar as proporções de tamanho entre os quatro sprites
desenvolvidos.
Criar pranchetas individuais de exportação usando a Ferramenta Prancheta
(Shift + O).
Renomear as pranchetas no painel com nomes padronizados (ex.:
Item_Vida, Item_Moeda, Item_Pocao, Item_Espada).
Exportar os assets através de Arquivo > Exportar > Exportar para Telas
em formato PNG transparente.
Conferir se os arquivos PNG gerados abrem sem fundo preto ou branco
colado por trás.
Salvar o projeto master como SeuNome_InventarioFinal_Semana33.ai.'),
('producao-multimidia-i', 'modulo-5', 'semana-34', 'Semana 34: Avaliação de Domínio do Módulo 5', 7, 'Semana 34: Avaliação de Domínio do Módulo 5
Aula 1: Prova Teórica Objetiva (45 min)

- Qual é a diferença fundamental entre uma imagem em formato Bitmap
Raster  e uma imagem construída em Vetor?
a) O bitmap é feito de fórmulas matemáticas infinitas e o vetor é feito de
tinta física.
b) O bitmap é composto por uma grade fixa de pixels que perde nitidez
ao ser ampliada, enquanto o vetor é baseado em cálculos geométricos
recalculados em qualquer escala sem perda de qualidade.
c) Imagens vetoriais só podem ser abertas na internet e bitmaps só
existem em cartuchos antigos.
d) Não existe diferença técnica entre os dois formatos nos softwares
modernos.

- Ao construir uma matriz quadrada para Pixel Art no Illustrator com a
Ferramenta Grelha Retangular, qual é a regra matemática dos divisores para
obter 16 células?
a) Digitar 16 nos divisores horizontais e 16 nos verticais.
b) Digitar 32 nos divisores horizontais e zerar os verticais.
c) Digitar 15 divisores em cada eixo, pois o número de linhas divisórias
é sempre o total de espaços desejados menos um.
d) Desenhar 16 retângulos manuais com a caneta livre.

- No contexto da teoria das cores digitais para telas, o que caracteriza o
modelo aditivo RGB?
a) Funciona pela mistura de pigmentos de tinta azul, amarela e
vermelha sobre papel branco.
b) Baseia-se na emissão de feixes de luz Vermelha, Verde e Azul que,
somados em intensidade máxima, formam a luz Branca pura.
c) É um modelo que só permite o uso de 8 cores simultâneas na tela.
d) Transforma automaticamente qualquer desenho em uma imagem em
preto e branco.

- Por que a técnica do "Hue Shifting"  Desvio de Matiz) é considerada
indispensável na pintura de volumes em Pixel Art?
a) Porque escurece o desenho adicionando exclusivamente pigmento
preto, economizando tempo de pintura.
b) Porque evita a "Sombra Suja", alterando a posição da cor no círculo
cromático (desviando para tons quentes na luz e tons frios nas
sombras), criando riqueza material e vivacidade.
c) Porque reduz o tamanho do arquivo final no disco rígido do
computador.
d) Porque apaga automaticamente os pixels errados da grelha de
desenho.

- Na indústria de jogos, qual é a principal utilidade prática da técnica
conhecida como "Palette Swap"  Troca de Paleta)?
a) Impedir que o jogador troque a roupa do personagem principal
durante a partida.
b) Permitir a criação de novos itens e variações elementais
reaproveitando a mesma matriz de desenho e substituindo apenas a
tabela de cores com agilidade.
c) Desenhar cada armadura do zero garantindo que nenhuma linha seja
parecida com a anterior.
d) Converter gráficos tridimensionais em fotografias para impressão em
papel.
Aula 2: Prova Prática no Laboratório (45 min)
Enunciado do Desafio Prático: A Forja do Equipamento Épico
O estudante deverá criar do zero uma matriz de equipamento de jogo (um
machado, cajado mágico ou escudo) na grade de 16 × 16 pixels, aplicar
iluminação volumétrica profissional com desvio de matiz e apresentar uma
variação de raridade através de troca de paleta.
Requisitos Obrigatórios para Avaliação:

- Estrutura e Silhueta na Matriz: O item deve ser construído na Grelha
Retangular convertida em Pintura em Tempo Real, apresentando silhueta
nítida e proporção de escada limpa, sem pixels órfãos ou degraus
desordenados (jaggies).

- Sombreamento com Hue Shifting: É obrigatório aplicar no mínimo três
níveis tonais  Luz Plena, Cor Base e Sombra) com rotação no círculo
cromático (proibido o uso de preto puro para escurecer).

- Palette Swap Funcional: O aluno deve duplicar a matriz aprovada e
apresentar, lado a lado, duas versões da mesma arma com materiais
distintos (ex.: Versão Ferro/Comum vs. Versão Ouro/Mágico ou Versão
Gelo/Cristal), mantendo a preservação rigorosa dos valores de contraste.

- Finalização Técnica: A peça deve estar desprovida das linhas do traçado
da malha estrutural e devidamente expandida pelo comando Objeto >
Expandir, com camadas nomeadas e limpas.
Entrega: O projeto deve ser salvo obrigatoriamente como Prova_M5_NomeDoAluno.ai
e disponibilizado no diretório compartilhado do laboratório antes do
encerramento da aula.')
)
insert into public.teacher_guide_chapters (guide_id,slug,title,chapter_order,content_markdown)
select g.id,c.slug,c.title,c.chapter_order,c.content_markdown
from chapter_source c join public.modules m on m.discipline_slug=c.discipline_slug and m.slug=c.module_slug
join public.teacher_guides g on g.discipline_slug=c.discipline_slug and g.module_id=m.id
on conflict (guide_id,slug) do update set title=excluded.title, chapter_order=excluded.chapter_order, content_markdown=excluded.content_markdown, updated_at=timezone('utc'::text,now());
