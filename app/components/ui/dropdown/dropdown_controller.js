import { Controller } from '@hotwired/stimulus'
import Dropdown from 'flowbite/lib/esm/components/dropdown'
import { stimulus } from '~/init'

export default class DropdownController extends Controller {
  static targets = ['trigger', 'menu', 'autofocus']

  connect () {
    this.dropdown = new Dropdown(this.menuTarget, this.triggerTarget, this.#options())
  }

  disconnect () {
    this.dropdown.hide()
  }

  hide () {
    this.dropdown.hide()
  }

  #options () {
    const [placement, triggerType, offsetSkidding, offsetDistance, delay, ignoreClickOutsideClass] = JSON.parse(this.triggerTarget.dataset.dropdownAttributes)

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
