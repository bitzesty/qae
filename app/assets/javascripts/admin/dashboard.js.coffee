jQuery ->
  $(".dashboard-report .update-report").on "click", (e) ->
    e.preventDefault()
    link = $(e.currentTarget)
    href = link.attr("href")
    console.log(link.closest(".dashboard-report"))
    $("tbody", link.closest(".dashboard-report")).load(href)
