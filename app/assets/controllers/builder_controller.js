import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

// --- Color conversion utilities ---

function hexToSrgb (hex) {
  hex = hex.replace('#', '')
  return [
    parseInt(hex.slice(0, 2), 16) / 255,
    parseInt(hex.slice(2, 4), 16) / 255,
    parseInt(hex.slice(4, 6), 16) / 255
  ]
}

function srgbToLinear (c) {
  return c <= 0.04045 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4)
}

function linearRgbToOklab (r, g, b) {
  const l = Math.cbrt(0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b)
  const m = Math.cbrt(0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b)
  const s = Math.cbrt(0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b)
  return [
    0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
    1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
    0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s
  ]
}

function hexToOklch (hex) {
  const [r, g, b] = hexToSrgb(hex).map(srgbToLinear)
  const [L, a, bVal] = linearRgbToOklab(r, g, b)
  const c = Math.sqrt(a * a + bVal * bVal)
  let h = (Math.atan2(bVal, a) * 180) / Math.PI
  if (h < 0) h += 360
  return { l: L, c, h }
}

function formatOklch (l, c, h) {
  if (c < 0.001) return `oklch(${l.toFixed(3)} 0 0)`
  return `oklch(${l.toFixed(3)} ${c.toFixed(3)} ${h.toFixed(1)})`
}

export default class BuilderController extends Controller {
  static targets = [
    'primaryColor', 'primaryHex', 'primaryOklch',
    'darkPrimaryColor', 'darkPrimaryHex', 'darkPrimaryOklch',
    'secondaryColor', 'secondaryHex', 'secondaryOklch',
    'darkSecondaryColor', 'darkSecondaryHex', 'darkSecondaryOklch',
    'backgroundColor', 'backgroundHex', 'backgroundOklch',
    'darkBackgroundColor', 'darkBackgroundHex', 'darkBackgroundOklch',
    'lightPrimarySection', 'darkPrimarySection',
    'lightSecondarySection', 'darkSecondarySection',
    'lightBackgroundSection', 'darkBackgroundSection',
    'radiusBase', 'radiusBtn', 'radiusForm',
    'lightIcon', 'darkIcon',
    'download'
  ]

  static values = { defaults: Object, downloadUrl: String }

  connect () {
    this.currentTheme = this.getSavedTheme()
    this.applyThemeClass()
    this.updateThemeIcons()
    this.updateThemeSections()
    this.applyAllColors()
    this.applyRadius()
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
    this.updateThemeSections()
    this.applyAllColors()
    window.localStorage.setItem('theme', this.currentTheme)
    this.updateDownloadUrl()
  }

  applyThemeClass () {
    document.documentElement.classList.toggle('dark', this.currentTheme === 'dark')
  }

  updateThemeIcons () {
    if (this.hasLightIconTarget && this.hasDarkIconTarget) {
      const showLight = this.currentTheme === 'dark'
      this.lightIconTarget.classList.toggle('hidden', !showLight)
      this.lightIconTarget.classList.toggle('inline-flex', showLight)
      this.darkIconTarget.classList.toggle('hidden', showLight)
      this.darkIconTarget.classList.toggle('inline-flex', !showLight)
    }
  }

  updateThemeSections () {
    const isDark = this.currentTheme === 'dark'
    const pairs = [
      ['lightPrimarySection', 'darkPrimarySection'],
      ['lightSecondarySection', 'darkSecondarySection'],
      ['lightBackgroundSection', 'darkBackgroundSection']
    ]
    pairs.forEach(([light, dark]) => {
      if (this[`has${light[0].toUpperCase() + light.slice(1)}Target`]) {
        this[`${light}Target`].classList.toggle('hidden', isDark)
      }
      if (this[`has${dark[0].toUpperCase() + dark.slice(1)}Target`]) {
        this[`${dark}Target`].classList.toggle('hidden', !isDark)
      }
    })
  }

  applyAllColors () {
    const isDark = this.currentTheme === 'dark'

    // Primary
    const primaryTarget = isDark ? 'darkPrimaryColor' : 'primaryColor'
    const primaryOklch = isDark ? 'darkPrimaryOklch' : 'primaryOklch'
    this.applyColorPicker(primaryTarget, primaryOklch, '--primary')

    // Secondary
    const secondaryTarget = isDark ? 'darkSecondaryColor' : 'secondaryColor'
    const secondaryOklch = isDark ? 'darkSecondaryOklch' : 'secondaryOklch'
    this.applyColorPicker(secondaryTarget, secondaryOklch, '--secondary')

    // Background
    const bgTarget = isDark ? 'darkBackgroundColor' : 'backgroundColor'
    const bgOklch = isDark ? 'darkBackgroundOklch' : 'backgroundOklch'
    this.applyColorPicker(bgTarget, bgOklch, '--background')

    // Also display oklch for the hidden side
    if (!isDark) {
      this.applyOklchDisplay('darkPrimaryColor', 'darkPrimaryOklch')
      this.applyOklchDisplay('darkSecondaryColor', 'darkSecondaryOklch')
      this.applyOklchDisplay('darkBackgroundColor', 'darkBackgroundOklch')
    } else {
      this.applyOklchDisplay('primaryColor', 'primaryOklch')
      this.applyOklchDisplay('secondaryColor', 'secondaryOklch')
      this.applyOklchDisplay('backgroundColor', 'backgroundOklch')
    }
  }

