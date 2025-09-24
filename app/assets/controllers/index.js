import Autosave from 'stimulus-rails-autosave'
import {
  Toggle,
  Modal
} from 'tailwindcss-stimulus-components'
import TextareaAutogrow from 'stimulus-textarea-autogrow'

import { stimulus } from '~/init'

stimulus.register('autosave', Autosave)
stimulus.register('modal-sync', Modal)
stimulus.register('toggle', Toggle)
stimulus.register('textarea-autogrow', TextareaAutogrow)

import.meta.glob('./**/*_controller.js', { eager: true })
