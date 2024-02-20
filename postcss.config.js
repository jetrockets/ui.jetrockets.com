const environment = {
  plugins: {
    tailwindcss: {},
    '@csstools/postcss-oklab-function': { preserve: true },
    autoprefixer: {},
    ...(process.env.NODE_ENV === 'production' ? { cssnano: {} } : {})
  }
}

module.exports = environment
