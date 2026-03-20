import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'
import { throttle } from '~/utils/timing'

/* global sessionStorage */

export default class Sidebar extends Controller {
  static targets = ['menu']
  static values = {
    opened: { type: Boolean, default: false }
  }

  connect () {
    this.#restoreScrollPosition()
    this.#setupScrollListener()
    this.#setupBeforeUnloadListener()
  }

  disconnect () {
    if (this.hasMenuTarget && this.menuTarget.scrollTop > 0) {
      this.#saveScrollPosition()
    }
  }

  #saveScrollPosition () {
    if (!this.hasMenuTarget) return

    const scrollPosition = this.menuTarget.scrollTop
    sessionStorage.setItem('sidebar-scroll-position', scrollPosition)
  }

  #restoreScrollPosition () {
    const savedPosition = sessionStorage.getItem('sidebar-scroll-position')

    if (savedPosition && this.hasMenuTarget) {
      const position = parseInt(savedPosition, 10)
      this.menuTarget.scrollTop = position
    }
  }

  #setupScrollListener () {
    if (!this.hasMenuTarget) return

    const throttledSave = throttle(() => this.#saveScrollPosition(), 500)

    this.menuTarget.addEventListener('scroll', throttledSave)
  }

  #setupBeforeUnloadListener () {
    document.addEventListener('turbo:before-visit', () => {
      this.#saveScrollPosition()
    })

    window.addEventListener('beforeunload', () => {
      this.#saveScrollPosition()
    })
  }

  openedValueChanged (value) {
    if (value === true) {
      this.element.classList.add('body-overflow')
      this.menuTarget.classList.add('body__sidebar-opened')
    } else {
      this.element.classList.remove('body-overflow')
      this.menuTarget.classList.remove('body__sidebar-opened')
    }
  }

  toggle (e) {
    this.openedValue = !this.openedValue
  }
}

stimulus.register('sidebar', Sidebar)
