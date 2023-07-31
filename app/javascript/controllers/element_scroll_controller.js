import { scrollToElement } from '../helpers'; // eslint-disable-line import/no-unresolved

export default class extends ApplicationController {
  static targets = ['accordion'];

  connect() {
    if (this.firstInvalidField) {
      if (!this.visible(this.firstInvalidField)) {
        const collapsible = this.accordionTargets.find((target) => {
          return target.contains(this.firstInvalidField);
        });
        if (collapsible) $(collapsible).collapse('show');
      }

      setTimeout(() => {
        this.firstInvalidField.focus();
        scrollToElement(this.firstInvalidField);
      }, 300);
    }
  }

  // Private

  visible(el) {
    return !el.hidden && (!el.type || el.type != 'hidden') && (el.offsetWidth > 0 || el.offsetHeight > 0);
  }

  get formFields() {
    return Array.from(this.element.elements);
  }

  get firstInvalidField() {
    return this.formFields.find((field) => field.ariaInvalid == 'true');
  }
}
