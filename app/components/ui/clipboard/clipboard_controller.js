import { Controller } from '@hotwired/stimulus'
import CopyClipboard from 'flowbite/lib/esm/components/clipboard'
import { stimulus } from '~/init'

export default class ClipboardController extends Controller {
  static targets = ['clipboard', 'content', 'default', 'success', 'defaultText', 'successText']

  connect () {
    this.clipboard = new CopyClipboard(this.clipboardTarget, this.contentTarget, this.#options())
  }

  #showSuccessMessage () {
    const timeout = this.element.dataset.timeout || 1000

    if (this.hasDefaultTextTarget && this.hasSuccessTextTarget) {
      this.#toggleElementVisibility(this.defaultTextTarget, this.successTextTarget, timeout)
    }
    this.#toggleElementVisibility(this.defaultTarget, this.successTarget, timeout)
  }

  #toggleElementVisibility (defaultElement, successElement, timeout) {
    defaultElement.classList.add('hidden')
    successElement.classList.remove('hidden')

    setTimeout(() => {
      defaultElement.classList.remove('hidden')
      successElement.classList.add('hidden')
    }, timeout)
  }

  #options () {
    return {
      onCopy: () => {
        this.#showSuccessMessage()
      }
    }
  }
}

stimulus.register('clipboard', ClipboardController)
