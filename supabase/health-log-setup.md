# Health log diário

A rotina `/api/cron/health` grava uma linha em `public.logs_health`. O `vercel.json` agenda a chamada todos os dias às 12:00 UTC. Na Vercel Hobby, o cron diário respeita o limite de frequência e gera atividade regular no banco.

## Configuração

1. Execute [`logs-health.sql`](./logs-health.sql) no SQL Editor do projeto Supabase.
2. Cadastre na Vercel, nos ambientes Production e Preview, `PUBLIC_SUPABASE_URL`, `SUPABASE_SECRET_KEY` (chave secreta do Supabase) e `CRON_SECRET` (um valor aleatório longo). Para desenvolvimento local, configure as mesmas variáveis no `.env`.
3. Faça deploy de produção. A Vercel registra o cron a partir do `vercel.json` publicado.

O endpoint exige `Authorization: Bearer <CRON_SECRET>`. A tabela não tem acesso para `anon` nem `authenticated`; somente a função server-side usa a chave secreta.
