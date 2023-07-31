import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  get classList() {
    return this.element.classList;
  }

  get csrfToken() {
    return this.metaValue('csrf-token');
  }

  dispatch(eventName, { target = this.element, detail = {}, bubbles = true, cancelable = true } = {}) {
    const type = `${this.identifier}:${eventName}`;
    const event = new CustomEvent(type, { detail, bubbles, cancelable });
    target.dispatchEvent(event);
    return event;
  }

  observeMutations(callback, target = this.element, options = { childList: true, subtree: true }) {
    const observer = new MutationObserver((mutations) => {
      observer.disconnect();
      Promise.resolve().then(start); // eslint-disable-line no-use-before-define
      callback.call(this, mutations);
    });
    function start() {
      if (target.isConnected) observer.observe(target, options);
    }
    start();
  }

  metaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`);
    return element && element.getAttribute('content');
  }
}
