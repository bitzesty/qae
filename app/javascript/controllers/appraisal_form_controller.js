import { scrollToElement } from '../helpers';

export default class extends ApplicationController {
  static values = {
    success: String,
  };

  connect() {}

  success(event) {
    return this.handleSuccess(event);
  }

  error(event) {
    return this.handleError(event);
  }

  handleSuccess = ({ target }) => {
    const panel = target.closest('.panel-body');

    this.resetErrors(panel);

    const message = this.hasSuccessValue ? this.successValue : 'Success!';
    const [alert, identifier] = this.createAlert('success', message);

    panel.insertAdjacentHTML('afterbegin', alert);

    const template = this.element.querySelector('[data-role=template]');

    if ('content' in template) {
      const replacement = template.content.cloneNode(true);
      target.replaceWith(replacement.firstChild);
    } else {
      target.remove();
    }
  };

  handleError = (event) => {
    const {
      target,
      detail: { responseJSON: errors },
    } = event;
    const panel = target.closest('.panel-body');
    let form;

    this.resetErrors(panel);

    Object.entries(errors).forEach(([key, values]) => {
      const field = panel.querySelector(`[name*='[${key}]']`);
      if (!form) {
        form = field.closest('form');
      }
      const container = field.closest('.form-container');

      if (field && this.shouldValidateField(field)) {
        this.showFieldErrors(field, values);
      }

      if (key && key.endsWith('_rate')) {
        const button = container.querySelector('label button');
        if (button) button.classList.add('rag-error');
      } else {
        if (!this.visible(field)) {
          const target = container.querySelector('.form-edit-link');
          if (target) $(target).trigger('click');
        }
      }
    });

    const firstInvalidField = Array.from(form.elements).find((field) => field.ariaInvalid == 'true');

    if (this.visible(firstInvalidField)) {
      scrollToElement(firstInvalidField);
      firstInvalidField.focus();
    } else {
      const altTarget = firstInvalidField.closest('.form-container').querySelector('label button');
      if (altTarget) {
        scrollToElement(altTarget);
        altTarget.focus();
      }
    }
  };

  stash = (event) => {
    event.preventDefault();
    event.stopPropagation();

    const { target: button } = event;
    const wrapper = button.closest('.form-group');
    const form = wrapper.closest('form');
    const textarea = Array.from(wrapper.querySelectorAll('textarea')).filter(this.visible);

    if (textarea.length > 1) {
      for (let idx = 0; idx < textarea.length; idx++) {
        LS.removeItem(textarea[idx].dataset.autosaveKey);
      }
    } else {
      LS.removeItem(textarea[0].dataset.autosaveKey);
    }

    wrapper.classList.remove('form-edit');

    if (Array.from(wrapper.querySelectorAll('.form-value p[data-for]')).length > 0) {
      Array.from(wrapper.querySelectorAll('.form-value p[data-for]')).forEach((el) => {
        let identifier = el.dataset.for;
        let element = document.querySelector(`#${identifier}`);

        if (element) el.innerHTML = element.value;
      });

      return $(form).submit();
    } else if (textarea.length === 1) {
      let _textarea = textarea[0];

      if (_textarea.value.length) {
        const panel = event.target.closest('.panel-body');
        const value = _textarea.value.replace(/\n/g, '<br />');
        const updatedValue = button.dataset.updatedSection;

        wrapper.querySelector('.form-value p').innerHTML = value;

        panel.querySelector('.field-with-errors')?.classList?.remove('field-with-errors');
        panel.querySelector('.feedback-holder')?.classList?.remove('error');
        panel.querySelector('.btn-rag > button')?.classList?.remove('rag-error');

        Array.from(wrapper.querySelectorAll('textarea')).forEach((el) => {
          if (el.value && el.value.length) {
            return el.closest('.input')?.classList?.remove('field-with-errors');
          }
        });

        if (updatedValue) {
          const input = form.querySelector("input[name='updated_section']");

          if (input) {
            input.value = updatedValue;
          }
        }

        return $(form).submit();
      }
    } else {
      if (textarea[0] && textarea[0].value.length) {
        const value = textarea[0].value.replace(/\n/g, '<br />');
        Array.from(wrapper.querySelectorAll('.form-value p'))[0].innerHTML = value;
      }

      if (textarea[-1] && textarea[-1].value.length) {
        const value = textarea[-1].value.replace(/\n/g, '<br />');
        Array.from(wrapper.querySelectorAll('.form-value p'))[-1].innerHTML = value;
      }

      return $(form).submit();
    }
  };

  resetErrors(element) {
    element.querySelectorAll('.field-with-errors').forEach((el) => el.classList.remove('field-with-errors'));
    element.querySelectorAll('.rag-error').forEach((el) => el.classList.remove('rag-error'));
    element.querySelectorAll('[aria-errormessage]').forEach((el) => el.removeAttribute('aria-errormessage'));
    element.querySelectorAll('[aria-invalid]').forEach((el) => el.removeAttribute('aria-invalid'));
    element.querySelectorAll('.alert').forEach((el) => el.remove());
  }

  shouldValidateField(field) {
    return !field.disabled && field.type !== void 0 && !['file', 'reset', 'submit', 'button'].includes(field.type);
  }

  showFieldErrors(field, errors, selector) {
    if (selector == null) {
      selector = '.form-container';
    }

    const container = field.closest(selector);
    const group = field.closest('.govuk-form-group');

    if (group) {
      group.classList.add('field-with-errors');
    }

    if (container) {
      return errors.forEach((message) => {
        const [alert, identifier] = this.createAlert('danger', message);
        field.setAttribute('aria-errormessage', identifier);
        field.setAttribute('aria-invalid', true);
        return container.insertAdjacentHTML('afterbegin', alert);
      });
    }
  }

  createAlert = (type, message) => {
    const id = 'alert__' + String(Math.random()).slice(2, -1);
    const element = `
      <div id='${id}' class='alert alert-${type}' data-controller='element-removal' role='alert' style='padding-top: 6px; padding-bottom: 6px; margin-bottom: 8px;'>
        ${message}
        <button type='button' class='close' data-action='click->element-removal#remove' aria-label='Close'>
          <span aria-hidden='true'>&times;</span>
        </button>
      </div>
    `;

    return [element, id];
  };

  visible(field) {
    return (
      !field.hidden && (!field.type || field.type != 'hidden') && (field.offsetWidth > 0 || field.offsetHeight > 0)
    );
  }
}
