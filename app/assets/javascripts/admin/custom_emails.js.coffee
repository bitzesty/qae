jQuery ->
  emailRecipientChanged = (select) ->
    # Show the recipient hint
    email_help = $(".email-send-to-help")
    email_help.removeClass("show-qae-opt-in")
    email_help.removeClass("show-bis-opt-in")
    email_help.removeClass("show-all-users")

    switch select.val()
      when "qae_opt_in_group"
        email_help.addClass("show-qae-opt-in")
      when "bis_opt_in"
        email_help.addClass("show-bis-opt-in")
      when "all_users"
        email_help.addClass("show-all-users")

    # Change the send confirm warning
    email_link = $(".email-send-link")
    email_confirm = email_link.data("confirm-text")
    if !email_link.data("confirm-orig")
      email_link.attr("data-confirm-orig", email_confirm)
    email_confirm_orig = email_link.data("confirm-orig")
    email_confirm_orig = email_confirm_orig.substr(0, email_confirm_orig.length - 1)
    email_selected = select.find('option:selected').text().trim()
    email_confirm_new = "#{email_confirm_orig} to '#{email_selected}'?"
    email_link.attr("data-confirm-text", email_confirm_new)

    # To update the old confirm warning, we have to replace the send button
    new_email_link = email_link.clone().appendTo(email_link.parent())
    email_link.remove()
    new_email_link.on "click", (e) ->
      e.preventDefault()
      if confirm $(this).data("confirm-text")
        $("#new_custom_email_form").submit()

  $(".email-send-to select").on "change", ->
    emailRecipientChanged($(this))

  $(".email-send-to select").each ->
    emailRecipientChanged($(this))
