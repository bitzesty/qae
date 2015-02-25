ready = ->
  fadeAlert()

  updateCollapseHeaderClass()

  $(document).on "click", ".panel-title > a", (e) ->
    e.preventDefault()
    _this = $(this)

    setTimeout(updateCollapseHeaderClass, 400)

updateCollapseHeaderClass = ->
  $(".panel-title > a").each ->
    panel = $($(this).attr("href"))

    if panel.hasClass("in")
      $(this).closest(".panel-heading").addClass("expanded")
    else
      $(this).closest(".panel-heading").removeClass("expanded")

fadeAlert = ->
  alert_time = 5000
  alert_container = ".alert-container"

  # Fade on click
  $(document).on "click", alert_container, ->
    $(alert_container).fadeOut "fast"

  # Timer based
  timerFadeAlert = setTimeout( ->
    $(alert_container).fadeOut "fast"
  , alert_time)

  # Hover cancels timer
  $(alert_container).hover ->
    window.clearTimeout(timerFadeAlert)
  , ->
    timerFadeAlert = setTimeout( ->
      $(alert_container).fadeOut "fast"
    , alert_time)

$(document).ready(ready)
