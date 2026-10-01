export const disciplines = [
  { slug: 'game-design-i', name: 'Game Design I', description: 'Fundamentos de criação de jogos', icon: '✳' },
  { slug: 'game-design-ii', name: 'Game Design II', description: 'Projeto e prototipagem de jogos', icon: '◈' },
  { slug: 'producao-multimidia-i', name: 'Produção Multimídia I', description: 'Linguagens e ferramentas multimídia', icon: '▦' },
  { slug: 'producao-multimidia-ii', name: 'Produção Multimídia II', description: 'Produção e publicação de projetos', icon: '▣' },
  { slug: 'marketing', name: 'Marketing', description: 'Estratégia, comunicação e mercado', icon: '↗' }
] as const;

export function lessonPath(discipline: string, id: string) {
  const prefix = `${discipline}/`;
  const slug = id.startsWith(prefix) ? id.slice(prefix.length) : id;
  return `/apostila/${discipline}/${slug}`;
}
