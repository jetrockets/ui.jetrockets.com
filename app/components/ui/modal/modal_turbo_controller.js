import { Controller } from '@hotwired/stimulus'
import Modal from 'flowbite/lib/esm/components/modal'
import { stimulus } from '~/init'

export default class ModalTurboController extends Controller {
  connect () {
    this.#initializeModal()
    this.modal.show()
  }

  show () {
    this.modal.show()
  }

  close () {
    try {
      ModalTurboController.turboFrame.src = null
      this.modal.removeInstance()
      this.modal.hide()
      this.element.remove()
    } catch (e) {}
  }

  disconnect () {
    this.close()
    this.element.remove()
  }

  #initializeModal () {
    const options = this.#getModalOptions()
    this.modal = new Modal(this.element, options)
  }

  #getModalOptions () {
    const { closable } = this.element.dataset
    return {
      backdropClasses: 'bg-gray-900/50 fixed inset-0 z-30',
      closable: closable || 'true',
      onHide: () => {
        this.element.remove()
      }
    }
  }

  static get turboFrame () {
    return document.querySelector('turbo-frame[id=\'modal\']')
  }
}

stimulus.register('modal-turbo', ModalTurboController)
