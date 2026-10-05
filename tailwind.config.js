import plugin from 'tailwindcss/plugin';

/** @type {import('tailwindcss').Config} */
export default {
  darkMode: 'class',
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        // Deep Crimson brand palette (strategic discipline accent)
        crimson: {
          50: '#fff1f2',
          100: '#ffe4e6',
          200: '#fecdd3',
          300: '#fda4af',
          400: '#fb7185',
          500: '#f43f5e',
          600: '#e11d48', // Primary accent
          700: '#be123c', // Hover accent
          800: '#991b1b', // Active / deep crimson accent
          900: '#881337',
          950: '#4c0519',
          DEFAULT: '#e11d48',
        },
        // Dark theme zinc charcoal surfaces & borders
        dark: {
          bg: '#09090b',        // near-black primary canvas (zinc-950)
          surface: '#18181b',   // dark charcoal surface (zinc-900)
          card: '#18181b',      // subtle charcoal card (zinc-900)
          elevated: '#27272a',  // elevated dropdown/modal surface (zinc-800)
          cardHover: '#222226', // interactive card hover
          border: '#27272a',    // very subtle zinc-800 border
          borderHover: '#3f3f46', // subtle hover border (zinc-700)
          textPrimary: '#f4f4f5', // off-white primary text (zinc-100)
          textSecondary: '#a1a1aa', // muted gray secondary text (zinc-400)
          textMuted: '#71717a',     // muted text (zinc-500)
        },
        // Light theme counterparts
        light: {
          bg: '#fafafa',        // neutral/warm white background (zinc-50)
          surface: '#ffffff',   // clean white surface
          card: '#ffffff',      // white card
          elevated: '#f4f4f5',  // elevated surface (zinc-100)
          cardHover: '#f4f4f5',
          border: '#e4e4e7',    // subtle gray border (zinc-200)
          borderHover: '#d4d4d8', // zinc-300
          textPrimary: '#18181b', // charcoal primary text (zinc-900)
          textSecondary: '#71717a', // muted gray secondary text (zinc-500)
          textMuted: '#a1a1aa',
        },
        // Semantic status accents
        status: {
          success: '#10b981',   // muted green
          warning: '#f59e0b',   // muted amber
          danger: '#ef4444',    // muted red
          info: '#3b82f6',      // muted blue
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'sans-serif'],
      },
      boxShadow: {
        'subtle': '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
        'elevated': '0 4px 20px -2px rgba(0, 0, 0, 0.35)',
        'crimson-subtle': '0 0 15px -3px rgba(225, 29, 72, 0.25)',
      },
      animation: {
        'fade-in': 'fadeIn 0.2s ease-out forwards',
        'scale-in': 'scaleIn 0.15s ease-out forwards',
        'pulse-subtle': 'pulseSubtle 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0', transform: 'translateY(4px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        scaleIn: {
          '0%': { opacity: '0', transform: 'scale(0.97)' },
          '100%': { opacity: '1', transform: 'scale(1)' },
        },
        pulseSubtle: {
          '0%, 100%': { opacity: '1' },
          '50%': { opacity: '0.8' },
        },
      },
    },
  },
  plugins: [
    plugin(({ addVariant }) => {
      addVariant('light', ':is(.light &)');
    }),
  ],
};
