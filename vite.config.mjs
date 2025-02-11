import gzipPlugin from 'rollup-plugin-gzip'
import { defineConfig } from 'vite'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'
import StimulusHMR from 'vite-plugin-stimulus-hmr'
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [
    tailwindcss(),
    FullReload(['config/routes.rb', 'app/views/**/*']),
    RubyPlugin(),
    gzipPlugin(),
    StimulusHMR()
  ]
})
