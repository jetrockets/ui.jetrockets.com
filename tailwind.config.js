module.exports = {
  mode: 'jit',
  content: [
    './app/views/**/*.html.erb',
    './app/components/**/*.{html.erb,rb}',
    './app/services/**/*.rb',
    './app/helpers/**/*.rb',
    './app/assets/**/*.js',
    './app/lib/form_builders/**/*.rb',
    './config/locales/**/*.yml'
  ],
  theme: {
    extend: {

    }
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms')()
  ]
}
