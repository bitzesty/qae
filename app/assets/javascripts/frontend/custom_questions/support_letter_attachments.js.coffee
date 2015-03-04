window.SupportLetterAttachments = init: ->
  $('.js-support-letter-attachment-upload').each (idx, el) ->
    $el = $(el)
    parent = $el.closest("label")

    upload_done = (e, data, link) ->
      filename = data.result['original_filename']
      file_title = $("<span class='support_letter_attachment_filename'>" + filename + "</span>")
      hidden_input = $("<input>").prop('type', 'hidden').
                                  prop('name', $el.attr("name")).
                                  prop('value', data.result['id'])

      parent.find("input[type='hidden']").remove()
      parent.find(".support_letter_attachment_filename").remove()

      parent.append(file_title)
      parent.append(hidden_input)

    $el.fileupload(
      url: $el.closest("li").data 'attachments-url'
      formData: () -> {}
      done: upload_done
    )
