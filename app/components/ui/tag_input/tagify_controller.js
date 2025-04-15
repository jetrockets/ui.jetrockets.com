import { Controller } from '@hotwired/stimulus'
import Tagify from '@yaireo/tagify'
import { stimulus } from '~/init'
import '@yaireo/tagify/dist/tagify.css'

export default class TagifyController extends Controller {
  connect () {
    this.tagify = new Tagify(this.element, this.#options())
  }

  disconnect () {
    this.tagify.destroy()
  }

  #options () {
    const { whitelist, maxitems, closeonselect } = this.element.dataset

    return {
      whitelist: whitelist?.split(',') || [],
      dropdown: {
        enabled: 0,
        maxItems: maxitems || 10,
        classname: 'tags-look',
        closeOnSelect: closeonselect || false
      }
    }
  }
}

stimulus.register('tagify', TagifyController)
