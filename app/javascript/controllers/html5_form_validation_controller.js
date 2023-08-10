export default class extends ApplicationController {
  static values = {
    selectors: Array,
  };

  validate = (event) => {
    let counter = 0;

    this.filteredFields.forEach((field) => {
      if (field && this.shouldValidateField(field)) {
        field.required = true;

        if (!field.checkValidity()) {
          counter += 1;
        }
      }
    });

    if (counter > 0) {
      event.preventDefault();
      event.stopPropagation();
    }

    this.firstInvalidField && this.firstInvalidField.reportValidity();
  };

  discard = (event) => {
    this.filteredFields.forEach((field) => {
      field.removeAttribute('required');
    });
  };

  shouldValidateField(field) {
    return (
      !field.disabled &&
      field.type !== undefined &&
      this.visible(field) &&
      !['file', 'reset', 'submit', 'button'].includes(field.type)
    );
  }

  visible(field) {
    return (
      !field.hidden && (!field.type || field.type != 'hidden') && (field.offsetWidth > 0 || field.offsetHeight > 0)
    );
  }

  get filteredFields() {
    return this.formFields.filter((f) => this.selectors.includes(f.tagName)).filter(this.visible);
  }

  get formFields() {
    return Array.from(this.element.elements);
  }

  get selectors() {
    if (this.hasSelectorsValue) {
      return this.selectorsValue.map((selector) => selector.toUpperCase());
    } else {
      return [];
    }
  }

  get firstInvalidField() {
    return this.filteredFields.find((field) => !field.checkValidity());
  }
}
