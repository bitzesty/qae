jQuery ->
  if !Cookies.get("gaconsent") && !Cookies.get("gaoptout")
    $(".govuk-cookie-banner").attr("tabindex", "-1")
    $(".govuk-cookie-banner").attr("aria-live", "polite")
    $(".govuk-cookie-banner").removeAttr("hidden")
    $(".govuk-cookie-banner").attr("role", "alert")

    $(".govuk-cookie-banner .cookies-action").on "click", (e) ->
      e.preventDefault()

      Cookies.set("gaconsent", $(@).val(), { expires: 3650 })
      $(".govuk-cookie-banner .initial-message").attr("hidden", "true")

      if $(@).val() == "accept"
        $(".govuk-cookie-banner .accept-message").removeAttr("hidden")
      else
        $(".govuk-cookie-banner .reject-message").removeAttr("hidden")

    $(".govuk-cookie-banner .hide-message").on "click", (e) ->
      e.preventDefault()
      $(".govuk-cookie-banner").attr("hidden", "true")

  if $("#ga-optout-input").length

    document.querySelector('.cookie-consent-form').addEventListener 'submit', (e) ->
      e.preventDefault()
      e.stopPropagation()

    $("#ga-optout-input").prop("checked", Cookies.get("gaconsent") == "reject" || !Cookies.get("gaconsent"))
    $("#ga-optin-input").prop("checked", Cookies.get("gaconsent") == "accept")
    $("#ga-optout").on "click", (e) ->
      e.preventDefault()

      if $("#ga-optout-input").prop("checked")
        Cookies.set("gaconsent", "reject", { expires: 3650 })
      else if $("#ga-optin-input").prop("checked")
        Cookies.set("gaconsent", "accept", { expires: 3650 })

      $(".cookie-settings-banner").removeClass("hide").focus()
