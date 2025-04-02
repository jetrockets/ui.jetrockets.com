import { Controller } from '@hotwired/stimulus'
import CopyClipboard from 'flowbite/lib/esm/components/clipboard'
import { stimulus } from '~/init'

export default class ClipboardController extends Controller {
  static targets = ['clipboard', 'content', 'default', 'success']

  connect () {
    this.clipboard = new CopyClipboard(this.clipboardTarget, this.contentTarget, this.#options())
    console.log(this.element.dataset)
    console.log(this.clipboard)
    console.log('hello')
  }

  #showSuccessMessage () {
    this.defaultTarget.classList.add('hidden')
    this.successTarget.classList.remove('hidden')

    setTimeout(() => {
      this.defaultTarget.classList.remove('hidden')
      this.successTarget.classList.add('hidden')
    }, 1000)
  }

  #options () {
    const { contenttype } = this.element.dataset
    return {
      contentType: contenttype,
      onCopy: () => {
        this.#showSuccessMessage()
      }
    }
  }
}

stimulus.register('clipboard', ClipboardController)
