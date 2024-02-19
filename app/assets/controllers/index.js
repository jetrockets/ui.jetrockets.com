import { registerControllers } from 'stimulus-vite-helpers'
import Autosave from 'stimulus-rails-autosave'
import {
  Dropdown,
  Toggle,
  Modal
} from 'tailwindcss-stimulus-components'
import TextareaAutogrow from 'stimulus-textarea-autogrow'

import { stimulus } from '~/init'

stimulus.register('autosave', Autosave)
stimulus.register('dropdown', Dropdown)
stimulus.register('modal-sync', Modal)
stimulus.register('toggle', Toggle)
stimulus.register('textarea-autogrow', TextareaAutogrow)

// const controllers = import.meta.glob('./**/*_controller.js', { eager: true })

// registerControllers(stimulus, controllers)
