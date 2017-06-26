class Offline
  constructor: ->
    @offlineUi = $(".offline-ui")

  start: =>
    if window.addEventListener
      window.addEventListener('offline', @updateOnlineStatus)
      window.addEventListener('online', @updateOnlineStatus)
    else
      window.attachEvent('onoffline', @updateOnlineStatus)
      window.attachEvent('ononline', @updateOnlineStatus)

  updateOnlineStatus: =>
    if navigator.onLine
      @offlineUi.hide()
    else
      @offlineUi.show()

window.Offline = Offline
