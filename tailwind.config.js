import harmonyPalette from '@evilmartians/harmony/tailwind'

module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/components/**/*.{html.erb,rb,js}',
    './app/services/**/*.rb',
    './app/helpers/**/*.rb',
    './app/assets/**/*.js',
    './app/lib/form_builders/**/*.rb',
    './config/locales/**/*.yml',
    './node_modules/flowbite/**/*.js'
  ],
  darkMode: 'class',
  theme: {
    colors: harmonyPalette,
    extend: {
      height: {
        nav: 'var(--nav-height)'
      },
      spacing: {
        nav: 'var(--nav-height)'
      }
    }
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms')(),
    require('flowbite/plugin')
  ]
}
