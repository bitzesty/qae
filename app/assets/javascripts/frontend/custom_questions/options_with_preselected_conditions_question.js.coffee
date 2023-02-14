$.fn.reverse = [].reverse;

window.OptionsWithPreselectedConditionsQuestion = init: ->
  do changeTradeQuestion = ->
    dependable_children_div_block = $(".js-options-with-parent-dependency[data-depends-on='queen_award_holder_details']")
    dependable_controls = dependable_children_div_block.find(".selectable")

    if $(".queen-award-holder input:checked").val() != "yes"
      # Show the default content
      dependable_children_div_block.find("h2 [data-preselected-condition]").addClass "display-none"
      dependable_children_div_block.find("h2 [data-preselected-condition='default']").removeClass "display-none"
      dependable_controls.removeClass "display-none"
    else
      setTimeout (->
        $(".js-options-with-dependent-child-select").trigger("change")
        return
      ), 10

    # otherwise it's always true on page load
    # when user triggers this method manually
    # this var will be set to true in the callback
    window.changesUnsaved = false

  $(document).on "change", ".queen-award-holder input", ->
    changeTradeQuestion()
    window.changesUnsaved = true

  $(document).on "change input", ".js-options-with-dependent-child-select", ->
    dependable_key = $(this).attr("data-parent-option-dependable-key")
    dependable_children_div_block = $(".js-options-with-parent-dependency[data-depends-on=" + dependable_key + "]")
    dependable_controls = dependable_children_div_block.find(".selectable")
    applied = $(".queen-award-holder input:checked").val() == "yes"

    trade_award_and_highest_year = false
    trade_award_and_above_threshold_year = false
    trade_award_and_above_application_threshold_year = false

    # Get award year the current - 5 (threshold_year)
    highest_year = "0"

    year_options = $(this).closest("li").find("[data-dependable-option-siffix='year'] option")
    year_options.reverse().each ->
      won = $(this).closest("li").find("[data-dependable-option-siffix='outcome']").val() == "won"

      if $(this).attr("value") != ""
        if parseInt(highest_year) < parseInt($(this).attr("value"))
          highest_year = parseInt($(this).attr("value"))

    threshold_year = highest_year - 5
    application_threshold_year = highest_year - 1

    # Go through each current award
    # tests to see if one is trade
    # with an award year that's not the current - 5 (threshold_year)
    $(this).closest(".list-add").find("li").each ->
      award_category = $(this).find("[data-dependable-option-siffix='category']").val()
      award_year = parseInt($(this).find("[data-dependable-option-siffix='year']").val())
      won = $(this).closest("li").find("[data-dependable-option-siffix='outcome']").val() == "won"

      if award_category == "international_trade" && applied && won
        if award_year == highest_year
          trade_award_and_highest_year = true
        else if award_year > application_threshold_year
          trade_award_and_above_application_threshold_year = true
        else if award_year > threshold_year
          trade_award_and_above_threshold_year = true

    # Show C1 question based on this condition
    if trade_award_and_highest_year || trade_award_and_above_application_threshold_year
      # Do not give opportunity to apply if won last year
      dependable_children_div_block.find("h2 [data-preselected-condition='year_3_years_application']").addClass "display-none"
      dependable_children_div_block.find("h2 [data-preselected-condition='default']").addClass "display-none"
      dependable_children_div_block.find("h2 [data-preselected-condition='year_application_disabled']").removeClass "display-none"

      # hide inputs and remove the value
      dependable_controls.addClass "display-none"
      inputs = dependable_children_div_block.find(".selectable input")
      inputs.prop("checked", false)
    else if trade_award_and_above_threshold_year
      # Show the correct content
      dependable_children_div_block.find("h2 [data-preselected-condition='year_3_years_application']").removeClass "display-none"
      dependable_children_div_block.find("h2 [data-preselected-condition='default']").addClass "display-none"
      dependable_children_div_block.find("h2 [data-preselected-condition='year_application_disabled']").addClass "display-none"
      dependable_controls.addClass "display-none"

      # And set selected value for related control
      related_ui_control = dependable_children_div_block.find(".selectable input[data-preselected-condition]")
      related_ui_control.click()
    else
      # Show the default content
      dependable_children_div_block.find("h2 [data-preselected-condition='year_3_years_application']").addClass "display-none"
      dependable_children_div_block.find("h2 [data-preselected-condition='year_application_disabled']").addClass "display-none"
      dependable_children_div_block.find("h2 [data-preselected-condition='default']").removeClass "display-none"
      dependable_controls.removeClass "display-none"
  return
