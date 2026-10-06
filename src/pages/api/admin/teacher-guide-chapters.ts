import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../lib/admin';

const slugify = (value: string) => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().trim().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');

export const GET: APIRoute = async ({ cookies, request, url }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let query = auth.supabase.from('teacher_guide_chapters').select('*').order('chapter_order');
  const guideId = url.searchParams.get('guide');
  if (guideId) query = query.eq('guide_id', guideId);
  const { data, error } = await query;
  if (error) return Response.json({ error: error.message }, { status: 500 });
  return Response.json({ chapters: data });
};

async function save({ request, cookies }: Parameters<APIRoute>[0]) {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: Record<string, unknown>;
  try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  const title = typeof body.title === 'string' ? body.title.trim() : '';
  const slug = slugify(typeof body.slug === 'string' && body.slug.trim() ? body.slug : title);
  const guide_id = typeof body.guide_id === 'string' ? body.guide_id : '';
  const theory_markdown = typeof body.theory_markdown === 'string' ? body.theory_markdown.trim() : '';
  const bench_markdown = typeof body.bench_markdown === 'string' ? body.bench_markdown.trim() : '';
  const student_practice_markdown = typeof body.student_practice_markdown === 'string' ? body.student_practice_markdown.trim() : '';
  // Mantém uma cópia agregada para compatibilidade com seeds e registros antigos.
  const content_markdown = [
    theory_markdown,
    bench_markdown && `## Passo a Passo da Demonstração do Professor\n\n${bench_markdown}`,
    student_practice_markdown && `## Aula 1: Prática dos Alunos\n\n${student_practice_markdown}`,
  ].filter(Boolean).join('\n\n');
  const chapter_order = Math.max(1, Math.floor(Number(body.chapter_order) || 1));
  if (!guide_id || !title || title.length > 180 || !slug || !theory_markdown || [theory_markdown, bench_markdown, student_practice_markdown].some((content) => content.length > 200000)) return Response.json({ error: 'Informe título e teoria. Cada parte do capítulo pode ter até 200 mil caracteres.' }, { status: 400 });
  const { data: guide, error: guideError } = await auth.supabase.from('teacher_guides').select('id').eq('id', guide_id).maybeSingle();
  if (guideError || !guide) return Response.json({ error: 'Guia do professor não encontrado.' }, { status: 404 });

  const values = { guide_id, slug, title, chapter_order, theory_markdown, bench_markdown, student_practice_markdown, content_markdown, updated_at: new Date().toISOString() };
  const query = typeof body.id === 'string' && body.id
    ? auth.supabase.from('teacher_guide_chapters').update(values).eq('id', body.id)
    : auth.supabase.from('teacher_guide_chapters').insert(values);
  const { data, error } = await query.select().single();
  if (error) return Response.json({ error: error.message }, { status: 400 });
  return Response.json({ chapter: data });
}

export const POST: APIRoute = save;
export const PUT: APIRoute = save;

export const DELETE: APIRoute = async ({ request, cookies }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: { id?: unknown };
  try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (typeof body.id !== 'string') return Response.json({ error: 'Capítulo inválido.' }, { status: 400 });
  const { error } = await auth.supabase.from('teacher_guide_chapters').delete().eq('id', body.id);
  if (error) return Response.json({ error: error.message }, { status: 400 });
  return Response.json({ deleted: true });
};
