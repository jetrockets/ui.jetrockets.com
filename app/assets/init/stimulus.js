import { Application } from '@hotwired/stimulus'

const stimulus = Application.start()

window.Stimulus = stimulus
stimulus.debug = new URLSearchParams(window.location.search).has('debug')

export { stimulus }
