export default class extends ApplicationController {
  static targets = ['element'];

  connect() {
    this.elementTargets[0].focus();
  }
}
