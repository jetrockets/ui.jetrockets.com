const cssnano = require('cssnano')({ preset: 'default' });

const environment = {
  plugins: [
    require('postcss-nesting'),
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: { flexbox: 'no-2009' },
      stage: 3
    }),
    require('tailwindcss')('./tailwind.config.js'),
    require('autoprefixer'),
    ...process.env.NODE_ENV === 'production'
      ? [cssnano]
      : []
  ]
};

module.exports = environment;
