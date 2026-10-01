import { createServerClient, type CookieOptions } from '@supabase/ssr';
import { parseCookie } from 'cookie';
import type { AstroCookies } from 'astro';

export function createSupabaseServerClient(cookies: AstroCookies, request: Request) {
  const url = import.meta.env.PUBLIC_SUPABASE_URL;
  const publishableKey = import.meta.env.PUBLIC_SUPABASE_PUBLISHABLE_KEY;
  if (!url || !publishableKey) throw new Error('Configure PUBLIC_SUPABASE_URL e PUBLIC_SUPABASE_PUBLISHABLE_KEY.');

  return createServerClient(url, publishableKey, {
    cookies: {
      getAll: () => Object.entries(parseCookie(request.headers.get('cookie') ?? '')).map(([name, value]) => ({ name, value })),
      setAll: (values: { name: string; value: string; options: CookieOptions }[]) => {
        values.forEach(({ name, value, options }) => cookies.set(name, value, options));
      }
    }
  });
}
