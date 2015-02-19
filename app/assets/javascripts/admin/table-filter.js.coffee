ready = ->
  filterTableDropdowns()

filterTableDropdowns = () ->
  # Change the checked value on dropbox and the filtered text
  $("th.filter .dropdown-menu").each () ->
    selected_count = 0
    $(this).find("li label").each () ->
      # Individual checkboxes
      selected_label = $(this).attr("data-value")
      if selected_label != "select_all"
        selected_option = $(this).closest("th.filter").find("option[value='"+selected_label+"']")
        if selected_option.attr('selected')
          selected_count+=1
          $(this).find("input").attr('checked', 'checked')
          console.log "#{selected_count} : #{$(this).text()}"
          $(this).find(".text-filter").text("All ")
          if selected_count == 1
            $(this).closest(".dropdown").find(".text-filter").text($(this).text()+" ")
          else
            $(this).closest(".dropdown").find(".text-filter").text(selected_count+" selected ")

    # Select all checkboxes
    all_selected = true
    selected_options = $(this).closest("th.filter").find("option")
    selected_options.each () ->
      if !$(this).attr('selected')
        all_selected = false
    if all_selected
      $(this).find("label[data-value='select_all'] input").attr('checked', 'checked')
      $(this).closest(".dropdown").find(".text-filter").text("All ")

  # On clicking the dropbox filters
  $(document).on "click", "th.filter .dropdown-menu li label", () ->
    selected_label = $(this).attr("data-value")

    if selected_label == "select_all"
      # Select all
      all_selected = true
      selected_options = $(this).closest("th.filter").find("option")
      selected_options.each () ->
        if !$(this).attr('selected')
          all_selected = false
      # If any are unselected then select all
      if all_selected
        selected_options.prop('selected', false).trigger('change')
      else
        selected_options.prop('selected', 'selected').trigger('change')
    else
      # Select individual
      selected_option = $(this).closest("th.filter").find("option[value='"+selected_label+"']")
      if selected_option.attr('selected')
        selected_option.prop('selected', false).trigger('change')
      else
        selected_option.prop('selected', 'selected').trigger('change')

$(document).ready(ready)
