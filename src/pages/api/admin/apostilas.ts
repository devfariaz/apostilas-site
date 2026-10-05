import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../lib/admin';
const slugify = (value: string) => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().trim().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');

export const GET: APIRoute = async ({ cookies, url, request }) => {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let query = auth.supabase.from('apostilas').select('*').order('discipline_slug').order('lesson_order');
  const discipline = url.searchParams.get('discipline'); if (discipline) query = query.eq('discipline_slug', discipline);
  const { data, error } = await query;
  if (error) return Response.json({ error: error.message }, { status: 500 });
  return Response.json({ apostilas: data });
};

async function save({ request, cookies }: Parameters<APIRoute>[0]) {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: any; try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  const title = typeof body.title === 'string' ? body.title.trim() : '';
  const discipline_slug = typeof body.discipline_slug === 'string' ? body.discipline_slug : '';
  const module_id = typeof body.module_id === 'string' && body.module_id ? body.module_id : null;
  const body_markdown = typeof body.body_markdown === 'string' ? body.body_markdown : '';
  const practice_markdown = typeof body.practice_markdown === 'string' ? body.practice_markdown : '';
  const slug = slugify(typeof body.slug === 'string' && body.slug.trim() ? body.slug : title);
  if (!title || !slug || !discipline_slug || title.length > 180 || body_markdown.length > 200000 || practice_markdown.length > 200000) return Response.json({ error: 'Preencha os campos obrigatórios. Cada conteúdo pode ter até 200 mil caracteres.' }, { status: 400 });
  let module = '';
  if (module_id) {
    const result = await auth.supabase.from('modules').select('name').eq('id', module_id).eq('discipline_slug', discipline_slug).maybeSingle();
    if (result.error || !result.data) return Response.json({ error: 'O módulo selecionado não pertence a esta disciplina.' }, { status: 400 });
    module = result.data.name;
  }
  const essentialPoints = Array.isArray(body.essential_points)
    ? body.essential_points.flatMap((point: unknown) => {
        if (typeof point === 'string') {
          const [title, ...description] = point.split('|');
          const normalizedTitle = title.trim().slice(0, 120);
          return normalizedTitle ? [{ title: normalizedTitle, description: description.join('|').trim().slice(0, 500) }] : [];
        }
        if (point && typeof point === 'object') {
          const entry = point as { title?: unknown; description?: unknown };
          const normalizedTitle = typeof entry.title === 'string' ? entry.title.trim().slice(0, 120) : '';
          const description = typeof entry.description === 'string' ? entry.description.trim().slice(0, 500) : '';
          return normalizedTitle ? [{ title: normalizedTitle, description }] : [];
        }
        return [];
      }).slice(0, 12)
    : [];
  const values = {
    title, slug, discipline_slug, module_id, module,
    lesson_order: Math.max(0, Number(body.lesson_order) || 0),
    summary: String(body.summary ?? '').slice(0, 1000),
    tags: Array.isArray(body.tags) ? body.tags.filter((tag: unknown) => typeof tag === 'string').map((tag: string) => tag.trim()).filter(Boolean).slice(0, 30) : [],
    body_markdown, practice_markdown,
    reading_minutes: Math.min(999, Math.max(1, Number(body.reading_minutes) || 10)),
    difficulty: String(body.difficulty ?? 'Introdutório').slice(0, 80),
    key_idea: String(body.key_idea ?? '').slice(0, 1000),
    essential_points: essentialPoints,
    shortcut_keys: String(body.shortcut_keys ?? '').slice(0, 80), shortcut_label: String(body.shortcut_label ?? '').slice(0, 120),
    shortcuts: Array.isArray(body.shortcuts) ? body.shortcuts.filter((entry: any) => entry && typeof entry.keys === 'string' && typeof entry.label === 'string').map((entry: any) => ({ keys: entry.keys.trim().slice(0, 80), label: entry.label.trim().slice(0, 120) })).filter((entry: any) => entry.keys && entry.label).slice(0, 20) : [],
    published: body.published !== false, updated_at: new Date().toISOString()
  };
  const query = body.id ? auth.supabase.from('apostilas').update(values).eq('id', body.id) : auth.supabase.from('apostilas').insert({ ...values, created_by: auth.user.id });
  const { data, error } = await query.select().single();
  if (error) return Response.json({ error: error.message }, { status: 400 });
  return Response.json({ apostila: data });
}
export const POST: APIRoute = save;
export const PUT: APIRoute = save;

export const DELETE: APIRoute = async ({ request, cookies }) => {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: any; try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  const validId = (id: unknown): id is string => typeof id === 'string' && /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(id);
  if (Array.isArray(body.ids) && (body.ids.length > 500 || body.ids.some((id: unknown) => !validId(id)))) return Response.json({ error: 'Selecione até 500 capítulos válidos por vez.' }, { status: 400 });
  const ids = Array.isArray(body.ids) ? [...new Set(body.ids)] : validId(body.id) ? [body.id] : [];
  if (!ids.length) return Response.json({ error: 'Seleção de capítulos inválida.' }, { status: 400 });
  const { data, error } = await auth.supabase.from('apostilas').delete().in('id', ids).select('id');
  if (error) return Response.json({ error: error.message }, { status: 400 });
  return Response.json({ deleted: true, deletedCount: data?.length ?? 0 });
};
