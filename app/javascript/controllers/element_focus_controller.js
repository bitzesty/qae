export default class extends ApplicationController {
  static targets = ['reveal', 'dismiss'];
  static values = {
    selector: String
  }

  connect() {    
    if (this.hasRevealTarget) {
      this.revealTarget.addEventListener('click', () => setTimeout(() => this.focusFirstElement(), 1))
    }

    if (this.hasDismissTarget) {
      this.dismissTarget.addEventListener('click', () => setTimeout(() => this.focusElement(), 1))
    }
  }

  focusElement(_event) {
    if (this.hasRevealTarget && this.focusable(this.revealTarget)) {
      this.revealTarget.focus()
    }
  }

  focusFirstElement(_event) {
    const element = this.focusableElements[0]

    if (element) {
      element.focus()
    }
  }

  // Private

  visible(el) {
    return !el.hidden && (!el.type || el.type != 'hidden') && (el.offsetWidth > 0 || el.offsetHeight > 0)
  }

  focusable(el) {
    return el.tabIndex >= 0 && !el.disabled && this.visible(el)
  }

  get focusableElements() {
    return Array.from(this.element.querySelectorAll(this.selectors)).filter((el) => this.focusable(el)) || []
  }

  get selectors() {
    return this.hasSelectorValue ? 
      this.selectorValue : 
      'input:not([disabled]), select:not([disabled]), textarea:not([disabled])'
  }
}
