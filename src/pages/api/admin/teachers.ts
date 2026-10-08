import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../lib/admin';

export const prerender = false;

export const GET: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });

  const { data, error } = await auth.supabase.rpc('admin_list_teacher_accounts');
  if (error) return Response.json({ error: error.message }, { status: 500 });
  return Response.json({ teachers: data ?? [], currentUserId: auth.user.id });
};

export const POST: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });

  let body: { email?: unknown; grant_access?: unknown };
  try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }

  const email = typeof body.email === 'string' ? body.email.trim().toLowerCase() : '';
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) || email.length > 254 || typeof body.grant_access !== 'boolean') {
    return Response.json({ error: 'Informe um e-mail válido e a ação desejada.' }, { status: 400 });
  }

  const { data, error } = await auth.supabase.rpc('admin_set_teacher_guide_access', {
    target_email: email,
    grant_access: body.grant_access,
  });
  if (error) return Response.json({ error: error.message }, { status: 400 });
  if (!data) return Response.json({ error: 'Não encontrei uma conta cadastrada com esse e-mail.' }, { status: 404 });

  return Response.json({
    updated: true,
    message: body.grant_access ? 'Acesso aos guias concedido; a conta foi ativada.' : 'Acesso aos guias removido.',
  });
};
