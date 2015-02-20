ready = ->
  $('#new_form_answer_attachment').fileupload
    success: (result, textStatus, jqXHR)->
      $('.document-list').append(result)
$(document).ready(ready)