import { Controller } from '@hotwired/stimulus'

export default class Navbar extends Controller {
  static targets = ['menu', 'burger']
  static values = {
    opened: { type: Boolean, default: false }
  }

  openedValueChanged (value) {
    if (value === true) {
      this.element.classList.add('body-overflow')
      this.menuTarget.classList.add('navbar__menu-active')
      this.burgerTarget.classList.add('navbar__burger-opened')
    } else {
      this.element.classList.remove('body-overflow')
      this.menuTarget.classList.remove('navbar__menu-active')
      this.burgerTarget.classList.remove('navbar__burger-opened')
    }
  }

  toggle (e) {
    this.openedValue = !this.openedValue
  }
}
