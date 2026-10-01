import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { apostilaSchema } from './content/config';

const apostilas = defineCollection({
  loader: glob({ base: './src/content/apostilas', pattern: '**/*.mdx' }),
  schema: apostilaSchema
});

export const collections = { apostilas };
