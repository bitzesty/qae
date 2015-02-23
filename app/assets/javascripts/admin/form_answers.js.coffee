ready = ->
  $('#new_form_answer_attachment').fileupload
    success: (result, textStatus, jqXHR)->
      $('.document-list .p-empty').remove()
      $('.document-list ul').append(result)

  iframeHolder = $('.iframeholder')
  iframe = $('<iframe>')
  iframe.attr('src', iframeHolder.data('src'))
  iframe.attr('style', iframeHolder.data('style'))
  iframeHolder.append(iframe)
$(document).ready(ready)
