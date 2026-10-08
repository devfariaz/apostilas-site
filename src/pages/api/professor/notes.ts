import type { APIRoute } from 'astro';
import { requireTeacher } from '../../../lib/admin';

export const prerender = false;

export const PUT: APIRoute = async ({ request, cookies }) => {
  const auth = await requireTeacher(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });

  let body: unknown;
  try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (!body || typeof body !== 'object') return Response.json({ error: 'Dados inválidos.' }, { status: 400 });
  const { chapter_id, content } = body as Record<string, unknown>;
  if (typeof chapter_id !== 'string' || typeof content !== 'string' || chapter_id.length > 80 || content.length > 50000) {
    return Response.json({ error: 'Informe um capítulo válido. As notas podem ter até 50 mil caracteres.' }, { status: 400 });
  }

  const { data: chapter, error: chapterError } = await auth.supabase
    .from('teacher_guide_chapters')
    .select('id')
    .eq('id', chapter_id)
    .maybeSingle();
  if (chapterError || !chapter) return Response.json({ error: 'Capítulo do guia não encontrado.' }, { status: 404 });

  const { data, error } = await auth.supabase
    .from('teacher_guide_notes')
    .upsert({ user_id: auth.user.id, chapter_id, content, updated_at: new Date().toISOString() }, { onConflict: 'user_id,chapter_id' })
    .select('updated_at')
    .single();
  if (error) {
    console.error('Erro ao salvar nota do guia do professor', error);
    return Response.json({ error: 'Não foi possível salvar suas notas.' }, { status: 500 });
  }
  return Response.json({ saved: true, updated_at: data.updated_at });
};
