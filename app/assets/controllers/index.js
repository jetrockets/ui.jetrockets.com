import Autosave from 'stimulus-rails-autosave'
import TextareaAutogrow from 'stimulus-textarea-autogrow'

import { stimulus } from '~/init'

stimulus.register('autosave', Autosave)
stimulus.register('textarea-autogrow', TextareaAutogrow)

import.meta.glob('./**/*_controller.js', { eager: true })
