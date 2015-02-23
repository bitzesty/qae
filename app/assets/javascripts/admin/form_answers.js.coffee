ready = ->
  $('#new_form_answer_attachment').fileupload
    success: (result, textStatus, jqXHR)->
      $('.document-list .p-empty').remove()
      $('.document-list ul').append(result)

  iframeHolder = $('.iframeholder')
  iframe = $('<iframe>')
  iframe.attr('src', iframeHolder.data('src'))
  iframeHolder.append(iframe)

  $(document).on "click", ".js-expand-iframe", (e) ->
    e.preventDefault()
    iframeHolder.toggleClass("iframe-expanded")

  $(document).on "click", ".js-switch-admin-view", (e) ->
    e.preventDefault()
    $(".applicant-view").toggleClass("hidden")
    $(".submitted-view").toggleClass("hidden")

  $(document).on "click", ".form-edit-link", (e) ->
    e.preventDefault()
    $(this).closest(".form-group").addClass("form-edit")

$(document).ready(ready)
