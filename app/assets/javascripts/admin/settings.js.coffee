# require jquery-ui
jQuery ->
  if (settingsWrapper = ($ "#admin-settings-parent")).length
    ($ ".deadline-form").hide()
    ($ ".notification-edit-form, .notification-form").hide()
    ($ ".email-example").hide()

    settingsWrapper.on "click", ".edit-deadline", (e) ->
      e.preventDefault()

      wrapper = ($ e.currentTarget).closest('.deadline')

      ($ ".form-value", wrapper).hide()
      ($ ".deadline-form", wrapper).show()
      ($ e.currentTarget).hide()

    settingsWrapper.on "click", ".edit-notification", (e) ->
      e.preventDefault()

      wrapper = ($ e.currentTarget).closest('li')

      ($ ".form-value", wrapper).hide()
      ($ ".notification-edit-form", wrapper).show()
      ($ ".actions", wrapper).hide()

    settingsWrapper.on "click", ".btn-add-schedule", (e) ->
      e.preventDefault()
      wrapper = ($ e.currentTarget).closest('.panel-section')
      ($ ".notification-form", wrapper).toggle()

    settingsWrapper.on "click", ".link-email-example", (e) ->
      e.preventDefault()
      wrapper = ($ e.currentTarget).closest('.panel-section')
      ($ ".email-example", wrapper).toggle()
