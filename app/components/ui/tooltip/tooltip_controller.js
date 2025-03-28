import { Controller } from '@hotwired/stimulus'
import tippy from 'tippy.js'
import { stimulus } from '~/init'
import 'tippy.js/dist/tippy.css'
import 'tippy.js/themes/light.css'
import 'tippy.js/themes/light-border.css'
import 'tippy.js/themes/material.css'
import 'tippy.js/themes/translucent.css'
import 'tippy.js/animations/scale.css'
import 'tippy.js/animations/shift-away.css'
import 'tippy.js/animations/shift-toward.css'
import 'tippy.js/animations/perspective.css'

export default class TooltipController extends Controller {
  static targets = ['tooltip', 'autofocus']

  connect () {
    this.tooltip = tippy(this.tooltipTarget, this.#options())
  }

  disconnect () {
    this.tooltip.destroy()
  }

  #options () {
    const { content, placement, animation, theme } = this.element.dataset

    return {
      content: content || 'Default tooltip',
      placement: placement || 'top',
      animation: animation || 'scale',
      theme: theme || 'light',
      onShow: () => {
        if (this.hasAutofocusTarget) {
          this.autofocusTarget.focus()
        }
      }
    }
  }
}

stimulus.register('tooltip', TooltipController)
