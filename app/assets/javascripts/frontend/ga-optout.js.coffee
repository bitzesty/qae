jQuery ->
  if $("#ga-optout-input").length
    $("#ga-optout-input").prop("checked", Cookies.get("gaoptout") == "true")
    $("#ga-optout").on "click", (e) ->
      e.preventDefault()

      if $("#ga-optout-input").prop("checked")
        Cookies.set("gaoptout", "true", { expires: 3650 })
      else
        Cookies.remove("gaoptout")
