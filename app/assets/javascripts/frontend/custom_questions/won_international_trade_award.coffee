window.WonInternationalTradeAwardQuestion = init: ->
  identifier = "applied_for_queen_awards_details"

  do maybeDisplayAwardHelp = ->
    container = $("[data-container~=#{identifier}]")

    displayHelp = false

    rows = container.find("[data-container~=#{identifier}--row]")

    $.each rows, (_idx, row) ->
      validations = $.map ["category", "year", "outcome"], (type) ->
        input = $(row).find("select[data-input-value~=#{type}]")
        input.val() == container.data("#{type}-value").toString()
      if (validations.every(Boolean))
        displayHelp = true
        return false

    helpBlock = container.closest("fieldset").find(".question-block")

    if helpBlock
      if displayHelp
        helpBlock.show()
      else
        helpBlock.hide()

  $(document).on "change", "[data-container~=#{identifier}] select", ->
    maybeDisplayAwardHelp()
