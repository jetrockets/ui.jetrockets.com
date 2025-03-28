import { Controller } from '@hotwired/stimulus'
import Popover from 'flowbite/lib/esm/components/popover'
import { stimulus } from '~/init'

export default class PopoverController extends Controller {
  static targets = ['trigger', 'menu', 'autofocus']

  connect () {
    this.popover = new Popover(this.menuTarget, this.triggerTarget, this.#options())
  }

  disconnect () {
    this.popover.hide()
  }

  hide () {
    this.popover.hide()
  }

  #options () {
    const { placement, triggertype, offset } = this.element.dataset

    return {
      placement: placement || 'bottom',
      triggerType: triggertype || 'click',
      offset: parseInt(offset) || 0,
      onShow: () => {
        if (this.hasAutofocusTarget) {
          this.autofocusTarget.focus()
        }
      }
    }
  }
}

stimulus.register('popover', PopoverController)
