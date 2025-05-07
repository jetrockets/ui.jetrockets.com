import { Controller } from '@hotwired/stimulus'
import Modal from 'flowbite/lib/esm/components/modal'
import { stimulus } from '~/init'

export default class ModalController extends Controller {
  static targets = ['trigger', 'modal']

  connect () {
    this.modals = new Map()
    this.#initializeModals()
  }

  show (e) {
    this.#getModal(e)?.show()
  }

  close (e) {
    this.#getModal(e)?.hide()
  }

  #getModal (e) {
    const id = e.currentTarget.dataset.id
    return this.modals.get(id)
  }

  #initializeModals () {
    this.triggerTargets.forEach(trigger => {
      const targetId = trigger.dataset.id
      const modalElement = this.modalTargets.find(i => i.id === targetId)

      this.modals.set(targetId, new Modal(modalElement, {
        backdropClasses: 'bg-gray-900/50 fixed inset-0 z-30'
      }))
    })
  }
}

stimulus.register('modal', ModalController)
