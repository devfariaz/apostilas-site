import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../lib/admin';
import { normalizeFruitSequence } from '../../../lib/fruit-emojis';

export const GET: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });

  const [{ data: keywords, error: keywordError }, { data: lessons, error: lessonError }] = await Promise.all([
    auth.supabase.from('lesson_access_keys').select('discipline_slug,lesson_slug,keyword,updated_at').order('discipline_slug').order('lesson_slug'),
    auth.supabase.from('apostilas').select('discipline_slug,slug,title,module,keyword_required').order('discipline_slug').order('lesson_order')
  ]);

  if (keywordError || lessonError) {
    const error = keywordError ?? lessonError;
    return Response.json({ error: error?.message ?? 'Não foi possível carregar as palavras-chave.' }, { status: 500 });
  }

  const chaptersByKey = new Map((lessons ?? []).map((lesson) => [`${lesson.discipline_slug}:${lesson.slug}`, lesson]));
  const rows = (keywords ?? []).map((entry) => ({
    ...entry,
    chapter: chaptersByKey.get(`${entry.discipline_slug}:${entry.lesson_slug}`) ?? null
  }));

  return Response.json({ keywords: rows });
};

export const PUT: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });

  let body: unknown;
  try { body = await request.json(); }
  catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (!body || typeof body !== 'object') return Response.json({ error: 'Dados inválidos.' }, { status: 400 });

  const { discipline_slug, lesson_slug, keyword } = body as Record<string, unknown>;
  if (typeof discipline_slug !== 'string' || discipline_slug.length > 120 || typeof lesson_slug !== 'string' || lesson_slug.length > 180 || typeof keyword !== 'string' || keyword.trim().length > 100) {
    return Response.json({ error: 'Informe disciplina, capítulo e palavra-chave válidos (até 100 caracteres).' }, { status: 400 });
  }

  const normalizedKeyword = keyword.trim();
  if (normalizedKeyword && !normalizeFruitSequence(normalizedKeyword)) {
    return Response.json({ error: 'Use quatro emojis de frutas separados por hífen. Exemplo: 🍎-🍌-🍇-🍓.' }, { status: 400 });
  }
  const { data: lesson, error: lessonError } = await auth.supabase.from('apostilas').select('id').eq('discipline_slug', discipline_slug).eq('slug', lesson_slug).maybeSingle();
  if (lessonError || !lesson) return Response.json({ error: lessonError?.message ?? 'Capítulo não encontrado.' }, { status: 404 });

  if (normalizedKeyword) {
    const { error } = await auth.supabase.from('lesson_access_keys').upsert({
      discipline_slug,
      lesson_slug,
      keyword: normalizedKeyword,
      updated_by: auth.user.id,
      updated_at: new Date().toISOString()
    }, { onConflict: 'discipline_slug,lesson_slug' });
    if (error) return Response.json({ error: error.code === '23505' ? 'Essa palavra-chave já está em uso em outro capítulo.' : error.message }, { status: 400 });
  } else {
    const { error } = await auth.supabase.from('lesson_access_keys').delete().eq('discipline_slug', discipline_slug).eq('lesson_slug', lesson_slug);
    if (error) return Response.json({ error: error.message }, { status: 400 });
  }

  const { error: flagError } = await auth.supabase.from('apostilas').update({ keyword_required: Boolean(normalizedKeyword) }).eq('id', lesson.id);
  if (flagError) return Response.json({ error: flagError.message }, { status: 400 });
  return Response.json({ saved: true });
};
