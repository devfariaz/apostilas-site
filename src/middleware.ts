import { defineMiddleware } from 'astro:middleware';
import { createSupabaseServerClient } from './lib/supabase';

export const onRequest = defineMiddleware(async (context, next) => {
  const { pathname } = context.url;
  const isApostila = pathname === '/apostila' || pathname.startsWith('/apostila/');
  const isAdmin = pathname === '/admin' || pathname.startsWith('/admin/') || pathname === '/api/admin' || pathname.startsWith('/api/admin/');
  if (!isApostila && !isAdmin) return next();

  const apiRequest = pathname === '/api/admin' || pathname.startsWith('/api/admin/');
  const reject = (status: number, message: string) => apiRequest
    ? Response.json({ error: message }, { status })
    : context.redirect(status === 401 ? `/login?next=${encodeURIComponent(pathname)}` : '/aguardando-aprovacao');

  try {
    const supabase = createSupabaseServerClient(context.cookies, context.request);
    const { data: { user }, error } = await supabase.auth.getUser();
    if (error || !user) return reject(401, 'Autenticação necessária.');

    const { data: profile, error: profileError } = await supabase.from('profiles').select('is_active,role').eq('id', user.id).maybeSingle();
    if (profileError || !profile?.is_active) return reject(403, 'A conta aguarda aprovação.');
    if (isAdmin && profile.role !== 'admin') return reject(403, 'Acesso administrativo necessário.');
    if (isApostila && profile.role !== 'admin') {
      const segments = pathname.split('/').filter(Boolean);
      const discipline = segments[1];
      if (discipline) {
        const { data: assignments, error: assignmentError } = await supabase.from('student_disciplines').select('discipline_slug').eq('user_id', user.id).eq('discipline_slug', discipline).limit(1);
        if (assignmentError) {
          console.error('Falha ao verificar a disciplina do aluno:', assignmentError);
          return context.redirect('/?acesso=restrito');
        }
        if (!assignments?.length) return context.redirect('/?acesso=restrito');

        // Rotas antigas de capítulo também passam pela barreira sequencial.
        // A página principal aplica a mesma regra antes de renderizar conteúdo.
        if (segments.length > 2) {
          const targetSlug = segments.at(-1);
          const [{ data: lessons, error: lessonsError }, { data: modules, error: modulesError }, { data: progress, error: progressError }] = await Promise.all([
            supabase.from('apostilas').select('slug,lesson_order,module_id,module').eq('discipline_slug', discipline).eq('published', true),
            supabase.from('modules').select('id,name,sort_order').eq('discipline_slug', discipline).order('sort_order'),
            supabase.from('lesson_progress').select('lesson_slug').eq('user_id', user.id).eq('disciplina_slug', discipline)
          ]);
          if (lessonsError || modulesError || progressError) {
            console.error('Falha ao verificar pré-requisitos do capítulo:', lessonsError ?? modulesError ?? progressError);
            return context.redirect(`/apostila/${discipline}`);
          }
          const moduleOrder = (lesson: any) => {
            const index = (modules ?? []).findIndex((module) => module.id === lesson.module_id || module.name === lesson.module);
            return index < 0 ? (modules ?? []).length : index;
          };
          const orderedLessons = [...(lessons ?? [])].sort((a, b) => moduleOrder(a) - moduleOrder(b) || a.lesson_order - b.lesson_order || a.slug.localeCompare(b.slug));
          const currentIndex = orderedLessons.findIndex((lesson) => lesson.slug === targetSlug);
          if (currentIndex >= 0) {
            const completed = new Set((progress ?? []).map((row) => row.lesson_slug));
            if (orderedLessons.slice(0, currentIndex).some((lesson) => !completed.has(lesson.slug))) {
              return context.redirect(`/apostila/${discipline}?capitulo-bloqueado=1`);
            }
          }
        }
      }
    }
    return next();
  } catch (error) {
    console.error('Falha ao validar sessão ou aprovação', error);
    return apiRequest ? Response.json({ error: 'Não foi possível validar o acesso.' }, { status: 503 }) : context.redirect('/login');
  }
});
