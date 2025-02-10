const environment = {
  plugins: {
    'postcss-nested': {},
    ...(process.env.NODE_ENV === 'production' ? { cssnano: {} } : {})
  }
}

module.exports = environment
