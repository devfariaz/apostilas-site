import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../lib/admin';
export const prerender = false;
const slugify = (value: string) => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().trim().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');

export const GET: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  const { data, error } = await auth.supabase.from('disciplines').select('*').order('sort_order').order('name');
  if (error) return Response.json({ error: error.message }, { status: 500 });
  return Response.json({ disciplines: data });
};

async function save({ request, cookies }: Parameters<APIRoute>[0]) {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: any; try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  const name = typeof body.name === 'string' ? body.name.trim() : '';
  const slug = slugify(typeof body.slug === 'string' && body.slug.trim() ? body.slug : name);
  if (!name || !slug || name.length > 120 || slug.length > 120) return Response.json({ error: 'Informe nome e slug válidos.' }, { status: 400 });
  const values = {
    name, slug,
    description: String(body.description ?? '').trim().slice(0, 2000),
    skills: Array.isArray(body.skills) ? body.skills.filter((item: unknown) => typeof item === 'string').map((item: string) => item.trim()).filter(Boolean).slice(0, 30) : [],
    competencies: Array.isArray(body.competencies) ? body.competencies.filter((item: unknown) => typeof item === 'string').map((item: string) => item.trim()).filter(Boolean).slice(0, 30) : [],
    sort_order: Math.max(0, Number(body.sort_order) || 0), active: body.active !== false, updated_at: new Date().toISOString()
  };
  const query = body.id ? auth.supabase.from('disciplines').update(values).eq('id', body.id) : auth.supabase.from('disciplines').insert(values);
  const { data, error } = await query.select().single();
  if (error) return Response.json({ error: error.message }, { status: 400 });
  return Response.json({ discipline: data });
}
export const POST: APIRoute = save;
export const PUT: APIRoute = save;

export const DELETE: APIRoute = async ({ request, cookies }) => {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: any; try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (typeof body.id !== 'string') return Response.json({ error: 'Disciplina inválida.' }, { status: 400 });
  const { error } = await auth.supabase.from('disciplines').delete().eq('id', body.id);
  if (error) return Response.json({ error: error.message }, { status: 400 });
  return Response.json({ deleted: true });
};
