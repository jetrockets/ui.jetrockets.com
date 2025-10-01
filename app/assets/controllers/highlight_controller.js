import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

import hljs from 'highlight.js/lib/core'
import 'highlight.js/lib/common'
import javascript from 'highlight.js/lib/languages/javascript'
import erb from 'highlight.js/lib/languages/erb'
import ruby from 'highlight.js/lib/languages/ruby'

import 'highlight.js/styles/atom-one-dark.css'

hljs.registerLanguage('javascript', javascript)
hljs.registerLanguage('ruby', ruby)
hljs.registerLanguage('erb', erb)

export default class HighlightController extends Controller {
  connect () {
    this.highlightCode()
    this.element.addEventListener('turbo:frame-load', this.#onFrameLoad.bind(this))
  }

  disconnect () {
    this.element.removeEventListener('turbo:frame-load', this.#onFrameLoad.bind(this))
  }

  #onFrameLoad (event) {
    const frame = event.target
    this.highlightCode(frame)
  }

  highlightCode (container = this.element) {
    // It's a bad practice to use querySelectorAll in Stimulus controllers,
    // but in this case, we need to highlight all code blocks inside the body.
    container.querySelectorAll('pre code:not(.hljs)').forEach((element) => {
      hljs.highlightElement(element)
    })
  }
}

stimulus.register('highlight', HighlightController)
