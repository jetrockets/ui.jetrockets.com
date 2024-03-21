import { Controller } from '@hotwired/stimulus'
import { Turbo } from '@hotwired/turbo-rails'

export default class extends Controller {
  connect () {
    this.element.addEventListener('turbo:submit-end', (event) => {
      this.next(event)
    })
  }

  next (event) {
    if (event.detail.success) {
      Turbo.visit(event.detail.fetchResponse.response.url)
    }
  }
}
