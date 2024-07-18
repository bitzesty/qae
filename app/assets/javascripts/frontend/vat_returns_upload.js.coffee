window.VatReturnsUpload =
  init: ->
    $('.js-vat-returns-upload').each (idx, el) ->
      VatReturnsUpload.fileupload_init(el)

      govuk_button = $(el).closest('.govuk-button')
      $(el).on "focus", ->
        govuk_button.addClass('upload-focus')

      $(el).on "blur", ->
        govuk_button.removeClass('upload-focus')

  fileupload_init: (el) ->
    $el = $(el)

    parent = $el.closest('div.js-upload-wrapper')
    max = parent.data('max-attachments')
    list = parent.find('.js-uploaded-list')
    form = parent.find('form.vat-returns-upload-form')
    govuk_button = $( ".upload-file-btn" )

    progress_all = (e, data) ->
      # TODO

    upload_started = (e, data) ->
      # Show `Uploading...`
      form.addClass("govuk-!-display-none")
      new_el = $("<li class='js-uploading'>")
      div = $("<div>")
      label = $("<label class='govuk-body'>").text("Uploading...")
      div.append(label)
      new_el.append(div)
      list.append(new_el)
      list.removeClass("govuk-!-display-none")
      list.find(".li-figures-upload").addClass("govuk-!-display-none")

    upload_done = (e, data, link) ->
      # Immediately show a link to download the uploaded file
      file_url = data.result["attachment"]["url"]
      filename = file_url.match(/[^\/?#]+(?=$|[?#])/)

      dummy_el = list.find("li.dummy").clone()
      dummy_el.find(".js-commercial-figures-file a.file-url").attr("href", file_url)
      dummy_el.find(".js-commercial-figures-file a.file-url").text(filename)
      dummy_el.find(".js-commercial-figures-file a.file-url").attr("download", filename)
      dummy_el.find(".js-commercial-figures-file a.file-url").attr("title", filename)
      dummy_el.removeClass("dummy")

      remove_link_el = dummy_el.find("a.remove-link")
      remove_link = remove_link_el.attr("href")
      remove_link = remove_link.replace("PLACEHOLDER", data.result["id"])
      remove_link_el.attr("href", remove_link)

      list.append(dummy_el)
      dummy_el.removeClass("govuk-!-display-none")
      list.removeClass("govuk-!-display-none")
      form.removeClass("govuk-!-display-none")


      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.find(".li-figures-upload").removeClass("govuk-!-display-none")
      $(".js-vat-returns-status-message").remove()

      updateUploadListVisiblity(list, govuk_button, max)

    failed = (error_message) ->
      parent.find(".govuk-error-message").html(error_message)
      list.addClass("govuk-!-display-none")
      form.removeClass("govuk-!-display-none")

      # Remove `Uploading...`
      list.find(".js-uploading").remove()

      # Remove file block
      list.find("li.file").addClass("govuk-!-display-none")
      list.removeClass("govuk-!-display-none")

    success_or_error = (e, data) ->
      errors = data.result.errors

      if errors
        failed(errors.toString())
      else
        upload_done(e, data)

    $el.fileupload(
      url: form.attr("action") + ".json"
      forceIframeTransport: true
      dataType: 'json'
      formData: [
        { name: "authenticity_token", value: $("meta[name='csrf-token']").attr("content") }
      ]
      progressall: progress_all
      send: upload_started
      always: success_or_error
    )

updateUploadListVisiblity = (list, button, max) ->
  list_elements = list.find("li").not('.dummy')
  count = list_elements.length
  wrapper = button.closest('div.js-upload-wrapper')

  if count > 0
    list.removeClass("hide")

  if !max || count < max
    button.removeClass("hide")

  else
    button.addClass("hide")
