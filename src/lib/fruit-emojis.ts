export const fruitEmojis = [
  { emoji: '🍎', name: 'maçã vermelha' },
  { emoji: '🍏', name: 'maçã verde' },
  { emoji: '🍐', name: 'pera' },
  { emoji: '🍊', name: 'laranja' },
  { emoji: '🍋', name: 'limão' },
  { emoji: '🍌', name: 'banana' },
  { emoji: '🍉', name: 'melancia' },
  { emoji: '🍇', name: 'uvas' },
  { emoji: '🍓', name: 'morango' },
  { emoji: '🫐', name: 'mirtilo' },
  { emoji: '🍈', name: 'melão' },
  { emoji: '🍒', name: 'cerejas' },
  { emoji: '🍑', name: 'pêssego' },
  { emoji: '🥭', name: 'manga' },
  { emoji: '🍍', name: 'abacaxi' },
  { emoji: '🥥', name: 'coco' },
  { emoji: '🥝', name: 'kiwi' },
  { emoji: '🍅', name: 'tomate' },
  { emoji: '🫒', name: 'azeitona' },
  { emoji: '🥑', name: 'abacate' },
] as const;

export const fruitNameForEmoji = (emoji: string) => fruitEmojis.find((fruit) => fruit.emoji === emoji)?.name ?? emoji;

export function normalizeFruitSequence(value: string) {
  const sequence = value.trim().split('-').filter(Boolean);
  if (sequence.length !== 4 || sequence.some((emoji) => !fruitEmojis.some((fruit) => fruit.emoji === emoji))) return null;
  return sequence.join('-');
}

export function generateFruitSequence(randomValues: (array: Uint32Array) => Uint32Array = (array) => crypto.getRandomValues(array)) {
  const choose = () => fruitEmojis[randomValues(new Uint32Array(1))[0] % fruitEmojis.length].emoji;
  return [choose(), choose(), choose(), choose()].join('-');
}
