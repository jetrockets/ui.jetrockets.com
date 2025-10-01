import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class ModalController extends Controller {
  connect () {
    this.element.addEventListener('click', this.#closeOnBackdropClick.bind(this))
    this.element.showModal()
  }

  disconnect () {
    this.element.removeEventListener('click', this.#closeOnBackdropClick.bind(this))
    this.close()
  }

  show () {
    this.element.showModal()
  }

  close () {
    try {
      this.element.close()
      ModalController.turboFrame.src = null
      this.element.remove()
    } catch (e) {}
  }

  #closeOnBackdropClick (event) {
    if (event.target === this.element) {
      this.close()
    }
  }

  static get turboFrame () {
    return document.querySelector('turbo-frame[id=\'modal\']')
  }
}

stimulus.register('modal', ModalController)
