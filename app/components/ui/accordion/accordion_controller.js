import { Controller } from '@hotwired/stimulus'
import Accordion from 'flowbite/lib/esm/components/accordion'
import { stimulus } from '~/init'

export default class AccordionController extends Controller {
  static targets = ['accordion', 'trigger', 'item', 'autofocus']

  connect () {
    this.accordion = new Accordion(this.accordionTarget, this.accordionItems(), this.#options())
  }

  disconnect () {
    this.accordion.destroy()
  }

  accordionItems () {
    const items = this.triggerTargets.map(trigger => {
      const targetId = `accordion_${trigger.dataset.accordionId}`
      const target = this.itemTargets.find(i => i.id === targetId)

      return {
        id: targetId,
        triggerEl: trigger,
        targetEl: target
      }
    })

    return items
  }

  #options () {
    const { activeClasses, alwaysOpen } = this.element.dataset

    return {
      activeClasses: activeClasses || 'bg-gray-50',
      alwaysOpen: alwaysOpen || false,
      onOpen: () => {
        if (this.hasAutofocusTarget) {
          this.autofocusTarget.focus()
        }
      }
    }
  }
}

stimulus.register('accordion', AccordionController)
