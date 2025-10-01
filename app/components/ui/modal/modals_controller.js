import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class ModalsController extends Controller {
  static targets = ['dialog']

  disconnect () {
    this.openedDialog?.removeEventListener('click', this.#closeOnBackdropClick.bind(this))
  }

  show (e) {
    this.openedDialog = this.#getDialog(e)
    this.openedDialog.addEventListener('click', this.#closeOnBackdropClick.bind(this))

    this.#getDialog(e)?.showModal()
  }

  close (e) {
    this.#getDialog(e)?.close()
  }

  #getDialog (e) {
    const id = e.currentTarget.dataset.id
    return this.dialogTargets.find(dialog => dialog.id === id)
  }

  #closeOnBackdropClick (e) {
    if (e.target === this.openedDialog) {
      this.openedDialog.close()
    }
  }
}

stimulus.register('modals', ModalsController)
