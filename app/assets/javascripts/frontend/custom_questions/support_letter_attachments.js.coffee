window.SupportLetterAttachments =
  init: ->
    $('.js-support-letter-attachment-upload').each (idx, el) ->
      SupportLetterAttachments.fileupload_init(el)
    SupportLetterAttachments.save_collecation_init()

  new_item_init: (el) ->
    SupportLetterAttachments.clean_up_system_tags(el)
    SupportLetterAttachments.fileupload_init(el.find(".js-support-letter-attachment-upload"))

  fileupload_init: (el) ->
    $el = $(el)
    parent = $el.closest("label")

    upload_done = (e, data, link) ->
      SupportLetterAttachments.clean_up_system_tags(parent)

      filename = data.result['original_filename']
      file_title = $("<span class='support_letter_attachment_filename'>" + filename + "</span>")
      hidden_input = $("<input class='js-support-letter-attachment-id'>").prop('type', 'hidden').
                                                                          prop('name', $el.attr("name")).
                                                                          prop('value', data.result['id'])

      parent.append(file_title)
      parent.append(hidden_input)

    failed = (e, data) ->
      SupportLetterAttachments.clean_up_system_tags(parent)
      error_message = data.jqXHR.responseText
      error_tag = $("<span class='upload_error_message'>" + error_message + "</span>")
      parent.append(error_tag)

    $el.fileupload(
      url: $el.closest(".list-add").data 'attachments-url'
      formData: () -> {}
      done: upload_done
      fail: failed
    )

  clean_up_system_tags: (parent) ->
    parent.find("input[type='hidden']").remove()
    parent.find(".support_letter_attachment_filename").remove()
    parent.find(".upload_error_message").remove()

  save_collecation_init: ->
    $(document).on 'click', '.js-save-collection', ->
      parent = $(this).closest("li")
      save_url = parent.data 'save-collection-url'

      first_name = parent.find(".js-support-letter-first-name").val()
      last_name = parent.find(".js-support-letter-last-name").val()
      relationship_to_nominee = parent.find(".js-support-letter-relationship-to-nominee").val()
      attachment_id = parent.find(".js-support-letter-attachment-id").val()

      data = {
        "support_letter": {
          "first_name": first_name,
          "last_name": last_name,
          "relationship_to_nominee": relationship_to_nominee,
          "attachment": attachment_id
        }
      }
      console.log("[SAVE_URL]: " + save_url)
      console.dir(data)

      $.ajax
        url: save_url
        type: 'post'
        data: data
        dataType: 'json'
        success: (response) ->
          console.log("[SUCCESS RESPONSE]: " + response)
          return
        error: (response) ->
          console.log('[FAILED]: ' + response.responseText)
          error_message = response.responseText
          return
