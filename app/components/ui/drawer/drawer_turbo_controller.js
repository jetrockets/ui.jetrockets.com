import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'
import Drawer from 'flowbite/lib/esm/components/drawer'

export default class DrawerTurboController extends Controller {
  connect () {
    this.#initializeDrawer()
    this.show()
  }

  show () {
    this.drawer?.show()
  }

  close () {
    try {
      DrawerTurboController.turboFrame.src = null
      this.drawer.removeInstance()
      this.drawer?.hide()
      this.element.remove()
    } catch (e) {}
  }

  disconnect () {
    this.close()
    this.element.remove()
  }

  #initializeDrawer () {
    const options = this.#getOptions()
    this.drawer = new Drawer(this.element, options)
  }

  #getOptions () {
    return {
      backdropClasses: 'bg-gray-900/50 fixed inset-0 z-40',
      placement: DrawerTurboController.DEFAULT_PLACEMENT,
      onHide: () => this.element.remove()
    }
  }

  static get turboFrame () {
    return document.querySelector('turbo-frame[id=\'drawer\']')
  }

  static get DEFAULT_PLACEMENT () {
    return 'right'
  }
}

stimulus.register('drawer-turbo', DrawerTurboController)
