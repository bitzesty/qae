# require jquery-ui

class DeadlineForm
  constructor: (el) ->
    @form = el
    @hasChanged = false
    @init()

  init: ->
    @createModal()
    @gatherInitialValues()
    @bindEvents()

  createModal: ->
    html = """
<div class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
        <p>
          This could change the current status of the application and affect all users.
        </p>
        <p>
          Are you sure you want to change the date?
        </p>

        <br />

        <p>
          <button type="button" class="btn btn-primary confirm-date-change">Yes, change the date</button>
          <button type="button" class="btn btn-link" data-dismiss="modal">Cancel</button>
        </p>
      </div>
    </div>
  </div>
</div>
    """

    @modal = $(html)

  gatherInitialValues: ->
    @date = @form.find("input.datepicker").val()
    @time = @form.find("input.timepicker").val()

  bindEvents: ->
    @form.find("input.datepicker").on "change", (e) =>
      if e.target.value != @date and @date
        @hasChanged = true

    @form.find("input.timepicker").on "change", (e) =>
      if e.target.value != @time and @time
        @hasChanged = true

    @form.on "click", ".btn-submit", (e) =>
      if @hasChanged
        e.preventDefault()

        @showConfirmationModal()
      else
        @form.submit()

    @modal.on "click", ".confirm-date-change", (e) =>
      e.preventDefault()

      @modal.modal("hide")

      @form.submit()

    @form.on "ajax:saved", =>
      @reset()

  showConfirmationModal: ->
    @modal.modal("show")

  reset: ->
    @hasChanged = false
    @gatherInitialValues()


jQuery ->
  if (settingsWrapper = ($ "#admin-settings-parent")).length
    ($ ".deadline-form").addClass("hidden")
    ($ ".notification-edit-form, .notification-form").addClass("hidden")
    ($ ".email-example").addClass("hidden")

    ($ "form.edit_deadline").each ->
      new DeadlineForm($(@))

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

      well = ($ e.currentTarget).closest('.well')

      if well.hasClass("deadline-form")
        wrapper = ($ e.currentTarget).closest('.deadline')
        ($ ".form-value", wrapper).removeClass("hidden")
        ($ ".deadline-form", wrapper).addClass("hidden")
        ($ ".edit-deadline", wrapper).removeClass("hidden")

      else if well.hasClass("notification-edit-form")
        wrapper = ($ e.currentTarget).closest('li')
        ($ ".form-value", wrapper).removeClass("hidden")
        ($ ".notification-edit-form", wrapper).addClass("hidden")
        ($ ".actions", wrapper).removeClass("hidden")

      else if well.hasClass("notification-new-form")
        wrapper = ($ e.currentTarget).closest('.panel-section')
        ($ ".notification-form", wrapper).addClass("hidden")
