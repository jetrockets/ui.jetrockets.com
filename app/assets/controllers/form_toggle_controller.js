import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['on_hint', 'off_hint']

  toggle (event) {
    event.preventDefault()
    this.on_hintTarget.classList.toggle('hidden')
    this.off_hintTarget.classList.toggle('hidden')
  }
}
