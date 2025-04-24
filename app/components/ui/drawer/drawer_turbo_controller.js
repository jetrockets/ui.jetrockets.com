import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'
import Drawer from 'flowbite/lib/esm/components/drawer'

export default class DrawerTurboController extends Controller {
  connect () {
    this.#initializeModal()
    this.drawer.show()
  }

  show () {
    this.drawer.show()
  }

  close () {
    this.drawer.hide()
  }

  disconnect () {
    this.element.remove()
  }

  #initializeModal () {
    const options = this.#getOptions()
    this.drawer = new Drawer(this.element, options)
  }

  #getOptions () {
    return {
      placement: 'right',
      onHide: () => {
        this.element.remove()
      }
    }
  }
}

stimulus.register('turbo-drawer', DrawerTurboController)
