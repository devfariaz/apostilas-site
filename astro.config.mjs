// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';
import mdx from '@astrojs/mdx';
import vercel from '@astrojs/vercel';

// https://astro.build/config
export default defineConfig({
  output: 'server',
  vite: {
    plugins: [tailwindcss()],
    build: {
      rolldownOptions: {
        onwarn(warning, defaultHandler) {
          // Astro injects this internal directive into propagated MDX assets so
          // its head plugin can collect styles/scripts. Rolldown reports it as
          // a module directive even though Astro consumes it during bundling.
          if (warning.code === 'MODULE_LEVEL_DIRECTIVE' && warning.message.includes('"use astro:head-inject"')) return;
          defaultHandler(warning);
        }
      }
    }
  },

  integrations: [mdx()],
  adapter: vercel()
});
