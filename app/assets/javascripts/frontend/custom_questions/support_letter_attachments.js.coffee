window.SupportLetterAttachments = init: ->
  $('.js-support-letter-attachment-upload').each (idx, el) ->
    $el = $(el)
    parent = $el.closest("label")

    upload_done = (e, data, link) ->
      clean_up_system_tags(parent)

      filename = data.result['original_filename']
      file_title = $("<span class='support_letter_attachment_filename'>" + filename + "</span>")
      hidden_input = $("<input>").prop('type', 'hidden').
                                  prop('name', $el.attr("name")).
                                  prop('value', data.result['id'])

      parent.append(file_title)
      parent.append(hidden_input)

    failed = (e, data) ->
      clean_up_system_tags(parent)
      error_message = data.jqXHR.responseText
      error_tag = $("<span class='upload_error_message'>" + error_message + "</span>")
      parent.append(error_tag)

    clean_up_system_tags = (parent) ->
      parent.find("input[type='hidden']").remove()
      parent.find(".support_letter_attachment_filename").remove()
      parent.find(".upload_error_message").remove()

    $el.fileupload(
      url: $el.closest("li").data 'attachments-url'
      formData: () -> {}
      done: upload_done
      fail: failed
    )
