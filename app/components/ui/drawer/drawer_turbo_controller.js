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
    this.drawer?.hide()
  }

  disconnect () {
    this.element.remove()
  }

  #initializeDrawer () {
    const options = this.#getOptions()
    this.drawer = new Drawer(this.element, options)
  }

  #getOptions () {
    return {
      placement: DrawerTurboController.DEFAULT_PLACEMENT,
      onHide: () => this.element.remove()
    }
  }

  static get DEFAULT_PLACEMENT () {
    return 'right'
  }
}

stimulus.register('drawer-turbo', DrawerTurboController)
