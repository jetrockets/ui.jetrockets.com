import '~/init'
import '~/controllers'

// Import JS and CSS from view_components
import.meta.glob('../../components/**/*.js', { eager: true })
import.meta.glob('../../components/**/*.css', { eager: true })
