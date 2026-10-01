import type { APIRoute } from 'astro';
import { createSupabaseServerClient } from '../../../lib/supabase';
export const prerender = false;

export const POST: APIRoute = async ({ cookies, request, redirect }) => {
  try {
    const supabase = createSupabaseServerClient(cookies, request);
    const { error } = await supabase.auth.signOut();
    if (error) console.error('Erro ao encerrar sessão', error);
  } catch (error) { console.error('Erro ao encerrar sessão', error); }
  return redirect('/');
};
