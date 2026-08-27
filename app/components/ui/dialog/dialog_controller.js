import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

// Per-dialog behaviour: backdrop click / swipe-to-dismiss / Esc handling for a single
// <dialog>. Opening, stacking and DOM cleanup are owned by DialogsController — this
// controller only reacts to interactions on an already-mounted dialog.
export default class DialogController extends Controller {
  static targets = ['panel']

  static values = {
    position: { type: String, default: 'center' },
    dismissible: { type: Boolean, default: true },
    swipe: { type: Boolean, default: false },
    swipeThreshold: { type: Number, default: 100 }
  }

  #touchStart = 0

  connect () {
    this.element.addEventListener('click', this.#handleBackdropClick)
    this.element.addEventListener('cancel', this.#handleCancel)

    if (this.swipeValue) {
      this.element.addEventListener('touchstart', this.#handleTouchStart, { passive: true })
      this.element.addEventListener('touchmove', this.#handleTouchMove, { passive: true })
      this.element.addEventListener('touchend', this.#handleTouchEnd, { passive: true })
    }
  }

  disconnect () {
    this.element.removeEventListener('click', this.#handleBackdropClick)
    this.element.removeEventListener('cancel', this.#handleCancel)
    this.element.removeEventListener('touchstart', this.#handleTouchStart)
    this.element.removeEventListener('touchmove', this.#handleTouchMove)
    this.element.removeEventListener('touchend', this.#handleTouchEnd)
  }

  close () {
    try {
      this.element.close()
    } catch (e) {}
  }

  #handleBackdropClick = (event) => {
    if (event.target === this.element && this.dismissibleValue) {
      this.close()
    }
  }

  #handleCancel = (event) => {
    if (!this.dismissibleValue) event.preventDefault()
  }

  #axis () {
    return this.positionValue === 'top' || this.positionValue === 'bottom' ? 'y' : 'x'
  }

  // Sign of the direction that counts as "swiping the panel away".
  #sign () {
    return { left: -1, right: 1, top: -1, bottom: 1 }[this.positionValue] ?? 1
  }

  #coordinate (touch) {
    return this.#axis() === 'x' ? touch.clientX : touch.clientY
  }

  #translate (value, unit) {
    return this.#axis() === 'x' ? `translateX(${value}${unit})` : `translateY(${value}${unit})`
  }

  #handleTouchStart = (event) => {
    if (!this.hasPanelTarget) return
    this.#touchStart = this.#coordinate(event.touches[0])
    this.panelTarget.style.transition = 'none'
  }

  #handleTouchMove = (event) => {
    if (!this.hasPanelTarget) return
    const delta = (this.#coordinate(event.touches[0]) - this.#touchStart) * this.#sign()
    const clamped = Math.max(0, delta)
    this.panelTarget.style.transform = this.#translate(clamped * this.#sign(), 'px')
  }

  #handleTouchEnd = (event) => {
    if (!this.hasPanelTarget) return
    const delta = (this.#coordinate(event.changedTouches[0]) - this.#touchStart) * this.#sign()
    this.panelTarget.style.transition = 'transform 0.2s ease-out'

    if (delta > this.swipeThresholdValue) {
      this.panelTarget.style.transform = this.#translate(this.#sign() * 100, '%')
      this.panelTarget.addEventListener('transitionend', () => this.close(), { once: true })
    } else {
      this.panelTarget.style.transform = this.#translate(0, 'px')
    }
  }
}

stimulus.register('dialog', DialogController)
