import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class Sidebar extends Controller {
  static targets = ['menu', 'burger']
  static values = {
    opened: { type: Boolean, default: false }
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
