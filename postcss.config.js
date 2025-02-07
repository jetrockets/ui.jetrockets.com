const environment = {
  plugins: {
    'postcss-nested': {},
    '@tailwindcss/postcss': {},
    ...(process.env.NODE_ENV === 'production' ? { cssnano: {} } : {})
  }
}

module.exports = environment
