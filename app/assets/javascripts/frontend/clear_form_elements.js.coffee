window.clearFormElements = (obj) ->
  obj.find(':input').each ->
    switch @type
      when 'password', 'text', 'textarea', 'file', 'select-one', 'select-multiple'
        $(this).val ''
      when 'checkbox', 'radio'
        @checked = false
    return
  return