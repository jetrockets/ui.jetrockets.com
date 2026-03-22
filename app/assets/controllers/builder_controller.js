import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class BuilderController extends Controller {
  static targets = ['hue', 'hueValue', 'grayChroma', 'grayChromaValue', 'radiusBase', 'radiusForm', 'lightIcon', 'darkIcon', 'download']
  static values = { defaults: Object, downloadUrl: String }

  connect () {
    this.currentTheme = this.getSavedTheme()
    this.applyThemeClass()
    this.updateThemeIcons()
    this.applyTheme()
    this.updateDownloadUrl()
  }

  getSavedTheme () {
    const saved = window.localStorage.getItem('theme')
    if (saved) return saved
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  }

  toggleTheme () {
    this.currentTheme = this.currentTheme === 'dark' ? 'light' : 'dark'
    this.applyThemeClass()
    this.updateThemeIcons()
    window.localStorage.setItem('theme', this.currentTheme)
    this.updateDownloadUrl()
  }

  applyThemeClass () {
    if (this.currentTheme === 'dark') {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }

  updateThemeIcons () {
    if (this.hasLightIconTarget && this.hasDarkIconTarget) {
      this.lightIconTarget.classList.toggle('hidden', this.currentTheme !== 'dark')
      this.darkIconTarget.classList.toggle('hidden', this.currentTheme !== 'light')
    }
  }

  updateHue () {
    const value = this.hueTarget.value
    this.hueValueTarget.textContent = value
    this.setProperty('--accent-hue', value)
    this.updateDownloadUrl()
  }

  updateGrayChroma () {
    const value = this.grayChromaTarget.value
    this.grayChromaValueTarget.textContent = value
    this.setProperty('--gray-chroma', value)
    this.updateDownloadUrl()
  }

  updateRadiusBase (event) {
    const value = event.currentTarget.dataset.value
    this.radiusBaseTargets.forEach(el => {
      const isActive = el.dataset.value === value
      el.classList.toggle('btn-default', isActive)
      el.classList.toggle('btn-outline', !isActive)
    })
    this.setProperty('--radius-base', this.radiusToRem(value))
    this.updateDownloadUrl()
  }

  updateRadiusForm (event) {
    const value = event.currentTarget.dataset.value
    this.radiusFormTargets.forEach(el => {
      const isActive = el.dataset.value === value
      el.classList.toggle('btn-default', isActive)
      el.classList.toggle('btn-outline', !isActive)
    })
    this.setProperty('--radius-field', this.radiusToRem(value))
    this.updateDownloadUrl()
  }

  radiusToRem (value) {
    const map = {
      none: '0',
      sm: '0.25rem',
      md: '0.375rem',
      lg: '0.5rem',
      xl: '0.75rem',
      full: '9999px'
    }
    return map[value] || map.md
  }

  setProperty (name, value) {
    document.documentElement.style.setProperty(name, value)
  }

  applyTheme () {
    this.setProperty('--accent-hue', this.hueTarget.value)
    this.setProperty('--gray-chroma', this.grayChromaTarget.value)

    const activeRadiusBase = this.radiusBaseTargets.find(el => el.classList.contains('btn-default'))
    if (activeRadiusBase) {
      this.setProperty('--radius-base', this.radiusToRem(activeRadiusBase.dataset.value))
    }

    const activeRadiusForm = this.radiusFormTargets.find(el => el.classList.contains('btn-default'))
    if (activeRadiusForm) {
      this.setProperty('--radius-field', this.radiusToRem(activeRadiusForm.dataset.value))
    }
  }

  updateDownloadUrl () {
    if (!this.hasDownloadTarget) return

    const activeRadiusBase = this.radiusBaseTargets.find(el => el.classList.contains('btn-default'))
    const activeRadiusForm = this.radiusFormTargets.find(el => el.classList.contains('btn-default'))

    const params = new URLSearchParams({
      accent_hue: this.hueTarget.value,
      gray_chroma: this.grayChromaTarget.value,
      radius_base: activeRadiusBase?.dataset.value || 'lg',
      radius_form: activeRadiusForm?.dataset.value || 'md',
      theme: this.currentTheme || 'light'
    })

    this.downloadTarget.href = `${this.downloadUrlValue}?${params.toString()}`
  }

  reset () {
    const defaults = this.defaultsValue

    this.hueTarget.value = defaults.accent_hue
    this.hueValueTarget.textContent = defaults.accent_hue

    this.grayChromaTarget.value = defaults.gray_chroma
    this.grayChromaValueTarget.textContent = defaults.gray_chroma

    this.radiusBaseTargets.forEach(el => {
      const isActive = el.dataset.value === defaults.radius_base
      el.classList.toggle('btn-default', isActive)
      el.classList.toggle('btn-outline', !isActive)
    })

    this.radiusFormTargets.forEach(el => {
      const isActive = el.dataset.value === defaults.radius_form
      el.classList.toggle('btn-default', isActive)
      el.classList.toggle('btn-outline', !isActive)
    })

    // Reset theme to light
    this.currentTheme = 'light'
    this.applyThemeClass()
    this.updateThemeIcons()
    window.localStorage.setItem('theme', 'light')

    this.applyTheme()
    this.updateDownloadUrl()
  }
}

stimulus.register('builder', BuilderController)
