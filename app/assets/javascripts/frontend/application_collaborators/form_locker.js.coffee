window.ApplicationCollaboratorsFormLocker =

  lock_current_form_section: () ->
    $(".page-award-form").addClass("page-read-only-form")

    # Disable controls
    #
    $(".js-step-condition.step-current").find("input, select, textarea")
                                        .addClass("read-only")
                                        .prop('disabled', true)

    # Hide remove links on list type questions
    #
    $(".remove-link").hide()

    # Disable submit buttons
    #
    $("a.button-add, .qae-form button[type='submit']").addClass("read-only")
                                                      .prop('disabled', true)
    $(".js-save-and-come-back").hide()

    # Disable instances of CKEditor
    #
    for i of CKEDITOR.instances
      instance = CKEDITOR.instances[i]
      instance.setReadOnly(true)

    # Update 'Back' link with form_refresh option
    # in order to avoid redirection to NON JS version
    #
    back_link = $(".previous.previous-alternate.js-step-link a:visible")
    back_link_url = back_link.attr("href")
    back_link_url += "&form_refresh=true"
    back_link.attr("href", back_link_url)

    CollaboratorsLog.log("[FORM LOCKER] --------------- LOCKED!")
