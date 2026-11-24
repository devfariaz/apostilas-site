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
  const [studentResult, administratorResult] = await Promise.all([
    auth.supabase.rpc('admin_list_students'),
    auth.supabase.rpc('admin_list_administrators')
  ]);
  if (studentResult.error || administratorResult.error) {
    const client = adminClient();
    if (client) {
      const { data: profiles, error } = await client.from('profiles').select('id,email,full_name,role,is_active,created_at').order('created_at', { ascending: false });
      if (!error) return Response.json({ users: profiles ?? [] });
    }
    const availableUsers = [
      ...(studentResult.data ?? []).map((student: Record<string, any>) => ({ ...student, role: 'aluno' })),
      ...(administratorResult.data ?? []).map((administrator: Record<string, any>) => ({ ...administrator, role: 'admin' }))
    ];
    if (availableUsers.length) {
      return Response.json({ users: availableUsers, warning: 'A lista está incompleta: uma das funções de usuários não está disponível no banco.' });
    }
    return Response.json({ error: 'Não foi possível listar os usuários. Verifique as funções admin_list_students e admin_list_administrators no Supabase e configure SUPABASE_SECRET_KEY para a consulta de contingência.' }, { status: 500 });
  }
  const users = [
    ...(studentResult.data ?? []).map((student: Record<string, any>) => ({ ...student, role: 'aluno' })),
    ...(administratorResult.data ?? []).map((administrator: Record<string, any>) => ({ ...administrator, role: 'admin' }))
  ].sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
  return Response.json({ users });
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
