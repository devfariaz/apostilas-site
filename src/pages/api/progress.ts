import type { APIRoute } from 'astro';
import { createSupabaseServerClient } from '../../lib/supabase';
export const prerender = false;

export const PUT: APIRoute = async ({ request, cookies }) => {
  let body: unknown;
  try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (!body || typeof body !== 'object') return Response.json({ error: 'Dados inválidos.' }, { status: 400 });
  const { discipline_slug, lesson_slug, completed } = body as Record<string, unknown>;
  if (typeof discipline_slug !== 'string' || typeof lesson_slug !== 'string' || typeof completed !== 'boolean' || discipline_slug.length > 100 || lesson_slug.length > 200) return Response.json({ error: 'Informe disciplina, aula e status válidos.' }, { status: 400 });
  if (!completed) return Response.json({ error: 'Uma aula concluída não pode ser desmarcada.' }, { status: 409 });
  try {
    const supabase = createSupabaseServerClient(cookies, request);
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) return Response.json({ error: 'Autenticação necessária.' }, { status: 401 });
    const [{ data: lessons, error: lessonsError }, { data: modules, error: modulesError }, { data: existingProgress, error: progressError }] = await Promise.all([
      supabase.from('apostilas').select('slug,lesson_order,module_id,module').eq('discipline_slug', discipline_slug).eq('published', true),
      supabase.from('modules').select('id,name,sort_order').eq('discipline_slug', discipline_slug).order('sort_order'),
      supabase.from('lesson_progress').select('lesson_slug').eq('user_id', user.id).eq('disciplina_slug', discipline_slug)
    ]);
    if (lessonsError || modulesError || progressError) throw lessonsError ?? modulesError ?? progressError;
    const moduleOrder = (lesson: any) => {
      const index = (modules ?? []).findIndex((module) => module.id === lesson.module_id || module.name === lesson.module);
      return index < 0 ? (modules ?? []).length : index;
    };
    const orderedLessons = [...(lessons ?? [])].sort((a, b) => moduleOrder(a) - moduleOrder(b) || a.lesson_order - b.lesson_order || a.slug.localeCompare(b.slug));
    const currentIndex = orderedLessons.findIndex((lesson) => lesson.slug === lesson_slug);
    if (currentIndex < 0) return Response.json({ error: 'Capítulo não encontrado.' }, { status: 404 });
    const completedBefore = new Set((existingProgress ?? []).map((row) => row.lesson_slug));
    const missingPrerequisite = orderedLessons.slice(0, currentIndex).find((lesson) => !completedBefore.has(lesson.slug));
    if (missingPrerequisite) return Response.json({ error: 'Conclua os capítulos anteriores antes de avançar.' }, { status: 409 });
    const { error } = await supabase.from('lesson_progress').upsert({ user_id: user.id, disciplina_slug: discipline_slug, lesson_slug }, { onConflict: 'user_id,disciplina_slug,lesson_slug' });
    if (error) throw error;
    return Response.json({ progress: { discipline_slug, lesson_slug, completed } });
  } catch (error) { console.error('Erro ao salvar progresso', error); return Response.json({ error: 'Não foi possível salvar o progresso.' }, { status: 500 }); }
};
