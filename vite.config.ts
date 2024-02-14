import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import StimulusHMR from 'vite-plugin-stimulus-hmr';
import compression from 'vite-plugin-compression';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    StimulusHMR(),
    compression()
  ],
})
