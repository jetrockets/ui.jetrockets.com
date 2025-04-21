import { Controller } from '@hotwired/stimulus'
import Tagify from '@yaireo/tagify'
import { stimulus } from '~/init'
import '@yaireo/tagify/dist/tagify.css'

export default class TagifyController extends Controller {
  get tagifyInstance () {
    const { mode, whitelist, maxtags } = this.element.dataset

    return new Tagify(this.element, {
      tagTextProp: 'name',
      editTags: false,
      mode: mode || null,
      dropdown: {
        enabled: 0,
        maxItems: 100,
        placeAbove: false,
        fuzzySearch: false
      },
      whitelist: whitelist?.split(',') || '[]',
      maxTags: maxtags || 100
    })
  }

  connect () {
    this.tagify = this.tagifyInstance
    this.#setupInputListener()
    this.tagify.on('dropdown:select', this.#onSelectSuggestion.bind(this))
    this.tagify.setContentEditable(!this.tagify.hasMaxTags())
    this.tagify.on('change', () => {
      this.tagify.setContentEditable(!this.tagify.hasMaxTags())
      this.dispatch('tagifyChange', { detail: { tagify: this.tagify } })
    })
  }

  disconnect () {
    this.tagify.off('input')
  }

  reload () {
    this.disconnect()
    this.connect()
  }

  #setupInputListener () {
    let controller = new AbortController()

    this.tagify.on('input', (event) => {
      const path = this.element.dataset.tagsPath

      if (path) {
        const { value } = event.detail
        this.tagify.settings.whitelist.length = 0

        controller.abort()
        controller = new AbortController()
        this.tagify.loading(true)

        fetch(`${path}?query=${value}`, { signal: controller.signal })
          .then((response) => response.json())
          .then((whitelist) => {
            this.tagify.whitelist = whitelist
            this.tagify.loading(false).dropdown.show(value)
          })
      }
    })
  }

  #onSelectSuggestion (event) {
    if (event.detail.elm.classList.contains('tagify__dropdown__item__addNew')) {
      this.tagify.addTags(this.tagify.state.inputText)
      this.tagify.DOM.input.innerHTML = ''
    }
  }
}

stimulus.register('tagify', TagifyController)
