import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class FormToggleController extends Controller {
  static targets = ['on_hint', 'off_hint']

  toggle (event) {
    event.preventDefault()
    this.on_hintTarget.classList.toggle('hidden')
    this.off_hintTarget.classList.toggle('hidden')
  }
}

stimulus.register('form-toggle', FormToggleController)
