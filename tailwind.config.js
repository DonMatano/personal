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
    extend: {
      colors: {
        'primary-dark': '#151515',
        'accent-teal': '#4ee1a0',
        'dark-grey': '#242424',
        'light-grey': 'd9d9d9',
      }
    },
  },
  plugins: [],
}
