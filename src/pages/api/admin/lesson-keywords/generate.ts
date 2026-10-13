import type { APIRoute } from 'astro';
import { requireAdmin } from '../../../../lib/admin';
import { generateFruitSequence } from '../../../../lib/fruit-emojis';

export const POST: APIRoute = async ({ cookies, request }) => {
  const auth = await requireAdmin(cookies, request);
  if (!auth.user) return Response.json({ error: auth.error }, { status: auth.status });

  const existing = new Set<string>();
  for (let from = 0; ; from += 1000) {
    const { data, error } = await auth.supabase
      .from('lesson_access_keys')
      .select('keyword')
      .range(from, from + 999);
    if (error) return Response.json({ error: 'Não foi possível consultar as sequências já cadastradas.' }, { status: 500 });
    (data ?? []).forEach((row) => existing.add(String(row.keyword).trim()));
    if (!data || data.length < 1000) break;
  }
  for (let attempt = 0; attempt < 20; attempt++) {
    const keyword = generateFruitSequence();
    if (!existing.has(keyword)) return Response.json({ keyword });
  }

  return Response.json({ error: 'Não foi possível encontrar uma sequência disponível. Tente novamente.' }, { status: 503 });
};
