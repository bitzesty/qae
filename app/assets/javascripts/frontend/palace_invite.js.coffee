jQuery ->
  if $(".js-has-royal-connections").length > 0
    toggleRoyalConnections = ->
      if $(".js-has-royal-connections:checked").val() == "true"
        $(".js-royal-connection-details").closest(".govuk-form-group").show()
      else
        $(".js-royal-connection-details").closest(".govuk-form-group").hide()

    toggleRoyalConnections()

    $(".js-has-royal-connections").on "change", (e) ->
      toggleRoyalConnections()
