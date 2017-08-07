window.TextareaCkeditorIeCallback =

  init: ->
    ms_ie = false
    ua = window.navigator.userAgent
    old_ie = ua.indexOf('MSIE ')
    new_ie = ua.indexOf('Trident/')

    if (old_ie > -1) || (new_ie > -1)
      ms_ie = true;

    if ms_ie
      waitCKEDITOR = setInterval((->
        if window.CKEDITOR
          $(".js-ckeditor-spinner-block").addClass('hidden')
          clearInterval waitCKEDITOR
        return
      ), 6000)

