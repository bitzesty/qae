#= require jquery
#= require jquery_ujs
#= require_tree .

jQuery ->
  # Hidden hints as seen on
  # https://www.gov.uk/service-manual/user-centred-design/resources/patterns/help-text
  $(document).on "click", ".hidden-hint a", (e) ->
    e.preventDefault()
    if ($(this).closest(".hidden-hint").hasClass("show-hint"))
      $(this).closest(".hidden-hint").removeClass("show-hint")
    else
      $(this).closest(".hidden-hint").addClass("show-hint")