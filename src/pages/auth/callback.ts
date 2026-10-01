import type { APIRoute } from 'astro';
import { createSupabaseServerClient } from '../../lib/supabase';
export const prerender = false;

export const GET: APIRoute = async ({ url, cookies, request, redirect }) => {
  const code = url.searchParams.get('code');
  if (!code) return redirect('/login?erro=confirmacao');
  try {
    const supabase = createSupabaseServerClient(cookies, request);
    const { data, error } = await supabase.auth.exchangeCodeForSession(code);
    if (error || !data.user) return redirect('/login?erro=confirmacao');
    const { data: profile } = await supabase.from('profiles').select('is_active,role').eq('id', data.user.id).maybeSingle();
    if (!profile?.is_active) return redirect('/aguardando-aprovacao');
    return redirect(profile.role === 'admin' ? '/admin' : '/');
  } catch (error) {
    console.error('Falha ao concluir confirmação de e-mail', error);
    return redirect('/login?erro=confirmacao');
  }
};
