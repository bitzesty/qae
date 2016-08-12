ready = ->
  filterApplicationsDropdowns()

filterApplicationsDropdowns = () ->
  # Change the checked value on dropbox and the filtered text
  $(".applications-filter .dropdown-menu").each () ->
    selected_count = 0
    $(this).closest(".dropdown").find(".text-filter").text("None selected")
    $(this).find("li label").each () ->
      # Individual checkboxes
      selected_label = $(this).attr("data-value")
      if selected_label != "select_all"
        selected_option = $(this).closest(".applications-filter").find("option[value='"+selected_label+"']")
        if selected_option.is(':selected')
          selected_count+=1
          $(this).find("input").attr('checked', 'checked')
          if selected_count == 1
            $(this).closest(".dropdown").find(".text-filter").text($(this).text())
          else
            $(this).closest(".dropdown").find(".text-filter").text(selected_count+" selected")

    # Select all checkboxes
    all_selected = true
    selected_options = $(this).closest(".applications-filter").find("option")
    selected_options.each () ->
      if !$(this).attr('selected')
        all_selected = false
    if all_selected
      $(this).find("label[data-value='select_all'] input").attr('checked', 'checked')
      $(this).closest(".dropdown").find(".text-filter").text("All")

  # On clicking the dropbox filters
  $(document).on "click", ".applications-filter .dropdown-menu li label", (e) ->
    e.stopPropagation()
    selected_label = $(this).attr("data-value")

    if selected_label == "select_all"
      # Select all
      all_selected = $(this).closest(".applications-filter").find("label[data-value='select_all'] input").is(":checked")
      selected_options = $(this).closest(".applications-filter").find("select.js-admin-filter-option option")
      # If any are unselected then select all
      if all_selected
        selected_options.prop('selected', 'selected').trigger('change')
        $(this).closest(".applications-filter").find(".checkbox input").prop("checked", true)
      else
        selected_options.prop('selected', false).trigger('change')
        $(this).closest(".applications-filter").find(".checkbox input").prop("checked", false)

    else
      # Select individual
      selected_option = $(this).closest(".applications-filter").find("option[value='"+selected_label+"']")

      if selected_option.attr('selected')
        selected_option.prop('selected', false).trigger('change')
      else
        selected_option.prop('selected', 'selected').trigger('change')

      unselected = $(this).closest(".applications-filter")
                          .find("label")
                          .not("[data-value='select_all']")
                          .find("input")
                          .not(":checked")
                          .length
      $(this).closest(".applications-filter").find("label[data-value='select_all'] input").prop("checked", unselected is 0)

$(document).ready(ready)
