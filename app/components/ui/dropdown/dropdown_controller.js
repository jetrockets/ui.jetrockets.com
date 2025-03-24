import { Controller } from '@hotwired/stimulus'
import Dropdown from 'flowbite/lib/esm/components/dropdown'
import { stimulus } from '~/init'
import Dropdown from 'flowbite/lib/esm/components/dropdown'

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
    const { placement, triggertype, offsetskidding, offsetdistance, delay, ignoreclickoutsideclass } = this.element.dataset

    return {
      placement: placement || 'bottom',
      triggerType: triggertype || 'click',
      offsetSkidding: parseInt(offsetskidding) || 0,
      offsetDistance: parseInt(offsetdistance) || 5,
      delay: parseInt(delay) || 300,
      ignoreClickOutsideClass: ignoreclickoutsideclass || false,
      onShow: () => {
        if (this.hasAutofocusTarget) {
          this.autofocusTarget.focus()
        }
      }
    }
  }
}

stimulus.register('dropdown', DropdownController)
