/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./components/**/*.{js,vue,ts}",
    "./layouts/**/*.vue",
    "./pages/**/*.vue",
    "./plugins/**/*.{js,ts}",
    "./nuxt.config.{js,ts}",
    "./app.vue",
  ],
  theme: {
    fontSize: {
      'xl': ['5.5rem', {
        lineHeight: '5.5rem',
        letterSpacing: '-2.5px',
        fontWeight: '700',
      }],
      'l': ['3rem', {
        lineHeight: '3.5rem',
        letterSpacing: '-1.5px',
        fontWeight: '700',
      }],
      'm': ['1.5rem', {
        lineHeight: '2rem',
        fontWeight: '700',
      }],
      'body': ['1.125rem', {
        lineHeight: '1.75rem',
      }],
    },
    extend: {
      colors: {
        'primary-dark': '#151515',
        'accent-teal': '#4ee1a0',
        'dark-grey': '#242424',
        'light-grey': 'd9d9d9',
      },
      backgroundImage: {
        'matano': "url('/assets/images/matano.jpg')"
      }
    },
  },
  plugins: [],
}
