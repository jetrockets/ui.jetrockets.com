import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'
import Modal from 'flowbite/lib/esm/components/modal'

export default class ModalController extends Controller {
  connect () {
    const options = {
      placement: 'center-center',
      // backdrop: 'dynamic',
      // backdropClasses: 'bg-gray-950 bg-opacity-50 fixed inset-0 z-40',
      // closable: this.data.get('closable') === 'true',
      onHide: () => {
        this.element.remove()
        window.modal = undefined
      }
    }

    const instanceOptions = {
      id: 'modalContainer',
      override: false
    }

    this.modal = new Modal(this.element, options, instanceOptions)
    window.modal = this.modal
    this.modal.show()
  }

  close () {
    this.modal.hide()
  }

  disconnect () {
    this.element.remove()
  }
}

stimulus.register('modal', ModalController)
