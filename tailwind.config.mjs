import typography from '@tailwindcss/typography';

/** @type {import('tailwindcss').Config} */
export default {
  darkMode: 'class',
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,ts,tsx}'],
  theme: {
    extend: {
      colors: {
        'bg-light': '#FAF7F2', 'bg-dark': '#121214',
        'surface-light': '#FFFFFF', 'surface-dark': '#1E1E22',
        'text-main-light': '#1E1E1E', 'text-main-dark': '#EDEDED',
        'text-muted-light': '#666666', 'text-muted-dark': '#9CA3AF',
        'accent-light': '#007F9E', 'accent-dark': '#FF6B4A',
        'highlight-light': '#E8B931', 'highlight-dark': '#D97706',
        'border-light': '#E5E0D8', 'border-dark': '#2A2A2E'
      },
      fontFamily: { sans: ['Inter', 'ui-sans-serif', 'system-ui'], display: ['Fraunces', 'Georgia', 'serif'] }
    }
  },
  plugins: [typography]
};
