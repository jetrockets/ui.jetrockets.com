import { Controller } from '@hotwired/stimulus'
import { useClickOutside } from 'stimulus-use'
import { computePosition, flip, shift, offset } from '@floating-ui/dom'
import { stimulus } from '~/init'

export default class DropdownController extends Controller {
  static targets = ['menu', 'autofocus']
  static values = { open: { type: Boolean, default: false } }

  connect () {
    useClickOutside(this, { element: this.element })
    this.element.addEventListener('click', this.#handleClick)
    document.addEventListener('turbo:morph', this.#handleMorph)
  }

  disconnect () {
    this.element.removeEventListener('click', this.#handleClick)
    document.removeEventListener('keydown', this.#handleKeydown)
    document.removeEventListener('turbo:morph', this.#handleMorph)
  }

  #handleClick = (event) => {
    if (!this.menuTarget.contains(event.target)) {
      this.toggle()
    }
  }

  toggle () {
    this.openValue = !this.openValue
  }

  show () {
    this.openValue = true
  }

  hide () {
    this.openValue = false
  }

  openValueChanged (isOpen) {
    if (isOpen) {
      this.#showMenu()
    } else {
      this.#hideMenu()
    }
  }

  clickOutside () {
    this.hide()
  }

  #showMenu () {
    this.menuTarget.classList.remove('hidden')
    this.menuTarget.classList.add('block')
    this.#updatePosition()

    if (this.hasAutofocusTarget) {
      this.autofocusTarget.focus()
    }

    document.addEventListener('keydown', this.#handleKeydown)
  }

  #hideMenu () {
    this.menuTarget.classList.remove('block')
    this.menuTarget.classList.add('hidden')
    document.removeEventListener('keydown', this.#handleKeydown)
  }

  #handleKeydown = (event) => {
    if (event.key === 'Escape') {
      this.hide()
    }
  }

  #handleMorph = () => {
    if (this.openValue) {
      this.#showMenu()
    }
  }

  async #updatePosition () {
    const { x, y } = await computePosition(this.element, this.menuTarget, {
      placement: 'bottom-start',
      middleware: [
        offset(5),
        flip(),
        shift({ padding: 8 })
      ]
    })

    Object.assign(this.menuTarget.style, {
      left: `${x}px`,
      top: `${y}px`
    })
  }
}

stimulus.register('dropdown', DropdownController)
