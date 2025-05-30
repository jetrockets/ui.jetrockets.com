import { Controller } from '@hotwired/stimulus'
import Tooltip from 'flowbite/lib/esm/components/tooltip'

import { stimulus } from '~/init'

export default class TooltipController extends Controller {
  static targets = ['tooltip', 'menu']

  connect () {
    this.tooltip = new Tooltip(this.menuTarget, this.tooltipTarget, this.#options())
  }

  disconnect () {
    this.tooltip.destroy()
  }

  #options () {
    const { placement, triggertype } = this.element.dataset

    return {
      placement: placement || 'top',
      triggerType: triggertype || 'hover'
    }
  }
}

stimulus.register('tooltip', TooltipController)
