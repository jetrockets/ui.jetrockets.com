module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/assets/**/*.js',
    './app/views/**/*',
    './app/components/**/*',
    './app/lib/form_builders/**/*.rb'
  ],
  plugins: [
    require('@tailwindcss/forms')(),
    require('flowbite/plugin')
  ],
  safelist: [
    {
      pattern: /btn-(xs|sm|md|lg|xl)/
    }
  ]
}
