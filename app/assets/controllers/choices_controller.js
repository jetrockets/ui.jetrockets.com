import { Controller } from '@hotwired/stimulus'
import Choices from 'choices.js'
import { stimulus } from '~/init'

export default class ChoicesController extends Controller {
  static targets = ['select']

  initialize () {
    this.searchPath = this.selectTarget.dataset.search
    this.newPath = this.selectTarget.dataset.new
  }

  connect () {
    this.#setup()
    document.addEventListener('turbo:morph', this.reload.bind(this))
    this.selectTarget.addEventListener('enable', this.enable.bind(this))
  }

  disconnect () {
    try {
      this.choices.destroy()

      document.removeEventListener('turbo:morph', this.reload.bind(this))

      this.selectTarget.removeEventListener('enable', this.enable.bind(this))
      if (this.input && this.searchPath) {
        this.input.removeEventListener('input', this.#search)
      }
      this.selectTarget.removeEventListener('addItem', this.#addItem)
    } catch {}
  }

  reload () {
    if (this.choices) {
      this.choices.destroy()
      this.#setup()
    }
  }

  enable () {
    this.choices.enable()
  }

  setValue (event) {
    const value = event.detail?.value
    if (value && this.choices) {
      this.choices.setChoiceByValue(value)

      this.selectTarget.dispatchEvent(
        new CustomEvent('change', {
          bubbles: true,
          detail: { value }
        })
      )
    }
  }

  #setup = () => {
    const controller = this

    this.choices = new Choices(this.selectTarget, {
      searchPlaceholderValue: 'Search',
      searchFloor: 1,
      maxItemCount: -1,
      fuseOptions: {
        threshold: 0.2
      },
      searchEnabled: this.searchPath || false,
      shouldSort: false,
      removeItemButton: this.selectTarget.multiple,
      searchResultLimit: 10,
      allowHTML: true,
      ...this.#options(),
      callbackOnCreateTemplates: function (template) {
        return controller.#template(template, this)
      }
    })
    this.input = this.element.querySelector('input')

    this.selectTarget.addEventListener('addItem', this.#addItem)
    if (this.input && this.searchPath) {
      this.input.addEventListener('input', this.#search)
    }

    this.#appendNewLink()
  }

  #addItem = (event) => {
    const selectedLength = this.selectTarget.options.length
    const maxItemCount = parseInt(this.selectTarget.dataset.maxItemCount)

    if (event.detail.customProperties === 'all') {
      this.choices.choiceList.element.querySelectorAll('.choices__item').forEach(item => {
        this.choices.setChoiceByValue(item.dataset.value)
      })
      this.choices.hideDropdown()
      return this.choices.removeActiveItemsByValue('all')
    }

    if (maxItemCount && selectedLength === maxItemCount) {
      this.choices.hideDropdown()
    }
  }

  #search = (event) => {
    if (event.target.value) {
      fetch(this.#buildSearchPath(this.searchPath, `q=${event.target.value}`), {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      })
        .then(response => response.json())
        .then(this.#setSearchOptions)
    }
  }

  #buildSearchPath = (path, query) => {
    const [basePath, baseQuery] = path.split('?')
    if (!baseQuery) {
      return `${path}?${query}`
    }

    return `${basePath}?${query}&${baseQuery}`
  }

  #setSearchOptions = (data) => {
    this.choices.setChoices(data, 'value', 'label', true)
  }

  #appendNewLink () {
    if (this.newPath) {
      const dropdownList = this.element.querySelector('.choices__list--dropdown')

      if (dropdownList) {
        dropdownList.insertAdjacentHTML('beforeend', this.#dropdownFooterTemplate())
      }
    }
  }

  #template (template, choices) {
    return {
      choice: (args, data) =>
        this.#choiceTemplate(template, choices, args, data)
      // item: (args, data) =>
      //   this.#itemTemplate(template, args, data)
    }
  }

  #choiceTemplate (template, choices, { classNames }, data) {
    const id = this.#escape(data.id)
    const value = this.#escape(data.value)
    const label = this.#escape(data.label)
    const desc = data.customProperties?.desc ? this.#escape(data.customProperties.desc) : ''

    return template(`
      <div class="${classNames.item} ${classNames.itemChoice} ${
      data.disabled ? classNames.itemDisabled : classNames.itemSelectable
    }" data-select-text="${choices.config.itemSelectText}" data-choice ${
      data.disabled
        ? 'data-choice-disabled aria-disabled="true"'
        : 'data-choice-selectable'
    } data-id="${id}" data-value="${value}" ${
      data.groupId > 0 ? 'role="treeitem"' : 'role="option"'
    }>
      ${label}
      ${value && desc
        ? `
        <div class="text-sm text-foreground">
        ${desc}
        </div>
        `
        : ''
      }
    </div>
    `)
  }

  #options = () => {
    return 'silent renderChoiceLimit maxItemCount addItems removeItems removeItemButton editItems duplicateItemsAllowed delimiter paste searchEnabled searchChoices searchFloor searchResultLimit position resetScrollPosition addItemFilter shouldSort shouldSortItems placeholder placeholderValue prependValue appendValue searchPlaceholderValue renderSelectedChoices loadingText noResultsText noChoicesText itemSelectText addItemText maxItemText'
      .split(' ')
      .reduce(this.#optionsReducer, {})
  }

  #optionsReducer = (accumulator, currentValue) => {
    const value = this.selectTarget.dataset[currentValue]
    if (value) {
      accumulator[currentValue] = ['true', 'false'].includes(value) ? JSON.parse(value) : value
    }
    return accumulator
  }

  #dropdownFooterTemplate () {
    return `
      <a href="${this.newPath}" data-turbo-frame="drawer" class="choices__item choices__item--choice flex items-center gap-2 hover:bg-accent" tabindex="-1">
        <svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M2.8125 9H15.1875" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          <path d="M9 2.8125V15.1875" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <span>New</span>
      </a>
    `
  }

  #escape (value) {
    return String(value ?? '').replace(/[&<>"']/g, (char) => ({
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#39;'
    }[char]))
  }
}

stimulus.register('choices', ChoicesController)
