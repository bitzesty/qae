export default class extends ApplicationController {
  static targets = ['form', 'link'];

  static values = {
    error: String,
    success: String,
  };

  connect() {
    this.formTargets.forEach((el) => {
      el.addEventListener('ajax:x:success', this.onSuccess);
      el.addEventListener('ajax:x:error', this.onError);
    });
  }

  disconnect() {
    this.formTargets.forEach((el) => {
      el.removeEventListener('ajax:x:success', this.onSuccess);
      el.removeEventListener('ajax:x:error', this.onError);
    });
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

    setTimeout(() => this.showAlert(alert, identifier), 10);
  };

  onError = (event) => {
    const msg = this.hasErrorValue ? this.errorValue : 'An unknown error has occurred, please try again.';
    const [alert, identifier] = this.createAlert('danger', msg);

    setTimeout(() => this.showAlert(alert, identifier), 10);
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
    const existing = this.element.querySelector('[id*=alert__]');
    if (existing) existing.remove();

    this.element.insertAdjacentHTML('afterbegin', alert);

    setTimeout(() => {
      const inserted = document.getElementById(identifier);
      if (inserted) inserted.remove();
    }, 4000);
  };
}
