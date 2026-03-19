import { Controller } from '@hotwired/stimulus'
import { useHover } from 'stimulus-use'
import { computePosition, flip, shift, offset } from '@floating-ui/dom'
import { stimulus } from '~/init'

export default class PopoverController extends Controller {
  static targets = ['content']
  static values = {
    open: { type: Boolean, default: false },
    placement: { type: String, default: 'bottom' }
  }

  connect () {
    useHover(this, { element: this.element })
    document.addEventListener('turbo:morph', this.#handleMorph)
  }

  disconnect () {
    document.removeEventListener('turbo:morph', this.#handleMorph)
  }

  mouseEnter () {
    this.openValue = true
  }

  mouseLeave () {
    this.openValue = false
  }

  openValueChanged (isOpen) {
    if (isOpen) {
      this.#showContent()
    } else {
      this.#hideContent()
    }
  }

  #showContent () {
    this.contentTarget.classList.remove('opacity-0', 'pointer-events-none')
    this.contentTarget.classList.add('opacity-100', 'pointer-events-auto')
    this.#updatePosition()
  }

  #hideContent () {
    this.contentTarget.classList.remove('opacity-100', 'pointer-events-auto')
    this.contentTarget.classList.add('opacity-0', 'pointer-events-none')
  }

  #handleMorph = () => {
    if (this.openValue) {
      this.#showContent()
    }
  }

  async #updatePosition () {
    const { x, y, placement } = await computePosition(this.element, this.contentTarget, {
      placement: this.placementValue,
      middleware: [
        offset(12),
        flip(),
        shift({ padding: 8 })
      ]
    })

    Object.assign(this.contentTarget.style, {
      left: `${x}px`,
      top: `${y}px`
    })

    this.contentTarget.dataset.placement = placement
  }
}

stimulus.register('popover', PopoverController)
