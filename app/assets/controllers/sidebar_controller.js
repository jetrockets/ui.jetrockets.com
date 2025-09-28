import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

/* global sessionStorage */

export default class Sidebar extends Controller {
  static targets = ['menu', 'burger', 'scroll']
  static values = {
    opened: { type: Boolean, default: false }
  }

  connect () {
    this.#restoreScrollPosition()
    this.#setupScrollListener()
    this.#setupBeforeUnloadListener()
  }

  disconnect () {
    if (this.#scrollDebounceTimer) {
      clearTimeout(this.#scrollDebounceTimer)
    }

    if (this.hasScrollTarget && this.scrollTarget.scrollTop > 0) {
      this.#saveScrollPosition()
    }
  }

  #scrollDebounceTimer = null

  #saveScrollPosition () {
    if (!this.hasScrollTarget) return

    const scrollPosition = this.scrollTarget.scrollTop
    sessionStorage.setItem('sidebar-scroll-position', scrollPosition)
  }

  #saveScrollPositionDebounced () {
    if (this.#scrollDebounceTimer) {
      clearTimeout(this.#scrollDebounceTimer)
    }

    this.#scrollDebounceTimer = setTimeout(() => {
      this.#saveScrollPosition()
    }, 500)
  }

  #restoreScrollPosition () {
    const savedPosition = sessionStorage.getItem('sidebar-scroll-position')

    if (savedPosition && this.hasScrollTarget) {
      const position = parseInt(savedPosition, 10)
      this.scrollTarget.scrollTop = position
    }
  }

  #setupScrollListener () {
    if (!this.hasScrollTarget) return

    this.scrollTarget.addEventListener('scroll', () => {
      this.#saveScrollPositionDebounced()
    })
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
      this.menuTarget.classList.add('sidebar__nav-mobile_open')
      this.burgerTarget.classList.add('sidebar__burger-opened')
    } else {
      this.element.classList.remove('body-overflow')
      this.menuTarget.classList.remove('sidebar__nav-mobile_open')
      this.burgerTarget.classList.remove('sidebar__burger-opened')
    }
  }

  toggle (e) {
    this.openedValue = !this.openedValue
  }
}

stimulus.register('sidebar', Sidebar)
