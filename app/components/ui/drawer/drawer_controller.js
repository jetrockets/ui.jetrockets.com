import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'
import Drawer from 'flowbite/lib/esm/components/drawer'

export default class DrawerController extends Controller {
  static targets = ['drawer']

  connect () {
    this.drawer = new Drawer(this.drawerTarget)
  }

  show () {
    this.drawer.show()
  }

  close () {
    this.drawer.hide()
  }
}

stimulus.register('drawer', DrawerController)
