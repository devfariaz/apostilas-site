import type { APIRoute } from 'astro';
import { createSupabaseServerClient } from '../../lib/supabase';
export const prerender = false;

export const GET: APIRoute = async ({ url, cookies, request }) => {
  const discipline = url.searchParams.get('discipline'); const lesson = url.searchParams.get('lesson');
  if (!discipline || !lesson) return Response.json({ error: 'Informe disciplina e aula.' }, { status: 400 });
  try {
    const supabase = createSupabaseServerClient(cookies, request); const { data: { user } } = await supabase.auth.getUser();
    if (!user) return Response.json({ error: 'Autenticação necessária.' }, { status: 401 });
    const { data, error } = await supabase.from('user_notes').select('content,updated_at').eq('user_id', user.id).eq('disciplina_slug', discipline).eq('lesson_slug', lesson).maybeSingle();
    if (error) throw error; return Response.json({ note: data });
  } catch (error) { console.error('Erro ao buscar anotação', error); return Response.json({ error: 'Não foi possível carregar a anotação.' }, { status: 500 }); }
};

export const PUT: APIRoute = async ({ request, cookies }) => {
  let body: unknown; try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (!body || typeof body !== 'object') return Response.json({ error: 'Dados inválidos.' }, { status: 400 });
  const { discipline_slug, lesson_slug, content } = body as Record<string, unknown>;
  if (typeof discipline_slug !== 'string' || typeof lesson_slug !== 'string' || typeof content !== 'string' || discipline_slug.length > 100 || lesson_slug.length > 200 || content.length > 50000) return Response.json({ error: 'Informe disciplina, aula e texto válidos (máximo 50 mil caracteres).' }, { status: 400 });
  try {
    const supabase = createSupabaseServerClient(cookies, request); const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) return Response.json({ error: 'Autenticação necessária.' }, { status: 401 });
    const { data, error } = await supabase.from('user_notes').upsert({ user_id: user.id, disciplina_slug: discipline_slug, lesson_slug, content, updated_at: new Date().toISOString() }, { onConflict: 'user_id,disciplina_slug,lesson_slug' }).select('updated_at').single();
    if (error) throw error; return Response.json({ saved: true, updated_at: data.updated_at });
  } catch (error) { console.error('Erro ao salvar anotação', error); return Response.json({ error: 'Não foi possível salvar a anotação.' }, { status: 500 }); }
};
