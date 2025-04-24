import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'
import Drawer from 'flowbite/lib/esm/components/drawer'

export default class DrawerController extends Controller {
  static targets = ['drawer', 'trigger']

  connect () {
    this.drawers = new Map()
    this.#initializeDrawers()
  }

  show (e) {
    this.#getDrawer(e)?.show()
  }

  close (e) {
    this.#getDrawer(e)?.hide()
  }

  #getDrawer (e) {
    const id = e.currentTarget.dataset.id
    return this.drawers.get(id)
  }

  #initializeDrawers () {
    this.triggerTargets.forEach(trigger => {
      const targetId = trigger.dataset.id
      const drawerElement = this.drawerTargets.find(i => i.id === targetId)

      this.drawers.set(targetId, new Drawer(drawerElement, this.#options()))
    })
  }

  #options () {
    return {
      placement: 'right'
    }
  }
}

stimulus.register('drawer', DrawerController)
