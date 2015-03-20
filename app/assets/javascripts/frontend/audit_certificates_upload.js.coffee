window.AuditCertificatesUpload =
  init: ->
    $('.js-audit-certificate-file-upload').each (idx, el) ->
      AuditCertificatesUpload.fileupload_init(el)
    AuditCertificatesUpload.remove_attachment_init()

  fileupload_init: (el) ->
    form = $(el).closest('form')
    $el = $(el)

    wrapper = $el.closest('div.js-upload-wrapper')
    button = wrapper.find('.button-add')
    list = wrapper.find('.js-uploaded-list')

    progress_all = (e, data) ->
      # TODO

    upload_started = (e, data) ->
      button.addClass('visuallyhidden') #TODO: show progressbar

    upload_done = (e, data, link) ->
      list.removeClass('visuallyhidden')

    $el.fileupload(
      formData: () -> {}
      done: upload_done
      progressall: progress_all
      send: upload_started
    )

  remove_attachment_init: ->
    $(document).on "click", ".js-upload-wrapper .js-remove-audit-certificate-link", (e) ->
      e.preventDefault()

      $(this).closest('.js-uploaded-list').addClass('visuallyhidden')
      false
