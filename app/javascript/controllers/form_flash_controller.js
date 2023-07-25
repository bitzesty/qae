export default class extends ApplicationController {
  static values = {
    error: String,
    success: String,
  };

  connect() {
    this.element.addEventListener('ajax:x:success', this.onSuccess);
    this.element.addEventListener('ajax:x:error', this.onError);
  }

  disconnect() {
    this.element.removeEventListener('ajax:x:success', this.onSuccess);
    this.element.removeEventListener('ajax:x:error', this.onError);
  }

  success(event) {
    return this.onSuccess(event);
  }

  error(event) {
    return this.onError(event);
  }

  onSuccess = (event) => {
    const msg = this.hasSuccessValue ? this.successValue : 'Success!';
    const [alert, identifier] = this.createAlert('success', msg);

    setTimeout(() => this.showAlert(alert, identifier), 50);
  };

  onError = (event) => {
    const msg = this.hasErrorValue ? this.errorValue : 'An unknown error has occurred, please try again.';
    const [alert, identifier] = this.createAlert('danger', msg);

    setTimeout(() => this.showAlert(alert, identifier), 50);
  };

  createAlert = (type, message) => {
    const id = 'alert__' + String(Math.random()).slice(2, -1);
    const element = `
      <div id='${id}' class='alert alert-${type}' data-controller='element-removal' role='alert' style='padding-top: 6px; padding-bottom: 6px; margin-bottom: 8px;'>
        ${message}
        <button type='button' class='close' data-action='click->element-removal#remove' aria-label='Close' style='font-size: 18px;'>
          <span aria-hidden='true'>&times;</span>
        </button>
      </div>
    `;

    return [element, id];
  };

  showAlert = (alert, identifier) => {
    const form = document.getElementById(this.element.id);
    const container = form.parentNode;
    const element =
      container && (container.classList.contains('form-container') || container.classList.contains('form-group'))
        ? container
        : form;
    element.insertAdjacentHTML('afterbegin', alert);
    console.log('element', element);
    setTimeout(() => {
      const inserted = document.getElementById(identifier);
      if (inserted) inserted.remove();
    }, 4000);
  };
}
