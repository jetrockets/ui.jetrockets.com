import '@hotwired/turbo-rails'
import * as Turbo from '@hotwired/turbo'

Turbo.setProgressBarDelay(500)

// If a frame is missing, it's likely because the server redirected to a new location
document.addEventListener('turbo:frame-missing', event => {
  if (event.detail.response.redirected) {
    event.preventDefault()
    event.detail.visit(event.detail.response)
  }
})

Turbo.setConfirmMethod((message) => {
  const dialog = document.getElementById('turbo-confirm')
  dialog.querySelector('p').textContent = message
  dialog.showModal()

  return new Promise((resolve) => {
    dialog.addEventListener('close', () => {
      resolve(dialog.returnValue === 'confirm')
    }, { once: true })

    dialog.addEventListener('click', (event) => {
      if (event.target.nodeName === 'DIALOG') {
        dialog.returnValue = 'cancel'
        dialog.close()
      }
    })
  })
})
