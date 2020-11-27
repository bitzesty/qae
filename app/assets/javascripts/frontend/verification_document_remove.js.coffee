jQuery( document ).ready () ->
  return if jQuery(".js-remove-verification-document-link").length == 0

  jQuery(".js-remove-verification-document-link").on "confirm:complete", () ->
    jQuery(this).closest("form").submit()

