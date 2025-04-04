import { Controller } from '@hotwired/stimulus'
import CopyClipboard from 'flowbite/lib/esm/components/clipboard'
import { stimulus } from '~/init'

export default class ClipboardController extends Controller {
  static targets = ['clipboard', 'content', 'default', 'success']

  connect () {
    this.clipboard = new CopyClipboard(this.clipboardTarget, this.contentTarget, this.#options())
  }

  #showSuccessMessage () {
    const { timeout } = this.element.dataset

    this.defaultTarget.classList.add('hidden')
    this.successTarget.classList.remove('hidden')

    setTimeout(() => {
      this.defaultTarget.classList.remove('hidden')
      this.successTarget.classList.add('hidden')
    }, timeout || 1000)
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
