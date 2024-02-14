import { registerControllers } from 'stimulus-vite-helpers';
import {
  Dropdown,
  Toggle,
  Modal
} from 'tailwindcss-stimulus-components';

import { stimulus } from '~/init';

const controllers = import.meta.glob('./**/*_controller.js', { eager: true });

stimulus.register('dropdown', Dropdown);
stimulus.register('modal-sync', Modal);
stimulus.register('toggle', Toggle);

registerControllers(stimulus, controllers);
