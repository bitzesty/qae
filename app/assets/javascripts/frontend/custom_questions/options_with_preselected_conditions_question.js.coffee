window.OptionsWithPreselectedConditionsQuestion = init: ->
  $(document).on 'change input', ".js-options-with-dependent-child-question", ->
    selected_options = $(this).closest(".list-add").find(".js-options-with-dependent-child-question option:selected")
    dependable_key = $(this).attr("data-parent-option-dependable-key")
    dependable_values = $(this).attr("data-dependable-values").split(",")
    dependable_option_suffix = $(this).attr("data-dependable-option-siffix")

    dependable_children_div_block = $(".js-options-with-parent-dependency[data-depends-on=" + dependable_key + "]")
    dependable_sections = dependable_children_div_block.find(".js-option-by-preselected-condition")
    dependable_controls = dependable_children_div_block.find(".selectable")

    # Fetching all selected values in list
    selected_values = []
    $.each selected_options, (index, el) ->
      selected_values.push $(el).val()
      return
    selected_values = $.unique(selected_values)

    # Comparing dependable values with selected values
    matched_conditional_value = ""
    $.each dependable_values, (key, value) ->
      if $.inArray(value, selected_values) != -1
        matched_conditional_value = value
        return false
      return

    dependable_sections.addClass "display-none"
    if matched_conditional_value.length > 1
      # If there is at least of one matched condition value

      # Then show related selected
      data_preselected_condition = dependable_option_suffix + "_" + matched_conditional_value
      selected_child_el = dependable_children_div_block.find(".js-option-by-preselected-condition[data-preselected-condition=" + data_preselected_condition + "]")
      if selected_child_el.size() > 0
        selected_child_el.removeClass "display-none"

        # Hide related controles
        dependable_controls.addClass "display-none"

        # And set selected value for related control
        related_ui_control = dependable_children_div_block.find(".selectable input[data-preselected-condition='" + data_preselected_condition + "']")
        related_ui_control.click()
      else
        # In nothing in conditions are match

        # Then show default section 
        dependable_children_div_block.find(".js-option-by-preselected-condition[data-preselected-condition='default']").removeClass "display-none"

        # And display controls
        dependable_controls.removeClass "display-none"
    else
      # In nothing in conditions are match

      # Then show default section 
      dependable_children_div_block.find(".js-option-by-preselected-condition[data-preselected-condition='default']").removeClass "display-none"

      # And display controls
      dependable_controls.removeClass "display-none"
    return
  return