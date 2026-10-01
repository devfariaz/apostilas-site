import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../lib/admin';
export const prerender = false;

export const GET: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  const { data, error } = await auth.supabase.rpc('admin_list_students');
  if (error) return Response.json({ error: error.message }, { status: 500 });
  const studentIds = (data ?? []).map((student: { id: string }) => student.id);
  const { data: assignments, error: assignmentsError } = studentIds.length
    ? await auth.supabase.from('student_disciplines').select('user_id,discipline_slug').in('user_id', studentIds)
    : { data: [], error: null };
  if (assignmentsError) return Response.json({ error: assignmentsError.message }, { status: 500 });
  const disciplinesByStudent = new Map<string, string[]>();
  for (const assignment of assignments ?? []) {
    const current = disciplinesByStudent.get(assignment.user_id) ?? [];
    current.push(assignment.discipline_slug);
    disciplinesByStudent.set(assignment.user_id, current);
  }
  // Read the relation table directly so the UI always reflects the persisted
  // assignments, even if an older RPC definition returns a stale aggregate.
  const students = (data ?? []).map((student: Record<string, any>) => ({
    ...student,
    year_level: student.year_level == null ? null : Number(student.year_level),
    discipline_slugs: disciplinesByStudent.get(student.id) ?? []
  }));
  const { data: disciplines, error: disciplinesError } = await auth.supabase.from('disciplines').select('slug,name').order('sort_order');
  if (disciplinesError) return Response.json({ error: disciplinesError.message }, { status: 500 });
  return Response.json({ students, disciplines });
};

export const PUT: APIRoute = async ({ request, cookies }) => {
  const auth = await requireAdmin(cookies, request); if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });
  let body: any; try { body = await request.json(); } catch { return Response.json({ error: 'JSON inválido.' }, { status: 400 }); }
  if (Array.isArray(body.student_ids)) {
    if (!body.student_ids.length || body.student_ids.length > 500 || !body.student_ids.every((id: unknown) => typeof id === 'string')) return Response.json({ error: 'Selecione até 500 alunos válidos.' }, { status: 400 });
    if (!Number.isInteger(body.year_level) || body.year_level < 1 || body.year_level > 3) return Response.json({ error: 'Selecione um ano válido.' }, { status: 400 });
    if (!Array.isArray(body.discipline_slugs) || !body.discipline_slugs.every((slug: unknown) => typeof slug === 'string')) return Response.json({ error: 'Disciplinas inválidas.' }, { status: 400 });
    const { data, error } = await auth.supabase.rpc('admin_bulk_update_student_access', { target_users: body.student_ids, target_year: body.year_level, target_disciplines: body.discipline_slugs });
    if (error) return Response.json({ error: error.message }, { status: 400 });
    return Response.json({ updated: data });
  }
  if (Array.isArray(body.discipline_slugs)) {
    if (body.year_level !== null && (!Number.isInteger(body.year_level) || body.year_level < 1 || body.year_level > 3)) return Response.json({ error: 'Selecione um ano válido.' }, { status: 400 });
    if (!body.discipline_slugs.every((slug: unknown) => typeof slug === 'string')) return Response.json({ error: 'Disciplinas inválidas.' }, { status: 400 });
    const { data, error } = await auth.supabase.rpc('admin_update_student_access', { target_user: body.id, target_year: body.year_level, target_disciplines: body.discipline_slugs });
    if (error) return Response.json({ error: error.message }, { status: 400 });
    if (!data) return Response.json({ error: 'Aluno não encontrado.' }, { status: 404 });
    return Response.json({ updated: true });
  }
  if (typeof body.id !== 'string' || typeof body.is_active !== 'boolean') return Response.json({ error: 'Informe aluno e status válidos.' }, { status: 400 });
  const { data, error } = await auth.supabase.rpc('admin_set_student_active', { target_user: body.id, new_active: body.is_active });
  if (error) return Response.json({ error: error.message }, { status: 400 });
  if (!data) return Response.json({ error: 'Aluno não encontrado.' }, { status: 404 });
  return Response.json({ updated: true });
};
