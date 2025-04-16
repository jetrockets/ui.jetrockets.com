import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'
import { DateTime, easepick, LockPlugin, RangePlugin } from '@easepick/bundle'

export default class DatepickerController extends Controller {
  connect () {
    const { format, autohide } = this.element.dataset
    const { plugins, pluginOptions } = this.#plugins()

    this.picker = new easepick.Core({
      element: this.element,
      css: ['https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css'],
      plugins,
      format: format || 'YYYY-MM-DD',
      autoApply: autohide || true,
      zIndex: 1000,
      ...pluginOptions
    })
  }

  disconnect () {
    this.picker.destroy()
  }

  #plugins () {
    const { range, disableddates } = this.element.dataset
    const plugins = []
    const pluginOptions = {}

    if (range) plugins.push(RangePlugin)

    if (disableddates) {
      plugins.push(LockPlugin)

      const lockedDates = disableddates.split(', ').map(dateStr => {
        return new DateTime(dateStr.trim(), 'YYYY-MM-DD')
      })

      pluginOptions.LockPlugin = {
        minDate: new Date(),
        inseparable: true,
        filter (date, picked) {
          if (picked.length === 1) {
            const incl = date.isBefore(picked[0]) ? '[)' : '(]'
            return date.inArray(lockedDates, incl)
          }

          return date.inArray(lockedDates, '[)')
        }
      }
    }

    return { plugins, pluginOptions }
  }
}

stimulus.register('datepicker', DatepickerController)
