window.OptionsWithPreselectedConditionsQuestion = init: ->
  $(document).on "change input", ".js-options-with-dependent-child-select", ->
    dependable_key = $(this).attr("data-parent-option-dependable-key")
    dependable_children_div_block = $(".js-options-with-parent-dependency[data-depends-on=" + dependable_key + "]")
    dependable_controls = dependable_children_div_block.find(".selectable")

    trade_award_and_not_lowest_year = false

    # Get award year the current - 5 (lowest_year)
    lowest_year = "9999"
    year_options = $(this).closest("li").find("[data-dependable-option-siffix='year'] option")
    year_options.each ->
      if $(this).attr("value") != ""
        if parseInt(lowest_year) > parseInt($(this).attr("value"))
          lowest_year = $(this).attr("value")

    # Go through each current award
    # tests to see if one is trade
    # with an award year that's not the current - 5 (lowest_year)
    $(this).closest(".list-add").find("li").each ->
      award_category = $(this).find("[data-dependable-option-siffix='category']").val()
      award_year = $(this).find("[data-dependable-option-siffix='year']").val()
      if award_category == "international_trade" && award_year != lowest_year
        trade_award_and_not_lowest_year = true

    # Show C1 question based on this condition
    if trade_award_and_not_lowest_year
      # Show the correct content
      dependable_children_div_block.find("h2 [data-preselected-condition]").removeClass "display-none"
      dependable_children_div_block.find("h2 [data-preselected-condition='default']").addClass "display-none"
      dependable_controls.addClass "display-none"

      # And set selected value for related control
      related_ui_control = dependable_children_div_block.find(".selectable input[data-preselected-condition]")
      related_ui_control.click()
    else
      # Show the default content
      dependable_children_div_block.find("h2 [data-preselected-condition]").addClass "display-none"
      dependable_children_div_block.find("h2 [data-preselected-condition='default']").removeClass "display-none"
      dependable_controls.removeClass "display-none"
  return