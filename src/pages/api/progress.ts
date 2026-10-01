import type { APIRoute } from 'astro';
import { createSupabaseServerClient } from '../../lib/supabase';
export const prerender = false;

export const PUT: APIRoute = async ({ request, cookies }) => {
  let body: unknown;
  try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (!body || typeof body !== 'object') return Response.json({ error: 'Dados inválidos.' }, { status: 400 });
  const { discipline_slug, lesson_slug, completed } = body as Record<string, unknown>;
  if (typeof discipline_slug !== 'string' || typeof lesson_slug !== 'string' || typeof completed !== 'boolean' || discipline_slug.length > 100 || lesson_slug.length > 200) return Response.json({ error: 'Informe disciplina, aula e status válidos.' }, { status: 400 });
  try {
    const supabase = createSupabaseServerClient(cookies, request);
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) return Response.json({ error: 'Autenticação necessária.' }, { status: 401 });
    if (completed) {
      const { error } = await supabase.from('lesson_progress').upsert({ user_id: user.id, disciplina_slug: discipline_slug, lesson_slug }, { onConflict: 'user_id,disciplina_slug,lesson_slug' });
      if (error) throw error;
    } else {
      const { error } = await supabase.from('lesson_progress').delete().eq('user_id', user.id).eq('disciplina_slug', discipline_slug).eq('lesson_slug', lesson_slug);
      if (error) throw error;
    }
    return Response.json({ progress: { discipline_slug, lesson_slug, completed } });
  } catch (error) { console.error('Erro ao salvar progresso', error); return Response.json({ error: 'Não foi possível salvar o progresso.' }, { status: 500 }); }
};
