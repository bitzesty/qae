window.WonInternationalTradeAwardQuestion = init: ->
  identifier = "applied_for_queen_awards_details"

  do maybeDisplayAwardHelp = ->
    container = $("[data-container~=#{identifier}]")

    conditionFulfilled = false

    rows = container.find("li")

    $.each rows, (_idx, row) ->
      validations = $.map ["category", "year", "outcome"], (type) ->
        input = $(row).find("select[data-input-value~=#{type}]")
        input.val() == container.data("#{type}-value").toString()
      if (validations.every(Boolean))
        conditionFulfilled = true
        return false

    helpBlock = $("#help-block")

    if helpBlock
      if conditionFulfilled
        helpBlock.show()
      else
        helpBlock.hide()

  $(document).on "change", "[data-container~=#{identifier}] select", ->
    maybeDisplayAwardHelp()

  $(document).on "click", "[data-container~=#{identifier}] a.js-remove-link", ->
    maybeDisplayAwardHelp()
    window.OptionsWithPreselectedConditionsQuestion.init()
