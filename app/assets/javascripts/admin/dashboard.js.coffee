jQuery ->
  $(document).on "click", ".updating-data", (e) ->
    e.preventDefault()
    e.stopPropagation()

  $(".dashboard-report .update-report").on "click", (e) ->
    e.preventDefault()
    link = $(e.currentTarget)
    href = link.attr("href")
    wrapper = link.closest(".dashboard-report")
    link.addClass("hidden")
    link.html("Update data")
    link.removeClass("btn--load")
    link.addClass("btn--reload")
    $(".updating-data", wrapper).removeClass("hidden")
    $(".updating-data", wrapper).prop "disabled", true

    $("tbody", wrapper).load href, ->
      link.removeClass("hidden")
      $(".updating-data", wrapper).addClass("hidden")
      # $(".dashboard-report .sr-only").empty()
      srWrapper = wrapper.closest(".dashboard-report .sr-only")
      srWrapper.text("Data updated")
