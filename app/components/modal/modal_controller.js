import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class ModalController extends Controller {
  connect () {
    const options = {
      placement: 'center-center',
      backdropClasses: 'bg-gray-900 bg-opacity-50 fixed inset-0 z-40',
      closable: true,
      onHide: () => {
        this.element.remove()
      }
      // onShow: () => {
      //   console.log('modal is shown')
      // }
      // onToggle: () => {
      //   console.log('modal has been toggled')
      // }
    }

    const modal = new window.Modal(this.element, options)
    modal.show()
  }
}

stimulus.register('modal', ModalController)
