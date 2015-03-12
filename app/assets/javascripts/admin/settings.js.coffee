# require jquery-ui
jQuery ->
  if ($ "#admin-settings-parent").length
    ($ ".deadline-form").hide()
    ($ ".notification-edit-form, .notification-form").hide()
    ($ ".email-example").hide()

    ($ ".edit-deadline").on "click", (e) ->
      e.preventDefault()

      wrapper = ($ e.currentTarget).closest('.deadline')

      ($ ".form-value", wrapper).hide()
      ($ ".deadline-form", wrapper).show()
      ($ e.currentTarget).hide()

    ($ ".edit-notification").on "click", (e) ->
      e.preventDefault()

      wrapper = ($ e.currentTarget).closest('li')

      ($ ".form-value", wrapper).hide()
      ($ ".notification-edit-form", wrapper).show()
      ($ ".actions", wrapper).hide()

    ($ ".btn-add-schedule").on "click", (e) ->
      e.preventDefault()
      wrapper = ($ e.currentTarget).closest('.panel-section')
      ($ ".notification-form", wrapper).toggle()

    ($ ".link-email-example").on "click", (e) ->
      e.preventDefault()
      wrapper = ($ e.currentTarget).closest('.panel-section')
      ($ ".email-example", wrapper).toggle()
