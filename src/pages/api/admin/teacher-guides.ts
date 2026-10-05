import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../lib/admin';

const slugify = (value: string) => value.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase().trim().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');

export const GET: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  const { data, error } = await auth.supabase.from('teacher_guides').select('*').order('created_at');
  if (error) return Response.json({ error: error.message }, { status: 500 });
  return Response.json({ guides: data });
};

async function save({ request, cookies }: Parameters<APIRoute>[0]) {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });

  let form: FormData;
  try { form = await request.formData(); } catch { return Response.json({ error: 'Formulário inválido.' }, { status: 400 }); }
  const id = String(form.get('id') ?? '');
  const discipline_slug = String(form.get('discipline_slug') ?? '').trim();
  const module_id = String(form.get('module_id') ?? '').trim();
  const title = String(form.get('title') ?? '').trim();
  const file = form.get('pdf');
  if (!discipline_slug || !module_id || !title || title.length > 180) return Response.json({ error: 'Informe disciplina, módulo e título do guia.' }, { status: 400 });

  const { data: module, error: moduleError } = await auth.supabase.from('modules').select('id,slug,discipline_slug').eq('id', module_id).eq('discipline_slug', discipline_slug).maybeSingle();
  if (moduleError || !module) return Response.json({ error: 'O módulo escolhido não pertence à disciplina selecionada.' }, { status: 400 });

  const { data: existing, error: existingError } = id
    ? await auth.supabase.from('teacher_guides').select('*').eq('id', id).maybeSingle()
    : { data: null, error: null };
  if (existingError || (id && !existing)) return Response.json({ error: 'Guia não encontrado.' }, { status: 404 });
  if (file instanceof File && file.size > 0 && (file.type !== 'application/pdf' || file.size > 20 * 1024 * 1024)) {
    return Response.json({ error: 'Envie um PDF de até 20 MB.' }, { status: 400 });
  }
  let storagePath: string | null = existing?.storage_path ?? null;
  let uploadedPath = '';
  let sourceFilename: string | null = existing?.source_filename ?? null;
  if (file instanceof File && file.size > 0) {
    const bytes = new Uint8Array(await file.arrayBuffer());
    if (new TextDecoder().decode(bytes.slice(0, 5)) !== '%PDF-') return Response.json({ error: 'O arquivo selecionado não parece ser um PDF válido.' }, { status: 400 });
    sourceFilename = file.name.slice(0, 180) || `${slugify(title)}.pdf`;
    uploadedPath = `${discipline_slug}/${module.slug}-${crypto.randomUUID()}.pdf`;
    const { error: uploadError } = await auth.supabase.storage.from('teacher-guides').upload(uploadedPath, bytes, { contentType: 'application/pdf', upsert: false, cacheControl: '3600' });
    if (uploadError) return Response.json({ error: `Falha ao enviar o PDF: ${uploadError.message}` }, { status: 400 });
    storagePath = uploadedPath;
  }

  const values = {
    discipline_slug, module_id, title, source_filename: sourceFilename, storage_path: storagePath,
    page_count: existing?.page_count ?? 1, created_by: existing?.created_by ?? auth.user.id, updated_at: new Date().toISOString(),
  };
  const result = existing
    ? await auth.supabase.from('teacher_guides').update(values).eq('id', id).select().single()
    : await auth.supabase.from('teacher_guides').insert(values).select().single();

  if (result.error) {
    if (uploadedPath) await auth.supabase.storage.from('teacher-guides').remove([uploadedPath]);
    return Response.json({ error: result.error.message }, { status: 400 });
  }
  if (uploadedPath && existing?.storage_path) await auth.supabase.storage.from('teacher-guides').remove([existing.storage_path]);
  return Response.json({ guide: result.data });
}

export const POST: APIRoute = save;
export const PUT: APIRoute = save;

export const DELETE: APIRoute = async ({ request, cookies }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: { id?: unknown };
  try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (typeof body.id !== 'string') return Response.json({ error: 'Guia inválido.' }, { status: 400 });
  const { data: guide, error: readError } = await auth.supabase.from('teacher_guides').select('storage_path').eq('id', body.id).maybeSingle();
  if (readError || !guide) return Response.json({ error: 'Guia não encontrado.' }, { status: 404 });
  const { error } = await auth.supabase.from('teacher_guides').delete().eq('id', body.id);
  if (error) return Response.json({ error: error.message }, { status: 400 });
  if (guide.storage_path) await auth.supabase.storage.from('teacher-guides').remove([guide.storage_path]);
  return Response.json({ deleted: true });
};
