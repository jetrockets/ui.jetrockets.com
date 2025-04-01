import { Controller } from '@hotwired/stimulus'
import tippy from 'tippy.js'
import { stimulus } from '~/init'
import 'tippy.js/dist/tippy.css'
import 'tippy.js/themes/light.css'
import 'tippy.js/themes/material.css'
import 'tippy.js/animations/scale.css'
import 'tippy.js/animations/shift-away.css'

export default class TooltipController extends Controller {
  connect () {
    this.tooltip = tippy(this.element, this.#options())
  }

  disconnect () {
    this.tooltip.destroy()
  }

  #options () {
    const { content, placement, animation, theme } = this.element.dataset

    return {
      content: content || 'Default content',
      placement: placement || 'top',
      animation: animation || 'scale',
      theme: theme || 'light'
    }
  }
}

stimulus.register('tooltip_tippy', TooltipController)
