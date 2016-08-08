class Offline
  constructor: ->
    @offlineUi = $(".offline-ui")

  start: =>
    window.addEventListener('offline', @updateOnlineStatus)
    window.addEventListener('online', @updateOnlineStatus)

  updateOnlineStatus: =>
    if navigator.onLine
      @offlineUi.hide()
    else
      @offlineUi.show()

window.Offline = Offline
