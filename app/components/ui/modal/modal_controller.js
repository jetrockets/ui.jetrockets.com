import { Controller } from '@hotwired/stimulus'
// import Modal from 'flowbite/lib/esm/components/modal'
import { stimulus } from '~/init'

export default class ModalController extends Controller {
  static targets = ['trigger', 'modal']

  connect () {
    // this.triggerTargets.forEach((trigger) => {
    //   this.modal = new Modal(this.modalContainerTarget, this.#options())
    // })
  }
}

stimulus.register('modal', ModalController)
