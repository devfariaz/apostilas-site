import type { AstroCookies } from 'astro';
import { createSupabaseServerClient } from './supabase';

export async function requireAdmin(cookies: AstroCookies, request: Request) {
  const supabase = createSupabaseServerClient(cookies, request);
  const { data: { user }, error: authError } = await supabase.auth.getUser();
  if (authError || !user) return { supabase, user: null, error: 'Autenticação necessária.', status: 401 as const };
  const { data: profile, error } = await supabase.from('profiles').select('is_active,role').eq('id', user.id).maybeSingle();
  if (error || !profile?.is_active || profile.role !== 'admin') return { supabase, user: null, error: 'Acesso administrativo necessário.', status: 403 as const };
  return { supabase, user, error: null, status: 200 as const };
}

export async function requireTeacher(cookies: AstroCookies, request: Request) {
  const supabase = createSupabaseServerClient(cookies, request);
  const { data: { user }, error: authError } = await supabase.auth.getUser();
  if (authError || !user) return { supabase, user: null, error: 'Autenticação necessária.', status: 401 as const };
  const { data: profile, error } = await supabase.from('profiles').select('is_active,role,can_access_teacher_guides').eq('id', user.id).maybeSingle();
  if (error || !profile?.is_active || (profile.role !== 'admin' && !profile.can_access_teacher_guides)) {
    return { supabase, user: null, error: 'Acesso à área do professor necessário.', status: 403 as const };
  }
  return { supabase, user, error: null, status: 200 as const };
}
