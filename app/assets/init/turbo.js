import '@hotwired/turbo-rails'
import * as Turbo from '@hotwired/turbo'

Turbo.setProgressBarDelay(500)

Turbo.setConfirmMethod((message) => {
  const dialog = document.getElementById('turbo-confirm')
  dialog.querySelector('h3').textContent = message
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
