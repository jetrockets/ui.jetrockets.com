import { Controller } from '@hotwired/stimulus'
import Dropdown from 'flowbite/lib/esm/components/dropdown'
import { stimulus } from '~/init'

export default class DropdownController extends Controller {
  static targets = ['trigger', 'menu', 'autofocus']

  connect () {
    this.dropdown = new Dropdown(this.menuTarget, this.triggerTarget, this.#options())
    document.addEventListener('turbo:morph', this.reload.bind(this))
  }

  disconnect () {
    document.removeEventListener('turbo:morph', this.reload.bind(this))
    this.dropdown.hide()
  }

  hide () {
    this.dropdown.hide()
  }

  reload () {
    if (this.dropdown) {
      this.dropdown.destroy()
      this.dropdown = new Dropdown(this.menuTarget, this.triggerTarget, this.#options())
    }
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
