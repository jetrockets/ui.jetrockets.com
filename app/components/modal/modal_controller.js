import { Controller } from '@hotwired/stimulus'

// import { Modal } from 'flowbite'
import { stimulus } from '~/init'

export default class ModalController extends Controller {
  connect () {
    const options = {
      // placement: 'bottom-right',
      // backdrop: 'dynamic',
      // backdropClasses: 'bg-gray-900 bg-opacity-50 dark:bg-opacity-80 fixed inset-0 z-40',
      closable: true,
      onHide: () => {
        setTimeout(() => {
          // this.element.remove()
        }, 300)
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
