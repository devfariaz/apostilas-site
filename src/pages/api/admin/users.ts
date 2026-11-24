import type { APIRoute } from 'astro';
import { createClient } from '@supabase/supabase-js';
import { requireAdmin } from '../../../lib/admin';

export const prerender = false;

function adminClient() {
  const url = import.meta.env.PUBLIC_SUPABASE_URL;
  const key = import.meta.env.SUPABASE_SECRET_KEY ?? import.meta.env.SUPABASE_SERVICE_ROLE_KEY;
  return url && key ? createClient(url, key, { auth: { autoRefreshToken: false, persistSession: false } }) : null;
}

export const GET: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  const client = adminClient();
  if (!client) return Response.json({ error: 'Configure SUPABASE_SECRET_KEY no servidor para listar todos os usuários.' }, { status: 500 });
  const { data: profiles, error } = await client.from('profiles').select('id,email,full_name,role,is_active,created_at').order('created_at', { ascending: false });
  if (error) return Response.json({ error: error.message }, { status: 500 });
  return Response.json({ users: profiles ?? [] });
};

export const POST: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: any; try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (typeof body.id !== 'string' || !body.id || typeof body.password !== 'string' || body.password.length < 8 || body.password.length > 128) return Response.json({ error: 'Informe o usuário e uma senha entre 8 e 128 caracteres.' }, { status: 400 });
  const client = adminClient();
  if (!client) return Response.json({ error: 'Configure SUPABASE_SECRET_KEY no servidor para alterar senhas.' }, { status: 500 });
  const { data: profile, error: profileError } = await client.from('profiles').select('id').eq('id', body.id).maybeSingle();
  if (profileError) return Response.json({ error: profileError.message }, { status: 500 });
  if (!profile) return Response.json({ error: 'Usuário não encontrado.' }, { status: 404 });
  const { error } = await client.auth.admin.updateUserById(body.id, { password: body.password });
  if (error) return Response.json({ error: error.message }, { status: 400 });
  return Response.json({ updated: true });
};
