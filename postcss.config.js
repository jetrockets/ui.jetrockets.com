const cssnano = require('cssnano')({ preset: 'default' })

const environment = {
  plugins: [
    require('tailwindcss'),
    require('autoprefixer'),
    ...process.env.NODE_ENV === 'production'
      ? [cssnano]
      : []
  ]
}

module.exports = environment
