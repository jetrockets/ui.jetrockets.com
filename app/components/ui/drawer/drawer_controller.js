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
      console.warn('Drawer ID not found in dataset.')
      return null
    }
    return this.drawers.get(id)
  }

  #initializeDrawers () {
    this.triggerTargets.forEach(trigger => {
      const targetId = trigger.dataset.id
      if (!targetId) {
        console.warn('Trigger is missing a dataset ID.')
        return
      }

      const drawerElement = this.drawerTargets.find(drawer => drawer.id === targetId)
      if (!drawerElement) {
        console.warn(`Drawer element with ID "${targetId}" not found.`)
        return
      }

      this.drawers.set(targetId, new Drawer(drawerElement, this.#drawerOptions()))
    })
  }

  #drawerOptions () {
    return {
      backdropClasses: 'bg-gray-900/50 fixed inset-0 z-40',
      placement: DrawerController.DEFAULT_PLACEMENT
    }
  }

  static get DEFAULT_PLACEMENT () {
    return 'right'
  }
}

stimulus.register('drawer', DrawerController)
