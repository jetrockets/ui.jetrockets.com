import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'
import Drawer from 'flowbite/lib/esm/components/drawer'

export default class DrawerController extends Controller {
  static targets = ['drawer', 'trigger']

  connect () {
    this.drawers = new Map()
    this.#initializeDrawers()
  }

  show (event) {
    const drawer = this.#findDrawer(event)
    if (drawer) drawer.show()
  }

  close (event) {
    const drawer = this.#findDrawer(event)
    if (drawer) drawer.hide()
  }

  #findDrawer (event) {
    const id = event.currentTarget.dataset.id
    if (!id) {
      return null
    }
    return this.drawers.get(id)
  }

  #initializeDrawers () {
    this.triggerTargets.forEach(trigger => {
      const targetId = trigger.dataset.id
      if (!targetId) {
        return
      }

      const drawerElement = this.drawerTargets.find(drawer => drawer.id === targetId)
      if (!drawerElement) {
        return
      }

      this.drawers.set(targetId, new Drawer(drawerElement, this.#drawerOptions()))
    })
  }

  #drawerOptions () {
    return {
      backdropClasses: 'bg-gray-900/50 fixed inset-0 z-40',
      placement: 'right'
    }
  }
}

stimulus.register('drawer', DrawerController)
