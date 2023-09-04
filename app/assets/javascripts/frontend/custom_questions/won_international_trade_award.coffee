window.WonInternationalTradeAwardQuestion = init: ->
  identifier = "applied_for_queen_awards_details"

  do maybeDisplayAwardHelp = ->
    container = $("[data-container~=#{identifier}]")

    currentHolder = false
    recentWinner = false

    rows = container.find("li")

    $.each rows, (_idx, row) ->
      validations = $.map ["category", "outcome"], (type) ->
        input = $(row).find("select[data-input-value~=#{type}]")
        input.val() == container.data("#{type}-value").toString()
      if (validations.every(Boolean))
        yearInput = $(row).find("select[data-input-value~=year]")
        if yearInput.val() == container.data("year-value").toString()
          currentHolder = true
          return false
        else if yearInput.val() < container.data("year-value").toString() && yearInput.val() > (container.data("year-value")-5).toString()
          recentWinner = true
          return false

    currentHolderHelpBlock = $(".help-block #current-holder")
    recentWinnerHelpBlock = $(".help-block #recent-winner")

    if currentHolder
      currentHolderHelpBlock.removeClass("hide")
      recentWinnerHelpBlock.addClass("hide")
    else if recentWinner
      recentWinnerHelpBlock.removeClass("hide")
      currentHolderHelpBlock.addClass("hide")
    else
      currentHolderHelpBlock.addClass("hide")
      recentWinnerHelpBlock.addClass("hide")

  $(document).on "change", "[data-container~=#{identifier}] select", ->
    maybeDisplayAwardHelp()

  $(document).on "click", "[data-container~=#{identifier}] a.js-remove-link", ->
    maybeDisplayAwardHelp()
    window.OptionsWithPreselectedConditionsQuestion.init()
