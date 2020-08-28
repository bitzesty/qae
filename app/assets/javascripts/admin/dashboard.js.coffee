jQuery ->
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

    $("tbody", wrapper).load href, ->
      link.removeClass("hidden")
      $(".updating-data", wrapper).addClass("hidden")
