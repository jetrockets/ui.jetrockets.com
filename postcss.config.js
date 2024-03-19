const environment = {
  plugins: {
    'postcss-import': {},
    'tailwindcss/nesting': 'postcss-nested',
    tailwindcss: {},
    autoprefixer: {},
    ...(process.env.NODE_ENV === 'production' ? { cssnano: {} } : {})
  }
}

module.exports = environment
