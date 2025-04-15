import { Controller } from '@hotwired/stimulus'
import Tagify from '@yaireo/tagify'
import { stimulus } from '~/init'
import '@yaireo/tagify/dist/tagify.css'

export default class TagifyController extends Controller {
  connect () {
    const { whitelist } = this.element.dataset

    this.tagify = new Tagify(this.element, {
      whitelist: whitelist?.split(',') || [],
      dropdown: {
        enabled: 0,
        maxItems: 10,
        classname: 'tags-look',
        closeOnSelect: false
      }
    })
  }

  disconnect () {
    this.tagify.destroy()
  }
}

stimulus.register('tagify', TagifyController)
