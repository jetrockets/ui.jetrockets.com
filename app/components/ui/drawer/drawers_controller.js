import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class DrawersController extends Controller {
  static targets = ['dialog']
  static values = {
    swipeThreshold: { type: Number, default: 100 }
  }

  disconnect () {
    this.#removeDialogListeners()
  }

  show (e) {
    this.openedDialog = this.#getDialog(e)
    this.#addDialogListeners()
    this.openedDialog?.showModal()
  }

  close (e) {
    this.#removeDialogListeners()
    this.#getDialog(e)?.close()
  }

  #getDialog (e) {
    const id = e.currentTarget.dataset.id
    return this.dialogTargets.find(dialog => dialog.id === id)
  }

  #addDialogListeners () {
    if (!this.openedDialog) return
    this.openedDialog.addEventListener('click', this.#closeOnBackdropClick.bind(this))
    this.openedDialog.addEventListener('touchstart', this.#onTouchStart.bind(this), { passive: true })
    this.openedDialog.addEventListener('touchmove', this.#onTouchMove.bind(this), { passive: true })
    this.openedDialog.addEventListener('touchend', this.#onTouchEnd.bind(this), { passive: true })
  }

  #removeDialogListeners () {
    if (!this.openedDialog) return
    this.openedDialog.removeEventListener('click', this.#closeOnBackdropClick.bind(this))
    this.openedDialog.removeEventListener('touchstart', this.#onTouchStart.bind(this))
    this.openedDialog.removeEventListener('touchmove', this.#onTouchMove.bind(this))
    this.openedDialog.removeEventListener('touchend', this.#onTouchEnd.bind(this))
  }

  #closeOnBackdropClick (e) {
    if (e.target === this.openedDialog) {
      this.openedDialog.close()
    }
  }

  #onTouchStart (event) {
    this.touchStartX = event.touches[0].clientX
    this.openedDialog.style.transition = 'none'
  }

  #onTouchMove (event) {
    const currentX = event.touches[0].clientX
    const diff = Math.max(0, currentX - this.touchStartX)
    this.openedDialog.style.transform = `translateX(${diff}px)`
  }

  #onTouchEnd (event) {
    const touchEndX = event.changedTouches[0].clientX
    const diff = touchEndX - this.touchStartX

    this.openedDialog.style.transition = 'transform 0.2s ease-out'

    if (diff > this.swipeThresholdValue) {
      this.openedDialog.style.transform = 'translateX(100%)'
      this.openedDialog.addEventListener('transitionend', () => {
        this.openedDialog.close()
        this.openedDialog.style.transform = ''
        this.openedDialog.style.transition = ''
      }, { once: true })
    } else {
      this.openedDialog.style.transform = 'translateX(0)'
    }
  }
}

stimulus.register('drawers', DrawersController)
