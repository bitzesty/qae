window.clearFormElements = (obj) ->
  obj.find(':input').each ->
    switch @type
      when 'password', 'text', 'textarea', 'file', 'select-one', 'select-multiple', 'tel', 'number'
        $(this).val ''
      when 'checkbox', 'radio'
        @checked = false
    return

  obj.find("span.error").text("") # clear errors

  return
