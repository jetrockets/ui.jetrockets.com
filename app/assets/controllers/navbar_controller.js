import { Controller } from '@hotwired/stimulus'
import { useClickOutside } from 'stimulus-use'

export default class Navbar extends Controller {
  static targets = ['menu', 'main', 'burger']
  static values = {
    opened: { type: Boolean, default: false }
  }

  connect () {
    useClickOutside(this, { element: this.menuTaget })
  }

  openedValueChanged (value) {
    if (value === true) {
      this.menuTarget.classList.add('navbar__menu-active')
      this.mainTarget.classList.add('body__main-overflowed')
      this.burgerTarget.classList.add('navbar__burger-opened')
    } else {
      this.menuTarget.classList.remove('navbar__menu-active')
      this.mainTarget.classList.remove('body__main-overflowed')
      this.burgerTarget.classList.remove('navbar__burger-opened')
    }
  }

  toggle (e) {
    this.openedValue = !this.openedValue
  }

  clickOutside (event) {
    if (this.openedValue === true) {
      event.preventDefault()
      this.openedValue = false
    }
  }
}
