import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class FieldsController extends Controller {
  enable ({ target }) {
    const elements = Array.from(this.element.elements)
    const selectedElements = 'selectedOptions' in target
      ? target.selectedOptions
      : [target]

    for (const element of elements.filter(element => element.name === target.name)) {
      if (element instanceof window.HTMLFieldSetElement) element.disabled = true
    }

    for (const element of this.#controlledElements(...selectedElements)) {
      if (element instanceof window.HTMLFieldSetElement) element.disabled = false
    }
  }

  #controlledElements (...selectedElements) {
    return selectedElements.flatMap(selectedElement => {
      // data-custom-properties is used for selectize.js and data-controls is used for the rest
      const attr = selectedElement.dataset.customProperties || selectedElement.dataset.controls
      return this.#getElementsByTokens(attr)
    })
  }

  #getElementsByTokens (tokens) {
    const ids = (tokens ?? '').split(/\s+/)

    return ids.map(id => document.getElementById(id))
  }
}

stimulus.register('fields', FieldsController)
