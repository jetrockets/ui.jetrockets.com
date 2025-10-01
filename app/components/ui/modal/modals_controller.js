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
    document.body.classList.add('body-overflow')
    this.#getDialog(e)?.showModal()
  }

  close (e) {
    this.#getDialog(e)?.close()
    document.body.classList.remove('body-overflow')
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
