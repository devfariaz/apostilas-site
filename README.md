# Apostilas | Plataforma de materiais didáticos

## 1. Visão Geral do Projeto
A plataforma de apostilas é um ambiente de leitura e consulta didática. Cada publicação pode usar seu próprio projeto Supabase e configurar o nome do professor sem alterar o código.

A plataforma foi concebida para acomodar **7 disciplinas académicas**, separando de forma clara a entrega de conteúdo pedagógico curado em MDX das funcionalidades dinâmicas individuais do aluno (autenticação, controlo de leitura e bloco de notas persistente).

---

## 2. Stack Tecnológica e Infraestrutura
* **Framework:** [Astro](https://astro.build/) configurado em modo híbrido com renderização no servidor (SSR) através do adaptador `@astrojs/vercel`.
* **Formato dos Conteúdos:** **MDX (Markdown + JSX)** estruturado através das *Content Collections* do Astro.
* **Estilização:** **Tailwind CSS** com tokens semânticos fiéis ao layout do Figma e suporte nativo a modo escuro com a classe `darkMode: 'class'`.
* **Base de Dados & Autenticação:** **Supabase** (PostgreSQL gerido, JWT Auth e políticas de segurança Row Level Security - RLS).
* **Alojamento & CI/CD:** **Vercel** integrado ao repositório GitHub (custo zero de infraestrutura na camada gratuita).

## Implantação na Vercel

O projeto já usa `@astrojs/vercel` com saída `server`; o build gera as funções SSR e os arquivos estáticos em `.vercel/output`. Não é necessário criar um `vercel.json` personalizado.

1. Envie este projeto para um repositório Git e importe-o no painel da Vercel.
2. Use `npm run build` como comando de build. A Vercel identifica Astro e o adaptador configurado no projeto.
3. Cadastre estas variáveis nos ambientes Production, Preview e Development da Vercel:
   - `PUBLIC_SUPABASE_URL`
   - `PUBLIC_SUPABASE_PUBLISHABLE_KEY`
   - `PUBLIC_TEACHER_NAME` (por exemplo, `Professora Ana Silva`; se omitida, mantém o nome padrão desta instalação)
4. Depois do primeiro deploy, em Supabase → Authentication → URL Configuration, defina a URL principal como o domínio de produção e permita os retornos de autenticação:
   - `https://SEU-DOMINIO/auth/callback`
   - `https://*-SEU-SLUG.vercel.app/**` para previews
   - `http://localhost:4321/**` para desenvolvimento local

O arquivo `.env.example` contém apenas os nomes das variáveis. Nunca envie `.env` para o repositório. A URL de callback de cadastro usa o domínio atual automaticamente.

Referências: [implantação Astro na Vercel](https://docs.astro.build/en/guides/deploy/vercel/) e [URLs de redirecionamento do Supabase Auth](https://supabase.com/docs/guides/auth/redirect-urls).

### Preparar uma instalação para outro professor

1. Publique este repositório em um projeto Vercel separado e crie um projeto Supabase separado para o professor.
2. No Supabase, execute `supabase/schema.sql` no SQL Editor.
3. Na Vercel, configure `PUBLIC_SUPABASE_URL`, `PUBLIC_SUPABASE_PUBLISHABLE_KEY` e `PUBLIC_TEACHER_NAME` para essa instalação e faça o deploy.
4. Crie a conta do professor no site publicado. No SQL Editor desse Supabase, execute `supabase/bootstrap-admin.sql` após substituir `PROFESSOR_EMAIL_AQUI` pelo e-mail cadastrado. Confirme que a consulta retornou exatamente o perfil esperado com `role = admin` e `is_active = true`.
5. O professor entra no painel `/admin` e configura as disciplinas, alunos e conteúdos.

Cada instalação deve usar um banco Supabase próprio. Não reutilize as credenciais do banco do site atual. Ao publicar o código novo no projeto Vercel existente, mantenha as variáveis atuais; o valor padrão do nome preserva a identidade atual.

---

## 3. Especificação do Modo Escuro (Dark Mode Editorial)
Para proporcionar ergonomia visual em sessões noturnas de estudo, a interface utiliza uma paleta escura com tonalidade de papel carvão:

### Mapeamento Cromático:
| Elemento | Modo Claro (Figma) | Modo Escuro (Editorial) |
| :--- | :--- | :--- |
| **Fundo da aplicação** | Marfim (`#FAF7F2`) | Carvão Profundo (`#121214`) |
| **Superfície de cartões / caixas** | Branco suave (`#FFFFFF`) | Grafite Escuro (`#1E1E22`) |
| **Texto de leitura principal** | Grafite escuro (`#1E1E1E`) | Gelo Suave (`#EDEDED`) |
| **Metadados e textos de apoio** | Cinzento neutro (`#666666`) | Cinzento claro (`#9CA3AF`) |
| **Acentos, botões e CTAs** | Terracota (`#E35335`)[cite: 8] | Terracota vivo (`#FF6B4A`) |
| **Destaques didáticos ("O essencial")** | Mostarda (`#E8B931`)[cite: 8] | Âmbar suave (`#D97706`) |
| **Separadores e linhas de grelha** | Bege suave (`#E5E0D8`) | Ardósia subtil (`#2A2A2E`) |

### Script Anti-FOUC (`src/layouts/BaseLayout.astro`):
```html
<script is:inline>
  const temaSalvo = localStorage.getItem('theme');
  const prefereEscuro = window.matchMedia('(prefers-color-scheme: dark)').matches;
  if (temaSalvo === 'dark' || (!temaSalvo && prefereEscuro)) {
    document.documentElement.classList.add('dark');
  } else {
    document.documentElement.classList.remove('dark');
  }
</script>
