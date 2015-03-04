window.ongoingDateDuration = () ->
  $(document).on "change", ".date-ongoing input", ->
    date_end_inputs = $(this).closest(".validate-date-start-end").find(".validate-date-end input")
    if $(this).is(":checked")
      date_end_inputs.attr("disabled", "disabled")
    else
      date_end_inputs.removeAttr("disabled")
