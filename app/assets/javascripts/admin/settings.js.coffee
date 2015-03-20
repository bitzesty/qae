# require jquery-ui
jQuery ->
  if (settingsWrapper = ($ "#admin-settings-parent")).length
    ($ ".deadline-form").addClass("hidden")
    ($ ".notification-edit-form, .notification-form").addClass("hidden")
    ($ ".email-example").addClass("hidden")

    settingsWrapper.on "click", ".edit-deadline", (e) ->
      e.preventDefault()

      wrapper = ($ e.currentTarget).closest('.deadline')

      ($ ".form-value", wrapper).addClass("hidden")
      ($ ".deadline-form", wrapper).removeClass("hidden")
      ($ e.currentTarget).addClass("hidden")

    settingsWrapper.on "click", ".edit-notification", (e) ->
      e.preventDefault()

      wrapper = ($ e.currentTarget).closest('li')

      ($ ".form-value", wrapper).addClass("hidden")
      ($ ".notification-edit-form", wrapper).removeClass("hidden")
      ($ ".actions", wrapper).addClass("hidden")

    settingsWrapper.on "click", ".btn-add-schedule", (e) ->
      e.preventDefault()
      wrapper = ($ e.currentTarget).closest('.panel-section')
      ($ ".notification-form", wrapper).toggleClass("hidden")

    settingsWrapper.on "click", ".link-email-example", (e) ->
      e.preventDefault()
      wrapper = ($ e.currentTarget).closest('.panel-section')
      ($ ".email-example", wrapper).toggleClass("hidden")

    settingsWrapper.on "click", ".btn-cancel", (e) ->
      e.preventDefault()

      form_well = ($ e.currentTarget).closest('.well')

      if form_well.hasClass("deadline-form")
        wrapper = ($ e.currentTarget).closest('.deadline')
        ($ ".form-value", wrapper).removeClass("hidden")
        ($ ".deadline-form", wrapper).addClass("hidden")
        ($ ".edit-deadline", wrapper).removeClass("hidden")

      else if form_well.hasClass("notification-edit-form")
        wrapper = ($ e.currentTarget).closest('li')
        ($ ".form-value", wrapper).removeClass("hidden")
        ($ ".notification-edit-form", wrapper).addClass("hidden")
        ($ ".actions", wrapper).removeClass("hidden")

      else if form_well.hasClass("notification-new-form")
        wrapper = ($ e.currentTarget).closest('.panel-section')
        ($ ".notification-form", wrapper).addClass("hidden")
