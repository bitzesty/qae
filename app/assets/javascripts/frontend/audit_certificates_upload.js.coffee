window.AuditCertificatesUpload =
  init: ->
    $('.js-audit-certificate-file-upload').each (idx, el) ->
      AuditCertificatesUpload.fileupload_init(el)
    AuditCertificatesUpload.remove_attachment_init()

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
      file_url = data.result["attachment"]["url"]
      list.removeClass("hidden")
      list.find(".js-audit-certificate-title").attr("href", file_url)

      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.find(".li-audit-upload").removeClass("hidden")

    failed = (e, data) ->
      error_message = data.jqXHR.responseText
      parent.find(".errors-container").html("<li>" + error_message + "</li>")
      list.addClass("hidden")
      form.removeClass("hidden")
      # Remove `Uploading...`
      list.find(".js-uploading").remove()
      list.removeClass("hidden")

    $el.fileupload(
      url: form.attr("action") + ".json"
      forceIframeTransport: true
      dataType: 'json'
      formData: [
        { name: "authenticity_token", value: $("meta[name='csrf-token']").attr("content") }
      ]
      done: upload_done
      progressall: progress_all
      send: upload_started
      fail: failed
    )

  remove_attachment_init: ->
    $(document).on "click", ".js-upload-wrapper .js-remove-audit-certificate-link", (e) ->
      e.preventDefault()

      parent = $(this).closest('.js-upload-wrapper')
      list = parent.find('.js-uploaded-list')
      form = parent.find('form')

      parent.find(".errors-container").html("")
      list.addClass("hidden")
      form.removeClass("hidden")

      false
