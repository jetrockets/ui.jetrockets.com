import { Application } from '@hotwired/stimulus';

const stimulus = Application.start();

window.Stimulus = stimulus;
// application.debug = true;

export { stimulus };
