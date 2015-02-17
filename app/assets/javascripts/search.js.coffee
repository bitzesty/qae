class SearchForm
  constructor: (@form) ->

  init: ->
    do @bindSelectFilters

  bindSelectFilters: ->
    ($ '.filter select', @form).on 'change', ->
      do @form.submit

jQuery ($) ->
  if ($ '.search-form').length
   searchForm = new SearchForm($ '.search-form')
   searchForm.init()
