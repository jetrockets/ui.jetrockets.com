import { Controller } from '@hotwired/stimulus'
import Choices from 'choices.js'

// import 'choices.js/src/styles/choices.scss'

export default class extends Controller {
  static targets = ['select', 'options']

  initialize () {
    this.searchPath = this.element.dataset.searchPath
    this.newPath = this.element.dataset.newPath || false
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
      this.selectTarget.removeEventListener('removeItem', this.#removeItem)
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

  #toggleInput () {
    const input = this.element.querySelector('.choices__input.choices__input--cloned')

    if (!input) return

    const selectedItems = this.selectTarget.querySelectorAll('option:checked').length
    if (selectedItems >= parseInt(this.element.dataset.maxItemCount)) {
      input.classList.add('hidden')
    } else {
      input.classList.remove('hidden')
    }
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
    this.choices = new Choices(this.selectTarget, {
      searchPlaceholderValue: 'Search',
      searchFloor: 1,
      maxItemCount: -1,
      fuseOptions: {
        threshold: 0.2
      },
      searchResultLimit: 10,
      removeItemButton: true,
      allowHTML: true,
      ...this.#options(),
      callbackOnCreateTemplates: function (template) {
        return {
          choice: ({ classNames }, data) => {
            return template(`
              <div class="${classNames.item} ${classNames.itemChoice} ${
              data.disabled ? classNames.itemDisabled : classNames.itemSelectable
            }" data-select-text="${this.config.itemSelectText}" data-choice ${
              data.disabled
                ? 'data-choice-disabled aria-disabled="true"'
                : 'data-choice-selectable'
            } data-id="${data.id}" data-value="${data.value}" ${
              data.groupId > 0 ? 'role="treeitem"' : 'role="option"'
            }>
              ${data.label}
              ${data.value && data.customProperties?.desc
                ? `
                <div class="text-sm text-gray-800">
                ${data.customProperties.desc}
                </div>
                `
                : ''
              }
            </div>
            `)
          }
        }
      }
    })
    this.input = this.element.querySelector('input')

    this.selectTarget.addEventListener('addItem', this.#addItem)
    this.selectTarget.addEventListener('removeItem', this.#removeItem)
    if (this.input && this.searchPath) {
      this.input.addEventListener('input', this.#search)
    }

    this.#appendNewLink()
    this.#toggleInput()
  }

  #loadDefaultOptions = () => {
    // this.choices.setChoices([{ value: '', label: 'Please Select' }], 'value', 'label', true)

    if (this.hasOptionsTarget) {
      const options = [...this.optionsTarget.children].map(option => ({
        value: option.value,
        label: option.label,
        customProperties: option.dataset.customProperties ? JSON.parse(option.dataset.customProperties) : {}
      }))
      this.choices.setChoices(options, 'value', 'label', false)
    }
  }

  #addItem = (event) => {
    const selectedLength = this.selectTarget.options.length
    const maxItemCount = parseInt(this.element.dataset.maxItemCount)

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

    this.#toggleInput()
  }

  #removeItem = (event) => {
    this.#toggleInput()
  }

  #search = (event) => {
    if (event.target.value) {
      fetch(this.#buildSearchPath(this.searchPath, `q=${event.target.value}`), {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      })
        .then(response => response.json())
        .then(this.#setSearchOptions)
    } else {
      this.#loadDefaultOptions()
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

      if (dropdownList && !dropdownList.querySelector('.choices__item--new')) {
        const linkElement = `<a href="${this.newUrlValue}" class="choices__item choices__item--new" data-turbo-frame="modal">+ New item</a>`
        dropdownList.insertAdjacentHTML('beforeend', linkElement)
      }
    }
  }

  #options = () => {
    return 'silent renderChoiceLimit maxItemCount addItems removeItems removeItemButton editItems duplicateItemsAllowed delimiter paste searchEnabled searchChoices searchFloor searchResultLimit position resetScrollPosition addItemFilter shouldSort shouldSortItems placeholder placeholderValue prependValue appendValue searchPlaceholderValue renderSelectedChoices loadingText noResultsText noChoicesText itemSelectText addItemText maxItemText'
      .split(' ')
      .reduce(this.#optionsReducer, {})
  }

  #optionsReducer = (accumulator, currentValue) => {
    const value = this.element.dataset[currentValue]
    if (value) {
      accumulator[currentValue] = value === 'true' || value === 'false' ? JSON.parse(value) : value
    } else if (currentValue === 'shouldSort') {
      accumulator[currentValue] = false // Set default value for shouldSort
    }
    return accumulator
  }
}
