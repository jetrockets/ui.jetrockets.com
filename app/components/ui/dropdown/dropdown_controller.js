import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class DropdownController extends Controller {
  static targets = ['trigger', 'menu', 'autofocus']

  connect () {
    this.dropdown = new window.Dropdown(this.menuTarget, this.triggerTarget, this.#options())
  }

  disconnect () {
    this.dropdown.hide()
  }

  hide () {
    this.dropdown.hide()
  }

  #options () {
    const { placement, triggerType, offsetSkidding, offsetDistance, delay, ignoreClickOutsideClass } = this.element.dataset

    return {
      placement: placement || 'bottom',
      triggerType: triggerType || 'click',
      offsetSkidding: parseInt(offsetSkidding) || 0,
      offsetDistance: parseInt(offsetDistance) || 5,
      delay: parseInt(delay) || 300,
      ignoreClickOutsideClass: ignoreClickOutsideClass || false,
      onShow: () => {
        if (this.hasAutofocusTarget) {
          this.autofocusTarget.focus()
        }
      }
    }
  }
}

stimulus.register('dropdown', DropdownController)
