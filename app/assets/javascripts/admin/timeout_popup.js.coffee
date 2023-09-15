$(window).load ->
  prefix = '/' + window.namespace
  hasDisplayedWarning = false

  $(document).on 'click', '.extend-session', (e) ->
    e.preventDefault()
    $('.js-session-timeout-warning-popup').modal 'hide'
    $.post prefix + '/session_checks/extend.json?__t=' + window.lastRequestAt, ->
      $('.js-session-timeout-warning-popup').modal 'hide'
      hasDisplayedWarning = false

  if window.timeoutTime and window.timeoutTime > 0
    checkInterval = setInterval((->
      $.ajax
        url: prefix + '/session_checks.json'
        type: 'GET'
        success: (data) ->
          remaining = Math.round(window.timeoutTime / 60000 - (data.elapsed))
          if remaining == 1
            $('.js-session-timeout-warning-popup .time-target').html ' ' + remaining + ' minute'
          else
            $('.js-session-timeout-warning-popup .time-target').html ' ' + remaining + ' minutes'
          if remaining < 5 and !hasDisplayedWarning
            hasDisplayedWarning = true
            $('.js-session-timeout-warning-popup').modal
              backdrop: 'static'
              keyboard: true
        complete: (response) ->
          if response.status == 401
            clearInterval checkInterval
            $('.js-session-timeout-warning-popup').modal 'hide'
            $('.js-session-timeout-popup').modal
              backdrop: 'static'
              keyboard: false
        dataType: 'json'
    ), 10 * 1000)
