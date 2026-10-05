import type { APIRoute } from 'astro';
import { createSupabaseServerClient } from '../../../../../lib/supabase';

export const prerender = false;

export const GET: APIRoute = async ({ params, cookies, request, redirect }) => {
  const supabase = createSupabaseServerClient(cookies, request);
  const { data: guide, error: guideError } = await supabase
    .from('teacher_guides')
    .select('storage_path')
    .eq('id', params.id ?? '')
    .maybeSingle();

  if (guideError || !guide) return new Response('Guia não encontrado.', { status: 404 });
  if (!guide.storage_path) return new Response('Este guia não tem PDF de referência.', { status: 404 });

  const { data, error } = await supabase.storage
    .from('teacher-guides')
    .createSignedUrl(guide.storage_path, 60, { download: true });

  if (error || !data?.signedUrl) return new Response('Não foi possível preparar o download.', { status: 503 });
  return redirect(data.signedUrl, 302);
};
