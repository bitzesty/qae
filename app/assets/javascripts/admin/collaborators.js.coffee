ready = ->
  $(document).on "click", ".btn-add-collaborator", (e) ->
    e.preventDefault()
    $(this).closest(".form-collaborator").addClass("show-form")

  $(document).on "click", ".form-collaborator .btn-cancel", (e) ->
    e.preventDefault()
    $(this).closest(".form-collaborator").removeClass("show-form")

$(document).ready(ready)