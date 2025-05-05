import { Controller } from '@hotwired/stimulus'
import { easepick, RangePlugin, LockPlugin, AmpPlugin } from '@easepick/bundle'
import Imask from 'imask'

import styles from '@easepick/bundle/dist/index.css?inline'
import customStyles from '~/stylesheets/vendors/easepick.css?inline'
import { coreOptions, rangeOptions, lockOptions, ampOptions } from './easepick/config_options'
import { events } from './easepick/events'
import isMobile from '~/utils/navigator'
import { capitalize, kebabCase } from '~/utils/string'

export default class extends Controller {
  static targets = ['elementStart', 'elementEnd']

  initialize () {
    this.config = {
      css: styles + customStyles,
      date: this.element.value,
      firstDay: 0,
      element: this.hasElementStartTarget ? this.elementStartTarget : this.element,
      zIndex: 9999,
      format: 'MM/DD/YYYY',
      readonly: !!isMobile
    }
  }

  connect () {
    this.#init()
  }

  reload () {
    this.picker.destroy()
    this.#init()
  }

  clear () {
    this.picker.clear()
  }

  onClear (e) {
    this.dispatch('onClear')
  }

  onSelect (e) {
    this.dispatch('onSelect', { detail: e.detail })
  }

  disconnect () {
    this.picker.destroy()
  }

  show () {
    this.picker.show()
  }

  hide () {
    this.picker.hide()
  }

  #init () {
    this.#initializeEvents()
    this.#initializeOptions()
    this.#initializePlugins()

    if (!this.config.readonly) {
      this.#initializeMask()
    }

    this.picker = new easepick.Core({
      ...this.config
    })

    if (this.data.has('goto')) {
      this.#gotoDate(this.data.get('goto'))
    }
  }

  #initializeMask () {
    const startElement = this.hasElementStartTarget ? this.elementStartTarget : this.element
    const endElement = this.hasElementEndTarget ? this.elementEndTarget : null

    const options = {
      mask: 'MM/DD/YYYY',
      blocks: {
        DD: {
          mask: Imask.MaskedRange,
          from: 1,
          to: 31,
          maxLength: 2
        },
        MM: {
          mask: Imask.MaskedRange,
          from: 1,
          to: 12,
          maxLength: 2
        },
        YYYY: {
          mask: Imask.MaskedRange,
          from: 1900,
          to: 9999
        }
      },
      autofix: true,
      lazy: true,
      overwrite: true
    }

    const mask = Imask(startElement, options)
    if (this.hasElementEndTarget) {
      Imask(endElement, options)
    }

    const selectDate = () => {
      this.#gotoDate(mask.value)
      this.#setDate(mask.value)
    }

    mask.on('complete', selectDate)
  }

  #initializeEvents () {
    const self = this

    this.config = {
      ...this.config,
      setup (picker) {
        events.forEach((event) => {
          const hook = `on${capitalize(event)}`
          if (self[hook]) {
            picker.on(event, self[hook].bind(self))
          }
        })
      }
    }
  }

  #setDate (date) {
    this.picker.setDate(date)
  }

  #gotoDate (date) {
    this.picker.gotoDate(date)
  }

  // Core options
  #initializeOptions () {
    Object.keys(coreOptions).forEach((optionType) => {
      const optionsCamelCase = coreOptions[optionType]
      optionsCamelCase.forEach((option) => {
        const optionKebab = kebabCase(option)

        if (this.data.has(optionKebab)) {
          this.config[option] = this[`_${optionType}`](optionKebab)
        }
      })
    })
  }

  #initializePlugins () {
    if (this.data.has('plugins')) {
      this.config.plugins = []

      if (this._array('plugins').includes('RangePlugin')) {
        this.config.plugins.push(RangePlugin)
        this.#initializeRangeOptions()
      }

      if (this._array('plugins').includes('LockPlugin')) {
        this.config.plugins.push(LockPlugin)
        this.#initializeLockOptions()
      }

      if (this._array('plugins').includes('AmpPlugin')) {
        this.config.plugins.push(AmpPlugin)
        this.#initializeAmpOptions()
      }
    }
  }

  // RangePlugin
  #initializeRangeOptions () {
    this.config.RangePlugin = {}

    if (this.hasElementStartTarget) {
      this.config.element = this.elementStartTarget
    }

    if (this.hasElementEndTarget) {
      this.config.RangePlugin.elementEnd = this.elementEndTarget
    }

    Object.keys(rangeOptions).forEach((optionType) => {
      const optionsCamelCase = rangeOptions[optionType]
      optionsCamelCase.forEach((option) => {
        const optionKebab = kebabCase(`range_${option}`)

        if (this.data.has(optionKebab)) {
          this.config.RangePlugin[option] = this[`_${optionType}`](optionKebab)
        }
      })
    })
  }

  // LockPlugin
  #initializeLockOptions () {
    this.config.LockPlugin = {}

    Object.keys(lockOptions).forEach((optionType) => {
      const optionsCamelCase = lockOptions[optionType]
      optionsCamelCase.forEach((option) => {
        const optionKebab = kebabCase(`lock_${option}`)

        if (this.data.has(optionKebab)) {
          this.config.LockPlugin[option] = this[`_${optionType}`](optionKebab)
        }
      })
    })
  }

  #initializeAmpOptions () {
    this.config.AmpPlugin = {}

    Object.keys(ampOptions).forEach((optionType) => {
      const optionsCamelCase = ampOptions[optionType]
      optionsCamelCase.forEach((option) => {
        const optionKebab = kebabCase(`amp_${option}`)

        if (this.data.has(optionKebab)) {
          this.config.AmpPlugin[option] = this[`_${optionType}`](optionKebab)
        }
      })
    })
  }

  _string (option) {
    return this.data.get(option)
  }

  _date (option) {
    return this.data.get(option)
  }

  _boolean (option) {
    return !(this.data.get(option) === '0' || this.data.get(option) === 'false')
  }

  _array (option) {
    return JSON.parse(this.data.get(option))
  }

  _number (option) {
    return parseInt(this.data.get(option))
  }

  _object (option) {
    return JSON.parse(this.data.get(option))
  }
}
