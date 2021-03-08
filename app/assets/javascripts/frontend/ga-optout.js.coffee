jQuery ->
  if !Cookies.get("gaconsent") && !Cookies.get("gaoptout")
    $(".govuk-cookie-banner").attr("aria-hidden", "false")

    $(".govuk-cookie-banner .button").click (e) ->
      e.preventDefault()

      Cookies.set("gaconsent", $(@).val(), { expires: 3650 })
      $(".govuk-cookie-banner").attr("aria-hidden", "true")

  if $("#ga-optout-input").length
    $("#ga-optout-input").prop("checked", Cookies.get("gaconsent") == "reject" || Cookies.get("gaoptout"))
    $("#ga-optout").on "click", (e) ->
      e.preventDefault()

      if $("#ga-optout-input").prop("checked")
        Cookies.set("gaconsent", "reject", { expires: 3650 })
      else
        Cookies.set("gaconsent", "accept", { expires: 3650 })
