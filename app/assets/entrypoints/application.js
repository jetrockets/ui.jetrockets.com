import '~/init'
import '~/controllers'

import 'flowbite/dist/flowbite.turbo.js'
// import { initModals } from 'flowbite/lib/cjs/components/modal'

// document.addEventListener('turbo:load', () => {
//   initModals()
// })

// Import JS from view_components
import.meta.glob('../../components/**/*.js', { eager: true })
