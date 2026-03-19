import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class ClipboardController extends Controller {
  static values = {
    content: String,
    sourceId: String,
    successText: { type: String, default: 'Copied!' },
    timeout: { type: Number, default: 2000 }
  }

  connect () {
    this.originalText = this.#hasTooltip
      ? this.element.dataset.tooltipContentValue
      : this.element.textContent
  }

  async copy () {
    const text = this.#getContent()
    await navigator.clipboard.writeText(text)

    if (!this.#hasTooltip) {
      this.element.textContent = this.successTextValue
    }

    this.dispatch('change', { detail: { content: this.successTextValue } })

    setTimeout(() => {
      if (!this.#hasTooltip) {
        this.element.textContent = this.originalText
      }
      this.dispatch('change', { detail: { content: this.originalText } })
    }, this.timeoutValue)
  }

  get #hasTooltip () {
    return this.element.dataset.controller?.includes('tooltip')
  }

  #getContent () {
    if (this.hasSourceIdValue) {
      const el = document.getElementById(this.sourceIdValue)
      return el?.value ?? el?.textContent ?? ''
    }
    return this.contentValue
  }
}

stimulus.register('clipboard', ClipboardController)
