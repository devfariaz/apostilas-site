import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../lib/admin';

export const prerender = false;

export const GET: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });

  const { data, error } = await auth.supabase.rpc('admin_list_administrators');
  if (error) return Response.json({ error: error.message }, { status: 500 });
  return Response.json({ administrators: data ?? [], currentUserId: auth.user.id });
};

export const POST: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });

  let body: { email?: unknown; make_admin?: unknown };
  try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }

  const email = typeof body.email === 'string' ? body.email.trim().toLowerCase() : '';
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) || email.length > 254 || typeof body.make_admin !== 'boolean') {
    return Response.json({ error: 'Informe um e-mail válido e a ação desejada.' }, { status: 400 });
  }

  const { data, error } = await auth.supabase.rpc('admin_set_administrator', {
    target_email: email,
    make_admin: body.make_admin,
  });
  if (error) return Response.json({ error: error.message }, { status: 400 });
  if (!data) return Response.json({ error: 'Não encontrei uma conta cadastrada com esse e-mail.' }, { status: 404 });

  return Response.json({
    updated: true,
    message: body.make_admin ? 'Acesso administrativo concedido.' : 'Acesso administrativo removido.',
  });
};
