import gzipPlugin from 'rollup-plugin-gzip'
import { defineConfig } from 'vite'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'
import StimulusHMR from 'vite-plugin-stimulus-hmr'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    gzipPlugin(),
    StimulusHMR(),
    FullReload(['config/routes.rb', 'app/views/**/*'])
  ]
})