  // --- Generic color picker handler ---

  applyColorPicker (colorTarget, oklchTarget, cssProperty) {
    const targetName = `${colorTarget}Target`
    if (!this[`has${colorTarget[0].toUpperCase() + colorTarget.slice(1)}Target`]) return
    const colorEl = this[targetName]
    const { l, c, h } = hexToOklch(colorEl.value)
    const oklchStr = formatOklch(l, c, h)
    const oklchName = `${oklchTarget}Target`
    if (this[`has${oklchTarget[0].toUpperCase() + oklchTarget.slice(1)}Target`]) {
      this[oklchName].textContent = oklchStr
    }
    this.setProperty(cssProperty, oklchStr)
  }

  applyOklchDisplay (colorTarget, oklchTarget) {
    const colorName = `${colorTarget}Target`
    const oklchName = `${oklchTarget}Target`
    if (!this[`has${colorTarget[0].toUpperCase() + colorTarget.slice(1)}Target`]) return
    if (!this[`has${oklchTarget[0].toUpperCase() + oklchTarget.slice(1)}Target`]) return
    const { l, c, h } = hexToOklch(this[colorName].value)
    this[oklchName].textContent = formatOklch(l, c, h)
  }

  // --- Primary Color ---

  updatePrimaryColor () {
    this.primaryHexTarget.value = this.primaryColorTarget.value
    this.applyColorPicker('primaryColor', 'primaryOklch', '--primary')
    this.updateDownloadUrl()
  }

  updatePrimaryFromHex () {
    const hex = this.primaryHexTarget.value
    if (/^#[0-9a-f]{6}$/i.test(hex)) {
      this.primaryColorTarget.value = hex
      this.applyColorPicker('primaryColor', 'primaryOklch', '--primary')
      this.updateDownloadUrl()
    }
  }

  updateDarkPrimaryColor () {
    this.darkPrimaryHexTarget.value = this.darkPrimaryColorTarget.value
    this.applyColorPicker('darkPrimaryColor', 'darkPrimaryOklch', '--primary')
    this.updateDownloadUrl()
  }

  updateDarkPrimaryFromHex () {
    const hex = this.darkPrimaryHexTarget.value
    if (/^#[0-9a-f]{6}$/i.test(hex)) {
      this.darkPrimaryColorTarget.value = hex
      this.applyColorPicker('darkPrimaryColor', 'darkPrimaryOklch', '--primary')
      this.updateDownloadUrl()
    }
  }

  // --- Secondary Color ---

  updateSecondaryColor () {
    this.secondaryHexTarget.value = this.secondaryColorTarget.value
    this.applyColorPicker('secondaryColor', 'secondaryOklch', '--secondary')
    this.updateDownloadUrl()
  }

  updateSecondaryFromHex () {
    const hex = this.secondaryHexTarget.value
    if (/^#[0-9a-f]{6}$/i.test(hex)) {
      this.secondaryColorTarget.value = hex
      this.applyColorPicker('secondaryColor', 'secondaryOklch', '--secondary')
      this.updateDownloadUrl()
    }
  }

  updateDarkSecondaryColor () {
    this.darkSecondaryHexTarget.value = this.darkSecondaryColorTarget.value
    this.applyColorPicker('darkSecondaryColor', 'darkSecondaryOklch', '--secondary')
    this.updateDownloadUrl()
  }

  updateDarkSecondaryFromHex () {
    const hex = this.darkSecondaryHexTarget.value
    if (/^#[0-9a-f]{6}$/i.test(hex)) {
      this.darkSecondaryColorTarget.value = hex
      this.applyColorPicker('darkSecondaryColor', 'darkSecondaryOklch', '--secondary')
      this.updateDownloadUrl()
    }
  }

  // --- Background Color ---

  updateBackgroundColor () {
    this.backgroundHexTarget.value = this.backgroundColorTarget.value
    this.applyColorPicker('backgroundColor', 'backgroundOklch', '--background')
    this.updateDownloadUrl()
  }

  updateBackgroundFromHex () {
    const hex = this.backgroundHexTarget.value
    if (/^#[0-9a-f]{6}$/i.test(hex)) {
      this.backgroundColorTarget.value = hex
      this.applyColorPicker('backgroundColor', 'backgroundOklch', '--background')
      this.updateDownloadUrl()
    }
  }

  updateDarkBackgroundColor () {
    this.darkBackgroundHexTarget.value = this.darkBackgroundColorTarget.value
    this.applyColorPicker('darkBackgroundColor', 'darkBackgroundOklch', '--background')
    this.updateDownloadUrl()
  }

