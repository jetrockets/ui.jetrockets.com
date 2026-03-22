import { Controller } from '@hotwired/stimulus'
import { stimulus } from '~/init'

export default class ThemeController extends Controller {
  static targets = ['light', 'dark']

  connect () {
    this.applyTheme(this.currentTheme)
  }

  toggle () {
    const newTheme = this.currentTheme === 'dark' ? 'light' : 'dark'
    this.applyTheme(newTheme)
    this.saveTheme(newTheme)
  }

  applyTheme (theme) {
    if (theme === 'dark') {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
    this.updateIcons(theme)
  }

  updateIcons (theme) {
    if (this.hasLightTarget && this.hasDarkTarget) {
      // Show sun in light mode, moon in dark mode
      this.lightTarget.classList.toggle('hidden', theme !== 'dark')
      this.darkTarget.classList.toggle('hidden', theme !== 'light')
    }
  }

  saveTheme (theme) {
    window.localStorage.setItem('theme', theme)
  }

  get currentTheme () {
    const saved = window.localStorage.getItem('theme')
    if (saved) return saved

    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  }
}

stimulus.register('theme', ThemeController)
