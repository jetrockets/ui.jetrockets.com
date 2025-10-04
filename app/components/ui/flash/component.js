import { Controller } from '@hotwired/stimulus'
import { useTransition } from 'stimulus-use'
import { stimulus } from '~/init'

export default class FlashController extends Controller {
  static values = {
    dismissAfter: Number,
    showDelay: { type: Number, default: 0 }
  }

  connect () {
    useTransition(this, {
      element: this.boxToCloseTarget,
      enterFrom: 'opacity-0 translate-x-1/4',
      enterTo: 'opacity-100 translate-x-0',
      leaveFrom: 'opacity-100 translate-x-0',
      leaveTo: 'opacity-0 translate-x-1/4',
      hiddenClass: 'hidden',
      transitioned: false
    })

    setTimeout(() => {
      this.enter()
    }, this.showDelayValue)

    if (this.hasDismissAfterValue) {
      setTimeout(() => {
        this.close()
      }, this.dismissAfterValue)
    }
  }

  close () {
    this.leave().then(() => {
      this.element.remove()
    })
  }
}

stimulus.register('flash', FlashController)
