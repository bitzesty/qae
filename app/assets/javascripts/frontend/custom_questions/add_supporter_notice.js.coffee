window.addSupporterNotice = init: ->
  $(document).on "click", ".js-button-support", (e)->
    e.preventDefault()
    $(this).closest("li").addClass("read-only")
    $(this).closest("li").find("input").attr("disabled", "disabled")
    $(this).remove()
