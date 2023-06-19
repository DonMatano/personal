// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  css: ['~/assets/css/main.css', 'vue-final-modal/style.css'],
   postcss: {
    plugins: {
      tailwindcss: {},
      autoprefixer: {},
    },
  },
  modules: [
    ['@nuxtjs/google-fonts', {
      families: {
        'Nunito': true,
        download: true,
        inject: true,
      }
    }],
    '@nuxtjs/supabase',
  ]
})
