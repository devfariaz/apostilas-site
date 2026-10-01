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
      const discipline = pathname.split('/').filter(Boolean)[1];
      if (discipline) {
        // A tabela pode conter vínculos duplicados legados; a autorização só
        // precisa confirmar que existe pelo menos um vínculo correspondente.
        const { data: assignment, error: assignmentError } = await supabase.from('student_disciplines').select('discipline_slug').eq('user_id', user.id).eq('discipline_slug', discipline).limit(1).maybeSingle();
        if (assignmentError || !assignment) return context.redirect('/?acesso=restrito');
      }
    }
    return next();
  } catch (error) {
    console.error('Falha ao validar sessão ou aprovação', error);
    return apiRequest ? Response.json({ error: 'Não foi possível validar o acesso.' }, { status: 503 }) : context.redirect('/login');
  }
});
