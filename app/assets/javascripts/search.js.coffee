class SearchForm
  constructor: (@form) ->

  init: ->
    do @bindSelectFilters
    do @bindSortLinks

  bindSelectFilters: ->
    ($ '.filter input:checkbox', @form).on 'change', ->
      setTimeout(() =>
        do @form.submit
      , 70)

  bindSortLinks: ->
    ($ '.sortable a', @form).on 'click', (event) =>
      do event.preventDefault
      ($ 'input', ($ event.currentTarget).closest('.sortable')).prop('disabled', false)

      do @form.submit

jQuery ($) ->
  if ($ '.search-form').length
   searchForm = new SearchForm($ '.search-form')
   do searchForm.init
