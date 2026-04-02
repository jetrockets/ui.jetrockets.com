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

/*
 * Generic builder controller.
 *
 * Color pickers use data attributes instead of named targets:
 *   data-color-var="primary"       — CSS variable name (--primary)
 *   data-color-mode="light|dark"   — which theme this picker controls
 *   data-color-role="picker|hex"   — input type
 *
 * Each color row is a <div data-color-var="..." data-color-mode="...">.
 * Inside it: input[type=color] (picker) + input[type=text] (hex).
 */
export default class BuilderController extends Controller {
  static targets = [
    'colorRow',
    'radiusBase',
    'radiusBtn',
    'radiusForm',
    'lightIcon',
    'darkIcon',
    'download'
  ]

  static values = {
    defaults: Object,
    downloadUrl: String
  }

  connect () {
    this.currentTheme = this.getSavedTheme()
    this.applyThemeClass()
    this.updateThemeIcons()
    this.showActiveColorRows()
    this.applyAllColors()
    this.applyRadius()
    this.updateDownloadUrl()
  }

  // --- Theme ---

  getSavedTheme () {
    const saved = window.localStorage.getItem('theme')
    if (saved) return saved
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  }

  toggleTheme () {
    this.currentTheme = this.currentTheme === 'dark' ? 'light' : 'dark'
    this.applyThemeClass()
    this.updateThemeIcons()
    this.showActiveColorRows()
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

  // --- Color rows visibility ---

  showActiveColorRows () {
    this.colorRowTargets.forEach(row => {
      const mode = row.dataset.colorMode
      if (mode === 'light') {
        row.classList.toggle('hidden', this.currentTheme === 'dark')
      } else if (mode === 'dark') {
        row.classList.toggle('hidden', this.currentTheme !== 'dark')
      }
    })
  }

  // --- Generic color handler ---

  oklchFromRow (row) {
    const picker = row.querySelector('input[type="color"]')
    if (!picker) return null
    const alphaInput = row.querySelector('[data-role="alpha"]')
    const { l, c, h } = hexToOklch(picker.value)
    const base = formatOklch(l, c, h)
    if (alphaInput) {
      const a = parseInt(alphaInput.value, 10)
      if (!isNaN(a) && a < 100) {
        return base.replace(')', ' / ' + a + '%)')
      }
    }
    return base
  }

  updateColor (event) {
    const row = event.currentTarget.closest('[data-builder-target="colorRow"]')
    if (!row) return
    const picker = row.querySelector('input[type="color"]')
    const hex = row.querySelector('input[type="text"]')
    const cssVar = row.dataset.colorVar
    const mode = row.dataset.colorMode

    // Sync picker <-> hex (skip for alpha input)
    if (event.currentTarget.type === 'color') {
      hex.value = picker.value
    } else if (event.currentTarget.type === 'text') {
      if (/^#[0-9a-f]{6}$/i.test(hex.value)) {
        picker.value = hex.value
      } else {
        return
      }
    }

    // Apply to CSS if this row's mode matches current theme
    if (mode === this.currentTheme || !mode) {
      this.setProperty(`--${cssVar}`, this.oklchFromRow(row))
    }

    this.updateDownloadUrl()
  }

  applyAllColors () {
    // Clear all inline color overrides first (restore CSS defaults)
    const seen = new Set()
    this.colorRowTargets.forEach(row => {
      const cssVar = row.dataset.colorVar
      if (cssVar && !seen.has(cssVar)) {
        document.documentElement.style.removeProperty(`--${cssVar}`)
        seen.add(cssVar)
      }
    })

    // Re-apply only values that differ from defaults
    this.colorRowTargets.forEach(row => {
      const picker = row.querySelector('input[type="color"]')
      const cssVar = row.dataset.colorVar
      const mode = row.dataset.colorMode
      if (!picker || !cssVar) return
      if (mode !== this.currentTheme) return

      const paramKey = cssVar.replace(/-/g, '_')
      const defaultKey = mode === 'dark' ? `${paramKey}_dark` : paramKey
      const defaultVal = this.defaultsValue[defaultKey]
      if (picker.value === defaultVal) return

      this.setProperty(`--${cssVar}`, this.oklchFromRow(row))
    })
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

    const params = new URLSearchParams()

    // Collect all color values + alpha
    this.colorRowTargets.forEach(row => {
      const picker = row.querySelector('input[type="color"]')
      const alphaInput = row.querySelector('[data-role="alpha"]')
      const cssVar = row.dataset.colorVar
      const mode = row.dataset.colorMode
      if (!picker || !cssVar) return
      const paramKey = cssVar.replace(/-/g, '_')
      const suffix = mode === 'dark' ? '_dark' : ''
      params.set(paramKey + suffix, picker.value)
      if (alphaInput) {
        params.set(paramKey + suffix + '_alpha', alphaInput.value)
      }
    })

    // Radius
    const activeRadiusBase = this.radiusBaseTargets.find(el => el.classList.contains('btn-default'))
    const activeRadiusBtn = this.radiusBtnTargets.find(el => el.classList.contains('btn-default'))
    const activeRadiusForm = this.radiusFormTargets.find(el => el.classList.contains('btn-default'))
    params.set('radius_base', activeRadiusBase?.dataset.value || 'md')
    params.set('radius_btn', activeRadiusBtn?.dataset.value || '')
    params.set('radius_form', activeRadiusForm?.dataset.value || 'md')

    this.downloadTarget.href = `${this.downloadUrlValue}?${params.toString()}`
  }

  reset () {
    const defaults = this.defaultsValue

    // Reset all color rows (including alpha)
    this.colorRowTargets.forEach(row => {
      const picker = row.querySelector('input[type="color"]')
      const hex = row.querySelector('input[type="text"]')
      const alphaInput = row.querySelector('[data-role="alpha"]')
      const cssVar = row.dataset.colorVar
      const mode = row.dataset.colorMode
      if (!picker || !cssVar) return
      const paramKey = cssVar.replace(/-/g, '_')
      const defaultKey = mode === 'dark' ? `${paramKey}_dark` : paramKey
      const defaultVal = defaults[defaultKey]
      if (defaultVal) {
        picker.value = defaultVal
        if (hex) hex.value = defaultVal
      }
      if (alphaInput) {
        const alphaKey = defaultKey + '_alpha'
        alphaInput.value = defaults[alphaKey] || alphaInput.defaultValue
      }
    })

    // Reset radius
    this.radiusBaseTargets.forEach(el => {
      const isActive = el.dataset.value === (defaults.radius_base || 'md')
      el.classList.toggle('btn-default', isActive)
      el.classList.toggle('btn-outline', !isActive)
    })
    this.radiusBtnTargets.forEach(el => {
      const isActive = el.dataset.value === (defaults.radius_btn || defaults.radius_base || 'md')
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
    this.showActiveColorRows()
    window.localStorage.setItem('theme', 'light')

    this.applyAllColors()
    this.applyRadius()
    this.updateDownloadUrl()
  }
}

stimulus.register('builder', BuilderController)
