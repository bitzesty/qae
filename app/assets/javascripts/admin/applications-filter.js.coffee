ready = ->
  filterApplicationsDropdowns()

  # processing arrow keys in admin dropdowns
  $(document).on "keydown", (e) ->
    return unless $(".dropdown.open").length > 0

    if e.keyCode == 40 || e.keyCode == 38
      e.preventDefault()
      e.stopPropagation()

  $(document).on "keyup", (e) ->
    return unless $(".dropdown.open").length > 0

    select = $(".dropdown.open").first()

    if e.keyCode == 40
      e.preventDefault()
      e.stopPropagation()

      if $(".dropdown-menu li.checkbox input:focus", select).length is 0
        $(".dropdown-menu li.checkbox input", select)[0].focus()
      else
        element = $(".dropdown-menu li.checkbox input:focus", select).closest("li")
        next_element = element.next()

        if next_element.hasClass("divider")
          next_element = next_element.next()

        $("input", next_element).focus()

    if e.keyCode == 38
      e.preventDefault()
      e.stopPropagation()

      if $(".dropdown-menu li.checkbox input:focus", select).length is 0
        $(".dropdown-menu li.checkbox input", select).last().focus()
      else
        element = $(".dropdown-menu li.checkbox input:focus", select).closest("li")
        prev_element = element.prev()

        if prev_element.hasClass("divider")
          prev_element = prev_element.prev()

        $("input", prev_element).focus()

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


  $(".applications-filter .dropdown-toggle").on "click", (e) ->
    e.preventDefault()
    e.stopPropagation()

    if $(@).parent().hasClass("open")
      $(@).parent().removeClass("open")
    else
      $(".applications-filter .dropdown").not($(@).parent()).removeClass("open")
      $(@).parent().addClass("open")

  $("html").on "click", (e) ->
    if $(e.target).closest(".dropdown").length is 0
      $(".applications-filter .dropdown").removeClass("open")

  # On clicking the dropbox filters
  $(document).on "change", ".applications-filter .dropdown-menu li input[type='checkbox']", (e) ->
    e.stopPropagation()
    selected_label = $(this).closest("label").attr("data-value")

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

      selected = $(this).closest(".applications-filter").find("select").val() || []

      if selected_label in selected
        selected_option.prop('selected', false).trigger('change')
      else
        selected_option.prop('selected', true).trigger('change')

      unselected = $(this).closest(".applications-filter")
                          .find("label")
                          .not("[data-value='select_all']")
                          .find("input")
                          .not(":checked")
                          .length
      $(this).closest(".applications-filter").find("label[data-value='select_all'] input").prop("checked", unselected is 0)

  # On clicking the award year radio
  $(document).on "click", ".applications-filter .input__award-years input[type='radio']", (e) ->
    e.stopPropagation()
    # if other selected, show dropdown of years, otherwise get form answers for current year or all years
    if $(this).attr('id') == "other"
      dropdownWrapper = $(this).closest(".applications-filter").find(".other-years-dropdown")
      dropdownWrapper.removeClass("hide")
      dropdown = dropdownWrapper.find(".dropdown-toggle")
      dropdown.focus().click()
    else
      search_query = $(this).closest("#new_search").find("#search_query").val()
      console.log(search_query)
      url = new URL($(this).data('url'), document.baseURI)
      url.searchParams.set('[search][query]', search_query)
      window.location = url

$(document).ready(ready)
