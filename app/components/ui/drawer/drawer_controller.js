import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class DrawerController extends Controller {
  static values = {
    swipeThreshold: { type: Number, default: 100 }
  }

  connect () {
    this.element.addEventListener('click', this.#closeOnBackdropClick.bind(this))
    this.element.addEventListener('touchstart', this.#onTouchStart.bind(this), { passive: true })
    this.element.addEventListener('touchmove', this.#onTouchMove.bind(this), { passive: true })
    this.element.addEventListener('touchend', this.#onTouchEnd.bind(this), { passive: true })
    this.element.showModal()
  }

  disconnect () {
    this.element.removeEventListener('click', this.#closeOnBackdropClick.bind(this))
    this.element.removeEventListener('touchstart', this.#onTouchStart.bind(this))
    this.element.removeEventListener('touchmove', this.#onTouchMove.bind(this))
    this.element.removeEventListener('touchend', this.#onTouchEnd.bind(this))
    this.close()
  }

  show () {
    this.element.showModal()
  }

  close () {
    try {
      this.element.close()
      DrawerController.turboFrame.src = null
      this.element.remove()
    } catch (e) {}
  }

  #closeOnBackdropClick (event) {
    if (event.target === this.element) {
      this.close()
    }
  }

  #onTouchStart (event) {
    this.touchStartX = event.touches[0].clientX
    this.element.style.transition = 'none'
  }

  #onTouchMove (event) {
    const currentX = event.touches[0].clientX
    const diff = Math.max(0, currentX - this.touchStartX)
    this.element.style.transform = `translateX(${diff}px)`
  }

  #onTouchEnd (event) {
    const touchEndX = event.changedTouches[0].clientX
    const diff = touchEndX - this.touchStartX

    this.element.style.transition = 'transform 0.2s ease-out'

    if (diff > this.swipeThresholdValue) {
      this.element.style.transform = 'translateX(100%)'
      this.element.addEventListener('transitionend', () => this.close(), { once: true })
    } else {
      this.element.style.transform = 'translateX(0)'
    }
  }

  static get turboFrame () {
    return document.querySelector('turbo-frame[id=\'drawer\']')
  }
}

stimulus.register('drawer', DrawerController)
