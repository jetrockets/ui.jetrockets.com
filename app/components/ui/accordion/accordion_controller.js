import { Controller } from '@hotwired/stimulus'
import Accordion from 'flowbite/lib/esm/components/accordion'
import { stimulus } from '~/init'

export default class AccordionController extends Controller {
  static targets = ['autofocus']

  connect () {
    this.initializeAccordion()
  }

  disconnect () {
    this.accordion.destroy()
  }

  initializeAccordion () {
    const accordionEl = this.element.querySelector('.accordion')

    const items = [...accordionEl.querySelectorAll('[data-accordion-target]')].map((trigger) => {
      const targetId = trigger.getAttribute('data-accordion-target')
      const target = this.element.querySelector(targetId)

      return {
        id: targetId,
        triggerEl: trigger,
        targetEl: target
      }
    })

    this.accordion = new Accordion(accordionEl, items, this.#options())
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