  updateDarkBackgroundFromHex () {
    const hex = this.darkBackgroundHexTarget.value
    if (/^#[0-9a-f]{6}$/i.test(hex)) {
      this.darkBackgroundColorTarget.value = hex
      this.applyColorPicker('darkBackgroundColor', 'darkBackgroundOklch', '--background')
      this.updateDownloadUrl()
    }
  }

  // --- Radius ---

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

  updateRadiusBtn (event) {
    const value = event.currentTarget.dataset.value
    this.radiusBtnTargets.forEach(el => {
      const isActive = el.dataset.value === value
      el.classList.toggle('btn-default', isActive)
      el.classList.toggle('btn-outline', !isActive)
    })
    this.setProperty('--radius-btn', this.radiusToRem(value))
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

  applyRadius () {
    const activeRadiusBase = this.radiusBaseTargets.find(el => el.classList.contains('btn-default'))
    if (activeRadiusBase) {
      this.setProperty('--radius-base', this.radiusToRem(activeRadiusBase.dataset.value))
    }

    const activeRadiusBtn = this.radiusBtnTargets.find(el => el.classList.contains('btn-default'))
    if (activeRadiusBtn) {
      this.setProperty('--radius-btn', this.radiusToRem(activeRadiusBtn.dataset.value))
    }

    const activeRadiusForm = this.radiusFormTargets.find(el => el.classList.contains('btn-default'))
    if (activeRadiusForm) {
      this.setProperty('--radius-field', this.radiusToRem(activeRadiusForm.dataset.value))
    }
  }

  // --- Utilities ---

  setProperty (name, value) {
    document.documentElement.style.setProperty(name, value)
  }

  updateDownloadUrl () {
    if (!this.hasDownloadTarget) return

    const activeRadiusBase = this.radiusBaseTargets.find(el => el.classList.contains('btn-default'))
    const activeRadiusBtn = this.radiusBtnTargets.find(el => el.classList.contains('btn-default'))
    const activeRadiusForm = this.radiusFormTargets.find(el => el.classList.contains('btn-default'))

    const params = new URLSearchParams({
      primary: this.primaryColorTarget.value,
      primary_dark: this.hasDarkPrimaryColorTarget ? this.darkPrimaryColorTarget.value : '',
      secondary: this.hasSecondaryColorTarget ? this.secondaryColorTarget.value : '',
      secondary_dark: this.hasDarkSecondaryColorTarget ? this.darkSecondaryColorTarget.value : '',
      background: this.hasBackgroundColorTarget ? this.backgroundColorTarget.value : '',
      background_dark: this.hasDarkBackgroundColorTarget ? this.darkBackgroundColorTarget.value : '',
      radius_base: activeRadiusBase?.dataset.value || 'lg',
      radius_btn: activeRadiusBtn?.dataset.value || '',
      radius_form: activeRadiusForm?.dataset.value || 'md'
    })

    this.downloadTarget.href = `${this.downloadUrlValue}?${params.toString()}`
  }

  reset () {
    const defaults = this.defaultsValue

    // Reset primary
    this.primaryColorTarget.value = defaults.primary
    this.primaryHexTarget.value = defaults.primary
    if (this.hasDarkPrimaryColorTarget) {
      this.darkPrimaryColorTarget.value = defaults.primary_dark
      this.darkPrimaryHexTarget.value = defaults.primary_dark
    }

    // Reset secondary
    if (this.hasSecondaryColorTarget) {
      this.secondaryColorTarget.value = defaults.secondary
      this.secondaryHexTarget.value = defaults.secondary
    }
    if (this.hasDarkSecondaryColorTarget) {
      this.darkSecondaryColorTarget.value = defaults.secondary_dark
      this.darkSecondaryHexTarget.value = defaults.secondary_dark
    }

    // Reset background
    if (this.hasBackgroundColorTarget) {
      this.backgroundColorTarget.value = defaults.background
      this.backgroundHexTarget.value = defaults.background
    }
    if (this.hasDarkBackgroundColorTarget) {
      this.darkBackgroundColorTarget.value = defaults.background_dark
      this.darkBackgroundHexTarget.value = defaults.background_dark
    }

    // Reset radius
    this.radiusBaseTargets.forEach(el => {
      const isActive = el.dataset.value === (defaults.radius_base || 'lg')
      el.classList.toggle('btn-default', isActive)
      el.classList.toggle('btn-outline', !isActive)
    })
    this.radiusBtnTargets.forEach(el => {
      const isActive = el.dataset.value === (defaults.radius_btn || defaults.radius_base || 'lg')
      el.classList.toggle('btn-default', isActive)
      el.classList.toggle('btn-outline', !isActive)
    })
    this.radiusFormTargets.forEach(el => {
      const isActive = el.dataset.value === (defaults.radius_form || 'md')
      el.classList.toggle('btn-default', isActive)
      el.classList.toggle('btn-outline', !isActive)
    })

    // Reset theme to light
    this.currentTheme = 'light'
    this.applyThemeClass()
    this.updateThemeIcons()
    this.updateThemeSections()
    window.localStorage.setItem('theme', 'light')

    this.applyAllColors()
    this.applyRadius()
    this.updateDownloadUrl()
  }
}

stimulus.register('builder', BuilderController)
