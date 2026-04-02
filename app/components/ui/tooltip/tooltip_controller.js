import { Controller } from '@hotwired/stimulus'
import { useHover } from 'stimulus-use'
import { computePosition, flip, shift, offset } from '@floating-ui/dom'
import { stimulus } from '~/init'

export default class TooltipController extends Controller {
  static values = {
    content: String,
    placement: { type: String, default: 'top' }
  }

  connect () {
    useHover(this, { element: this.element })
  }

  async mouseEnter () {
    this.#createTooltip()
    await this.#updatePosition()
  }

  mouseLeave () {
    this.tooltip?.remove()
    this.tooltip = null
  }

  updateContent (event) {
    const text = event.detail?.content
    if (text) this.contentValue = text
  }

  contentValueChanged (value) {
    if (this.tooltip) {
      this.tooltip.innerHTML = value
      this.#updatePosition()
    }
  }

  #createTooltip () {
    this.tooltip = document.createElement('div')
    this.tooltip.className = 'tooltip'
    this.tooltip.role = 'tooltip'
    this.tooltip.innerHTML = this.contentValue
    const container = this.element.closest('dialog') || document.body
    container.appendChild(this.tooltip)
  }

  async #updatePosition () {
    const { x, y, placement } = await computePosition(this.element, this.tooltip, {
      placement: this.placementValue,
      middleware: [
        offset(8),
        flip(),
        shift({ padding: 8 })
      ]
    })

    Object.assign(this.tooltip.style, {
      left: `${x}px`,
      top: `${y}px`
    })

    this.tooltip.dataset.placement = placement
  }
}

stimulus.register('tooltip', TooltipController)
