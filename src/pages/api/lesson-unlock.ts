import type { APIRoute } from 'astro';
import { createSupabaseServerClient } from '../../lib/supabase';

export const POST: APIRoute = async ({ request, cookies }) => {
  let body: unknown;
  try { body = await request.json(); }
  catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (!body || typeof body !== 'object') return Response.json({ error: 'Dados inválidos.' }, { status: 400 });

  const { discipline_slug, lesson_slug, keyword } = body as Record<string, unknown>;
  if (typeof discipline_slug !== 'string' || discipline_slug.length > 120 || typeof lesson_slug !== 'string' || lesson_slug.length > 180 || typeof keyword !== 'string' || keyword.trim().length < 1 || keyword.length > 100) {
    return Response.json({ error: 'Digite a palavra-chave do capítulo.' }, { status: 400 });
  }

  try {
    const supabase = createSupabaseServerClient(cookies, request);
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) return Response.json({ error: 'Entre na sua conta para liberar o capítulo.' }, { status: 401 });

    const { data, error } = await supabase.rpc('unlock_lesson_with_keyword', {
      target_discipline: discipline_slug,
      target_lesson: lesson_slug,
      provided_keyword: keyword
    });
    if (error) throw error;
    if (!data) return Response.json({ error: 'A palavra-chave não confere.' }, { status: 403 });
    return Response.json({ unlocked: true });
  } catch (error) {
    console.error('Falha ao validar palavra-chave do capítulo:', error);
    return Response.json({ error: 'Não foi possível liberar o capítulo agora.' }, { status: 500 });
  }
};
