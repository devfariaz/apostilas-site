# Configurar o banco de dados

1. Abra o projeto no painel do Supabase e entre em **SQL Editor**.
2. Copie o conteúdo de `schema.sql`, execute-o uma vez e confirme que terminou sem erros.
3. Em **Authentication → URL Configuration**, adicione `http://localhost:4321/auth/callback` às URLs de redirecionamento. Em produção, adicione também a URL do domínio publicado com `/auth/callback`.
4. A conta `deivid.farias@docente.fieb.edu.br` recebe `role = 'admin'` pelo gatilho de cadastro. O SQL também cria o perfil como administrador se essa conta já existir no Auth.
5. Inicie sessão nesse e-mail e acesse `/admin` para cadastrar disciplinas, módulos e capítulos.

O script cria sete disciplinas iniciais. O painel permite cadastrar outras disciplinas e organizar módulos e capítulos. Contas com e-mail começando por `rm` são ativadas automaticamente; outras começam inativas. O conteúdo, as notas, o progresso e as disciplinas atribuídas são protegidos por RLS.

Para um banco já instalado, execute `upgrade-access-and-chapter-layout.sql` no SQL Editor. Esse arquivo adiciona a alocação de disciplinas por aluno e os campos usados no novo formato dos capítulos.

Na guia **Aprovações e disciplinas** do painel, o ano sugere estas disciplinas: 1º ano (Game Design I e Produção Multimídia I), 2º ano (Game Design II e Produção Multimídia II) e 3º ano (Marketing, Game Design III e Produção Multimídia III). Você pode revisar cada aluno individualmente ou filtrar RM, colar uma coluna de e-mails do Excel, selecionar os cadastros encontrados e aplicar o ano em massa. A ação em massa só altera as atribuições de contas existentes; e-mails não encontrados são listados.

No cadastro de capítulos, **Aula** e **Prática guiada** aceitam Markdown. Cada linha de “O essencial” deve seguir o formato `Título | explicação`, uma por linha. As seções com `##` aparecem como títulos; listas numeradas formam as etapas da prática; imagens usam a sintaxe padrão `![descrição](URL)` do Markdown.

O aplicativo usa a chave publicável do Supabase no `.env`; ela não permite criar tabelas. A execução inicial do SQL precisa ser feita no SQL Editor do projeto Supabase.

Se o cadastro retornar `Database error saving new user` porque `profiles` já existia com colunas diferentes, execute `fix-auth-trigger.sql` no SQL Editor e tente cadastrar novamente.


A confirmação por e-mail é uma configuração do Supabase Auth. Para testar cadastro, use uma caixa de e-mail acessível; o prefixo `rm` ativa o perfil no aplicativo, mas não confirma a propriedade do endereço. Se optar por desativar **Confirm Email** durante o desenvolvimento, lembre-se de que os cadastros passam a ser confirmados automaticamente enquanto essa configuração estiver desligada.
