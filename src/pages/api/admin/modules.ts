import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../lib/admin';
const slugify = (value: string) => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().trim().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');

export const GET: APIRoute = async ({ cookies, url, request }) => {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let query = auth.supabase.from('modules').select('*').order('sort_order').order('name');
  const discipline = url.searchParams.get('discipline'); if (discipline) query = query.eq('discipline_slug', discipline);
  const { data, error } = await query;
  if (error) return Response.json({ error: error.message }, { status: 500 });
  return Response.json({ modules: data });
};

async function save({ request, cookies }: Parameters<APIRoute>[0]) {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: any; try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  const name = typeof body.name === 'string' ? body.name.trim() : '';
  const discipline_slug = typeof body.discipline_slug === 'string' ? body.discipline_slug : '';
  const slug = slugify(typeof body.slug === 'string' && body.slug.trim() ? body.slug : name);
  if (!name || !slug || !discipline_slug) return Response.json({ error: 'Informe disciplina, nome e slug.' }, { status: 400 });
  const values = { discipline_slug, name, slug, sort_order: Math.max(0, Number(body.sort_order) || 0), updated_at: new Date().toISOString() };
  const query = body.id ? auth.supabase.from('modules').update(values).eq('id', body.id) : auth.supabase.from('modules').insert(values);
  const { data, error } = await query.select().single();
  if (error) return Response.json({ error: error.message }, { status: 400 });
  return Response.json({ module: data });
}
export const POST: APIRoute = save;
export const PUT: APIRoute = save;

export const DELETE: APIRoute = async ({ request, cookies }) => {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: any; try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (typeof body.id !== 'string') return Response.json({ error: 'Módulo inválido.' }, { status: 400 });
  const { error } = await auth.supabase.from('modules').delete().eq('id', body.id);
  if (error) return Response.json({ error: error.message }, { status: 400 });
  return Response.json({ deleted: true });
};
