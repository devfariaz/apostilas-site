import { z } from 'astro:content';

export const disciplines = ['desenho', 'pintura', 'historia-da-arte', 'design-grafico', 'fotografia', 'ilustracao', 'game-design-i', 'game-design-ii', 'producao-multimidia-i', 'producao-multimidia-ii', 'marketing'] as const;
export const apostilaSchema = z.object({
  title: z.string().min(1),
  discipline: z.string().regex(/^[a-z0-9]+(?:-[a-z0-9]+)*$/),
  module: z.string().min(1),
  order: z.number().int().nonnegative(),
  summary: z.string().min(1),
  tags: z.array(z.string()).default([])
});
