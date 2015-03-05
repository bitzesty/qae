jQuery ->
  if ($ "#financial-summary form").length
    form = ($ "#financial-summary form")
    timer = null

    ($ "input", form).on "change keyup keydown paste", ->
      timer ||= setTimeout(saveFinancials, 500 )

    saveFinancials = ->
      timer = null
      url = form.attr('action')
      form_data = form.serialize()

      $.ajax({
        url: url
        data: form_data
        type: 'POST'
        dataType: 'js'
      })
