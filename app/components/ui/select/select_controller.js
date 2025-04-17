import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'
import Choices from 'choices.js'
import 'choices.js/public/assets/styles/choices.css'

export default class SelectController extends Controller {
  static targets = ['selection']

  connect () {
    const { choices } = this.element.dataset

    this.choices = new Choices(this.selectionTarget, {
      choices: choices?.split(',') || []
    })
  }

  disconnect () {
    this.choices.destroy()
  }
}

stimulus.register('select', SelectController)
