module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/assets/**/*.js',
    './app/views/**/*.erb',
    './app/components/**/*.{erb,rb,js}',
    './app/lib/form_builders/**/*.rb'
  ],
  plugins: [
    require('@tailwindcss/forms')(),
    require('flowbite/plugin')
  ]
}
