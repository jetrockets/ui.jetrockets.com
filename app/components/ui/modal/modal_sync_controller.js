import { Controller } from '@hotwired/stimulus'
import Modal from 'flowbite/lib/esm/components/modal'
import { stimulus } from '~/init'

export default class ModalSyncController extends Controller {
  static targets = ['modalContainer']

  connect () {
    this.modal = new Modal(this.modalContainerTarget, this.#options())
  }

  show () {
    this.modal.show()
  }

  close () {
    this.modal.hide()
  }

  #options () {
    const { placement } = this.element.dataset

    return {
      placement: placement || 'center-center'
      // backdrop: 'dynamic',
      // backdropClasses: 'bg-gray-950 bg-opacity-50 fixed inset-0 z-40',
      // closable: this.data.get('closable') === 'true',
    }
  }
}

stimulus.register('modal', ModalSyncController)
