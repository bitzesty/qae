FOCUSABLE_ELEMENTS = 'input:not([disabled]), select:not([disabled]), textarea:not([disabled]), button:not([disabled]), [href], [tabindex]:not([tabindex="-1"]):not([disabled]), details:not([disabled]), summary:not(:disabled)'
FOCUSABLE_FORM_ELEMENTS = 'input:not([disabled]), select:not([disabled]), textarea:not([disabled])'

window.FOCUSABLE_ELEMENTS = FOCUSABLE_ELEMENTS
window.FOCUSABLE_FORM_ELEMENTS = FOCUSABLE_FORM_ELEMENTS

visible = (el) ->
  !el.hidden and (!el.type or el.type != 'hidden') and (el.offsetWidth > 0 or el.offsetHeight > 0)

focusable = (el) ->
  el.tabIndex >= 0 and !el.disabled and visible(el)

window.focusElement = (el, elements = FOCUSABLE_ELEMENTS) ->
  autofocusElement = Array.from(el.querySelectorAll(elements)).filter(focusable)[0]
  if autofocusElement
    autofocusElement.focus()
  return

window.autofocusElement = (el) ->
  autofocusElement = Array.from(el.querySelectorAll('[autofocus]')).filter(focusable)[0]
  if !autofocusElement
    autofocusElement = el
    el.setAttribute('tabindex', '-1')
  autofocusElement.focus()
  return