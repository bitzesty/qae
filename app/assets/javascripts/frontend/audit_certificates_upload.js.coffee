window.AuditCertificatesUpload =
  init: ->
    $('.js-audit-certificate-file-upload').each (idx, el) ->
      AuditCertificatesUpload.fileupload_init(el)

  fileupload_init: (el) ->
    form = $(el).closest('form')
    $el = $(el)

    parent = $el.closest('div.js-upload-wrapper')
    list = parent.find('.js-uploaded-list')
    form = parent.find('form')

    progress_all = (e, data) ->
      # TODO

    upload_started = (e, data) ->
      # Show `Uploading...`
      form.addClass("hidden")
      new_el = $("<li class='js-uploading'>")
      div = $("<div>")
      label = $("<label>").text("Uploading...")
      div.append(label)
      new_el.append(div)
      list.append(new_el)
      list.removeClass("hidden")
      list.find(".li-audit-upload").addClass("hidden")

    upload_done = (e, data, link) ->
      # Immediately show a link to download the uploaded file
      file_url = data.result["attachment"]["url"]
      filename = file_url.split('/').pop()
      list.find(".js-audit-certificate-title").attr("href", file_url)
      list.find(".js-audit-certificate-title").text(filename)
      list.find(".js-audit-certificate-title").attr("download", filename)
      list.find(".js-audit-certificate-title").attr("title", filename)
      list.removeClass("hidden")

      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.find(".li-audit-upload").removeClass("hidden")
      list.find(".js-remove-verification-document-form").removeClass("hidden")
      $(".js-audit-certificate-status-message").remove()

    failed = (error_message) ->
      parent.find(".errors-container").html("<li>" + error_message + "</li>")
      list.addClass("hidden")
      form.removeClass("hidden")

      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.removeClass("hidden")

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
