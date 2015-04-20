jQuery ->
  $(document).on "change", ".queen-award-holder input", ->
    if $(".queen-award-holder input:checked").val() == "yes"
      $(".business-name-changed-first-option").addClass("hidden")
    else
      $(".business-name-changed-first-option").removeClass("hidden")
