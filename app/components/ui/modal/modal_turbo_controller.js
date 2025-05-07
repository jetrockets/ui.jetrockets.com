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
    this.modal.hide()
  }

  disconnect () {
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
}

stimulus.register('modal-turbo', ModalTurboController)
