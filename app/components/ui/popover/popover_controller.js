import { Controller } from '@hotwired/stimulus'
import Popover from 'flowbite/lib/esm/components/popover'
import { stimulus } from '~/init'

export default class PopoverController extends Controller {
  static targets = ['trigger', 'menu']

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
    const { placement, triggertype } = this.element.dataset

    return {
      placement: placement || 'bottom',
      triggerType: triggertype || 'hover',
      offset: 0
    }
  }
}

stimulus.register('popover', PopoverController)
