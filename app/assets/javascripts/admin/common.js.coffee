ready = ->
  updateCollapseHeaderClass()

  $(document).on "click", ".panel-title > a", (e) ->
    e.preventDefault()
    _this = $(this)

    setTimeout(updateCollapseHeaderClass, 400)

updateCollapseHeaderClass = () ->
  $(".panel-title > a").each () ->
    panel = $($(this).attr("href"))

    if panel.hasClass("in")
      $(this).closest(".panel-heading").addClass("expanded")
    else
      $(this).closest(".panel-heading").removeClass("expanded")

$(document).ready(ready)
